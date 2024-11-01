# ares CMake common helper functions module

include_guard(GLOBAL)

function(add_sourcery_command target subdir)
  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/resource.cpp ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/resource.hpp
    COMMAND sourcery resource.bml resource.cpp resource.hpp
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/resource.bml
    VERBATIM
  )
  add_custom_target(
    ${target}-resource
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/resource.cpp ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/resource.hpp
  )
  add_dependencies(${target} ${target}-resource)
  set_target_properties(${target}-resource PROPERTIES FOLDER resources PREFIX "")
endfunction()

# message_configuration: Function to print configuration outcome
function(message_configuration)
  include(FeatureSummary)
  feature_summary(WHAT ALL VAR _feature_summary)

  message(DEBUG "${_feature_summary}")

  message(
    NOTICE
    "                          ..\n"
    "                           ::.\n"
    "                           .::.     ____ _________  _____\n"
    "                   ..     .:::.    / __ `/ ___/ _ \\/ ___/\n"
    "                    .-::::::::    / /_/ / /  /  __(__  )\n"
    "                      .::::.      \\__,_/_/   \\___/____/\n"
    "\n                  ares version: ${ARES_VERSION}\n"
    "==================================================================================\n\n"
  )

  get_property(ARES_FEATURES_ENABLED GLOBAL PROPERTY ARES_FEATURES_ENABLED)
  list(SORT ARES_FEATURES_ENABLED COMPARE NATURAL CASE SENSITIVE ORDER ASCENDING)

  if(ARES_FEATURES_ENABLED)
    message(NOTICE "------------------------       Enabled Features           ------------------------")
    foreach(feature IN LISTS ARES_FEATURES_ENABLED)
      message(NOTICE " - ${feature}")
    endforeach()
  endif()

  get_property(ARES_FEATURES_DISABLED GLOBAL PROPERTY ARES_FEATURES_DISABLED)
  list(SORT ARES_FEATURES_DISABLED COMPARE NATURAL CASE SENSITIVE ORDER ASCENDING)

  if(ARES_FEATURES_DISABLED)
    message(NOTICE "------------------------       Disabled Features          ------------------------")
    foreach(feature IN LISTS ARES_FEATURES_DISABLED)
      message(NOTICE " - ${feature}")
    endforeach()
  endif()

  get_property(ARES_CORES_ENABLED GLOBAL PROPERTY ARES_CORES_ENABLED)
  list(SORT ARES_CORES_ENABLED COMPARE NATURAL CASE SENSITIVE ORDER ASCENDING)

  message(NOTICE "------------------------         Enabled Cores            ------------------------")
  foreach(core IN LISTS ARES_CORES_ENABLED)
    message(NOTICE " - ${core}")
  endforeach()

  get_property(ARES_CORES_DISABLED GLOBAL PROPERTY ARES_CORES_DISABLED)
  list(SORT ARES_CORES_DISABLED COMPARE NATURAL CASE SENSITIVE ORDER ASCENDING)

  message(NOTICE "------------------------         Disabled Cores           ------------------------")
  get_property(ARES_CORES_ALL GLOBAL PROPERTY ares_cores_all)
  list(APPEND ARES_CORES_DISABLED ${ARES_CORES_ALL})
  list(REMOVE_ITEM ARES_CORES_DISABLED ${ARES_CORES})
  foreach(core IN LISTS ARES_CORES_DISABLED)
    message(NOTICE " - ${core}")
  endforeach()

  # message(NOTICE "==================================================================================\n")
  
  get_property(ARES_SUBPROJECTS_ENABLED GLOBAL PROPERTY ARES_SUBPROJECTS_ENABLED)
  list(SORT ARES_SUBPROJECTS_ENABLED COMPARE NATURAL CASE SENSITIVE ORDER ASCENDING)

  if(ARES_SUBPROJECTS_ENABLED)
    message(NOTICE "-----------------------       Enabled Subprojects           ----------------------")
    foreach(subproject IN LISTS ARES_SUBPROJECTS_ENABLED)
      message(NOTICE " - ${subproject}")
    endforeach()
  endif()

  get_property(ARES_SUBPROJECTS_DISABLED GLOBAL PROPERTY ARES_SUBPROJECTS_DISABLED)
  list(SORT ARES_SUBPROJECTS_DISABLED COMPARE NATURAL CASE SENSITIVE ORDER ASCENDING)

  if(ARES_SUBPROJECTS_DISABLED)
    message(NOTICE "-----------------------       Disabled Subprojects          ----------------------")
    foreach(subproject IN LISTS ARES_SUBPROJECTS_DISABLED)
      message(NOTICE " - ${subproject}")
    endforeach()
  endif()
  message(NOTICE "==================================================================================")
endfunction()

function(target_enable_subproject target subproject_description)
  set_property(GLOBAL APPEND PROPERTY ARES_SUBPROJECTS_ENABLED "${subproject_description}")

  if(ARGN)
    target_compile_definitions(${target} PRIVATE ${ARGN})
  endif()
endfunction()

function(target_disable_subproject target subproject_description)
  set_property(GLOBAL APPEND PROPERTY ARES_SUBPROJECTS_DISABLED "${subproject_description}")

  if(ARGN)
    target_compile_definitions(${target} PRIVATE ${ARGN})
  endif()
endfunction()

# target_enable_feature: Adds feature to list of enabled application features and sets optional compile definitions
function(target_enable_feature target feature_description)
  set_property(GLOBAL APPEND PROPERTY ARES_FEATURES_ENABLED "${feature_description}")

  if(ARGN)
    target_compile_definitions(${target} PRIVATE ${ARGN})
  endif()
endfunction()

# enable_core: Add core to list of enabled cores
function(enable_core core_description)
  set_property(GLOBAL APPEND PROPERTY ARES_CORES_ENABLED "${core_description}")
endfunction()

# disable_core: Add core to list of disabled cores
function(disable_core core_description)
  set_property(GLOBAL APPEND PROPERTY ARES_CORES_DISABLED "${core_description}")
endfunction()

# target_disable_feature: Adds feature to list of disabled application features and sets optional compile definitions
function(target_disable_feature target feature_description)
  set_property(GLOBAL APPEND PROPERTY ARES_FEATURES_DISABLED "${feature_description}")

  if(ARGN)
    target_compile_definitions(${target} PRIVATE ${ARGN})
  endif()
endfunction()

# _handle_generator_expression_dependency: Helper function to yield dependency from a generator expression
function(_handle_generator_expression_dependency library)
  set(oneValueArgs FOUND_VAR)
  set(multiValueArgs)
  cmake_parse_arguments(var "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  set(${var_FOUND_VAR} "${var_FOUND_VAR}-NOTFOUND")

  message(DEBUG "Checking ${library}...")

  if(library MATCHES "\\$<\\$<PLATFORM_ID:[^>]+>:.+>" OR library MATCHES "\\$<\\$<NOT:\\$<PLATFORM_ID:[^>]+>>:.+>")
    # Platform-dependent generator expression found. Platforms are a comma-separated list of CMake host OS identifiers.
    # Convert to CMake list and check if current host OS is contained in list.
    string(REGEX REPLACE "\\$<.*\\$<PLATFORM_ID:([^>]+)>>?:([^>]+)>" "\\1;\\2" gen_expression "${library}")
    list(GET gen_expression 0 gen_platform)
    list(GET gen_expression 1 gen_library)
    string(REPLACE "," ";" gen_platform "${gen_platform}")

    set(${var_FOUND_VAR} "${var_FOUND_VAR}-SKIP")

    if(library MATCHES "\\$<\\$<NOT:.+>.+>")
      if(NOT CMAKE_SYSTEM_NAME IN_LIST gen_platform)
        set(${var_FOUND_VAR} "${gen_library}")
      endif()
    else()
      if(CMAKE_SYSTEM_NAME IN_LIST gen_platform)
        set(${var_FOUND_VAR} "${gen_library}")
      endif()
    endif()
  elseif(library MATCHES "\\$<\\$<BOOL:[^>]+>:.+>")
    # Boolean generator expression found. Consider parameter a CMake variable that resolves into a CMake-like boolean
    # value for a simple conditional check.
    string(REGEX REPLACE "\\$<\\$<BOOL:([^>]+)>:([^>]+)>" "\\1;\\2" gen_expression "${library}")
    list(GET gen_expression 0 gen_boolean)
    list(GET gen_expression 1 gen_library)

    set(${var_FOUND_VAR} "${var_FOUND_VAR}-SKIP")

    if(${gen_boolean})
      set(${var_FOUND_VAR} "${gen_library}")
    endif()
  elseif(library MATCHES "\\$<TARGET_NAME_IF_EXISTS:[^>]+>")
    # Target-dependent generator expression found. Consider parameter to be a CMake target identifier and check for
    # target existence.
    string(REGEX REPLACE "\\$<TARGET_NAME_IF_EXISTS:([^>]+)>" "\\1" gen_target "${library}")

    set(${var_FOUND_VAR} "${var_FOUND_VAR}-SKIP")

    if(TARGET ${gen_target})
      set(${var_FOUND_VAR} "${gen_target}")
    endif()
  else()
    # Unknown or unimplemented generator expression found. Abort script run to either add to ignore list or implement
    # detection.
    message(AUTHOR_WARNING "${library} is an unsupported generator expression for linked libraries.")
  endif()

  if(CMAKE_VERSION VERSION_LESS 3.25)
    set(${var_FOUND_VAR} ${var_FOUND_VAR} PARENT_SCOPE)
  else()
    return(PROPAGATE ${var_FOUND_VAR})
  endif()
endfunction()

# find_dependencies: Check linked interface and direct dependencies of target
function(find_dependencies)
  set(oneValueArgs TARGET FOUND_VAR)
  set(multiValueArgs)
  cmake_parse_arguments(var "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT DEFINED is_root)
    # Root of recursive dependency resolution
    set(is_root TRUE)
    set(nested_depth 0)
  else()
    # Branch of recursive dependency resolution
    set(is_root FALSE)
    math(EXPR nested_depth "${nested_depth}+1")
  endif()

  # * LINK_LIBRARIES are direct dependencies
  # * INTERFACE_LINK_LIBRARIES are transitive dependencies
  get_target_property(linked_libraries ${var_TARGET} LINK_LIBRARIES)
  get_target_property(interface_libraries ${var_TARGET} INTERFACE_LINK_LIBRARIES)
  message(DEBUG "[${nested_depth}] Linked libraries in target ${var_TARGET}: ${linked_libraries}")
  message(DEBUG "[${nested_depth}] Linked interface libraries in target ${var_TARGET}: ${interface_libraries}")

  # Consider CMake targets only
  list(FILTER linked_libraries INCLUDE REGEX ".+::.+")
  list(FILTER interface_libraries INCLUDE REGEX ".+::.+")

  foreach(library IN LISTS linked_libraries interface_libraries)
    if(NOT library)
      continue()
    elseif(library MATCHES "\\$<.*:[^>]+>")
      # Generator expression found
      _handle_generator_expression_dependency(${library} FOUND_VAR found_library)
      if(found_library STREQUAL found_library-SKIP)
        continue()
      elseif(found_library)
        set(library ${found_library})
      endif()
    endif()

    message(DEBUG "[${nested_depth}] Found ${library}...")

    if(NOT library IN_LIST ${var_FOUND_VAR})
      list(APPEND found_libraries ${library})
      # Enter recursive branch
      find_dependencies(TARGET ${library} FOUND_VAR ${var_FOUND_VAR})
    endif()
  endforeach()

  if(NOT is_root)
    set(found_libraries ${found_libraries} PARENT_SCOPE)
    # Exit recursive branch
    return()
  endif()

  list(REMOVE_DUPLICATES found_libraries)
  list(APPEND ${var_FOUND_VAR} ${found_libraries})
  set(${var_FOUND_VAR} ${${var_FOUND_VAR}} PARENT_SCOPE)
endfunction()
