package src.utils;

enum FinalCheck {
	OK;
	ERROR;
	SKIP;
}

class Libs {
	public static var validLibs:Map<String, Array<String>> = ["libnotifications" => ["hxlibnotifications", "notifications"],
		"slushiUtilsU" => ["slushiUtilsU", "None"],];
	static var jsonFile:JsonStruct = JsonFile.getJson();

	public static function check():FinalCheck {
		if (jsonFile.extraLibs.length == 0) {
			return SKIP;
		}

		for (lib in jsonFile.extraLibs) {
			if (validLibs.exists(lib)) {
				return OK;
			} else {
				SlushiUtils.printMsg("Invalid lib: " + lib, "error");
				return ERROR;
			}
		}

		return ERROR;
	}

	public static function parseHXLibs():Array<String> {
		var libs:Array<String> = [];

		for (hxLib in jsonFile.extraLibs) {
			var finalHxLib:String = validLibs.get(hxLib)[0];
			libs.push("-lib " + finalHxLib);
		}

		return libs;
	}

	public static function parseMakeLibs():Array<String> {
		var libs:Array<String> = [];

		for (makeLib in jsonFile.extraLibs) {
			if (validLibs.get(makeLib)[1] == "None") {
				continue;
			}
			var finalMakeLib:String = validLibs.get(makeLib)[1];
			libs.push("-l" + finalMakeLib);
		}

		return libs;
	}
}
