package src.compilers;

import src.SlushiUtils;
import src.compilers.CafeCompiler;
import src.compilers.HaxeCompiler;

/**
 * The main compiler, it will start the compilation of the project
 * in Haxe and Wii U.
 * 
 * Author: Slushi.
 */

class MainCompiler {
	public static function start(arg2:String):Void {
		if (SlushiUtils.parseVersion(Main.version) < SlushiUtils.parseVersion(JsonFile.getJson().programVersion)
			|| SlushiUtils.parseVersion(Main.version) > SlushiUtils.parseVersion(JsonFile.getJson().programVersion)) {
			SlushiUtils.printMsg("The current version of HxCompileU is not the same as the one in the JSON file, this may cause problems, consider checking that file.\n",
				WARN);
		}

		// check libs
		if (Libs.check() == FinalCheck.ERROR) {
			SlushiUtils.printMsg("Invalid libs, but continuing...", ERROR);
		}
		else if (Libs.check() == FinalCheck.SKIP) {
			SlushiUtils.printMsg("No extra libs found, but continuing...", INFO);
		}

		SlushiUtils.printMsg("Starting...", INFO);

		if (arg2 == "--onlyHaxe") {
			HaxeCompiler.init();
			return;
		}
		else if (arg2 == "--onlyCafe") {
			CafeCompiler.init();
			return;
		}
		else if (arg2 == "--clean") {
			SlushiUtils.cleanBuild();
		}

		// First compile Haxe part, wait and then compile Wii U part
		HaxeCompiler.init();
		Sys.sleep(2);
		CafeCompiler.init();
	}
}
