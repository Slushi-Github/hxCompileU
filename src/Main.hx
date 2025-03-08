package src;

import src.SlushiUtils;
import src.compilers.MainCompiler;

class Main {
	public static var hxcompileuString = "\x1b[38;5;214mHx\033[0mCompile\x1b[38;5;74mU\033[0m";
	public static var version:String = "1.2.5";
	static var stdin = Sys.stdin();
	static var stdout = Sys.stdout();
	static var args = Sys.args();

	public static function main() {
		if (args.length < 1) {
			SlushiUtils.printMsg("No arguments, use --help for more information", "warning");
			return;
		}

		if (args[0] != "--version" || args[0] != "--help" || args.length < 1) {
			SlushiUtils.printMsg('$hxcompileuString v$version -- Created by \033[96mSlushi\033[0m', "none");
		}

		try {
			switch (args[0]) {
				case "--prepare":
					JsonFile.createJson();
				case "--compile":
					MainCompiler.start(args[1]);
				case "--version":
					SlushiUtils.printMsg('$hxcompileuString v$version -- Created by \033[96mSlushi\033[0m', "none");
				case "--help":
					SlushiUtils.printMsg("Usage: hxCompileU [command]\nCommands:\n\t--prepare: Creates hxCompileUConfig.json\n\t--compile: Compiles the project (use \"--compile --onlyHaxe\" for compiling only the Haxe part)\n\t--version: Shows the version of the compiler\n\t--help: Shows this message",
						"none");
				default:
					SlushiUtils.printMsg("Invalid argument: " + args[0], "error");
					return;
			}
		} catch (e) {
			SlushiUtils.printMsg("Unknown Error: " + e, "error");
		}
	}
}
