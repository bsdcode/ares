ares_components(sm83 m93lcx6)

target_sources(
  ares
  PRIVATE
    system/system.cpp
    cartridge/cartridge.cpp
    bus/bus.cpp
    cpu/cpu.cpp
    ppu/ppu.cpp
    apu/apu.cpp
)

ares_add_header_sources(gb gb.hpp CMakeLists.txt)

ares_add_header_sources(
  gb
  apu/apu.hpp
  apu/io.cpp
  apu/noise.cpp
  apu/sequencer.cpp
  apu/serialization.cpp
  apu/square1.cpp
  apu/square2.cpp
  apu/wave.cpp
)

ares_add_header_sources(gb bus/bus.hpp)

ares_add_header_sources(
  gb
  cartridge/cartridge.hpp
  cartridge/memory.cpp
  cartridge/serialization.cpp
  cartridge/slot.cpp
  cartridge/slot.hpp
)

ares_add_header_sources(
  gb
  cartridge/board/board.cpp
  cartridge/board/board.hpp
  cartridge/board/huc1.cpp
  cartridge/board/huc3.cpp
  cartridge/board/linear.cpp
  cartridge/board/mbc1.cpp
  cartridge/board/mbc1m.cpp
  cartridge/board/mbc2.cpp
  cartridge/board/mbc3.cpp
  cartridge/board/mbc5.cpp
  cartridge/board/mbc6.cpp
  cartridge/board/mbc7.cpp
  cartridge/board/mmm01.cpp
  cartridge/board/none.cpp
  cartridge/board/tama.cpp
)

ares_add_header_sources(
  gb
  cpu/cpu.hpp
  cpu/debugger.cpp
  cpu/io.cpp
  cpu/memory.cpp
  cpu/serialization.cpp
  cpu/timing.cpp
)

ares_add_header_sources(
  gb
  system/controls.cpp
  system/serialization.cpp
  system/system.hpp
)
