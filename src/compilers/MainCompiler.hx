// Copyright (c) 2025 Andrés E. G.
//
// This software is licensed under the MIT License.
// See the LICENSE file for more details.


package src.compilers;

import src.SlushiUtils;
import src.compilers.CafeCompiler;
import src.compilers.HaxeCompiler;

import src.utils.LibsManager;

/**
 * The main compiler, it will start the compilation of the project
 * in Haxe and Wii U.
 * 
 * Author: Slushi.
 */
class MainCompiler {
	public static var libs:Array<HxCULibStruct> = [];

	/**
	 * Starts the compilation of the project.
	 */
	public static function start(arg2:String, arg3:String):Void {
		if (SlushiUtils.parseVersion(Main.version) < SlushiUtils.parseVersion(JsonFile.getJson().programVersion)) {
			SlushiUtils.printMsg("The current version of HxCompileU is older than the one in the JSON file, consider updating it.", WARN);
		}
		else if (SlushiUtils.parseVersion(Main.version) > SlushiUtils.parseVersion(JsonFile.getJson().programVersion)) {
			SlushiUtils.printMsg("The current version of HxCompileU is newer than the one in the JSON file, consider checking the JSON file.", WARN);
		}

		// Check and get required libs
		libs = LibsManager.getRequiredLibs();

		SlushiUtils.printMsg("Starting...", INFO);

		if (JsonFile.getJson().wiiuConfig.isAPlugin == true) {
			SlushiUtils.printMsg("The current project is configured as a plugin, this is an experimental feature! It may not work as expected.", WARN);
		}

		if (arg2.toLowerCase() == "--debug" || (arg2 == "--onlyHaxe" && arg3.toLowerCase() == "--debug")) {
			HaxeCompiler.forceDebugMode = true;
		}

		if (arg2 == "--onlyHaxe") {
			HaxeCompiler.init();
			return;
		}
		else if (arg2 == "--onlyCafe") {
			CafeCompiler.init();
			return;
		}
		else if (arg2.toLowerCase() == "--clean") {
			SlushiUtils.cleanBuild();
		}

		// First compile Haxe part and then compile Wii U part
		HaxeCompiler.init();
		CafeCompiler.init();

		// Convert to WUHB if needed
		if (JsonFile.getJson().wiiuConfig.convertToWUHB == true) {
			SlushiUtils.printMsg("Converting to WUHB...", INFO);
			DevKitProUtils.convertToWUHB();
			SlushiUtils.printMsg("Conversion to WUHB completed.", SUCCESS);
		}
	}
}
