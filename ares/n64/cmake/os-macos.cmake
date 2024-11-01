target_sources(ares PRIVATE cmake/os-macos.cmake)

find_package(MoltenVK)

target_link_libraries(
  ares
  PRIVATE $<$<BOOL:${MoltenVK_FOUND}>:MoltenVK::MoltenVK>
)

if(MoltenVK_FOUND)
  set(VULKAN_FOUND true)
endif()
