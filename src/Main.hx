// Copyright (c) 2025 Andrés E. G.
//
// This software is licensed under the MIT License.
// See the LICENSE file for more details.


package src;

import src.SlushiUtils;
import src.compilers.MainCompiler;
import src.utils.DevKitProUtils;
import src.utils.UDPListener;

/**
 * The Main class is the entry point of the HxCompileU compiler.
 * It handles the command line arguments and starts the compilation process.
 * 
 * Author: Slushi
 */
class Main {
	public static var hxcompileuString = "\x1b[38;5;214mHx\033[0mCompile\x1b[38;5;74mU\033[0m";
	public static final version:String = "1.5.3";
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
				case "--import":
					JsonFile.importJSON(args[1]);
				case "--compile":
					MainCompiler.start(args[1], args[2]);
				case "--searchProblem":
					DevKitProUtils.searchProblem(args[1]);
				case "--udpServer":
					UDPListener.start();
				case "--send":
					DevKitProUtils.send();
				case "--version":
					// No need to print the version here, it's already printed at the start of the program
					return;
				case "--help":
					SlushiUtils.printMsg("Usage: haxeCompileU [command]\nCommands:\n\t--prepare: Creates hxCompileUConfig.json in the current directory.\n\t--import \033[3mHAXE_LIB\033[0m: Imports a JSON file from a Haxe lib to the current directory \n\t--compile: Compiles the project. \n\t\tUse \"--compile --onlyHaxe\" for compiling only the Haxe part. \n\t\tUse \"--compile --onlyCafe\" for compiling only the Wii U part.\n\t\tAdd \"--debug\" or \"--onlyHaxe --debug\" to enable Haxe debug mode\n\t--searchProblem \033[3mLINE_ADDRESS\033[0m: search for a line of code in the [.elf] file from a line address of some log using DevKitPro's powerpc-eabi-addr2line program\n\t--udpServer: Starts the UDP server on port 4405 to view logs from the Wii U\n\t--send: Sends the .rpx or .wps file to the Wii U\n\t--version: Shows the version of the compiler\n\t--help: Shows this message",
						NONE);
				default:
					SlushiUtils.printMsg("Invalid argument: [" + args.join(" ") + "], use \033[3m--help\033[0m argument for more information", NONE);
					return;
			}
		} catch (e) {
			SlushiUtils.printMsg("Unknown Error: " + e, ERROR);
		}
	}
}
