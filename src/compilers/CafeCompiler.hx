package src.compilers;

import src.compilers.HaxeCompiler;
import sys.io.File;
import sys.FileSystem;
import src.JsonFile;
import src.SlushiUtils;
import haxe.Resource;
import src.Main;

using StringTools;

/**
 * The CafeCompiler class is used to compile the project to Wii U
 * using [DevKitPro] (https://devkitpro.org) MakeFile.
 * 
 * Author: Slushi.
 */

class CafeCompiler {
	static var jsonFile:JsonStruct = JsonFile.getJson();
	static var exitCodeNum:Int = 0;

	public static function init() {
		if (HaxeCompiler.getExitCode() != 0) {
			return;
		}

		if (jsonFile == null) {
			SlushiUtils.printMsg("Error loading [hxCompileUConfig.json]", ERROR);
			return;
		}

		// Check if all required fields are set
		if (jsonFile.wiiuConfig.projectName == "") {
			SlushiUtils.printMsg("projectName in [hxCompileUConfig.json -> wiiuConfig.projectName] is empty", ERROR);
			exitCodeNum = 3;
			return;
		}

		SlushiUtils.printMsg("Trying to compile to Wii U project...", PROCESSING);

		SlushiUtils.printMsg("Creating Makefile...", PROCESSING);
		// Create a temporal Makefile with all required fields
		try {
			// Prepare Makefile
			var makefileContent:String = Resource.getString("cafeMakefileWUT");
			makefileContent = makefileContent.replace("[PROGRAM_VERSION]", Main.version);
			makefileContent = makefileContent.replace("[PROJECT_NAME]", jsonFile.wiiuConfig.projectName);
			makefileContent = makefileContent.replace("[SOURCE_DIR]", jsonFile.haxeConfig.outDir + "/src");
			makefileContent = makefileContent.replace("[INCLUDE_DIR]", jsonFile.haxeConfig.outDir + "/include");
			makefileContent = makefileContent.replace("[LIBS]", parseMakeLibs());
			makefileContent = makefileContent.replace("[DEFINES]", parseMakeDefines());

			if (!FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.haxeConfig.outDir + "/wiiuFiles")) {
				FileSystem.createDirectory(SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.haxeConfig.outDir + "/wiiuFiles");
			}
			makefileContent = makefileContent.replace("[OUT_DIR]", jsonFile.haxeConfig.outDir + "/wiiuFiles");

			// Save Makefile
			// delete temporal makefile if already exists
			if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile")) {
				FileSystem.deleteFile(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile");
				SlushiUtils.printMsg("Deleted existing [Makefile]", INFO);
			}

			File.saveContent(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile", makefileContent);
			SlushiUtils.printMsg("Created Makefile", SUCCESS);
		} catch (e:Dynamic) {
			SlushiUtils.printMsg("Error creating Makefile: " + e, ERROR);
			exitCodeNum = 4;
			return;
		}

		SlushiUtils.printMsg("Compiling to Wii U...\n------------------", PROCESSING);

		var startTime:Float = Sys.time(); 
		var compileProcess = Sys.command("make");

		SlushiUtils.printMsg("------------------", NONE);

		var endTime:Float = Sys.time(); 
		var elapsedTime:Float = endTime - startTime; 
		var formattedTime:String = StringTools.trim(Math.fround(elapsedTime * 10) / 10 + "s");

		if (compileProcess != 0) {
			SlushiUtils.printMsg("Compilation failed", ERROR, "\n");
			exitCodeNum = 2;
		}

		// delete temporal makefile
		if (jsonFile.deleteTempFiles == true) {
			if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile")) {
				FileSystem.deleteFile(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile");
			}
		}

		if (exitCodeNum == 0) {
			SlushiUtils.printMsg('Compilation successful. Check [${jsonFile.haxeConfig.outDir}/wiiuFiles], compilation time: ${formattedTime}\n', SUCCESS, "\n");
		}
	}

	public static function getExitCode():Int {
		return exitCodeNum;
	}

	static function parseMakeLibs():String {
		var libs = "";

		for (lib in Libs.parseMakeLibs()) {
			libs += lib + " ";
		}

		return libs;
	}

	static function parseMakeDefines():String {
		var defines = "";

		for (define in Defines.parseCDefines()) {
			defines += define + " ";
		}

		return defines;
	}
}
