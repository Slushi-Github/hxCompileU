package src;

using StringTools;

/**
 * Just a simple class to print messages and other stuff.
 * The "SlushiUtils" class is common in projects created by me xd.
 * 
 * Author: Slushi.
 */

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

	public static function deleteRecursively(path:String):Void {
		if (FileSystem.exists(path)) {
			if (FileSystem.isDirectory(path)) {
				for (file in FileSystem.readDirectory(path)) {
					deleteRecursively(path + "/" + file);
				}
				FileSystem.deleteDirectory(path);
			} else {
				FileSystem.deleteFile(path);
			}
		}
	}

	public static function cleanBuild():Void {
		var outDir = getPathFromCurrentTerminal() + "/" + JsonFile.getJson().haxeConfig.outDir;
		var buildDir = getPathFromCurrentTerminal() + "/build";

		if (FileSystem.exists(outDir)) {
			try {
				deleteRecursively(outDir);
				SlushiUtils.printMsg("Deleted [" + outDir + "]", SUCCESS);
			} catch (e:Dynamic) {
				SlushiUtils.printMsg("Failed to delete [" + outDir + "]: " + e, ERROR);
			}
		}

		if (FileSystem.exists(buildDir)) {
			try {
				deleteRecursively(buildDir);
				SlushiUtils.printMsg("Deleted [" + buildDir + "]", SUCCESS);
			} catch (e:Dynamic) {
				SlushiUtils.printMsg("Failed to delete [" + buildDir + "]: " + e, ERROR);
			}
		}
	}
}
