---
name: cpp-imgui
description: Use when building or changing a Dear ImGui or ImPlot interface in C++ (windows, widgets, tables, plots, fonts, DPI scaling, docking, multi-viewports, backends), or when widgets react to the wrong item, clicks leak to the app, text is tiny or blurry, or the UI is slow or hard to test.
---

# Dear ImGui / ImPlot

## Overview
Immediate mode: each frame redraws the UI from your state. C++/CMake: `rules/cpp.md`; Win32/D3D host: `cpp-win32-directx`; visuals: `ux-design`; chart choice: `ux-dashboards`.

## State and separation
- App state in your own models, never in ImGui. Draw functions take state and emit actions; no I/O, blocking or business rules. Logic testable without an ImGui context.
- Dialogs edit a copy; commit on OK. Slow work on workers; the UI reads a snapshot.

## IDs and scopes
- `"Save##row"` hides a suffix, `"###id"` keeps the ID when the label changes; in loops `PushID(stable id)`/`PopID`. Debug with `ShowIDStackToolWindow()`.
- `End()`/`EndChild()` always; `EndPopup`, `EndTable`, `EndMenu`, `ImPlot::EndPlot` only when their `Begin*` returned true.

## Input
- Forward all input to ImGui; the app handles mouse/keyboard only when `io.WantCaptureMouse`/`WantCaptureKeyboard` are false.
- Keys via `ImGuiKey_*` (`IsKeyPressed`, `Shortcut`), not virtual-key codes.

## DPI and fonts (1.92+)
- `style.FontScaleDpi = dpiScale` (fonts are dynamic, no glyph ranges); `style.ScaleAllSizes(dpiScale)` once on a fresh style, rebuilt on DPI change.
- Sizes relative to `GetFontSize()`/`GetFrameHeight()`, never fixed pixels. Strings are UTF-8.
- `io.IniFilename`: per-user app-data path or `nullptr`, never the working directory.

## Docking and viewports
- Only in the `docking` branch (`vX.Y-docking` tags): `ImGuiConfigFlags_DockingEnable` + `DockSpaceOverViewport()`.
- `ImGuiConfigFlags_ViewportsEnable` needs `UpdatePlatformWindows()` + `RenderPlatformWindowsDefault()` each frame; positions become screen coordinates.

## Backends and setup
- Core and backends from the same pinned commit, unmodified; settings via `IMGUI_USER_CONFIG`, not editing `imconfig.h`.
- `ImGui::CreateContext()` then `ImPlot::CreateContext()`, then backend `Init`; shut down in reverse.
- Win32: `ImGui_ImplWin32_WndProcHandler` first in `WndProc`. CI build with `IMGUI_DISABLE_OBSOLETE_FUNCTIONS`.

## ImPlot
- `if (ImPlot::BeginPlot(...)) { Setup*; Plot*; EndPlot(); }`; all `Setup*` before the first `Plot*`.
- Scrolling: `SetupAxisLimits(..., ImPlotCond_Always)`; ring buffers via the `offset` argument, no copying.
- Dense plots: 32-bit `ImDrawIdx` or a `RendererHasVtxOffset` backend; downsample millions of points.

## Performance
- `ImGuiListClipper` for long lists; no formatting of hidden rows. Skip frames while hidden. Measure with `ShowMetricsWindow()`.

## Common mistakes
| Symptom | Cause / fix |
|---|---|
| Wrong row reacts | Duplicate IDs: `PushID` in loops |
| Assert on End | `End*` called when `Begin*` was false (or skipped for `End()`) |
| Clicks reach the app under a window | `WantCaptureMouse` ignored |
| Tiny or blurry text | No `FontScaleDpi`/`ScaleAllSizes` |
| Glitches in big plots | 16-bit indices |

Sources: ocornut/imgui FAQ, wiki, `imgui.h` and examples (~77k stars, MIT), epezent/implot README and `implot.h` (~6.3k, MIT).
