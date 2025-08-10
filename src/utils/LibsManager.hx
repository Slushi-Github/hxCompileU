// Copyright (c) 2025 Andrés E. G.
//
// This software is licensed under the MIT License.
// See the LICENSE file for more details.


package src.utils;

import haxe.Json;
import sys.io.File;
import sys.FileSystem;

using StringTools;

/**
 * The HxCULibJSONStruct is used to store the JSON data of a HxCU library.
 */
typedef HxCULibJSONStruct = {
	libVersion:String,
	// Haxe things
	haxeLibs:Array<String>,
	// Wii U things
	wiiuLibs:Array<String>,
	// Other things
	mainDefines:Array<String>,
	// MakeFile things
	cDefines:Array<String>,
	cppDefines:Array<String>
}

/**
 * The HxCULibStruct is used to store the data of a HxCU library.
 * It contains the JSON data of the library and the name of the Haxe library.
 */
typedef HxCULibStruct = {
    libJSONData:HxCULibJSONStruct,
    hxLibName:String,
}

/**
 * The LibsManager class is used to manage the libs of the project, it will
 * parse check the libs in the JSON file and return the required libs for the project.
 *
 * This was much easier than the first version of the HxCompileU library manager, now 
 * there are no longer only a few libraries allowed per compiler version, they can
 * now be as many as the user needs.
 * In addition to searching for each Haxe library, if a library 
 * requires additional Haxe libraries, the compiler will search for them and if 
 * they exist, it will import the necessary data (like more Haxe libraries or the C++ libraries for the Wii U).
 *
 * Author: Slushi.
 */
class LibsManager {
	private static final jsonName:String = "HxCU_Meta.json";

	static var mainJsonFile:JsonStruct = JsonFile.getJson();

	public static function getRequiredLibs():Array<HxCULibStruct> {
		var libs:Array<HxCULibStruct> = [];
		var importedLibs = new Map<String, Bool>();
		if (mainJsonFile.extraLibs.length == 0) {
			return libs;
		}

		var requiredMainLibs:Array<String> = mainJsonFile.extraLibs;
		var mainPath:String = "";
		var haxelibPath:String = Sys.getEnv("HAXEPATH") + "/lib";

		if (FileSystem.exists(SlushiUtils.getPathFromCurrentTerminal() + ".haxelib")) {
			mainPath = SlushiUtils.getPathFromCurrentTerminal() + ".haxelib";
		} else {
			mainPath = haxelibPath;
		}

		function processLib(libName:String, libVersion:String = null) {
			if (importedLibs.exists(libName)) return;
			importedLibs.set(libName, true);

			var libFolder = mainPath + "/" + libName;
			if (!FileSystem.exists(libFolder)) {
				SlushiUtils.printMsg("Required Haxe lib [" + libName + "] not found.", WARN);
				return;
			}
			var versionFolder = "";
			if (libVersion != null) {
				versionFolder = libVersion.replace(".", ",");
			} else if (FileSystem.exists(libFolder + "/.current")) {
				var currentVersion = File.getContent(libFolder + "/.current").trim();
				versionFolder = currentVersion.replace(".", ",");
			}
			var metaPath = "";
			if (FileSystem.exists(libFolder + "/.current") && File.getContent(libFolder + "/.current").trim() == "git") {
				metaPath = libFolder + "/git/" + jsonName;
			} else {
				metaPath = libFolder + "/" + versionFolder + "/" + jsonName;
			}
			if (!FileSystem.exists(metaPath)) {
				SlushiUtils.printMsg("Meta file [" + metaPath + "] not found for lib [" + libName + "]", WARN);
				return;
			}
			try {
				var fileContent = File.getContent(metaPath);
				var jsonContent:Dynamic = Json.parse(fileContent);

				// SlushiUtils.printMsg("LIB CONTENT:\n" + "libVersion: " + jsonContent.libVersion + "\nhaxeLibs: " + jsonContent.haxeLibs + "\nwiiuLibs: " + jsonContent.wiiuLibs + "\nmainDefines: " + jsonContent.mainDefines + "\n", DEBUG);

				libs.push({
					libJSONData: {
						libVersion: jsonContent.libVersion,
						haxeLibs: jsonContent.haxeLibs,
						wiiuLibs: jsonContent.wiiuLibs,
						mainDefines: jsonContent.mainDefines,
						cDefines: jsonContent.cDefines,
						cppDefines: jsonContent.cppDefines
					},
					hxLibName: libName,
				});

				// Recursively process extra haxeLibs
				var jsonExtraLibs:Array<String> = jsonContent.haxeLibs;
				for (extraLib in jsonExtraLibs) {
					var extraLibName = extraLib;
					var extraLibVersion:String = null;
					if (extraLib.indexOf(":") != -1) {
						var parts = extraLib.split(":");
						extraLibName = parts[0];
						extraLibVersion = parts[1];
					}
					processLib(extraLibName, extraLibVersion);
				}
			} catch (e) {
				SlushiUtils.printMsg("Error loading [" + metaPath + "]: " + e, ERROR);
				return;
			}
		}

		for (libEntry in requiredMainLibs) {
			var libName = libEntry;
			var libVersion:String = null;
			if (libEntry.indexOf(":") != -1) {
				var parts = libEntry.split(":");
				libName = parts[0];
				libVersion = parts[1];
			}
			processLib(libName, libVersion);
		}
		return libs;
	}

	public static function parseHXLibs():Array<String> {
		var libs:Array<String> = [];

		for (i in 0...MainCompiler.libs.length) {
			if (MainCompiler.libs[i].libJSONData.haxeLibs.length == 0) {
				continue;
			}

			libs.push("-lib " + MainCompiler.libs[i].hxLibName);

			for (lib in MainCompiler.libs[i].libJSONData.haxeLibs) {
				libs.push("-lib " + lib);
			}
		}

		return libs;
	}

	public static function parseCPPLibs():Array<String> {
		var libs:Array<String> = [];

		for (i in 0...MainCompiler.libs.length) {

			// SlushiUtils.printMsg("CPP Lib:" + MainCompiler.libs[i].libJSONData.wiiuLibs, DEBUG);

			if (MainCompiler.libs[i].libJSONData.wiiuLibs.length <= 0) {
				continue;
			}

			for (lib in MainCompiler.libs[i].libJSONData.wiiuLibs) {
				libs.push("-l" + lib);
			}
		}

		// SlushiUtils.printMsg("FINAL CPP Libs:" + libs, DEBUG);

		return libs;
	}
}
