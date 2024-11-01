#[=======================================================================[.rst:
FindSDL
-------

Finds the SDL library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``GTK::GTK``

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``GTK_FOUND``
  True if the system has GTK 3.
``GTK_VERSION``
  The version of GTK3 which was found.
``GTK_INCLUDE_DIRS``
  Include directories needed to use GTK3.
``GTK_LIBRARIES``
  Libraries needed to link to GTK3.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:
.
``GTK_LIBRARY``
  The path to the SDL library.

#]=======================================================================]

include(FindPackageHandleStandardArgs)

find_path(
  OSS_INCLUDE_DIR
  NAMES sys/soundcard.h
  HINTS ${PC_OSS_INCLUDE_DIRS}
  PATHS /usr/include /usr/local/include
  DOC "OSS include directory"
)

set(OSS_VERSION ${CMAKE_HOST_SYSTEM_VERSION})

find_package_handle_standard_args(
  OSS
  REQUIRED_VARS OSS_INCLUDE_DIR
  VERSION_VAR OSS_VERSION
  REASON_FAILURE_MESSAGE "Ensure that OSS is installed on the system."
)
mark_as_advanced(OSS_INCLUDE_DIR OSS_LIBRARY)

if(OSS_FOUND)
  if(NOT TARGET OSS::OSS)
    add_library(OSS::OSS INTERFACE IMPORTED)

    set_target_properties(OSS::OSS PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${OSS_INCLUDE_DIR}" VERSION ${OSS_VERSION})
  endif()
endif()
