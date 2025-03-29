package src.utils;

/**
 * The Defines class is used to parse the defines that are required by the project.
 * 
 * Author: Slushi.
 */

class Defines {
	static var jsonFile:JsonStruct = JsonFile.getJson();

	public static function parseHXDefines():Array<String> {
		var defines:Array<String> = [];

		for (define in jsonFile.projectDefines) {
			defines.push("-D " + define);
		}

		return defines;
	}

	public static function parseCDefines():Array<String> {
		var defines:Array<String> = [];

		for (define in jsonFile.projectDefines) {
			defines.push("-D" + define);
		}

		return defines;
	}

	public static function parseOtherOptions():Array<String> {
		var options:Array<String> = [];

		for (option in jsonFile.haxeConfig.othersOptions) {
			options.push(option);
		}

		return options;
	}
}
