# HxCompileU
![mainImage](https://github.com/Slushi-Github/hxCompileU/blob/main/docs/readme/MainImage.png)

Using this small utility you can compile code from Haxe to PowerPC and finally the Nintendo Wii U using DevKitPro and [reflaxe.CPP](https://github.com/SomeRanDev/reflaxe.CPP).

Please note, it is still missing the possibility to use the WUT toolchain to really make use of the Wii U features! 

## How?
The magic really comes from [reflaxe.CPP](https://github.com/SomeRanDev/reflaxe.CPP), being an alternative to [HXCPP](https://github.com/HaxeFoundation/hxcpp) when you want to compile Haxe to C++.
By default, if you would try to make Haxe with HXCPP compile to PPC... the results are not nice, there are many errors. With reflaxe.CPP we avoid this because it generates a cleaner code without dependencies!

This project is simple, **yet incomplete**. Using it creates a JSON file that contains all the basics for a Haxe compilation and a few other things that would go in the MakeFile.
When compiling, first you compile the Haxe side, then you use a MakeFile to finish the compilation and bring it to the Wii U.

## Why?
Well, ever since I got a Nintendo Wii U a while ago I've been interested in bringing Haxe to this console. 
Officially it's not possible due to mostly Nintendo NDA (Non-Disclosure Agreement) issues, and that you can actually even develop for this console.

So... why not experiment to do it taking advantage of the homebrew that exists for the Wii U? hehe! well this is the project for it!

## Usage

You need [DevKitPro](https://devkitpro.org/wiki/Getting_Started), in addition to DevKitPPC and [WUT](https://github.com/devkitPro/wut).

First, you need compilate this project.

```bash
# Just clone the repository
git clone https://github.com/Slushi-Github/hxCompileU.git

# Compile the project
cd hxCompileU
haxe build.hxml
```

After that, you will get your executable “haxeCompileU” in the ``output`` folder, for the moment, copy it to the root of the project you need it.

### First, initialize your project, that is, create the configuration JSON file that HxCompileU will use, you can create it using this command:
``{haxeCompileUProgram} --prepare``

### Once you have configured your JSON file to what your project needs, you can use the following command to compile it:
``{haxeCompileUProgram} --compile``

If you want to compile only Haxe but not to Wii U, you can use the following command:
``{haxeCompileUProgram} --compile --haxeOnly``

and that's it! if your compilation was successful on both Haxe and Wii U side, your ``.rpx`` and ``.elf`` will be in ``yourOuputFolder/wiiuFiles``.