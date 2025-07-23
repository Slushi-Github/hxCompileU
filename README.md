# HxCompileU
![mainImage](https://github.com/Slushi-Github/hxCompileU/blob/main/docs/readme/MainImage.png)

Using this small utility you can compile code from Haxe to PowerPC and finally the Nintendo Wii U using [DevKitPro](https://devkitpro.org/) and [reflaxe/C++](https://github.com/SomeRanDev/reflaxe.CPP), for creating homebrew for the Wii U.

Officially there are supported libraries to be used in conjunction with HxCompileU:

- [HxU_WUT](https://github.com/Haxe-WiiU/HxU_WUT): the toolchain or SDK used to create homebrew on the Wii U.
- [HxU_LibNotifications](https://github.com/Haxe-WiiU/HxU_LibNotifications): a library to create notifications on the Wii U (Useful for mostly plugins).
- [HxU_LibMappedMemory](https://github.com/Haxe-WiiU/HxU_LibMappedMemory): a library to create mapped memory on the Wii U.
- [SlushiUtilsU](https://github.com/Slushi-Github/slushiUtilsU): a library to facilitate the use of certain Wii U libraries.
- [HxU_SDL2](https://github.com/Haxe-WiiU/HxU_SDL2): SDL2 (SDL2, SDL2_Image, SDL2_mixer...) @:native bindings for Haxe, for use SDL2 on the Wii U.
- [HxU_SDL_FontCache](https://github.com/Haxe-WiiU/HxU_SDL_FontCache): SDL_FontCache @:native bindings for Haxe to do homebrew on Wii U.
- [HxU_Jansson](https://github.com/Haxe-WiiU/HxU_Jansson): Jansson @:native bindings for Haxe to do homebrew on Wii U.
- [HxU_Vorbis](https://github.com/Haxe-WiiU/HxU_Vorbis): Vorbis @:native bindings for Haxe to do homebrew on Wii U.
- [Leafy Engine](https://github.com/Slushi-Github/leafyEngine): A 2D engine for the Wii U made with Haxe and based on [HaxeFilxel](http://haxeflixel.com/).

## How?
The magic really comes from [reflaxe.CPP](https://github.com/SomeRanDev/reflaxe.CPP), being an alternative to [HXCPP](https://github.com/HaxeFoundation/hxcpp) when you want to compile Haxe to C++.
By default, if you would try to make Haxe with [HXCPP](https://github.com/HaxeFoundation/hxcpp) compile to PowerPC... the results are not nice, there are many errors. With [Reflaxe/C++](https://github.com/SomeRanDev/reflaxe.CPP) we avoid this because it generates a cleaner code without dependencies!

This project is simple... But it works!

This program what it does, is that by means of some data stored in a JSON file (``hxCompileUConfig.json``), it generates a MakeFile and a [HXML](https://haxe.org/manual/compiler-usage-hxml.html) file with those data of the JSON, of normal first it will try to execute the [HXML](https://haxe.org/manual/compiler-usage-hxml.html) with Haxe, [Reflaxe/C++](https://github.com/SomeRanDev/reflaxe.CPP) is in charge of generating the C++ code, if the compilation with Haxe is successful, it executes the MakeFile with Make and starts the normal compilation of a C++ code, if this is also successful, that's it, you have your homebrew for the Nintendo Wii U made with Haxe!

### Plugins?
Currently there is only support focused on creating homebrew applications for the Wii U, but I are working on support for creating [WUPS](https://github.com/wiiu-env/WiiUPluginSystem) plugins using this utility, but I do not assure interest that this is entirely possible

## Why?
Well, since I got a Nintendo Wii U a while ago I've been interested in bringing Haxe to this console. 
Officially it's not possible mainly due to Nintendo NDA (Non-Disclosure Agreement) issues, and that actually it can't even be developed for this console anymore.

So... why not experiment to do it taking advantage of the homebrew that exists for the Wii U? hehe! well this is the project for it!

# Usage

The basic usage of HxCompileU is as follows:

You need:
- [DevKitPro](https://devkitpro.org/wiki/Getting_Started)

- [WUT](https://github.com/devkitPro/wut?tab=readme-ov-file#install)

- [Haxe](https://haxe.org/)

- [reflaxe](https://github.com/SomeRanDev/reflaxe)

- [reflaxe.CPP (Fork)](https://github.com/Slushi-Github/reflaxe.CPP)

- [HxU_WUT](https://github.com/Haxe-WiiU/HxU_WUT)

First, you need compilate this project, or you can use the precompiled version that is in the [releases](https://github.com/Slushi-Github/hxCompileU/releases), or you can download it from the [GitHub Actions](https://github.com/Slushi-Github/hxCompileU/actions).

```bash
# Just clone the repository
git clone https://github.com/Slushi-Github/hxCompileU.git

# Compile the project
cd hxCompileU
haxelib install fuzzaldrin
haxe build.hxml
```

After that, you will get your executable ``haxeCompileU`` in the "export" folder, for the moment, copy it to the root of the project folder you need it.

-----

## How to use
#### First, initialize your project, that is, create the configuration JSON file that HxCompileU will use, you can create it using this command:
``{haxeCompileUProgram} --prepare``

 - Or you can import an existing JSON file from a Haxe library with the following command:
``{haxeCompileUProgram} --import HAXE_LIB``

-----

#### Once you have configured your JSON file to what your project needs, you can use the following command to compile it:
``{haxeCompileUProgram} --compile``

 - If you want to compile only Haxe but not to Wii U,
 you can use the following command:

    ``{haxeCompileUProgram} --compile --onlyHaxe``

 - If you want enable the Haxe debug mode, you can use the following command:

    ``{haxeCompileUProgram} --compile --debug`` or ``{haxeCompileUProgram} --compile --onlyHaxe --debug``

- You can also use the following command to compile only Wii U but not Haxe:

    ``{haxeCompileUProgram} --compile --onlyCafe``

-----

#### You can also use the following command search a line of code in the ``.elf`` file from a line address of some log using DevKitPro's ``powerpc-eabi-addr2line`` program:

``{haxeCompileUProgram} --searchProblem [lineAddress]``

-----

#### You can also use the following command send the ``.rpx`` or ``.wps`` file to the Wii U using DevKitPro's ``wiiload`` program:

``{haxeCompileUProgram} --send``

-----

### You can also use the following command to start a UDP server to view the logs from the Wii U:

``{haxeCompileUProgram} --udpServer``

-----

and that's it! if your compilation was successful on both Haxe and Wii U side, your ``.rpx`` or ``.wps`` and ``.elf`` will be in ``yourOutputFolder/wiiuFiles``.

-----

## WUHB conversion

If you want to convert a ``.rpx`` file to a ``.wuhb`` file, you can active the  ``wiiuConfig`` -> ``convertToWUHB`` option in the ``hxCompileUConfig.json`` file and change the information in the ``wiiuConfig`` -> ``wuhbConfig`` section (name, author, etc).
Then, in your project folder, create a folder called ``WUHB`` and put the ``icon.png`` and ``tv_image.png`` and ``drc_image.png`` files there.

After that, you can compile your project using the normal ``--compile`` command, and the ``.wuhb`` file will be in the ``yourOutputFolder/wiiuFiles`` folder.

-----

## License
This project is released under the [MIT license](https://github.com/Slushi-Github/hxCompileU/blob/main/LICENSE.md).