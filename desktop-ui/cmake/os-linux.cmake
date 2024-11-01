# Stage and install slang shaders
if(ARES_ENABLE_LIBRASHADER)
  add_custom_command(
    TARGET desktop-ui
    POST_BUILD
    COMMAND
      cp -R "${CMAKE_SOURCE_DIR}/.deps/ares-deps-linux-universal/lib/slang-shaders/."
      "${ARES_BUILD_OUTPUT_DIR}/$<CONFIG>/Shaders"
    COMMENT "Copying slang shaders to staging directory"
  )

  install(
    DIRECTORY "${CMAKE_SOURCE_DIR}/.deps/ares-deps-linux-universal/lib/slang-shaders/"
    DESTINATION "${ARES_INSTALL_DATA_DESTINATION}/Shaders"
    USE_SOURCE_PERMISSIONS
    COMPONENT Runtime
  )
endif()

# Stage and install mia database
add_custom_command(
  TARGET desktop-ui
  POST_BUILD
  COMMAND "${CMAKE_COMMAND}" -E make_directory "${ARES_BUILD_OUTPUT_DIR}/$<CONFIG>/Database"
  COMMAND
    cp -R "${CMAKE_SOURCE_DIR}/mia/Database/."
    "${ARES_BUILD_OUTPUT_DIR}/$<CONFIG>/Database/"
  COMMENT "Copying mia database to staging directory"
)

install(
  DIRECTORY "${CMAKE_SOURCE_DIR}/mia/Database/"
  DESTINATION "${ARES_INSTALL_DATA_DESTINATION}/Database"
  USE_SOURCE_PERMISSIONS
  COMPONENT Runtime
)

# Stage and install icon, .desktop file
add_custom_command(
  TARGET desktop-ui
  POST_BUILD
  COMMAND
    cp "${CMAKE_CURRENT_SOURCE_DIR}/resource/ares.desktop"
    "${ARES_BUILD_OUTPUT_DIR}/$<CONFIG>/ares.desktop"
  COMMAND
    cp "${CMAKE_CURRENT_SOURCE_DIR}/resource/ares.png"
    "${ARES_BUILD_OUTPUT_DIR}/$<CONFIG>/ares.png"
  COMMENT "Copying icon to staging directory"
)

install(
  FILES "${CMAKE_CURRENT_SOURCE_DIR}/resource/ares.desktop"
  DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/applications"
  COMPONENT Runtime
)

install(
  FILES "${CMAKE_CURRENT_SOURCE_DIR}/resource/ares.png"
  DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/256x256/apps"
  COMPONENT Runtime
)
