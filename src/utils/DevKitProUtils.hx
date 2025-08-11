// Copyright (c) 2025 Andrés E. G.
//
// This software is licensed under the MIT License.
// See the LICENSE file for more details.


package src.utils;

import haxe.io.Path;
import sys.FileSystem;
import src.JsonFile;

/**
 * The DevKitProUtils class is used to use the DevKitPro tools.
 * 
 * Author: Slushi.
 */
class DevKitProUtils {
	public static var jsonFile:JsonStruct = JsonFile.getJson();

	/**
	 * Searches for a problem in the code from a line address.
	 * @param address The address to search for.
	 */
	public static function searchProblem(address:String):Void {
		if (address == null || address == "") {
			SlushiUtils.printMsg("Invalid address", ERROR);
			return;
		}

		var elfPath:String = SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.haxeConfig.outDir + "/wiiuFiles/" + jsonFile.wiiuConfig.projectName
			+ ".elf";
		if (!FileSystem.exists(elfPath)) {
			SlushiUtils.printMsg("[.elf] file not found", ERROR);
			return;
		}

		var devKitProPPCEnv = Sys.getEnv("DEVKITPPC");
		var addr2lineProgram:String = devKitProPPCEnv + "/bin/powerpc-eabi-addr2line";

		if (devKitProPPCEnv == null) {
			SlushiUtils.printMsg("DEVKITPPC environment variable not found", ERROR);
			return;
		}

		SlushiUtils.printMsg("If the output is \"??:0\", the address does not exist or is invalid", NONE);
		SlushiUtils.printMsg("----------------------", NONE);
		Sys.command(addr2lineProgram, ["-e", elfPath, address]);
		SlushiUtils.printMsg("----------------------", NONE);
	}

	/**
	 * Sends the compiled file to the Wii U console.
	 */
	public static function send():Void {
		var filePath:String = "";

		if (jsonFile.wiiuConfig.isAPlugin == true) {
			filePath = SlushiUtils.getPathFromCurrentTerminal()
				+ "/"
				+ jsonFile.haxeConfig.outDir
				+ "/wiiuFiles/"
				+ jsonFile.wiiuConfig.projectName
				+ ".wps";
		} else {
			filePath = SlushiUtils.getPathFromCurrentTerminal()
				+ "/"
				+ jsonFile.haxeConfig.outDir
				+ "/wiiuFiles/"
				+ jsonFile.wiiuConfig.projectName
				+ ".rpx";
		}

		if (!FileSystem.exists(filePath)) {
			SlushiUtils.printMsg("RPX or WPS file not found", ERROR);
			return;
		}

		var fileName:String = Path.withoutDirectory(filePath);

		SlushiUtils.printMsg("Sending file: [" + fileName + "]", PROCESSING);

		var devKitProToolsEnv = Sys.getEnv("DEVKITPRO");
		var wiiloadProgram = devKitProToolsEnv + "/tools/bin/wiiload";

		if (Sys.getEnv("WIILOAD") == null) {
			Sys.putEnv("WIILOAD", jsonFile.wiiuConfig.consoleIP);
		} else {
			SlushiUtils.printMsg("WIILOAD environment variable already set, using that...", WARN);
		}

		if (devKitProToolsEnv == null) {
			SlushiUtils.printMsg("DEVKITPRO environment variable not found", ERROR);
			return;
		}

		Sys.command(wiiloadProgram, [filePath]);
	}

	/**
	 * Converts the project RPX to WUHB format.
	 */
	public static function convertToWUHB():Bool {
		var filePath:String = "";

		if (!FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "WUHB")) {
			SlushiUtils.printMsg("WUHB directory not found", ERROR);
			return false;
		} else if (!FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "WUHB/icon.png")) {
			SlushiUtils.printMsg("WUHB -> icon.png not found", WARN);
		} else if (!FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "WUHB/tv_image.png")) {
			SlushiUtils.printMsg("WUHB -> tv_image.png not found", WARN);
		} else if (!FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "WUHB/drc_image.png")) {
			SlushiUtils.printMsg("WUHB -> drc_image.png not found", WARN);
		}

		if (jsonFile.wiiuConfig.isAPlugin == true) {
			SlushiUtils.printMsg("Cannot convert a plugin to WUHB", ERROR);
			return false;
		}

		if (jsonFile.wiiuConfig.wuhbConfig.author == ""
			|| jsonFile.wiiuConfig.wuhbConfig.name == ""
			|| jsonFile.wiiuConfig.wuhbConfig.shortName == "") {
			SlushiUtils.printMsg("Missing WUHB configuration", ERROR);
			return false;
		}

		filePath = SlushiUtils.getPathFromCurrentTerminal()
			+ "/"
			+ jsonFile.haxeConfig.outDir
			+ "/wiiuFiles/"
			+ jsonFile.wiiuConfig.projectName
			+ ".rpx";

		if (!FileSystem.exists(filePath)) {
			SlushiUtils.printMsg("RPX file not found", ERROR);
			return false;
		}

		// remove path from the file name
		var fileName:String = Path.withoutDirectory(filePath);

		SlushiUtils.printMsg("Converting file: [" + fileName + "] to WUHB file", PROCESSING);

		var devKitProToolsEnv = Sys.getEnv("DEVKITPRO");
		var wuhbtoolProgram = devKitProToolsEnv + "/tools/bin/wuhbtool";

		SlushiUtils.printMsg("----------------------", NONE);
		Sys.command(wuhbtoolProgram, [filePath,
			SlushiUtils.getPathFromCurrentTerminal()
			+ jsonFile.haxeConfig.outDir
			+ "/wiiuFiles/"
			+ jsonFile.wiiuConfig.projectName
			+ ".wuhb",
			"--author=" + jsonFile.wiiuConfig.wuhbConfig.author,
			"--name=" + jsonFile.wiiuConfig.wuhbConfig.name,
			"--short-name=" + jsonFile.wiiuConfig.wuhbConfig.shortName,
			"--icon=" + SlushiUtils.getPathFromCurrentTerminal() + "WUHB/icon.png",
			"--tv-image=" + SlushiUtils.getPathFromCurrentTerminal() + "WUHB/tv_image.png",
			"--drc-image=" + SlushiUtils.getPathFromCurrentTerminal() + "WUHB/drc_image.png"
		]);
		SlushiUtils.printMsg("----------------------", NONE);

		return true;
	}
}
