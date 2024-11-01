![ares logo](https://github.com/ares-emulator/ares/blob/master/ares/ares/resource/logo.png)

[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](https://github.com/higan-emu/ares/blob/master/LICENSE)

**ares** is a multi-system emulator that began development on October 14th, 2004.
It is a descendant of [higan](https://github.com/higan-emu/higan) and [bsnes](https://github.com/bsnes-emu/bsnes/), and focuses on accuracy and preservation.

Official Releases
-----------------

Official releases are available from
[the ares website](https://ares-emu.net).

Nightly Builds
--------------

Automated, untested builds of ares are available for Windows and macOS as a [pre-release](https://github.com/higan-emu/ares/releases/tag/nightly). 
Only the latest nightly build is kept.

Building
-------------
> [!IMPORTANT]  
> If you are reading this, this build system is still heavily under development. Documentation is incomplete, and it is possible that commands listed here will change or temporarily not function. Thank you for testing! Please feel free to tag @yam on the [ares Discord](https://discord.com/invite/gz2quhk2kv) with any issues.

Building ares requires [CMake](https://cmake.org/download/) 3.28 or greater.

### Windows

ares on Windows can be built either via the default Windows shell, or within an MSYS2/MinGW environment.

#### Windows Command Prompt (MSVC/Clang-CL)

###### Prerequisites

* Windows 10 or higher
* CMake 3.28 or higher
* Git for Windows
* Visual Studio 17 2022

Ensure that the "Desktop Development with C++" package is included in your Visual Studio 2022 installation. Building ares with clang also requires that the "C++ Clang tools for Windows" package is installed.

###### Configuration

First, clone the ares repository:
```
git clone https://github.com/ares-emulator/ares
cd ares
```
A Visual Studio project can be setup by using the `windows` CMake preset:
```
cmake --preset windows
```
This preset will generate a Visual Studio project for ares using Clang-CL that will build all targets and package dependencies appropriately. 

If you prefer to use the MSVC compiler, specify the `windows-msvc` preset:
```
cmake --preset windows-msvc
```
Visual Studio presets will generate single-architecture configuration with the host architecture will be created; if you would like to compile for a specific architecture, you may specify `-A x64` or `-A arm64` as appropriate. Multi-architecture configuration is not supported. 32-bit `x86` builds are not currently supported (*note 10/14: WIP, may work, just untested*).
#### MSYS2/MinGW

Under MSYS2/MinGW, the same Visual Studio CMake presets above are also supported. Under MSYS2/MinGW, we may also however build with GNU Clang or GCC.

###### Prerequisites

* MSYS2
* An appropriate MSYS2 [environment](https://www.msys2.org/docs/environments/), such as CLANG64
* A suitable MinGW toolchain, for example [mingw-w64-llvm](https://packages.msys2.org/base/mingw-w64-llvm) 
* Git (`pacman -S git`)
* CMake 3.28 or higher (`pacman -S cmake`)

First, clone the ares repository:
```
git clone https://github.com/ares-emulator/ares
cd ares
```
Then, invoke CMake as normal with your chosen generator, e.g Ninja:
```
mkdir build && cd build
cmake .. -G "Ninja Multi-Config"
```
After configuration, build ares:
```
cmake --build . --config RelWithDebInfo
```
For further configuration options, see the [Build Options] section.
### macOS

###### Prerequisites

* macOS 10.15 or higher
* Xcode 12.4 or higher
* CMake 3.28 or higher

###### Configuration

First, clone the ares repository:
```
git clone https://github.com/ares-emulator/ares
cd ares
```
macOS builds can be setup by using the `macos` CMake preset:
```
cmake --preset macos
```
This generates an Xcode project in the `build_macos` folder that builds all `ares` targets including subprojects. By default, a single-architecture project with the host architecture is generated. To build universal binaries or cross-compile, the `-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"` option can be specified in addition to the preset.

You may also build with other generators such as Make or Ninja. To do this, invoke CMake as normal:
```
mkdir my_build && cd my_build
cmake .. -G "GNU Makefiles"
```
After configuration, build ares:
```
make desktop-ui -j8
```
For further configuration options, see the [Build Options] section.

### Linux

###### Prerequisites

* Git
* CMake 3.28 or higher
* A compiler toolchain such as clang or gcc

ares requires development versions of the following packages in order to build:

* X11
* libGL
* GTK3 (gtk+-3.0)

Recommended development packages include:

* [librashader](https://software.opensuse.org//download.html?project=home%3Achyyran%3Alibrashader&package=librashader)
* SDL2

You may also configure with development packages for other audio drivers:

* OpenAL
* AO
* ALSA
* PulseAudio

Optional but recommended build tools include:

* Ninja
* clang
* Ccache

###### Configuration

First, clone the ares repository:
```
git clone https://github.com/ares-emulator/ares
cd ares
```
Building ares with `clang` and Ninja is recommended:
```
mkdir build && cd build
cmake .. -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -G "Ninja Multi-Config"
```
The generation step will report what features are enabled and disabled according to the libraries found on your system. Next, build ares:
```
cmake --build .
```
After building, products can be found in the `rundir` folder. ares can be run from this location, or the rundir can be relocated. ares can also be `install`ed:
```
cmake --install . --prefix <your install prefix>
```

### Build Options

When generating/configuring ares on any platform, a number of configuration options are available.

##### ARES_CORES
Default: `"a26;fc;sfc;sg;ms;md;ps1;pce;ng;msx;cv;myvision;gb;gba;ws;ngp;spec;n64"`

By default, ares configures with all emulator cores. To specify that only a subset of cores should be built, use the `-DARES_CORES` option. For example:
```
cmake .. -G Ninja -DARES_CORES="a26;n64;sg;myvision"
```

##### CMAKE_BUILD_TYPE
Default: `RelWithDebInfo`

Multi-configuration generators (Xcode, Visual Studio, Ninja Multi-Config) will automatically configure with all build configurations available. Single-configuration generators will configure by default using the `RelWithDebInfo` configuration. To specify another configuration, use `-DCMAKE_BUILD_TYPE`:

```
cmake .. -G "MinGW Makefiles" -DARES_CORES="a26" -DCMAKE_BUILD_TYPE=Release
```

Supported build types are `<Debug|Release|RelWithDebInfo|MinSizeRel>`.
##### ENABLE_CCACHE
Default: `ON`

ares will try to use CCache by default on all platforms to speed up compilation. You may disable CCache if you are experimenting with compilation options or the build system by building with `-DENABLE_CCACHE=OFF`.

##### ARES_BUILD_LOCAL
Default: `ON`

When this option is enabled, certain compiler optimizations are enabled to optimize performance for the host/target system. This option also controls certain entitlements and runtime options on macOS that interfere with may debugging but are necessary for notarization and distribution.

##### ARES\_ENABLE_LIBRASHADER
Default: `ON`

This flag may be disabled if you wish to compile without librashader and slang-shaders, producing a slimmer build. Note that the librashader header is still required to build without librashader; however, this header is bundled as a dependency on all platforms and it should not be necessary to install any dependency to build without librashader.

##### ARES_PROFILE_ACCURACY
Default: `OFF`

Mostly unused in current versions of ares; acts as a compile-time switch for certain performance-sensitive areas of emulation.

# Legacy build system

Legacy build information is available [here](./Legacy%20Build%20System.md)

Command-line options
--------------------

When started from the command-line, ares accepts a few options.

```
Usage: ./ares [options] game(s)

  --help                 Displays available options and exit
  --fullscreen           Start in full screen mode
  --system system        Specify the system name
  --shader shader        Specify GLSL shader name to load (requires OpenGL driver)
  --setting name=value   Specify a value for a setting
  --dump-all-settings    Show a list of all existing settings and exit
  --no-file-prompt       Do not prompt to load (optional) additional roms (eg: 64DD)
```

The --system option is useful when the system type cannot be auto-detected.
--fullscreen will only have an effect if a game is also passed in argument.

Example:
`ares --system MSX examples.rom --fullscreen`

Specifying multiple games allows for multi-cart support.  For example, to load
the Super GameBoy BIOS and a game in one command (to avoid a file prompt), you 
can do:

`ares "Super GameBoy.sfc" "Super Mario Land.gb"`

The --no-file-prompt option is useful if you wish to launch a game from CLI
without being prompted to load additional roms. For example, some Nintendo 64 
games optionally support 64DD expansion disks, so this option can be used to
suppress the "64DD Disk" file dialog, and assume any secondary content is 
disconnected.

High-level Components
---------------------

* __ares__:       emulator cores and component implementations
* __desktop-ui__: main GUI implementation for this project
* __hiro__:       cross-platform GUI toolkit that utilizes native APIs on supported platforms
* __nall__:       Near's alternative to the C++ standard library
* __ruby__:       interface between a hiro application and platform-specific APIs for emulator video, audio, and input
* __mia__:        internal ROM database and ROM/image loader
* __libco__:      cooperative multithreading library

Contributing
------------

Please join our discord to chat with other ares developers: https://discord.com/invite/gz2quhk2kv
