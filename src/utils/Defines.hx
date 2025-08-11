// Copyright (c) 2025 Andrés E. G.
//
// This software is licensed under the MIT License.
// See the LICENSE file for more details.


package src.utils;

import src.JsonFile;
import src.compilers.MainCompiler;

/**
 * The Defines class is used to parse the defines that are required by the project.
 * 
 * Author: Slushi.
 */
class Defines {
	static var jsonFile:JsonStruct = JsonFile.getJson();

	/**
	 * Parses the Haxe defines from the JSON file.
	 * @return Array<String>
	 */
	public static function parseHXDefines():Array<String> {
		var defines:Array<String> = [];

		for (define in jsonFile.projectDefines) {
			defines.push("-D " + define);
		}

		for (lib in MainCompiler.libs) {
			for (define in lib.libJSONData.mainDefines) {
				defines.push("-D " + define);
			}
		}

		return defines;
	}

	/**
	 * Parses the C defines from the JSON file.
	 * @return Array<String>
	 */
	public static function parseMakeFileDefines():{main:Array<String>, c:Array<String>, cpp:Array<String>} {
		var defines = {main: [], c: [], cpp: []};

		for (define in jsonFile.projectDefines) {
			defines.main.push("-D" + define);
		}

		for (lib in MainCompiler.libs) {
			for (define in lib.libJSONData.mainDefines) {
				defines.main.push("-D" + define);
			}
		}

		for (lib in MainCompiler.libs) {
			for (define in lib.libJSONData.cDefines) {
				defines.c.push(define);
			}
		}

		for (lib in MainCompiler.libs) {
			for (define in lib.libJSONData.cppDefines) {
				defines.cpp.push(define);
			}
		}

		return defines;
	}

	/**
	 * Parses the other Haxe options from the JSON file.
	 * @return Array<String>
	 */
	public static function parseOtherOptions():Array<String> {
		var options:Array<String> = [];

		for (option in jsonFile.haxeConfig.othersOptions) {
			options.push(option);
		}

		return options;
	}
}
