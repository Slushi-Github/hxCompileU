package src.compilers;

import src.compilers.HaxeCompiler;
import sys.io.Process;
import sys.io.File;
import sys.FileSystem;
import src.JsonFile;
import src.SlushiUtils;
import haxe.Resource;
import src.Main;

using StringTools;

class CafeCompiler {
	static var jsonFile:JsonStruct = JsonFile.getJson();
	static var exitCodeNum:Int = 0;

	public static function init() {
		if (HaxeCompiler.getExitCode() != 0) {
			return;
		}

		if (jsonFile == null) {
			SlushiUtils.printMsg("Error loading [hxCompileUConfig.json]", "error");
			return;
		}

		// Check if all required fields are set
		if (jsonFile.wiiuConfig.projectName == "") {
			SlushiUtils.printMsg("projectName in [hxCompileUConfig.json -> wiiuConfig.projectName] is empty", "error");
			exitCodeNum = 3;
			return;
		}

		SlushiUtils.printMsg("Trying to compile to Wii U project...", "processing");

		SlushiUtils.printMsg("Creating Makefile...", "processing");
		// Create a temporal Makefile with all required fields
		try {
			// Prepare Makefile
			var makefileContent:String = Resource.getString("cafeMakefileWUT");
			makefileContent = makefileContent.replace("[PROGRAM_VERSION]", Main.version);
			makefileContent = makefileContent.replace("[PROJECT_NAME]", jsonFile.wiiuConfig.projectName);
			makefileContent = makefileContent.replace("[SOURCE_DIR]", jsonFile.haxeConfig.outDir + "/" + jsonFile.haxeConfig.sourceDir);
			makefileContent = makefileContent.replace("[INCLUDE_DIR]", jsonFile.haxeConfig.outDir + "/include");
			makefileContent = makefileContent.replace("[LIBS]", parseMakeLibs());

			if (!FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.haxeConfig.outDir + "/wiiuFiles")) {
				FileSystem.createDirectory(SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.haxeConfig.outDir + "/wiiuFiles");
			}
			makefileContent = makefileContent.replace("[OUT_DIR]", jsonFile.haxeConfig.outDir + "/wiiuFiles");

			// Save Makefile
			// delete temporal makefile if already exists
			if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile")) {
				FileSystem.deleteFile(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile");
				SlushiUtils.printMsg("Deleted existing [Makefile]", "info");
			}

			File.saveContent(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile", makefileContent);
			SlushiUtils.printMsg("Created Makefile", "success");
		} catch (e:Dynamic) {
			SlushiUtils.printMsg("Error creating Makefile: " + e, "error");
			exitCodeNum = 4;
			return;
		}

		SlushiUtils.printMsg("Compiling to Wii U...\n", "processing");

		var startTime:Float = Sys.time(); 

		var compileProcess = Sys.command("make");

		var endTime:Float = Sys.time(); 
		var elapsedTime:Float = endTime - startTime; 
		var formattedTime:String = StringTools.trim(Math.fround(elapsedTime * 10) / 10 + "s");

		if (compileProcess != 0) {
			SlushiUtils.printMsg("Compilation failed", "error", "\n");
			exitCodeNum = 2;
		}

		// delete temporal makefile
		if (jsonFile.deleteTempFiles == true) {
			if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile")) {
				FileSystem.deleteFile(SlushiUtils.getPathFromCurrentTerminal() + "/Makefile");
			}
		}

		if (exitCodeNum == 0) {
			SlushiUtils.printMsg('Compilation successful. Check [${jsonFile.haxeConfig.outDir}/wiiuFiles], compilation time: ${formattedTime}\n', "success", "\n");
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
}
