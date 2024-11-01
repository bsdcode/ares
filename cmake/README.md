### *ares* Build System

This document provides an overview of the general design and structure behind ares's CMake build system generator.

At a high level, all CMake code directly related to internal build system considerations (compiler/architecture configuration, project generation, dependency management, code signing, app bundling and installation) lives in this `cmake` folder. The tree of files that manage this functionality all branch off of `common/bootstrap.cmake` into various OS-specific and common files.

CMake code related to the actual generation and building of specific ares components lives in the CMakeLists.txt for each target, as well as auxiliary and OS-specific files for those targets where necessary.

Broadly, we try to conform to "modern CMake" best practices. There are plentiful resources on this subject; [An Introduction to Modern CMake](https://cliutils.gitlab.io/modern-cmake/README.html) is a good starting point. The primary philosophy behind these resources is that the build system code should be as modular and platform-agnostic as possible. Everything should be implemented as a target, and the build system's job is to describe and structure the relationships between these targets in a sound and logical way. `nall`'s Makefile this is not!

More in-depth documentation is available in separate documents. The most complicated part of this build system— the definition, resolution, and bundling of dependencies— is described in [Dependencies](./Dependencies.md).

