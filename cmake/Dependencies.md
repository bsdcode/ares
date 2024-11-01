# Dependencies

This document provides an extensive overview of how dependencies and packaging work in the ares build system with a little bit of overall contextual information about dependencies in CMake in general.

## The Link Interface

In modern CMake, each independent component of the build system is meant to be thought of as a target. For ares, this means `hiro`, `nall`, `ruby`, etc. all constitute different CMake targets underneath the `ares` namespace. We might link two targets together like so:
```cmake
target_link_libraries(ares::hiro PRIVATE ares::nall)
```
By doing this, we have made `nall` a dependency of `hiro` (or in CMake terms, `hiro` is a dependent of `nall`). When we link together these two targets, not only does that mean that when we eventually build `hiro`, the `nall` library file will be passed to the C++ linker, but more generally, `hiro` will also become aware of any `PUBLIC` OR `INTERFACE` properties in nall. For example, we might have the following properties:
```cmake
target_compile_definitions(ares::nall PUBLIC PLATFORM_MACOS)
target_compile_definitions(ares::nall INTERFACE USING_NALL)
```
If a property on a linked target is declared `PUBLIC` or `INTERFACE`, then any targets that link to it have those properties propagated to them. So `hiro` will have both `PLATFORM_MACOS` and `USING_NALL` defined. The visibility of those properties in `hiro` will be defined by how we link the targets together. In our example above, `PLATFORM_MACOS` and `USING_NALL` will both be `PRIVATE` properties of `hiro`. If we linked using `PUBLIC`, the properties would be public.

> [!NOTE]
> A property declared as `PRIVATE` under target `our_target` is known only to `our_target`. A property marked `PUBLIC` is known by `our_target` and will be propagated to any target that either directly or transitively links against `our_target`. A property declared `INTERFACE` will be known to all targets that directly or transitively link against `our_target`, but not to `our_target` itself.

The same logic applies for dependencies outside of the ares tree. Depending on how `ares` is configured, `ruby` and `hiro` may depend on a number of different libraries; some of these may be built-in system libraries, while others such as librashader or SDL may need to come from a package manager or be otherwise supplied by the user. If we treat these dependencies like any other target, we are able to propagate all of the information required to link with them in a logical and structured way.

In an ideal world, this would be as simple as calling something like `find_package(SDL)` and then, if it's found, calling `target_link_libraries` against `SDL`. However, we do not live in an ideal world! In fact, the world is so un-ideal that we will sometimes find ourselves having to construct a CMake Find Module.

## FindHelp.cmake

To link with a dependency, CMake generally needs to know:

* The library's binary file location (possibly multiple)
* The library's header files locations (possibly in multiple directories)
* Compile options required to compile the library's headers
* Version information

Our problem is that we need to define logic that can find all of that information, on every platform (macOS, Windows, Linux broadly). Between all of these platforms, for any particular dependency, this information might be found in many different places.

The `find_package` command is our primary tool for this purpose. This command takes a package name as a single argument, and is intended to provide you in return with a CMake target that contains all of the information you need with appropriate visibility.

At this point, it gets somewhat complicated. CMake recognizes two distinct modes of operation for locating dependencies with `find_package`; Config and Module mode. In Config mode, the default, CMake will scour the system for a "Config module" for a particular package. A Config module is meant to be provided by the upstream package to your particular platform. If a Config module exists for our package, our job is usually done. Unfortunately, they often do not exist for packages on every platform, and we cannot guarantee their existence. In rare cases, they can even be defined in a way that doesn't conform with our usage requirements (*foreshadowing*).

The fallback mode is the find module. A CMake find module is a CMake file, provided by the downstream consumer of the package (us), and is meant to supply all logic necessary to determine if a package exists on the system and, if it does, what we need in order to build against it (the four sets of information above).

On Linux, there is a tool that roughly serves this purpose, `pkg-config`, which may be queried from within our find module to locate compile and linker flags information for a particular library. CMake also provides comands such as `find_path`, `find_library`, and `find_package_handle_standard_args`, that make up a complicated platform-dependent toolset that makes educated guesses about where a library may be found.

> [!NOTE]
> ares provides certain dependencies pre-built on macOS and Windows, with binaries and headers fetched at configure-time. To ensure that CMake can find these pre-built dependencies, we simply add their directory prefix to the `CMAKE_PREFIX_PATH`, which is searched by these package-finding functions. In other respects, these dependencies are just like ones installed on the system. On Linux, we do not attempt to provide pre-built dependencies.

The main point is, after locating the information we need for each dependency, we need to create a CMake target for our package. Once we have this target, we can define various `PUBLIC` or `INTERFACE` properties on it in order to propagate include directories, compile definitions and library locations to targets that need them. For CMake code that builds our targets, this makes our job very easy. All we need to do is find the package and link it to our target.

For our CMake code overall, however, we're not done. While we've done the work required to make ares build, we still need to make it run, which is less trivial than it might sound. In fact, this is the most complicated part of the ares build system, mostly because of the disparate packaging requirements of all the platforms ares runs on.

## Packaged Suffering

Canonically, in CMake, the `build` step handles everything we've discussed so far, while the `install` step creates an actual runnable application and installs it; on Windows, that might mean in `C:\Program Files\ares\`, on macOS, `/Applications/ares.app`, while on Linux, libraries, executables, and data may be placed in a number of disparate locations around the system depending on the specific distribution and its packaging philosophy. `install`ing may also fix up runpaths for libraries and executables if we're on Linux or macOS.

There are a few reasons that we do not properly implement `install` behavior on all platforms:
* On macOS and Windows, dependencies that we need to bundle (such as librashader, SDL, and MoltenVK), cannot be `install`ed because they are `IMPORTED` targets. This restriction exists because `install` originates from Linux, where it does not make sense to install an `IMPORTED` target, and it would indeed not be correct to. Some workarounds exist for this issue, but they are either incomplete or don't apply to macOS.
* Semantically, the notion of `install` overall is somewhat muddy; on Linux, it might be a straightforward concept that something must installed in the appropriate system directories before it can be run, but on macOS and Windows, we generally consider *building* to the primary step, creating an app bundle or app directory, at which time it can be run, and subsequently relocated (or "installed") on the system wherever we wish. Only if a program has exceptional requirements (such as installing drivers or system extensions) would we expect the `install` step to be strictly necessary for running the program.
* On macOS in particular, the `install` flow for creating a bundle properly is meant to be provided by the `BundleUtilities` package, which is a fairly cursed utility that no one should have the displeasure of using.

Even the step of determining what libraries need to be `install`ed or bundled on macOS and Windows is quite complex. CMake does not trivially differentiate between system libraries and other types of runtime library dependencies. As such, for any executable target, we need to manually traverse the tree of dependencies recursively and determine what libraries are system or provided by us, and be sure to only try to bundle the required dependencies. 

In the end, what we choose to implement is basically the following:
* On macOS and Windows, the build step will create a fully runnable application located in the build directory. The install step will essentially duplicate the same work.
* On Linux, `cmake --build` will compile and link everything and place it in a staging directory, with no further guarantees. `cmake --install` will place libraries, executables and data in standard directories defined by the `GNUInstallDirs` CMake package.

Dependency copying, runpath fixups and code-signing on macOS are done by simple post-build scripts.

