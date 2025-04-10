package src.utils;

import haxe.io.Path;

/**
 * The DevKitProUtils class is used to use the DevKitPro tools
 * For now, only the powerpc-eabi-addr2line tool is used.
 * 
 * Author: Slushi.
 */

class DevKitProUtils {
	public static var jsonFile:JsonStruct = JsonFile.getJson();

	public static function searchProblem(address:String) {
		if (address == null || address == "") {
			SlushiUtils.printMsg("Invalid address", ERROR);
			return;
		}

        var elfPath:String = SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.haxeConfig.outDir + "/wiiuFiles/" + jsonFile.wiiuConfig.projectName + ".elf";
		if (!FileSystem.exists(elfPath)) { 
            SlushiUtils.printMsg("[.elf] file not found", ERROR);
            return;
        }

        var devKitProPPCEnv = Sys.getEnv("DEVKITPPC");
		var addr2lineProgram:String = devKitProPPCEnv + "/bin/powerpc-eabi-addr2line";

        if (devKitProPPCEnv == null) {
            SlushiUtils.printMsg("DEVKITPPC environment variable not found", ERROR);
            return;
        }

		SlushiUtils.printMsg("If the output is \"??:0\", the address does not exist or is invalid", NONE);
		SlushiUtils.printMsg("----------------------", NONE);
		Sys.command(addr2lineProgram, ["-e", elfPath, address]);
		SlushiUtils.printMsg("----------------------", NONE);
	}

	public static function sendRPX():Void {
		var rpxPath:String = SlushiUtils.getPathFromCurrentTerminal() + "/" + jsonFile.haxeConfig.outDir + "/wiiuFiles/" + jsonFile.wiiuConfig.projectName
			+ ".rpx";
		if (!FileSystem.exists(rpxPath)) {
			SlushiUtils.printMsg("[.rpx] file not found", ERROR);
			return;
		}

		// remove path from the file name
		var rpxFileName:String = Path.withoutDirectory(rpxPath);

		SlushiUtils.printMsg("Sending RPX file: [" + rpxFileName + "]", PROCESSING);

		var devKitProToolsEnv = Sys.getEnv("DEVKITPRO");

		var wiiloadProgram = devKitProToolsEnv + "/tools/bin/wiiload";

		if (Sys.getEnv("WIILOAD") == null) {
			Sys.putEnv("WIILOAD", jsonFile.wiiuConfig.consoleIP);
		} else {
			SlushiUtils.printMsg("WIILOAD environment variable already set, using that...", WARN);
		}

		if (devKitProToolsEnv == null) {
			SlushiUtils.printMsg("DEVKITPRO environment variable not found", ERROR);
			return;
		}

		Sys.command(wiiloadProgram, [rpxPath]);
	}
}
