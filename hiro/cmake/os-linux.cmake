find_package(X11)

option(USE_QT5 "Use Qt5 UI backend" OFF)
mark_as_advanced(USE_QT5)

if(NOT USE_QT5)
    find_package(GTK REQUIRED)
    target_compile_definitions(hiro PRIVATE HIRO_GTK)

    target_link_libraries(hiro PRIVATE GTK::GTK X11::X11)

    target_enable_feature(hiro "GTK3 UI backend" HIRO_GTK=3)
else()
    find_package(Qt6 COMPONENTS Widgets Xcb REQUIRED)
    
    find_program(qt_moc moc-qt6 moc)

    execute_process(
        COMMAND qt_moc -i -o ${CMAKE_CURRENT_SOURCE_DIR}/qt/qt.moc ${CMAKE_CURRENT_SOURCE_DIR}/qt/qt.hpp
    )

    target_link_libraries(hiro PRIVATE X11::X11 Qt6::Core Qt6::Gui Qt6::Widgets Qt6::Xcb)

    target_enable_feature(hiro "Qt6 UI backend" HIRO_QT=5)
endif()

get_target_property(hiro_SOURCES hiro SOURCES)

set_source_files_properties(hiro ${hiro_SOURCES} PROPERTIES HEADER_FILE_ONLY TRUE)

set_source_files_properties(hiro hiro.cpp PROPERTIES HEADER_FILE_ONLY FALSE)
