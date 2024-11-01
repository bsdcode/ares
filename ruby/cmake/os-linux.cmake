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

find_package(X11 REQUIRED)
find_package(OpenGL REQUIRED)

target_link_libraries(ruby PRIVATE X11::Xrandr OpenGL::GLX)

target_enable_feature(ruby "GLX OpenGL video driver" VIDEO_GLX)
target_enable_feature(ruby "Xlib input driver" INPUT_XLIB)

find_package(OpenAL)
find_package(librashader)
find_package(SDL)
find_package(OSS)
find_package(ALSA)
find_package(PulseAudio)
find_package(AO)

if(OpenAL_FOUND)
  target_enable_feature(ruby "OpenAL audio driver" AUDIO_OPENAL)
endif()

if(librashader_FOUND AND ARES_ENABLE_LIBRASHADER)
  target_enable_feature(ruby "librashader OpenGL runtime" LIBRA_RUNTIME_OPENGL)
else()
  # continue to define the runtime so openGL compiles
  target_compile_definitions(ruby PRIVATE LIBRA_RUNTIME_OPENGL)
endif()

if(OSS_FOUND)
  target_enable_feature(ruby "OSS audio driver" AUDIO_OSS)
endif()

if(ALSA_FOUND)
  target_enable_feature(ruby "ALSA audio driver" AUDIO_ALSA)
endif()

if(PulseAudio_FOUND)
  target_enable_feature(ruby "PulseAudio audio driver" AUDIO_PULSEAUDIO)
endif()

if(AO_FOUND)
  target_enable_feature(ruby "ao audio driver" AUDIO_AO)
endif()

if(SDL_FOUND)
  target_enable_feature(ruby "SDL input driver" INPUT_SDL)
  target_enable_feature(ruby "SDL audio driver" AUDIO_SDL)
endif()

target_link_libraries(
  ruby
  PRIVATE
    $<$<BOOL:${SDL_FOUND}>:SDL::SDL>
    $<$<BOOL:${OpenAL_FOUND}>:OpenAL::OpenAL>
    $<$<BOOL:TRUE>:librashader::librashader>
    $<$<BOOL:${OSS_FOUND}>:OSS::OSS>
    $<$<BOOL:${ALSA_FOUND}>:ALSA::ALSA>
    $<$<BOOL:${PulseAudio_FOUND}>:pulse>
    $<$<BOOL:${AO_FOUND}>:AO::AO>
)
