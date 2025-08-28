// Copyright (c) 2025 Andrés E. G.
//
// This software is licensed under the MIT License.
// See the LICENSE file for more details.


package src.compilers;

import src.SlushiUtils;
import src.compilers.CafeCompiler;
import src.compilers.HaxeCompiler;
import src.utils.LibsManager;
import src.JsonFile;
import src.utils.DevKitProUtils;
import src.Main;

using StringTools;

/**
 * The main compiler, it will start the compilation of the project
 * in Haxe and Wii U.
 * 
 * Author: Slushi.
 */
class MainCompiler {
	public static var libs:Array<HxCULibStruct> = [];

	/**
	 * Starts the compilation of the project.
	 */
	public static function start(arg2:String, arg3:String):Void {
		var jsonVersion:String = JsonFile.getJson().programVersion;
		var forced:Bool = jsonVersion.endsWith(":forced");
		var versionStr = forced ? jsonVersion.split(":")[0] : jsonVersion;

		var operatorStr:String = "";
		var versionValue:String = versionStr;

		if (versionStr.startsWith(">=")) {
			operatorStr = ">=";
			versionValue = versionStr.substr(2);
		} else if (versionStr.startsWith(">")) {
			operatorStr = ">";
			versionValue = versionStr.substr(1);
		} else if (versionStr.startsWith("<=")) {
			operatorStr = "<=";
			versionValue = versionStr.substr(2);
		} else if (versionStr.startsWith("<")) {
			operatorStr = "<";
			versionValue = versionStr.substr(1);
		}

		var parsedJsonVersion = SlushiUtils.parseVersion(versionValue);
		var currentVersion = SlushiUtils.parseVersion(Main.version);

		var versionMismatch:Bool = false;
		var shouldStop:Bool = false;

		if (operatorStr == ">=") {
			if (currentVersion < parsedJsonVersion) {
				versionMismatch = true;
				shouldStop = true; // Stop if current version is less than required
			}
			// If currentVersion >= parsedJsonVersion, continue
		} else if (operatorStr == ">") {
			if (currentVersion <= parsedJsonVersion) {
				versionMismatch = true;
				shouldStop = true; // Stop if current version is less or equal
			}
		} else if (operatorStr == "<=") {
			if (currentVersion > parsedJsonVersion) {
				versionMismatch = true;
				shouldStop = true; // Stop if current version is greater than required
			}
			// If currentVersion <= parsedJsonVersion, continue
		} else if (operatorStr == "<") {
			if (currentVersion >= parsedJsonVersion) {
				versionMismatch = true;
				shouldStop = true; // Stop if current version is greater or equal
			}
		} else {
			if (currentVersion < parsedJsonVersion) {
				SlushiUtils.printMsg("The current version of HxCompileU is older than the one in the JSON file, consider updating it.", WARN);
				if (forced) {
					versionMismatch = true;
					shouldStop = true; // Stop if forced
				}
			} else if (currentVersion > parsedJsonVersion) {
				SlushiUtils.printMsg("The current version of HxCompileU is newer than the one in the JSON file, consider checking the JSON file.", WARN);
				if (forced) {
					versionMismatch = true;
					shouldStop = true; // Stop if forced
				}
			}
		}

		if (shouldStop) {
			SlushiUtils.printMsg("Cannot continue: The JSON requires a specific version of HxCompileU: " + jsonVersion, ERROR);
			return;
		}

		// Check and get required libs
		libs = LibsManager.getRequiredLibs();

		SlushiUtils.printMsg("Starting...", INFO);

		if (JsonFile.getJson().wiiuConfig.isAPlugin == true) {
			SlushiUtils.printMsg("The current project is configured as a plugin, this is an experimental feature! It may not work as expected.", WARN);
		}

		if (JsonFile.getJson().wiiuConfig.convertToWUHB == true) {
			SlushiUtils.printMsg("The current project is being converted to a WUHB file, you can use RomFS!", INFO);
		}

		if (arg2.toLowerCase() == "--debug" || (arg2 == "--onlyHaxe" && arg3.toLowerCase() == "--debug")) {
			HaxeCompiler.forceDebugMode = true;
		}

		if (arg2 == "--onlyHaxe") {
			HaxeCompiler.init();
			return;
		}
		else if (arg2 == "--onlyCafe") {
			CafeCompiler.init();
			return;
		}
		else if (arg2.toLowerCase() == "--clean") {
			SlushiUtils.cleanBuild();
		}

		// First compile Haxe part and then compile Wii U part
		HaxeCompiler.init();
		CafeCompiler.init();

		// Convert to WUHB if needed
		if (JsonFile.getJson().wiiuConfig.convertToWUHB == true) {
			SlushiUtils.printMsg("Converting to WUHB...", INFO);
			if (DevKitProUtils.convertToWUHB()) {
				SlushiUtils.printMsg("Conversion to WUHB completed.", SUCCESS);
			}
			else {
				SlushiUtils.printMsg("Conversion to WUHB failed.", ERROR);
			}
		}
	}
}
