package src.utils;

using StringTools;

/**
 * The library "manager" of HxCompileU, it contains all the libs that are supported and their configurations
 * I should make a better support that does not require modifying the program itself but, I don't know how 
 * and... there are very few and specific libraries that should work with the project, for the same reason
 * of how specific is the project itself hehe.
 * 
 * Author: Slushi.
 */

enum FinalCheck {
	OK;
	ERROR;
	SKIP;
}

typedef HaxeLib = {
	libName:String,
	requirePreparation:Bool,
	skip:Bool
}

typedef CafeLib = {
	libsArray:Array<String>,
	skip:Bool
}

typedef HxCULibsConfig = {
	haxeLibraries:HaxeLib,
	cafeLibraries:CafeLib
}

class Libs {
	public static var validLibs:Map<String, HxCULibsConfig> = [
		"libnotifications" => {
			haxeLibraries: {libName: "hxu_libnotifications", requirePreparation: false, skip: false},
			cafeLibraries: {libsArray: ["notifications"], skip: false}
		},
		"slushiUtilsU" => {
			haxeLibraries: {libName: "slushiUtilsU", requirePreparation: false, skip: false},
			cafeLibraries: {libsArray: [], skip: true}
		},
		"SDL2" => {
			haxeLibraries: {libName: "hxu_sdl2", requirePreparation: false, skip: false},
			cafeLibraries: {
				libsArray: [
					"SDL2_mixer",
					"SDL2_image",
					"SDL2_ttf",
					"SDL2_gfx",
					"SDL2",
					"vorbisfile",
					"vorbis",
					"ogg",
					"mpg123",
					"modplug",
					"png",
					"jpeg",
					"z",
					"freetype",
					"bz2",
				],
				skip: false
			}
		},
		"SDL_FontCache" => {
			haxeLibraries: {libName: "hxu_sdl_fontcache", requirePreparation: true, skip: false},
			cafeLibraries: {libsArray: [], skip: true}
		},
		"jansson" => {
			haxeLibraries: {libName: "hxu_jansson", requirePreparation: false, skip: false},
			cafeLibraries: {libsArray: ["jansson"], skip: false}
		},
		"leafyEngine" => {
			haxeLibraries: {libName: "leafyengine", requirePreparation: false, skip: false},
			cafeLibraries: {libsArray: [], skip: true}
		},
		"curl" => {
			haxeLibraries: {libName: "", requirePreparation: false, skip: true},
			cafeLibraries: {libsArray: ["curl", "mbedtls", "mbedx509", "mbedcrypto"], skip: false}
		},
		"vorbis" => {
			haxeLibraries: {libName: "hxu_vorbis", requirePreparation: false, skip: false},
			cafeLibraries: {libsArray: ["vorbis"], skip: false}
		},
		// EXPERIMENTAL:
	];

	static var jsonFile:JsonStruct = JsonFile.getJson();

	public static function check():FinalCheck {
		if (jsonFile.extraLibs.length == 0) {
			return SKIP;
		}

		for (lib in jsonFile.extraLibs) {
			if (validLibs.exists(lib)) {
				return OK;
			} else {
				SlushiUtils.printMsg("Invalid lib: " + lib, ERROR);
				return ERROR;
			}
		}

		return OK;
	}

	public static function parseHXLibs():Array<String> {
		var libs:Array<String> = [];

		for (hxLib in jsonFile.extraLibs) {
			if (validLibs.get(hxLib).haxeLibraries.skip) {
				continue;
			}

			var finalHxLib:String = validLibs.get(hxLib).haxeLibraries.libName;
			libs.push("-lib " + finalHxLib);
		}

		return libs;
	}

	public static function parseMakeLibs():Array<String> {
		var libs:Array<String> = [];

		for (makeLib in jsonFile.extraLibs) {
			if (validLibs.get(makeLib).cafeLibraries.skip) {
				continue;
			}

			for (lib in validLibs.get(makeLib).cafeLibraries.libsArray) {
				// If lib contains "[N]" it means it's a lib like: `curl-config --libs`
				if (lib.contains("[N]")) {
					libs.push(lib.replace("[N]", ""));
				} else {
					libs.push("-l" + lib);
				}
			}
		}

		return libs;
	}
}
