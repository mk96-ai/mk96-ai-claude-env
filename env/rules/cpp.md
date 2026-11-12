---
paths:
  - "**/*.{cpp,cc,cxx,hpp,hh,h,ixx}"
  - "**/CMakeLists.txt"
  - "**/*.cmake"
  - "**/CMakePresets.json"
---

# Modern C++ (17/20/23) and CMake

Pure C++ and its build, on top of `coding.md`. Use the standard the project already targets. Platform and UI toolkits come from skills (`cpp-win32-directx`, `cpp-imgui`).

## Ownership and safety
- RAII everywhere, Rule of Zero. `std::unique_ptr` by default; `shared_ptr` only for real shared ownership. No naked `new`/`delete`.
- Raw pointers/references are non-owning. Read-only parameters as `std::span` / `std::string_view`; never store a `string_view` past the call.
- `const` / `constexpr` by default, `enum class`, `[[nodiscard]]` where ignoring the result is a bug. No C-style casts.
- Expected failures: `std::optional`, or `std::expected` (C++23; otherwise the project's result type). Exceptions never cross C callbacks or thread entry points: catch at the boundary.

## Concurrency
- `std::jthread` + `std::stop_token` (C++20); lock with `std::scoped_lock`; shared flags as `std::atomic`. No shared mutable data without a lock.

## Headers
- `#pragma once`; include what you use; no `using namespace` in headers.
- Format with the committed `.clang-format`.

## CMake
- `cmake_minimum_required` 3.21+. Target-based only (`target_*` with `PRIVATE`/`PUBLIC`); no global `include_directories`, `add_definitions` or `CMAKE_CXX_FLAGS` edits.
- `target_compile_features(<target> PUBLIC cxx_std_20)` on libraries (`PRIVATE` on executables).
- `CMakePresets.json` for configure/build/test presets (toolchain file set there); machine paths in an untracked `CMakeUserPresets.json`.
- Dependencies via vcpkg manifest (`vcpkg.json` with `builtin-baseline`, never classic `vcpkg install <lib>`) or `FetchContent` pinned to a tag/commit. Source-only libraries may be a pinned submodule built as their own target, included as `SYSTEM` so their warnings stay out.
- Warnings high on your targets (`/W4 /permissive- /utf-8` on MSVC, `-Wall -Wextra -Wpedantic -Wconversion -Wshadow` elsewhere). Errors only in CI via `CMAKE_COMPILE_WARNING_AS_ERROR` (3.24+), not hardcoded.
- clang-tidy via a committed `.clang-tidy` and `CMAKE_CXX_CLANG_TIDY`.
- Sanitizers in a Debug/CI preset: ASan + UBSan on GCC/Clang; MSVC has ASan only (`/fsanitize=address`).
- Tests through CTest (`enable_testing()`, GoogleTest `gtest_discover_tests` or Catch2 `catch_discover_tests`).

Sources: isocpp/CppCoreGuidelines (~45k stars, paraphrased), Google C++ Style Guide (~40k, CC BY 3.0), cpp-best-practices/cppbestpractices (~9k) and cmake_template (~1.8k, Unlicense), CMake docs + "Effective Modern CMake", vcpkg docs (microsoft/vcpkg ~28k, MIT), github/awesome-copilot cmake-vcpkg instructions (~41k, MIT).
