ares_components(mos6502)

target_sources(
  ares
  PRIVATE
    system/system.cpp
    controller/controller.cpp
    cartridge/cartridge.cpp
    cpu/cpu.cpp
    tia/tia.cpp
    riot/riot.cpp
)

ares_add_header_sources(a26 a26.hpp CMakeLists.txt)

ares_add_header_sources(
  a26
  cartridge/cartridge.hpp
  cartridge/serialization.cpp
  cartridge/slot.cpp
  cartridge/slot.hpp
  cartridge/board/atari16k.cpp
  cartridge/board/atari32k.cpp
  cartridge/board/atari8k.cpp
  cartridge/board/board.cpp
  cartridge/board/board.hpp
  cartridge/board/commavid.cpp
  cartridge/board/linear.cpp
  cartridge/board/parker-bros.cpp
  cartridge/board/tigervision.cpp
)

ares_add_header_sources(
  a26
  controller/controller.hpp
  controller/port.cpp
  controller/port.hpp
  controller/gamepad/gamepad.cpp
  controller/gamepad/gamepad.hpp
)

ares_add_header_sources(
  a26
  cpu/cpu.hpp
  cpu/debugger.cpp
  cpu/memory.cpp
  cpu/serialization.cpp
  cpu/timing.cpp
)

ares_add_header_sources(
  a26
  riot/io.cpp
  riot/riot.hpp
  riot/serialization.cpp
)

ares_add_header_sources(
  a26
  system/controls.cpp
  system/serialization.cpp
  system/system.hpp
)

ares_add_header_sources(
  a26
  tia/audio.cpp
  tia/ball.cpp
  tia/color.cpp
  tia/io.cpp
  tia/missile.cpp
  tia/player.cpp
  tia/playfield.cpp
  tia/serialization.cpp
  tia/tia.hpp
  tia/write-queue.cpp
)
