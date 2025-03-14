package src;

using StringTools;

enum MsgType {
	INFO;
	SUCCESS;
	WARN;
	ERROR;
	PROCESSING;
	NONE;
}

class SlushiUtils {
	public static function printMsg(text:Dynamic, alertType:MsgType, prefix:String = ""):Void {
		switch (alertType) {
			case ERROR:
				Sys.println(prefix + "\x1b[38;5;1m[ERROR]\033[0m " + text);
			case WARN:
				Sys.println(prefix + "\x1b[38;5;3m[WARNING]\033[0m " + text);
			case SUCCESS:
				Sys.println(prefix + "\x1b[38;5;2m[SUCCESS]\033[0m " + text);
			case INFO:
				Sys.println(prefix + "\x1b[38;5;7m[INFO]\033[0m " + text);
			case PROCESSING:
				Sys.println(prefix + "\x1b[38;5;24m[PROCESSING]\033[0m " + text);
			case NONE:
				Sys.println(prefix + text);
			default:
				Sys.println(text);
		}
	}

	public static function getPathFromCurrentTerminal():String {
		return Sys.getCwd().replace("\\", "/");
	}

	public static function parseVersion(version:String):Int {
		var parts = version.split(".");
		var major = Std.parseInt(parts[0]);
		var minor = parts.length > 1 ? Std.parseInt(parts[1]) : 0;
		var patch = parts.length > 2 ? Std.parseInt(parts[2]) : 0;
		return (major * 10000) + (minor * 100) + patch; // Ej: "1.2.3" -> 10203
	}

	public static function getExitCodeExplanation(number:Int):String {
		switch (number) {
			case 1:
				return "Compilation failed in Haxe part";
			case 2:
				return "Compilation failed in Wii U part";
			case 3:
				return "Error loading some part of [hxCompileUConfig.json]";
			case 4:
				return "Error creating some file";
			default:
				return "Unknown error";
		}
	}

	public static function cleanBuild():Void {
		if (FileSystem.exists(getPathFromCurrentTerminal() + "/" + JsonFile.getJson().haxeConfig.outDir)) {
			try {
				FileSystem.deleteDirectory(getPathFromCurrentTerminal() + "/output");
				SlushiUtils.printMsg("Deleted [" + JsonFile.getJson().haxeConfig.outDir + "] directory", SUCCESS);
			}
		}

		if (FileSystem.exists(getPathFromCurrentTerminal() + "/build")) {
			try {
				FileSystem.deleteDirectory(getPathFromCurrentTerminal() + "/build");
				SlushiUtils.printMsg("Deleted [build] directory", SUCCESS);
			}
		}
	}
}
