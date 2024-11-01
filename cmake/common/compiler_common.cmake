# ares CMake common compiler options module

include_guard(GLOBAL)

option(ARES_COMPILE_DEPRECATION_AS_WARNING "Downgrade deprecation warnings to actual warnings" FALSE)
mark_as_advanced(ARES_COMPILE_DEPRECATION_AS_WARNING)

# Set C and C++ language standards to C17 and C++17
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

# Set symbols to be hidden by default for C and C++
set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN TRUE)

# clang options for C, C++, ObjC, and ObjC++
set(
  _ares_clang_common_options
  -Wblock-capture-autoreleasing
  # -Wswitch
  # -Wdeprecated
  -Wempty-body
  -Wbool-conversion
  -Wconstant-conversion
  # -Wshorten-64-to-32
  # -Wanon-enum-enum-conversion
  -Wint-conversion
  -Wnon-literal-null-conversion
  -Winfinite-recursion
  -Werror=return-type
  # -Wparentheses
  -Wpointer-sign
  -Wquoted-include-in-framework-header
  -Wnewline-eof
  # -Wsign-compare
  # -Wstrict-prototypes
  # -Wcomma
  -Wignored-pragmas
  -Wunguarded-availability
  -Wuninitialized
  -Wunreachable-code
  # -Wunused
  -Wvla
  -Wformat-security
  -Wno-error=strict-prototypes
  -Wno-error=shorten-64-to-32
  -Wno-error=sign-compare
  -Wno-error=comma
  -Wno-error=parentheses
  -Wno-error=unused-parameter
  -Wno-error=unused-variable
  -Wno-error=unused-but-set-variable
  -Wno-error=deprecated-declarations
  -Wno-error=deprecated-literal-operator
  -Wno-error=newline-eof
  -Wno-error=protocol
  -Wno-error=comma
  -Wno-error=deprecated-copy-with-user-provided-copy
  -Wno-error=deprecated-copy
  -Wno-error=anon-enum-enum-conversion
  -Wno-error=deprecated-copy-with-user-provided-dtor
  -Wno-error=unused-local-typedef
  -Wno-error=unused-private-field
)

set(_ares_clang_c_options ${_ares_clang_common_options})

# clang options for C++
set(
  _ares_clang_cxx_options
  ${_ares_clang_common_options}
  -Wvexing-parse
  -Wdelete-non-virtual-dtor
  -Wrange-loop-analysis
  -Wmove
  -Winvalid-offsetof
  -Wno-delete-non-abstract-non-virtual-dtor
)

if(NOT DEFINED CMAKE_COMPILE_WARNING_AS_ERROR)
  set(CMAKE_COMPILE_WARNING_AS_ERROR OFF)
endif()
