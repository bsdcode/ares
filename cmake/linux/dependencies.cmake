# ares CMake linux build dependencies module

include_guard(GLOBAL)

include(dependencies_common)

function(_check_dependencies_linux)
  set(arch universal)
  set(platform linux-${arch})

  file(READ "${CMAKE_CURRENT_SOURCE_DIR}/buildspec.json" buildspec)

  set(dependencies_dir "${CMAKE_CURRENT_SOURCE_DIR}/.deps")
  set(prebuilt_filename "ares-deps-linux-ARCH-REVISION.tar.xz")
  set(prebuilt_destination "ares-deps-linux-ARCH")
  set(dependencies_list prebuilt)

  _check_dependencies()
endfunction()

_check_dependencies_linux()
