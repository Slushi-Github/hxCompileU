// Copyright (c) 2025 Andrés E. G.
//
// This software is licensed under the MIT License.
// See the LICENSE file for more details.


package src.utils;

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
	public static function parseCDefines():Array<String> {
		var defines:Array<String> = [];

		for (define in jsonFile.projectDefines) {
			defines.push("-D" + define);
		}

		for (lib in MainCompiler.libs) {
			for (define in lib.libJSONData.mainDefines) {
				defines.push("-D" + define);
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
