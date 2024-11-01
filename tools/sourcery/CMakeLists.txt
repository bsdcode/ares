add_executable(sourcery sourcery.cpp)

target_include_directories(sourcery PRIVATE ${CMAKE_SOURCE_DIR})

target_link_libraries(sourcery PRIVATE nall "$<$<PLATFORM_ID:Darwin>:$<LINK_LIBRARY:FRAMEWORK,Cocoa.framework>>")

ares_configure_executable(sourcery)

target_enable_subproject(sourcery "sourcery (resource compiler)")

set_target_properties(sourcery PROPERTIES FOLDER tools PREFIX "")
