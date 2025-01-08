package src.compilers;

import sys.io.Process;
import sys.io.File;
import sys.FileSystem;
import src.JsonFile;
import src.SlushiUtils;
import haxe.Resource;

using StringTools;

class CafeCompiler {
	static var jsonFile:JsonStruct = JsonFile.getJson();
    static var exitCodeNum:Int = 0;

	public static function init() {
		if (jsonFile == null) {
			SlushiUtils.printMsg("Error loading [hxCompileUConfig.json]", "error");
			return;
		}

		SlushiUtils.printMsg("Trying to compile to Wii U project...", "processing");

		// Check if all required fields are set
		if (jsonFile.wiiuMakeConfig.projectName == "") {
			SlushiUtils.printMsg("projectName in [hxCompileUConfig.json -> wiiuMakeConfig.projectName] is empty", "error");
            exitCodeNum = 3;
			return;
		}

		SlushiUtils.printMsg("Creating Makefile...", "processing");

		// Create a temporal Makefile with all required fields
		try {
			// Prepare Makefile
			var makefileContent:String = Resource.getString("cafeMakefileWUT");
			makefileContent = makefileContent.replace("[PROGRAM_VERSION]", Main.version);
			makefileContent = makefileContent.replace("[PROJECT_NAME]", jsonFile.wiiuMakeConfig.projectName);
			makefileContent = makefileContent.replace("[SOURCE_DIR]", jsonFile.haxeConfig.outDir + "/" + jsonFile.haxeConfig.sourceDir);
			makefileContent = makefileContent.replace("[INCLUDE_DIR]", jsonFile.haxeConfig.outDir + "/include");
			// makefileContent = makefileContent.replace("[BUILD_DIR]", jsonFile.haxeConfig.outDir + "/build");
			// makefileContent = makefileContent.replace("{[DEFINES]}", parseMakeDefines());
			// makefileContent = makefileContent.replace("{[LIBS]}", parseMakeLibs());

			if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.haxeConfig.outDir + "/wiiuFiles")) {
				FileSystem.deleteDirectory(SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.haxeConfig.outDir + "/wiiuFiles");
				FileSystem.createDirectory(SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.haxeConfig.outDir + "/wiiuFiles");
			}
			else {
				FileSystem.createDirectory(SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.haxeConfig.outDir + "/wiiuFiles");
			}
			makefileContent = makefileContent.replace("[OUT_DIR]", jsonFile.haxeConfig.outDir + "/wiiuFiles");

            // Save Makefile
            if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile")) {
                FileSystem.deleteFile(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile");
            }

            File.saveContent(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile", makefileContent);
            SlushiUtils.printMsg("Created Makefile", "success");
        } catch (e:Dynamic) {
            SlushiUtils.printMsg("Error creating Makefile: " + e, "error");
			exitCodeNum = 4;
            return;
		}

        SlushiUtils.printMsg("Compiling to Wii U...\n", "processing");

		var compileProcess = Sys.command("make");
		if (compileProcess != 0) {
            SlushiUtils.printMsg("Compilation failed", "error", "\n");
            exitCodeNum = 2;
        }

		// delete temporal makefile
		if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile")) {
			FileSystem.deleteFile(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile");
		}
	}

	public static function getExitCode():Int {
		return exitCodeNum;
	}

	static function parseMakeLibs() {
		var libs = "";

		for (i in 0...jsonFile.wiiuMakeConfig.makeLibs.length) {
			libs += " -l" + jsonFile.wiiuMakeConfig.makeLibs[i];
		}

		return libs;
	}

	static function parseMakeDefines() {
		var defines = "";

		for (i in 0...jsonFile.wiiuMakeConfig.makeDefines.length) {
			defines += " -D" + jsonFile.wiiuMakeConfig.makeDefines[i];
		}

		return defines;
	}
}
