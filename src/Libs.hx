package src;

class Libs {
	public static var validLibs:Map<String, Array<String>> = [
		// "wut" => ["hxwut", "wut"],
		"libnotifications" => ["hxlibnotifications", "notifications"],
	];

	static var jsonFile:JsonStruct = JsonFile.getJson();

	public static function check():Bool {
		for (lib in jsonFile.extraLibs) {
			if (validLibs.exists(lib)) {
				return true;
			} else {
				SlushiUtils.printMsg("Invalid lib: " + lib, "error");
				return false;
			}
		}

		return false;
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
			var finalMakeLib:String = validLibs.get(makeLib)[1];
			libs.push("-l" + finalMakeLib);
		}

		return libs;
	}
}
