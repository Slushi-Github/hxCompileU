package utils;

import sys.io.File;
import sys.FileSystem;
import haxe.Resource;

using StringTools;

/**
 * The PrepareMacro class is used to prepare the macros that are required by the libraries
 * such as libraries that require extra files at compile time.
 * 
 * This class really should have a better code order, but, I had a hard time getting this to work xd..
 * 
 * Author: Slushi.
 */

enum MacroFinalCheck {
	MACRO_OK;
	MACRO_ERROR;
	MACRO_SKIP;
}

class PrepareMacro {
	static var jsonFile:JsonStruct = JsonFile.getJson();

	private static var libsRequiringMacros:Map<String, String> = ["SDL_FontCache" => "hxsdl_fontcache"];
	public static var libsRequiringMacrosArray:Array<String> = [];

	public static function check():MacroFinalCheck {
		if (jsonFile.extraLibs.length == 0) {
			return MACRO_SKIP;
		}

		for (lib in jsonFile.extraLibs) {
			// SlushiUtils.printMsg("Checking lib: " + lib, PROCESSING);
			if (!libsRequiringMacros.exists(lib)) {
				continue;
			}

			if (Libs.validLibs.get(lib).haxeLibraries.requirePreparation) {
				libsRequiringMacrosArray.push(lib);
				SlushiUtils.printMsg("Libs requiring extra preparation: [" + libsRequiringMacrosArray.join(", ") + "]", INFO);
				return MACRO_OK;
			}
		}

		return MACRO_OK;
	}

	public static function searchLibInHaxeLibsAndSetHxFile(lib:String):Void {
		var libNameToSearch:String = libsRequiringMacros.get(lib);
		var haxePath:String = Sys.getEnv("HAXEPATH");

		SlushiUtils.printMsg("Searching lib: [" + libNameToSearch + "] in haxelib directories...", PROCESSING);

		var directory:String = "";

		try {
			if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + ".haxelib/" + libNameToSearch + "/git/CPP_FILES")) {
				SlushiUtils.printMsg("Found lib [" + libNameToSearch + "] in haxelib local repository in current directory", SUCCESS);
				directory = SlushiUtils.getPathFromCurrentTerminal() + ".haxelib/" + libNameToSearch + "/git/CPP_FILES";
			} else if (haxePath != "" && FileSystem.exists(haxePath + "/lib/" + libNameToSearch + "/git/CPP_FILES")) {
				SlushiUtils.printMsg("Found lib [" + libNameToSearch + "] in haxelib directory", SUCCESS);
				directory = haxePath + "/lib/" + libNameToSearch + "/git/CPP_FILES";
			} else {
				SlushiUtils.printMsg("Could not find [CPP_FILES] folder of lib ["
					+ libNameToSearch
					+ "] ("
					+ lib
					+ ") in haxelib directory (In HAXEPATH or local haxelib repository in current directory)",
					ERROR);
			}

			if (directory != "") {
				// SlushiUtils.printMsg("Found cpp file: " + cppFile, INFO);
				// SlushiUtils.printMsg("Found header file: " + headerFile, INFO);

				var haxeFunctionStr:String = prepareHxFile(directory);

				SlushiUtils.printMsg("Creating [HXCU_MACRO.hx]...", PROCESSING);

				try {
					if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + jsonFile.haxeConfig.sourceDir + "/hxCompileUMacros")) {
						FileSystem.deleteFile(SlushiUtils.getPathFromCurrentTerminal() + jsonFile.haxeConfig.sourceDir + "/hxCompileUMacros/HXCU_MACRO.hx");
						FileSystem.deleteDirectory(SlushiUtils.getPathFromCurrentTerminal() + jsonFile.haxeConfig.sourceDir + "/hxCompileUMacros");
						SlushiUtils.printMsg("Deleted existing [hxCompileUMacros] folder", INFO);
						FileSystem.createDirectory(SlushiUtils.getPathFromCurrentTerminal() + jsonFile.haxeConfig.sourceDir + "/hxCompileUMacros");
					} else {
						FileSystem.createDirectory(SlushiUtils.getPathFromCurrentTerminal() + jsonFile.haxeConfig.sourceDir + "/hxCompileUMacros");
					}

					File.saveContent(SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.haxeConfig.sourceDir + "/hxCompileUMacros/HXCU_MACRO.hx",
						haxeFunctionStr);
					SlushiUtils.printMsg("Created [HXCU_MACRO.hx]", SUCCESS);
				} catch (e) {
					SlushiUtils.printMsg("Error creating HXCU_MACRO.hx: " + e, ERROR);
					return;
				}
			} else {
				SlushiUtils.printMsg("Could not find cpp or header file for: " + libNameToSearch, ERROR);
				return;
			}
		} catch (e) {
			SlushiUtils.printMsg("Error unexpected in [searchLibInHaxeLibsAndSetHxFile] function: " + e, ERROR);
			return;
		}
	}

	private static function prepareHxFile(directory:String):String {
		var haxeFunction:String = Resource.getString("InitMacroFunctionOneFile");
		return haxeFunction = haxeFunction.replace("[PROGRAM_VERSION]", Main.version)
			.replace("[PACKAGE_NAME]", jsonFile.haxeConfig.sourceDir)
			.replace("[DIRECTORY_PATH]", directory);
	}
}
