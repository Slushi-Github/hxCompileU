// Copyright (c) 2025 Andrés E. G.
//
// This software is licensed under the MIT License.
// See the LICENSE file for more details.


package src;

import haxe.Json;
import sys.io.File;
import sys.FileSystem;
import src.SlushiUtils;
import src.Main;

using StringTools;

/**
 * The main JSON file for HxCompileU, contains the configuration of the project
 * like the libs, source directory, the output directory, the main class, etc.
 * 
 * Author: Slushi
 */

/**
 * The HaxeConfig is used to store the configuration of the Haxe compiler
 */
typedef HaxeConfig = {
	sourceDir:String,
	hxMain:String,
	outDir:String,
	debugMode:Bool,
	othersOptions:Array<String>,
	errorReportingStyle:String,
}

/**
 * The WUHBConfig is used to store the configuration of the Wii U Wii U Homebrew Bundle (WUHB).
 */
typedef WUHBConfig = {
	author:String,
	name:String,
	shortName:String,
}

/**
 * The WiiUConfig is used to store the configuration of the Wii U compiler.
 */
typedef WiiUConfig = {
	projectName:String,
	consoleIP:String,
	isAPlugin:Bool,
	convertToWUHB:Bool,
	wuhbConfig:WUHBConfig,
}

/**
 * The main structure of the JSON file.
 */
typedef JsonStruct = {
	programVersion:String,
	haxeConfig:HaxeConfig,
	wiiuConfig:WiiUConfig,
	deleteTempFiles:Bool,
	extraLibs:Array<String>,
	projectDefines:Array<String>,
}

/**
 * The JsonFile class is used to parse the JSON file that contains the configuration of the project
 */
class JsonFile {
	/**
	 * Checks if the JSON file is valid
	 * @return Bool
	 */
	public static function checkJson():Bool {
		try {
			if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUConfig.json")) {
				var jsonFile:JsonStruct = JsonFile.getJson();
				if (jsonFile == null) {
					SlushiUtils.printMsg("JSON file is invalid, please check it", ERROR);
					return false;
				}
			}
			return true;
		}
		catch (e) {
			SlushiUtils.printMsg("JSON file is invalid, please check it", ERROR);
			return false;
		}
	}

	/**
	 * Returns the JSON file as a JsonStruct from the current directory
	 * @return JsonStruct
	 */
	public static function getJson():JsonStruct {
		try {
			if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUConfig.json")) {
				var jsonContent:Dynamic = Json.parse(File.getContent(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUConfig.json"));

				var jsonStructure:JsonStruct = {
					programVersion: jsonContent.programVersion,
					haxeConfig: {
						sourceDir: jsonContent.haxeConfig.sourceDir,
						hxMain: jsonContent.haxeConfig.hxMain,
						outDir: jsonContent.haxeConfig.outDir,
						debugMode: jsonContent.haxeConfig.debugMode,
						othersOptions: jsonContent.haxeConfig.othersOptions,
						errorReportingStyle: jsonContent.haxeConfig.errorReportingStyle,
					},
					wiiuConfig: {
						projectName: jsonContent.wiiuConfig.projectName,
						consoleIP: jsonContent.wiiuConfig.consoleIP,
						isAPlugin: jsonContent.wiiuConfig.isAPlugin,
						convertToWUHB: jsonContent.wiiuConfig.convertToWUHB,
						wuhbConfig: {
							author: jsonContent.wiiuConfig.wuhbConfig.author,
							name: jsonContent.wiiuConfig.wuhbConfig.name,
							shortName: jsonContent.wiiuConfig.wuhbConfig.shortName,
						},
					},
					deleteTempFiles: jsonContent.deleteTempFiles,
					extraLibs: jsonContent.extraLibs,
					projectDefines: jsonContent.projectDefines,
				};
				return jsonStructure;
			}
		} catch (e) {
			SlushiUtils.printMsg("Error loading [hxCompileUConfig.json]: " + e, ERROR);
		}
		return null;
	}

	/**
	 * Creates a new JSON file if it doesn't exist
	 */
	public static function createJson():Void {
		if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUConfig.json")) {
			SlushiUtils.printMsg("[hxCompileUConfig.json] already exists", WARN);
			return;
		}

		SlushiUtils.printMsg("Creating [hxCompileUConfig.json]", PROCESSING);

		var jsonStructure:JsonStruct = {
			programVersion: Main.version,
			haxeConfig: {
				sourceDir: "source",
				hxMain: "Main",
				outDir: "output",
				debugMode: false,
				othersOptions: [],
				errorReportingStyle: "pretty",
			},
			wiiuConfig: {
				projectName: "project",
				consoleIP: "0.0.0.0",
				isAPlugin: false,
				convertToWUHB: false,
				wuhbConfig: {
					author: "author",
					name: "project",
					shortName: "project",
				},
			},
			deleteTempFiles: true,
			extraLibs: [],
			projectDefines: [],
		};

		try {
			File.saveContent(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUConfig.json", Json.stringify(jsonStructure, "\t"));
			SlushiUtils.printMsg("Created [hxCompileUConfig.json]", SUCCESS);
		} catch (e) {
			SlushiUtils.printMsg("Error creating [hxCompileUConfig.json]: " + e, ERROR);
		}
	}

	//////////////////////////////////////////////////////////////

	/**
	 * Returns the defines that are in the JSON file as a string for the Wii U compiler
	 * @return String
	 */
	public static function parseJSONVars():String {
		var jsonFile:JsonStruct = JsonFile.getJson();
		if (jsonFile == null) {
			return "";
		}

		var defines:String = "";
		
		defines += "-D HXCOMPILEU_JSON_VERSION=\"" + jsonFile.programVersion + "\" ";
		defines += "-D HXCOMPILEU_JSON_WIIU_PROJECTNAME=\"" + jsonFile.wiiuConfig.projectName + "\" ";

		var dateNow:Date = Date.now();
		var dateString = dateNow.getHours() + ":" 
			+ StringTools.lpad(dateNow.getMinutes() + "", "0", 2) + ":" 
			+ StringTools.lpad(dateNow.getSeconds() + "", "0", 2) + "--" 
			+ StringTools.lpad(dateNow.getDate() + "", "0", 2) + "-" 
			+ StringTools.lpad((dateNow.getMonth() + 1) + "", "0", 2) + "-" 
			+ dateNow.getFullYear();
		
		defines += "-D HXCOMPILEU_HAXE_APPROXIMATED_COMPILATION_DATE=\"" + dateString + "\" ";
		return defines;
	}

	//////////////////////////////////////////////////////////////

	/**
	 * Imports the JSON file from a Haxe library
	 * @param lib 
	 */
	public static function importJSON(lib:String):Void {
		var mainPath:String = "";
		var haxelibPath:String = Sys.getEnv("HAXEPATH") + "/lib";

		if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/.haxelib")) {
			mainPath = SlushiUtils.getPathFromCurrentTerminal() + "/.haxelib";
		} else {
			mainPath = haxelibPath;
		}

		if (!FileSystem.exists(mainPath + "/" + lib)) {
			SlushiUtils.printMsg("Lib [" + lib + "] not found", ERROR);
			return;
		}

		try {
			var hxuConfigPath:String = "";
			var currentFile:String = File.getContent(mainPath + "/" + lib + "/.current");
			if (currentFile == "git") {
				hxuConfigPath = mainPath + "/" + lib + "/git/hxCompileUConfig.json";
			} else {
				hxuConfigPath = mainPath + "/" + lib + "/" + currentFile.replace(".", ",") + "/hxCompileUConfig.json";
			}

			if (!FileSystem.exists(hxuConfigPath)) {
				SlushiUtils.printMsg("HxCompileUConfig.json not found in [" + lib + "]", WARN);
				return;
			}

			File.copy(hxuConfigPath, SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUConfig.json");
		}
		catch (e) {
			SlushiUtils.printMsg("Error importing [hxCompileUConfig.json]: " + e, ERROR);
			return;
		}

		SlushiUtils.printMsg("[hxCompileUConfig.json] imported from [" + lib + "]", SUCCESS);
	}
}
