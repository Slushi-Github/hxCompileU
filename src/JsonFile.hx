package src;

import haxe.Json;
import sys.io.File;
import sys.FileSystem;
import src.SlushiUtils;
import src.Main;

typedef HaxeConfig = {
	sourceDir:String,
	hxMain:String,
	outDir:String,
	reportErrorStyle:String,
	debugMode:Bool,
	hxDefines:Array<String>,
	othersOptions:Array<String>,
}

typedef CMakeConfing = {
	appImage:String,
	tvImage:String,
	gamepadImage:String,
}

typedef WiiUonfing = {
	projectName:String,
	// useCMake:Bool,
	// cmakeConfig:CMakeConfing,
}

typedef JsonStruct = {
	programVersion:String,
	haxeConfig:HaxeConfig,
	wiiuConfig:WiiUonfing,
	deleteTempFiles:Bool,
	extraLibs:Array<String>,
}

class JsonFile {
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
						reportErrorStyle: jsonContent.haxeConfig.reportErrorStyle,
						debugMode: jsonContent.haxeConfig.debugMode,
						hxDefines: jsonContent.haxeConfig.hxDefines,
						othersOptions: jsonContent.haxeConfig.othersOptions,
					},
					wiiuConfig: {
						projectName: jsonContent.wiiuConfig.projectName,
						// useCMake: jsonContent.wiiuConfig.useCMake,
						// cmakeConfig: {
						// 	appImage: jsonContent.wiiuConfig.cmakeConfig.appImage,
						// 	tvImage: jsonContent.wiiuConfig.cmakeConfig.tvImage,
						// 	gamepadImage: jsonContent.wiiuConfig.cmakeConfig.gamepadImage,
						// },
					},
					deleteTempFiles: jsonContent.deleteTempFiles,
					extraLibs: jsonContent.extraLibs,
				};
				return jsonStructure;
			}
		} catch (e) {
			SlushiUtils.printMsg("Error loading [hxCompileUConfig.json]: " + e, "error");
		}
		return null;
	}

	public static function createJson():Void {
		if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUConfig.json")) {
			SlushiUtils.printMsg("[hxCompileUConfig.json] already exists", "warning");
			return;
		}

		SlushiUtils.printMsg("Creating [hxCompileUConfig.json]", "processing");

		var jsonStructure:JsonStruct = {
			programVersion: Main.version,
			haxeConfig: {
				sourceDir: "source",
				hxMain: "Main",
				outDir: "output",
				reportErrorStyle: "pretty",
				debugMode: false,
				hxDefines: [],
				othersOptions: [],
			},
			wiiuConfig: {
				projectName: "project",
				// useCMake: false,
				// cmakeConfig: {
				// 	appImage: "",
				// 	tvImage: "",
				// 	gamepadImage: "",
				// },
			},
			deleteTempFiles: true,
			extraLibs: [],
		};

		try {
			File.saveContent(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUConfig.json", Json.stringify(jsonStructure, "\t"));
			SlushiUtils.printMsg("Created [hxCompileUConfig.json]", "success");
		} catch (e) {
			SlushiUtils.printMsg("Error creating [hxCompileUConfig.json]: " + e, "error");
		}
	}
}
