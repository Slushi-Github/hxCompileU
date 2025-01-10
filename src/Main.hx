package src;

import src.SlushiUtils;
import src.compilers.MainCompiler;

class Main {
	public static var version:String = "1.0.0";
	static var stdin = Sys.stdin();
	static var stdout = Sys.stdout();
	static var args = Sys.args();

	public static function main() {
		if (args.length < 1) {
			SlushiUtils.printMsg("No arguments", "warning");
			return;
		}

		switch (args[0]) {
			case "--prepare":
				JsonFile.createJson();
			case "--compile":
				MainCompiler.start(args[1]);
			case "--version":
				SlushiUtils.printMsg("HxCompileU v" + version + " -- Created by Slushi", "none");
			case "--help":
				SlushiUtils.printMsg("Usage: hxCompileU [command]\nCommands:\n\t--prepare: Creates hxCompileUConfig.json\n\t--compile: Compiles the project (use \"--compile --onlyHaxe\" for compiling only the Haxe part)\n\t--version: Shows the version of the compiler\n\t--help: Shows this message", "none");
			default:
				SlushiUtils.printMsg("Invalid argument: " + args[0], "error");
				return;
		}
	}
}
