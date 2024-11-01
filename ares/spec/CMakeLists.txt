ares_components(z80 ay38910)

target_sources(
  ares
  PRIVATE
    keyboard/keyboard.cpp
    expansion/expansion.cpp
    system/system.cpp
    cpu/cpu.cpp
    ula/ula.cpp
    psg/psg.cpp
    tape/tape.cpp
)

ares_add_header_sources(spec spec.hpp CMakeLists.txt)

ares_add_header_sources(
  spec
  cpu/cpu.hpp
  cpu/debugger.cpp
  cpu/memory.cpp
  cpu/serialization.cpp
)

ares_add_header_sources(
  spec
  expansion/expansion.hpp
  expansion/port.cpp
  expansion/port.hpp
  expansion/kempston/kempston.cpp
  expansion/kempston/kempston.hpp
)

ares_add_header_sources(spec keyboard/keyboard.hpp)

ares_add_header_sources(
  spec
  psg/psg.hpp
  psg/serialization.cpp
)

ares_add_header_sources(
  spec
  system/serialization.cpp
  system/system.hpp
)

ares_add_header_sources(
  spec
  tape/deck.cpp
  tape/deck.hpp
  tape/tape.hpp
  tape/tray.cpp
  tape/tray.hpp
)

ares_add_header_sources(
  spec
  ula/color.cpp
  ula/serialization.cpp
  ula/ula.hpp
)
