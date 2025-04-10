# HxCompileU
![mainImage](https://github.com/Slushi-Github/hxCompileU/blob/main/docs/readme/MainImage.png)

Using this small utility you can compile code from Haxe to PowerPC and finally the Nintendo Wii U using [DevKitPro](https://devkitpro.org/) and [reflaxe.CPP](https://github.com/SomeRanDev/reflaxe.CPP).

Currently supported libraries to be used in conjunction with HxCompileU:

- [hxWUT](https://github.com/Slushi-Github/hxWUT): the toolchain or SDK used to create homebrew on the Wii U.
- [hxLibNotifications](https://github.com/Slushi-Github/hxLibNotifications): a library to create notifications on the Wii U (Useful for mostly plugins).
- [hxLibMappedMemory](https://github.com/Slushi-Github/hxLibMappedMemory): a library to create mapped memory on the Wii U.
- [SlushiUtilsU](https://github.com/Slushi-Github/slushiUtilsU): a library to facilitate the use of certain Wii U libraries.
- [hxSDL2](https://github.com/Slushi-Github/hxSDL2): SDL2 (SDL2, SDL2_Image, SDL2_mixer...) @:native bindings for Haxe, for use SDL2 on the Wii U.
- [hxSDL_FontCache](https://github.com/Slushi-Github/hxSDL_FontCache): SDL_FontCache @:native bindings for Haxe to do homebrew on Wii U.
- [hxJansson](https://github.com/Slushi-Github/hxJansson): Jansson @:native bindings for Haxe to do homebrew on Wii U.

## How?
The magic really comes from [reflaxe.CPP](https://github.com/SomeRanDev/reflaxe.CPP), being an alternative to [HXCPP](https://github.com/HaxeFoundation/hxcpp) when you want to compile Haxe to C++.
By default, if you would try to make Haxe with HXCPP compile to PPC... the results are not nice, there are many errors. With reflaxe.CPP we avoid this because it generates a cleaner code without dependencies!

This project is simple, **yet incomplete**. 

This program what it does, is that by means of some data stored in a JSON file (``hxCompileUConfig.json``), it generates a MakeFile and a [HXML](https://haxe.org/manual/compiler-usage-hxml.html) file with those data of the JSON, of normal first it will try to execute the [HXML](https://haxe.org/manual/compiler-usage-hxml.html) with Haxe, [reflaxe.CPP](https://github.com/SomeRanDev/reflaxe.CPP) is in charge of generating the C++ code, if the compilation with Haxe is successful, it executes the MakeFile with Make and starts the normal compilation of a C++ code, if this is also successful, that's it, you have your homebrew for the Nintendo Wii U made with Haxe!

## Why?
Well, since I got a Nintendo Wii U a while ago I've been interested in bringing Haxe to this console. 
Officially it's not possible mainly due to Nintendo NDA (Non-Disclosure Agreement) issues, and that actually it can't even be developed for this console anymore.

So... why not experiment to do it taking advantage of the homebrew that exists for the Wii U? hehe! well this is the project for it!

## Usage

You need:
- [DevKitPro](https://devkitpro.org/wiki/Getting_Started)

- [WUT](https://github.com/devkitPro/wut?tab=readme-ov-file#install)

- [reflaxe](https://github.com/SomeRanDev/reflaxe)

- [reflaxe.CPP (Fork)](https://github.com/Slushi-Github/reflaxe.CPP)

- [hxWUT](https://github.com/Slushi-Github/hxWUT)

First, you need compilate this project, or you can use the precompiled version that is in the [releases](https://github.com/Slushi-Github/hxCompileU/releases), or you can download it from the [GitHub Actions](https://github.com/Slushi-Github/hxCompileU/actions).

```bash
# Just clone the repository
git clone https://github.com/Slushi-Github/hxCompileU.git

# Compile the project
cd hxCompileU
haxe build.hxml
```

After that, you will get your executable “haxeCompileU” in the ``export`` folder, for the moment, copy it to the root of the project you need it.

#### First, initialize your project, that is, create the configuration JSON file that HxCompileU will use, you can create it using this command:
``{haxeCompileUProgram} --prepare``

#### Once you have configured your JSON file to what your project needs, you can use the following command to compile it:
``{haxeCompileUProgram} --compile``

If you want to compile only Haxe but not to Wii U, you can use the following command:

``{haxeCompileUProgram} --compile --onlyHaxe``


You can also use the following command to compile only Wii U but not Haxe:

``{haxeCompileUProgram} --compile --onlyCafe``


You can also use the following command search a line of code in the ``.elf`` file from a line address of some log using DevKitPro's ``powerpc-eabi-addr2line`` program:

``{haxeCompileUProgram} --searchProblem [lineAddress]``


You can also use the following command send the ``.rpx`` file to the Wii U using DevKitPro's ``wiiload`` program:

``{haxeCompileUProgram} --sendRPX``


and that's it! if your compilation was successful on both Haxe and Wii U side, your ``.rpx`` and ``.elf`` will be in ``yourOuputFolder/wiiuFiles``.