package src.utils;

enum FinalCheck {
	OK;
	ERROR;
	SKIP;
}

class Libs {
	public static var validLibs:Map<String, Array<Array<String>>> = [
		"libnotifications" => [["hxlibnotifications"], ["notifications"]],
		"slushiUtilsU" => [["slushiUtilsU"], ["None"]],
		"SDL2" => [["hxsdl2"], ["SDL2_mixer", "SDL2_image", "SDL2_ttf", "SDL2_gfx", "SDL2", "vorbisfile", "vorbis", "ogg", "ogg", "mpg123", "modplug", "png", "jpeg", "z"]],
		// EXPERIMENTAL:
		"leafyEngine" => [["leafyengine"], ["None"]],
	];

	// HxSDLU

	static var jsonFile:JsonStruct = JsonFile.getJson();

	public static function check():FinalCheck {
		if (jsonFile.extraLibs.length == 0) {
			return SKIP;
		}

		for (lib in jsonFile.extraLibs) {
			if (validLibs.exists(lib)) {
				return OK;
			} else {
				SlushiUtils.printMsg("Invalid lib: " + lib, ERROR);
				return ERROR;
			}
		}

		return ERROR;
	}

	public static function parseHXLibs():Array<String> {
		var libs:Array<String> = [];

		for (hxLib in jsonFile.extraLibs) {

			if (validLibs.get(hxLib)[0][0] == "None") {
				continue;
			}

			var finalHxLib:String = validLibs.get(hxLib)[0][0];
			libs.push("-lib " + finalHxLib);
		}

		return libs;
	}

	public static function parseMakeLibs():Array<String> {
		var libs:Array<String> = [];

		for (makeLib in jsonFile.extraLibs) {
			if (validLibs.get(makeLib)[1][0] == "None") {
				continue;
			}

			for (lib in validLibs.get(makeLib)[1]) {
				libs.push("-l" + lib);
			}
		}

		return libs;
	}
}
