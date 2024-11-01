target_sources(
  ruby
  PRIVATE # cmake-format: sortable
    video/glx.cpp
)

target_sources(
  ruby
  PRIVATE # cmake-format: sortable
    audio/oss.cpp
    audio/alsa.cpp
    audio/openal.cpp
    audio/sdl.cpp
    audio/pulseaudio.cpp
    audio/pulseaudio-simple.cpp
    audio/ao.cpp
)

target_sources(
  ruby
  PRIVATE # cmake-format: sortable
    input/xlib.cpp
    input/sdl.cpp
    input/mouse/xlib.cpp
    input/keyboard/xlib.cpp
    input/joypad/sdl.cpp
    input/joypad/udev.cpp
    input/joypad/uhid.cpp
    input/joypad/xinput.cpp
)
