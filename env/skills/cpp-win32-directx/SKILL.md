---
name: cpp-win32-directx
description: Use when building or changing a native Windows desktop or tray app in C++ (Win32 window, message loop, WndProc, COM, Shell_NotifyIcon, Direct3D 11/DXGI swap chain, DPI, manifest, UAC elevation, packaging), or when it renders blurry, burns CPU while hidden, loses its tray icon, or dies after a GPU/driver reset.
---

# Win32 + Direct3D 11 desktop apps

## Overview
One UI thread owns window, loop and D3D context. C++/CMake: `rules/cpp.md`; Dear ImGui: `cpp-imgui`; visuals: `ux-design`.

## Setup
- `add_executable(<app> WIN32 ...)`; definitions `UNICODE _UNICODE NOMINMAX WIN32_LEAN_AND_MEAN`.
- Embedded manifest: `<dpiAwareness>PerMonitorV2</dpiAwareness>`, Windows 10 `supportedOS`, `requestedExecutionLevel asInvoker`. Icon and `VERSIONINFO` in a `.rc`.

## Text and DPI
- `W` APIs only; UTF-8 inside the app, convert with `MultiByteToWideChar`/`WideCharToMultiByte(CP_UTF8)` at OS calls (or manifest `activeCodePage` UTF-8, Windows 10 1903+).
- On `WM_DPICHANGED` apply the suggested rect (`SetWindowPos`), then rescale. Use `GetDpiForWindow`/`*ForDpi` APIs, no 96-DPI pixels.

## Message loop and threads
- `PeekMessage` loop only while visible; when hidden block on `GetMessage`/`MsgWaitForMultipleObjectsEx`. No exception escapes `WndProc`.
- Workers never touch `HWND` or D3D: `PostMessage(WM_APP + n)` or a mutex-guarded snapshot; never `SendMessage` (deadlock). Stop them before `DestroyWindow`.

## COM
- RAII `CoInitializeEx` per thread (UI thread STA); handle `RPC_E_CHANGED_MODE`.
- `Microsoft::WRL::ComPtr` (`As()`, `ReleaseAndGetAddressOf()`); every `HRESULT` checked by a helper keeping code and call site.

## Tray icon
- `NIM_ADD` then `NIM_SETVERSION` (`NOTIFYICON_VERSION_4`); re-add on `RegisterWindowMessageW(L"TaskbarCreated")`; `NIM_DELETE` on exit. Icon via `LoadIconMetric`.
- Menu: `SetForegroundWindow` before `TrackPopupMenu`, `PostMessage(WM_NULL)` after.

## Direct3D 11 / DXGI
- `D3D11_CREATE_DEVICE_DEBUG` in Debug only. `CreateSwapChainForHwnd` with `DXGI_SWAP_EFFECT_FLIP_DISCARD`, 2+ buffers, `B8G8R8A8_UNORM`, no MSAA; rebind the render target every frame.
- Resize at frame start, not in `WM_SIZE`: release back-buffer views, `ResizeBuffers(0, w, h, DXGI_FORMAT_UNKNOWN, 0)`, skip 0×0.
- `DXGI_STATUS_OCCLUDED`: present with `DXGI_PRESENT_TEST` and wait.
- `DXGI_ERROR_DEVICE_REMOVED`/`RESET` from `Present`/`ResizeBuffers`: log `GetDeviceRemovedReason`, release all, recreate device, swap chain and resources. Test: `dxcap -forcetdr`.

## Elevation and packaging
- Elevate only a helper (`ShellExecuteExW` `runas`). `requireAdministrator` prompts every launch, is not autostarted from the `Run` key (use a logon task with highest privileges) and blocks drag-and-drop.
- Static CRT (`CMAKE_MSVC_RUNTIME_LIBRARY`) or ship the VC++ redist; sign binaries.

## Common mistakes
| Symptom | Cause / fix |
|---|---|
| Blurry window | No PerMonitorV2 manifest |
| Wrong size after monitor change | Suggested rect of `WM_DPICHANGED` ignored |
| Tray icon gone after Explorer restart | `TaskbarCreated` not handled |
| CPU busy while hidden | `PeekMessage` spin |
| Black window after driver update | Device-removed not handled |
| No autostart | Elevated app in `Run` key |

Sources: Microsoft Learn (High DPI, DXGI flip model, device removed, `Shell_NotifyIcon`, COM, UTF-8), ocornut/imgui `example_win32_directx11` (~77k stars, MIT), microsoft/DirectXTK wiki (~2.9k, MIT); Run-key elevation: practitioner reports (Winaero, MS Q&A), no official page.
