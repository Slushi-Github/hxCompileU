package src;

using StringTools;

class SlushiUtils {
	public static function printMsg(text:String, alertType:String, prefix:String = ""):Void {
		switch (alertType) {
			case "error":
				Sys.println(prefix + "\x1b[38;5;1m[ERROR]\033[0m " + text);
			case "warning":
				Sys.println(prefix + "\x1b[38;5;3m[WARNING]\033[0m " + text);
			case "success":
				Sys.println(prefix + "\x1b[38;5;2m[SUCCESS]\033[0m " + text);
			case "info":
				Sys.println("\x1b[38;5;7m[INFO]\033[0m " + text);
			case "processing":
				Sys.println("\x1b[38;5;24m[PROCESSING]\033[0m " + text);
			case "none":
				Sys.println(text);
			default:
				Sys.println(text);
		}
	}

	public static function getPathFromCurrentTerminal():String {
		return Sys.getCwd().replace("\\", "/");
	}

	public static function getExitCodeExplanation(number:Int):String {
		switch (number) {
			case 0:
				return "Compilation successful in Haxe part and/or Wii U part";
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
}
