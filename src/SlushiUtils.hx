// Copyright (c) 2025 Andrés E. G.
//
// This software is licensed under the MIT License.
// See the LICENSE file for more details.

package src;

import sys.FileSystem;
import src.JsonFile;

using StringTools;

/**
 * Just a simple class to print messages and other stuff.
 * The "SlushiUtils" class is common in projects created by me xd.
 * 
 * Author: Slushi.
 */

/**
 * Message types for logging.
 */
enum MsgType {
	INFO;
	SUCCESS;
	WARN;
	ERROR;
	PROCESSING;
	NONE;
	DEBUG;
}

/**
 * The SlushiUtils class is used to print messages, parse versions, etc.
 */
class SlushiUtils {
	/**
	 * Prints a message to the terminal.
	 * @param text The text to print.
	 * @param alertType The type of message.
	 * @param prefix An optional prefix to add to the message.
	 */
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
			case DEBUG:
				Sys.println(prefix + "\x1b[38;5;5m[DEBUG]\033[0m " + text);
			default:
				Sys.println(text);
		}
	}

	/**
	 * Returns the path of the current terminal.
	 * @return String
	 */
	public static function getPathFromCurrentTerminal():String {
		return Sys.getCwd().replace("\\", "/");
	}

	/**
	 * Parses a version string into an integer.
	 * The version is parsed as major.minor.patch, e.g. "1.2.3" -> 10203.
	 * @param version The version string to parse.
	 * @return Int
	 */
	public static function parseVersion(version:String):Int {
		var parts = version.split(".");
		var major = Std.parseInt(parts[0]);
		var minor = parts.length > 1 ? Std.parseInt(parts[1]) : 0;
		var patch = parts.length > 2 ? Std.parseInt(parts[2]) : 0;
		return (major * 10000) + (minor * 100) + patch; // Ej: "1.2.3" -> 10203
	}

	/**
	 * Returns a string explaining the exit code.
	 * @param number The exit code number.
	 * @return String
	 */
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

	/**
	 * Deletes a file or directory recursively.
	 * @param path 
	 */
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

	/**
	 * Cleans the build directory.
	 */
	public static function cleanBuild():Void {
		var outDir = getPathFromCurrentTerminal() + JsonFile.getJson().haxeConfig.outDir;
		var buildDir = getPathFromCurrentTerminal() + "build";

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
