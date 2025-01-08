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
				SlushiUtils.printMsg("HxCompileU v" + version, "none");
			default:
				SlushiUtils.printMsg("Invalid argument: " + args[0], "error");
				return;
		}
	}
}
