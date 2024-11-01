ares_components(m68000 z80)

target_link_libraries(ares PRIVATE ymfm)

target_sources(
  ares
  PRIVATE
    system/system.cpp
    cpu/cpu.cpp
    apu/apu.cpp
    lspc/lspc.cpp
    opnb/opnb.cpp
    cartridge/cartridge.cpp
    controller/controller.cpp
    card/card.cpp
)

ares_add_header_sources(ng ng.hpp CMakeLists.txt)

ares_add_header_sources(
  ng
  apu/apu.hpp
  apu/debugger.cpp
  apu/memory.cpp
  apu/serialization.cpp
)

ares_add_header_sources(
  ng
  card/card.hpp
  card/debugger.cpp
  card/serialization.cpp
  card/slot.cpp
  card/slot.hpp
)

ares_add_header_sources(
  ng
  cartridge/cartridge.hpp
  cartridge/serialization.cpp
  cartridge/slot.cpp
  cartridge/slot.hpp
  cartridge/board/board.cpp
  cartridge/board/board.hpp
  cartridge/board/jockey-gp.cpp
  cartridge/board/mslugx.cpp
  cartridge/board/rom.cpp
)

ares_add_header_sources(
  ng
  controller/controller.hpp
  controller/port.cpp
  controller/port.hpp
)

ares_add_header_sources(
  ng
  controller/arcade-stick/arcade-stick.cpp
  controller/arcade-stick/arcade-stick.hpp
)

ares_add_header_sources(
  ng
  cpu/cpu.hpp
  cpu/debugger.cpp
  cpu/memory.cpp
  cpu/serialization.cpp
)

ares_add_header_sources(
  ng
  lspc/color.cpp
  lspc/debugger.cpp
  lspc/lspc.hpp
  lspc/render.cpp
  lspc/serialization.cpp
)

ares_add_header_sources(
  ng
  opnb/opnb.hpp
  opnb/serialization.cpp
)

ares_add_header_sources(
  ng
  system/debugger.cpp
  system/serialization.cpp
  system/system.hpp
)
