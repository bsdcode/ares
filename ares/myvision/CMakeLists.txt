ares_components(z80 tms9918 ay38910)

target_sources(
  ares
  PRIVATE
    cpu/cpu.cpp
    vdp/vdp.cpp
    psg/psg.cpp
    system/system.cpp
    cartridge/cartridge.cpp
)

ares_add_header_sources(
  myvision
  myvision.hpp
  CMakeLists.txt
)

ares_add_header_sources(
  myvision
  cartridge/cartridge.hpp
  cartridge/serialization.cpp
  cartridge/slot.cpp
  cartridge/slot.hpp
)

ares_add_header_sources(
  myvision
  cpu/cpu.hpp
  cpu/debugger.cpp
  cpu/memory.cpp
  cpu/serialization.cpp
)

ares_add_header_sources(
  myvision
  psg/psg.hpp
  psg/serialization.cpp
)

ares_add_header_sources(
  myvision
  system/controls.cpp
  system/serialization.cpp
  system/system.hpp
)

ares_add_header_sources(
  myvision
  vdp/color.cpp
  vdp/serialization.cpp
  vdp/vdp.hpp
)
