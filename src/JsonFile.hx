package src;

import haxe.Json;
import sys.io.File;
import sys.FileSystem;
import src.SlushiUtils;
import src.Main;

/**
 * The main JSON file for HxCompileU, contains the configuration of the project
 * like the libs, source directory, the output directory, the main class, etc.
 * 
 * Author: Slushi
 */

typedef HaxeConfig = {
	sourceDir:String,
	hxMain:String,
	outDir:String,
	debugMode:Bool,
	othersOptions:Array<String>,
}

typedef WiiUConfig = {
	projectName:String,
	consoleIP:String,
}

typedef ConsoleSettings = {
	sendProgramToConsole:Bool,
	consoleIP:String,
}

typedef JsonStruct = {
	programVersion:String,
	haxeConfig:HaxeConfig,
	wiiuConfig:WiiUConfig,
	deleteTempFiles:Bool,
	extraLibs:Array<String>,
	projectDefines:Array<String>,
}

class JsonFile {
	public static function checkJson():Bool {
		if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUConfig.json")) {
			var jsonFile:JsonStruct = JsonFile.getJson();
			if (jsonFile == null) {
				SlushiUtils.printMsg("JSON file is invalid, please check it", ERROR);
				return false;
			}
		}
		return true;
	}

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
					},
					wiiuConfig: {
						projectName: jsonContent.wiiuConfig.projectName,
						consoleIP: jsonContent.wiiuConfig.consoleIP,
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
			},
			wiiuConfig: {
				projectName: "project",
				consoleIP: "0.0.0.0",
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
}
