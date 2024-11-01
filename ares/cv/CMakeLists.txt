ares_components(z80 tms9918 sn76489)

target_sources(
  ares
  PRIVATE
    cpu/cpu.cpp
    vdp/vdp.cpp
    psg/psg.cpp
    system/system.cpp
    cartridge/cartridge.cpp
    controller/controller.cpp
)

ares_add_header_sources(cv cv.hpp CMakeLists.txt)

ares_add_header_sources(
  cv
  cartridge/cartridge.hpp
  cartridge/serialization.cpp
  cartridge/slot.cpp
  cartridge/slot.hpp
)

ares_add_header_sources(
  cv
  cartridge/board/board.cpp
  cartridge/board/board.hpp
  cartridge/board/coleco.cpp
  cartridge/board/megacart.cpp
  cartridge/board/xin1.cpp
)

ares_add_header_sources(
  cv
  controller/controller.hpp
  controller/port.cpp
  controller/port.hpp
)

ares_add_header_sources(
  cv
  controller/gamepad/gamepad.cpp
  controller/gamepad/gamepad.hpp
)

ares_add_header_sources(
  cv
  cpu/cpu.hpp
  cpu/debugger.cpp
  cpu/memory.cpp
  cpu/serialization.cpp
)

ares_add_header_sources(
  cv
  psg/psg.hpp
  psg/serialization.cpp
)

ares_add_header_sources(
  cv
  system/controls.cpp
  system/serialization.cpp
  system/system.hpp
)

ares_add_header_sources(
  cv
  vdp/color.cpp
  vdp/serialization.cpp
  vdp/vdp.hpp
)
