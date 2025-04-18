package src;

import src.SlushiUtils;
import src.compilers.MainCompiler;
import src.utils.DevKitProUtils;
import src.utils.UDPListener;

class Main {
	public static var hxcompileuString = "\x1b[38;5;214mHx\033[0mCompile\x1b[38;5;74mU\033[0m";
	public static var version:String = "1.3.6";
	static var stdin = Sys.stdin();
	static var stdout = Sys.stdout();
	static var args = Sys.args();

	public static function main() {
		if (args.length < 1) {
			SlushiUtils.printMsg("No arguments, use --help for more information", NONE);
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
				case "--udpServer":
					UDPListener.start();
				case "--sendRPX":
					DevKitProUtils.sendRPX();
				case "--version":
					// No need to print the version here, it's already printed at the start of the program
					return;
				case "--help":
					SlushiUtils.printMsg("Usage: hxCompileU [command]\nCommands:\n\t--prepare: Creates hxCompileUConfig.json\n\t--compile: Compiles the project (use \"--compile --onlyHaxe\" for compiling only the Haxe part)\n\t--searchProblem: search for a line of code in the [.elf] file from a line address of some log using DevKitPro's powerpc-eabi-addr2line program\n\t--udpServer: Starts the UDP server to view logs from the Wii U\n\t--sendRPX: Sends the .rpx file to the Wii U\n\t--version: Shows the version of the compiler\n\t--help: Shows this message",
						NONE);
				default:
					SlushiUtils.printMsg("Invalid argument: [" + args[0] + "], use --help for more information", NONE);
					return;
			}
		} catch (e) {
			SlushiUtils.printMsg("Unknown Error: " + e, ERROR);
		}
	}
}
