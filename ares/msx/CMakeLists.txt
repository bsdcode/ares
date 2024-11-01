ares_components(
  z80
  tms9918
  v9938
  ay38910
  ym2413
)

target_sources(
  ares
  PRIVATE
    system/system.cpp
    keyboard/keyboard.cpp
    cartridge/cartridge.cpp
    controller/controller.cpp
    cpu/cpu.cpp
    vdp/vdp.cpp
    psg/psg.cpp
    tape/tape.cpp
    rtc/rtc.cpp
)

ares_add_header_sources(msx msx.hpp CMakeLists.txt)

ares_add_header_sources(
  msx
  cartridge/cartridge.hpp
  cartridge/serialization.cpp
  cartridge/slot.cpp
  cartridge/slot.hpp
)

ares_add_header_sources(
  msx
  cartridge/board/asc16.cpp
  cartridge/board/asc8.cpp
  cartridge/board/board.cpp
  cartridge/board/board.hpp
  cartridge/board/cross-blaim.cpp
  cartridge/board/konami-scc.cpp
  cartridge/board/konami.cpp
  cartridge/board/linear.cpp
  cartridge/board/mirrored.cpp
  cartridge/board/super-lode-runner.cpp
  cartridge/board/super-pierrot.cpp
)

ares_add_header_sources(
  msx
  controller/controller.hpp
  controller/mux.cpp
  controller/mux.hpp
  controller/port.cpp
  controller/port.hpp
)

ares_add_header_sources(
  msx
  controller/gamepad/gamepad.cpp
  controller/gamepad/gamepad.hpp
)

ares_add_header_sources(
  msx
  controller/vaus-paddle/vaus-paddle.cpp
  controller/vaus-paddle/vaus-paddle.hpp
)

ares_add_header_sources(
  msx
  cpu/cpu.hpp
  cpu/debugger.cpp
  cpu/memory.cpp
  cpu/serialization.cpp
)

ares_add_header_sources(
  msx
  keyboard/keyboard.hpp
  keyboard/serialization.cpp
)

ares_add_header_sources(
  msx
  psg/psg.hpp
  psg/serialization.cpp
)

ares_add_header_sources(
  msx
  rtc/rtc.hpp
  rtc/serialization.cpp
)

ares_add_header_sources(
  msx
  system/serialization.cpp
  system/system.hpp
)

ares_add_header_sources(
  msx
  tape/deck.cpp
  tape/deck.hpp
  tape/tape.hpp
  tape/tray.cpp
  tape/tray.hpp
)

ares_add_header_sources(
  msx
  vdp/color.cpp
  vdp/serialization.cpp
  vdp/vdp.hpp
)
