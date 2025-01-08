package src;

import haxe.Json;
import sys.io.File;
import sys.FileSystem;

typedef HaxeConfig = {
	sourceDir:String,
	hxMain:String,
	outDir:String,
	reportErrorStyle:String,
	debugMode:Bool,
	hxLibs:Array<String>,
	hxDefines:Array<String>,
}

typedef WiiUMakeConfing = {
	projectName:String,
	makeDefines:Array<String>,
	makeLibs:Array<String>,
}

typedef JsonStruct = {
	haxeConfig:HaxeConfig,
	wiiuMakeConfig:WiiUMakeConfing,
}

class JsonFile {
	public static function getJson():JsonStruct {
		try {
			if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUConfig.json")) {
				var jsonContent:Dynamic = Json.parse(File.getContent(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUConfig.json"));

				var jsonStructure:JsonStruct = {
					haxeConfig: {
						sourceDir: jsonContent.haxeConfig.sourceDir,
						hxMain: jsonContent.haxeConfig.hxMain,
						outDir: jsonContent.haxeConfig.outDir,
						reportErrorStyle: jsonContent.haxeConfig.reportErrorStyle,
						debugMode: jsonContent.debugMode,
						hxLibs: jsonContent.haxeConfig.hxLibs,
						hxDefines: jsonContent.haxeConfig.hxDefines,
					},
					wiiuMakeConfig: {
						projectName: jsonContent.wiiuMakeConfig.projectName,
						makeDefines: jsonContent.wiiuMakeConfig.makeDefines,
						makeLibs: jsonContent.wiiuMakeConfig.makeLibs,
					}
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
			haxeConfig: {
				sourceDir: "source",
				hxMain: "Main",
				outDir: "output",
				reportErrorStyle: "pretty",
				debugMode: false,
				hxLibs: [],
				hxDefines: [],
			},
			wiiuMakeConfig: {
				projectName: "project",
				makeDefines: [],
				makeLibs: [],
			}
		};

		try {
			File.saveContent(SlushiUtils.getPathFromCurrentTerminal() + "/hxCompileUConfig.json", Json.stringify(jsonStructure, "\t"));
			SlushiUtils.printMsg("Created [hxCompileUConfig.json]", "success");
		} catch (e) {
			SlushiUtils.printMsg("Error creating [hxCompileUConfig.json]: " + e, "error");
		}
	}

	public static function getVariableFromJson(jsonStructure:JsonStruct, fieldName:String, variableName:String):Dynamic {
		if (jsonStructure != null) {
			var data:Dynamic = null;
			switch (fieldName) {
				case "haxeConfig":
					data = Reflect.getProperty(jsonStructure.haxeConfig, variableName);
					if (data != null) {
						return data;
					}
				case "wiiuMakeConfig":
					data = Reflect.getProperty(jsonStructure.wiiuMakeConfig, variableName);
					if (data != null) {
						return data;
					}
				default:
					return null;
			}
		}
		return null;
	}
}
