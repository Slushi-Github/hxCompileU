package src.compilers;

import src.SlushiUtils;
import src.compilers.CafeCompiler;
import src.compilers.HaxeCompiler;

class MainCompiler {
	public static function start(arg2:String):Void {
		if (SlushiUtils.parseVersion(Main.version) < SlushiUtils.parseVersion(JsonFile.getJson().programVersion)
			|| SlushiUtils.parseVersion(Main.version) > SlushiUtils.parseVersion(JsonFile.getJson().programVersion)) {
			SlushiUtils.printMsg("The current version of HxCompileU is not the same as the one in the JSON file, this may cause problems, consider checking that file.\n",
				"warning");
		}

		// check libs
		if (Libs.check() == false) {
			SlushiUtils.printMsg("Invalid libs, aborting...", "error");
			return;
		}

		SlushiUtils.printMsg("Starting...", "info");

		if (arg2 == "--onlyHaxe") {
			HaxeCompiler.init();
			return;
		}

		// First compile Haxe part, then Wii U part
		HaxeCompiler.init();
		Sys.sleep(2);
		CafeCompiler.init();
	}
}
