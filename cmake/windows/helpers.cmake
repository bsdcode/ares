include_guard(GLOBAL)

include(helpers_common)

# ares_configure_executable: Bundle entitlements, dependencies, resources to prepare macOS app bundle
function(ares_configure_executable target)
  set_target_properties(${target} PROPERTIES WIN32_EXECUTABLE TRUE)
  _bundle_dependencies(${target})
  install(TARGETS ${target} DESTINATION "${ARES_EXECUTABLE_DESTINATION}/${target}/$<CONFIG>" COMPONENT Application)
endfunction()

# _target_install_obs: Helper function to install build artifacts to rundir and install location
function(_target_install_ares target)
endfunction()

# Helper function to add resources into bundle
function(target_install_resources target)
endfunction()

# Helper function to add a specific resource to a bundle
function(target_add_resource target resource)
  get_property(ares_module_list GLOBAL PROPERTY ARES_MODULES_ENABLED)
  if(ARGN)
    set(target_destination "${ARGN}")
  elseif(${target} IN_LIST ares_module_list)
    set(target_destination "${ARES_DATA_DESTINATION}/ares-plugins/${target}")
  elseif(target STREQUAL desktop-ui)
    set(target_destination "${ARES_DATA_DESTINATION}/desktop-ui")
  else()
    set(target_destination "${ARES_DATA_DESTINATION}/${target}")
  endif()

  message(DEBUG "Add resource '${resource}' to target ${target} at destination '${target_destination}'...")

  install(FILES "${resource}" DESTINATION "${target_destination}" COMPONENT Runtime)

  add_custom_command(
    TARGET ${target}
    POST_BUILD
    COMMAND "${CMAKE_COMMAND}" -E echo "Copy ${target} resource ${resource} to library directory"
    COMMAND "${CMAKE_COMMAND}" -E make_directory "${ARES_OUTPUT_DIR}/$<CONFIG>/${target_destination}/"
    COMMAND "${CMAKE_COMMAND}" -E copy "${resource}" "${ARES_OUTPUT_DIR}/$<CONFIG>/${target_destination}/"
    COMMENT ""
    VERBATIM
  )

  source_group("Resources" FILES "${resource}")
endfunction()

# _bundle_dependencies: Resolve third party dependencies and add them to Windows binary directory
function(_bundle_dependencies target)
  message(DEBUG "Discover dependencies of target ${target}...")
  set(found_dependencies)
  find_dependencies(TARGET ${target} FOUND_VAR found_dependencies)

  get_property(ares_module_list GLOBAL PROPERTY ARES_MODULES_ENABLED)
  list(LENGTH ares_module_list num_modules)
  if(num_modules GREATER 0)
    add_dependencies(${target} ${ares_module_list})
    foreach(module IN LISTS ares_module_list)
      find_dependencies(TARGET ${module} FOUND_VAR found_dependencies)
    endforeach()
  endif()

  list(REMOVE_DUPLICATES found_dependencies)
  set(library_paths_DEBUG)
  set(library_paths_RELWITHDEBINFO)
  set(library_paths_RELEASE)
  set(library_paths_MINSIZEREL)
  set(plugins_list)

  foreach(library IN LISTS found_dependencies)
    get_target_property(library_type ${library} TYPE)
    get_target_property(is_imported ${library} IMPORTED)

    if(is_imported)
      get_target_property(imported_location ${library} IMPORTED_LOCATION)

      foreach(config IN ITEMS RELEASE RELWITHDEBINFO MINSIZEREL DEBUG)
        get_target_property(imported_location_${config} ${library} IMPORTED_LOCATION_${config})
        if(imported_location_${config})
          _check_library_location(${imported_location_${config}})
        elseif(NOT imported_location_${config} AND imported_location_RELEASE)
          _check_library_location(${imported_location_RELEASE})
        else()
          _check_library_location(${imported_location})
        endif()
      endforeach()
    endif()
  endforeach()

  foreach(config IN ITEMS DEBUG RELWITHDEBINFO RELEASE MINSIZEREL)
    list(REMOVE_DUPLICATES library_paths_${config})
  endforeach()
  
  if(NOT library_paths_DEBUG)
    return()
  endif()
  
  # Somewhat cursed, but in keeping with other platforms, make the build process create a runnable application.
  # That means copying dependencies and packaging as part of the build process. cmake --install will redundantly
  # perform this same process to conform with CMake convention.
  if(CMAKE_CONFIGURATION_TYPES)
    set(MULTI_CONFIG ON)
  else()
    set(MULTI_CONFIG OFF)
  endif()
  add_custom_command(
    TARGET ${target}
    POST_BUILD
    COMMAND "${CMAKE_COMMAND}" -E echo "Copy dependencies to binary directory (${ARES_EXECUTABLE_DESTINATION})..."
    COMMAND "${CMAKE_COMMAND}" -E make_directory "${ARES_OUTPUT_DIR}/${target}"
    COMMAND
      "${CMAKE_COMMAND}" -E "$<IF:$<CONFIG:Debug>,copy_if_different,true>" "$<$<CONFIG:Debug>:${library_paths_DEBUG}>"
      "${ARES_EXECUTABLE_DESTINATION}/${target}/$<IF:$<BOOL:${MULTI_CONFIG}>,Debug,>/"
    COMMAND
      "${CMAKE_COMMAND}" -E "$<IF:$<CONFIG:RelWithDebInfo>,copy_if_different,true>"
      "$<$<CONFIG:RelWithDebInfo>:${library_paths_RELWITHDEBINFO}>"
      "${ARES_EXECUTABLE_DESTINATION}/${target}/$<IF:$<BOOL:${MULTI_CONFIG}>,RelWithDebInfo,>/"
    COMMAND
      "${CMAKE_COMMAND}" -E "$<IF:$<CONFIG:Release>,copy_if_different,true>"
      "$<$<CONFIG:Release>:${library_paths_RELEASE}>" "${ARES_EXECUTABLE_DESTINATION}/${target}/$<IF:$<BOOL:${MULTI_CONFIG}>,Release,>"
    COMMAND
      "${CMAKE_COMMAND}" -E "$<IF:$<CONFIG:MinSizeRel>,copy_if_different,true>"
      "$<$<CONFIG:MinSizeRel>:${library_paths_MINSIZEREL}>"
      "${ARES_EXECUTABLE_DESTINATION}/${target}/$<IF:$<BOOL:${MULTI_CONFIG}>,MinSizeRel,>/"
    COMMENT "Copying dynamic dependencies to rundir"
    VERBATIM
    COMMAND_EXPAND_LISTS
  )


  install(
    FILES ${library_paths_DEBUG}
    CONFIGURATIONS Debug
    DESTINATION "${ARES_EXECUTABLE_DESTINATION}"
    DESTINATION "${ARES_EXECUTABLE_DESTINATION}/${target}/Debug/"
    COMPONENT Runtime
  )

  install(
    FILES ${library_paths_RELWITHDEBINFO}
    CONFIGURATIONS RelWithDebInfo
    DESTINATION "${ARES_EXECUTABLE_DESTINATION}"
    DESTINATION "${ARES_EXECUTABLE_DESTINATION}/${target}/RelWithDebInfo/"
    COMPONENT Runtime
  )

  install(
    FILES ${library_paths_RELEASE}
    CONFIGURATIONS Release
    DESTINATION "${ARES_EXECUTABLE_DESTINATION}"
    DESTINATION "${ARES_EXECUTABLE_DESTINATION}/${target}/Release/"
    COMPONENT Runtime
  )

  install(
    FILES ${library_paths_MINSIZEREL}
    CONFIGURATIONS MinSizeRel
    DESTINATION "${ARES_EXECUTABLE_DESTINATION}"
    DESTINATION "${ARES_EXECUTABLE_DESTINATION}/${target}/MinSizeRel/"
    COMPONENT Runtime
  )
endfunction()

# _check_library_location: Check for corresponding DLL given an import library path
macro(_check_library_location location)
  if(library_type STREQUAL "SHARED_LIBRARY")
    set(library_location "${location}")
  else()
    string(STRIP "${location}" location)
    if(location MATCHES ".+lib$")
      cmake_path(GET location FILENAME _dll_name)
      cmake_path(GET location PARENT_PATH _implib_path)
      cmake_path(SET _bin_path NORMALIZE "${_implib_path}/../bin")
      string(REPLACE ".lib" ".dll" _dll_name "${_dll_name}")
      string(REPLACE ".dll" ".pdb" _pdb_name "${_dll_name}")

      find_program(_dll_path NAMES "${_dll_name}" HINTS ${_implib_path} ${_bin_path} NO_CACHE NO_DEFAULT_PATH)

      find_program(_pdb_path NAMES "${_pdb_name}" HINTS ${_implib_path} ${_bin_path} NO_CACHE NO_DEFAULT_PATH)

      if(_dll_path)
        set(library_location "${_dll_path}")
        set(library_pdb_location "${_pdb_path}")
      else()
        unset(library_location)
        unset(library_pdb_location)
      endif()
      unset(_dll_path)
      unset(_pdb_path)
      unset(_bin_path)
      unset(_implib_path)
      unset(_dll_name)
      unset(_pdb_name)
    else()
      unset(library_location)
      unset(library_pdb_location)
    endif()
  endif()

  if(library_location)
    list(APPEND library_paths_${config} ${library_location})
  endif()
  if(library_pdb_location)
    list(APPEND library_paths_${config} ${library_pdb_location})
  endif()
  unset(location)
  unset(library_location)
  unset(library_pdb_location)
endmacro()
