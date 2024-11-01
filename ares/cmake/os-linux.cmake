target_link_options(ares PRIVATE LINKER:-export-dynamic)
target_link_libraries(ares PRIVATE X11 Xext)

target_sources(ares PRIVATE cmake/os-linux.cmake)
