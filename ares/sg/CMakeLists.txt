ares_components(z80 tms9918 sn76489 i8255)

target_sources(
  ares
  PRIVATE
    cpu/cpu.cpp
    vdp/vdp.cpp
    psg/psg.cpp
    ppi/ppi.cpp
    system/system.cpp
    cartridge/cartridge.cpp
    controller/controller.cpp
)

ares_add_header_sources(sg sg.hpp CMakeLists.txt)

ares_add_header_sources(
  sg
  cartridge/cartridge.hpp
  cartridge/serialization.cpp
  cartridge/slot.cpp
  cartridge/slot.hpp
)

ares_add_header_sources(
  sg
  cartridge/cartridge.hpp
  cartridge/serialization.cpp
  cartridge/slot.cpp
  cartridge/slot.hpp
  cartridge/board/arcade-rom.cpp
  cartridge/board/board.cpp
  cartridge/board/board.hpp
  cartridge/board/linear.cpp
  cartridge/board/taiwan-a.cpp
  cartridge/board/taiwan-b.cpp
)

ares_add_header_sources(
  sg
  controller/controller.hpp
  controller/port.cpp
  controller/port.hpp
  controller/gamepad/gamepad.cpp
  controller/gamepad/gamepad.hpp
)

ares_add_header_sources(
  sg
  cpu/cpu.hpp
  cpu/debugger.cpp
  cpu/memory.cpp
  cpu/serialization.cpp
)

ares_add_header_sources(
  sg
  ppi/ppi.hpp
  ppi/serialization.cpp
)

ares_add_header_sources(
  sg
  psg/psg.hpp
  psg/serialization.cpp
)

ares_add_header_sources(
  sg
  system/arcade-controls.cpp
  system/serialization.cpp
  system/system.hpp
)

ares_add_header_sources(
  sg
  vdp/color.cpp
  vdp/serialization.cpp
  vdp/vdp.hpp
)
