cmake_minimum_required(VERSION 3.28...3.30)

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/common/bootstrap.cmake" NO_POLICY_SCOPE)

set(CMAKE_SUPPRESS_REGENERATION true)

project(ares VERSION ${ARES_VERSION_CANONICAL})

include(compilerconfig)
include(defaults)
include(helpers)

add_subdirectory(cmake)

add_subdirectory(thirdparty)

add_subdirectory(nall)
add_subdirectory(libco)
add_subdirectory(ruby)
add_subdirectory(hiro)

# gersemi: off
set(
  ARES_CORES
  a26 fc sfc sg ms md ps1 pce ng msx cv myvision gb gba ws ngp spec n64
  CACHE INTERNAL LIST
)
# gersemi: on

add_subdirectory(ares)
add_subdirectory(mia)
add_subdirectory(desktop-ui)

add_subdirectory(tests/i8080)
if(NOT OS_WINDOWS AND NOT OS_MACOS)
  add_subdirectory(tools/genius)
else()
  target_disable_subproject(genius "genius (database editor)")
endif()
add_subdirectory(tools/mame2bml)
add_subdirectory(tools/sourcery)

message_configuration()
return()
