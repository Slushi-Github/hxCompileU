package src.compilers;

import src.SlushiUtils;
import src.compilers.CafeCompiler;

class MainCompiler {
    public static function start(arg2:String):Void {
        SlushiUtils.printMsg("Starting...", "info");

        if (arg2 == "--onlyHaxe") {
            HaxeCompiler.init();
            if (HaxeCompiler.getExitCode() != 0) {
                SlushiUtils.printMsg("Compilation failed", "error");
                SlushiUtils.printMsg(SlushiUtils.getExitCodeExplanation(HaxeCompiler.getExitCode()), "info");
            }
            return;
        }

        // First compile Haxe part, then Wii U part
        HaxeCompiler.init();
		if (HaxeCompiler.getExitCode() != 0) {
			SlushiUtils.printMsg("Compilation failed in Haxe part, Wii U part will be skipped", "error");
			SlushiUtils.printMsg(SlushiUtils.getExitCodeExplanation(HaxeCompiler.getExitCode()), "info");
			return;
		}

        Sys.sleep(2);
        SlushiUtils.printMsg("\n", "none");

        CafeCompiler.init();
        if (CafeCompiler.getExitCode() != 0) {
            SlushiUtils.printMsg("Compilation failed in Wii U part", "error");
            SlushiUtils.printMsg(SlushiUtils.getExitCodeExplanation(CafeCompiler.getExitCode()), "info");
            return;
        }
    }
}