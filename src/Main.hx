package src;

import src.SlushiUtils;
import src.compilers.MainCompiler;
import src.utils.DevKitProUtils;

class Main {
	public static var hxcompileuString = "\x1b[38;5;214mHx\033[0mCompile\x1b[38;5;74mU\033[0m";
	public static var version:String = "1.3.2";
	static var stdin = Sys.stdin();
	static var stdout = Sys.stdout();
	static var args = Sys.args();

	public static function main() {
		if (args.length < 1) {
			SlushiUtils.printMsg("No arguments, use --help for more information", WARN);
			return;
		}

		if (args[0] != "--version" || args[0] != "--help" || args.length < 1) {
			SlushiUtils.printMsg('$hxcompileuString v$version -- Created by \033[96mSlushi\033[0m', NONE);
		}

		if (JsonFile.checkJson() == false) {
			return;
		}

		try {
			switch (args[0]) {
				case "--prepare":
					JsonFile.createJson();
				case "--compile":
					MainCompiler.start(args[1]);
				case "--searchProblem":
					DevKitProUtils.searchProblem(args[1]);
				case "--version":
					SlushiUtils.printMsg('$hxcompileuString v$version -- Created by \033[96mSlushi\033[0m', NONE);
				case "--help":
					SlushiUtils.printMsg("Usage: hxCompileU [command]\nCommands:\n\t--prepare: Creates hxCompileUConfig.json\n\t--compile: Compiles the project (use \"--compile --onlyHaxe\" for compiling only the Haxe part)\n\t--searchProblem: search for a line of code in the [.elf] file from a line address of some log using DevKitPro's powerpc-eabi-addr2line \n\t--version: Shows the version of the compiler\n\t--help: Shows this message",
						NONE);
				default:
					SlushiUtils.printMsg("Invalid argument: " + args[0], ERROR);
					return;
			}
		} catch (e) {
			SlushiUtils.printMsg("Unknown Error: " + e, ERROR);
		}
	}
}
