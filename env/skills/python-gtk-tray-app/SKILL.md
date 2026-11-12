---
name: python-gtk-tray-app
description: Use when building or changing a Linux desktop or tray applet in Python with GTK/PyGObject (AppIndicator, GLib main loop, GNOME/Wayland), including threading, frozen UI, polling and making UI logic testable.
---

# Python GTK tray apps (Linux / GNOME)

## Overview
Only the main thread touches GTK. Logic lives in plain Python; GTK widgets just render state and forward events.

## Structure
- Logic (state, decisions, menu text): pure functions or classes, ideally in modules with **no `gi` import**, so pytest runs without a display. Tests in `tests/test_<module>_logic.py`.
- View: GTK widgets that render the logic's output and call it on events.
- Inject scheduler and clock: `GLib.idle_add` in production, a direct call in tests.

## Threading and main loop
- Workers hand UI updates to the main thread with `GLib.idle_add(callback, *args)`, ideally through one `run_in_thread(work, on_done)` helper.
- Idle/timeout callbacks return `GLib.SOURCE_REMOVE` unless they must repeat (anything truthy repeats forever).
- Polling with `GLib.timeout_add_seconds`, never `time.sleep` loops. Keep the source id and `GLib.source_remove` it on stop.
- Prefer non-blocking `Gio` `*_async` calls (D-Bus, files, `Gio.Subprocess`) with a `Gio.Cancellable`; cancel pending work and kill child processes on shutdown.
- Signals run in the emitting thread; some libraries (GStreamer) emit off the main thread.
- Never block the main loop waiting for a worker.
- No legacy `Gdk.threads_*` calls.

## AppIndicator
- `AyatanaAppIndicator3` exists only for GTK3, and GTK3 and GTK4 cannot share a process: the whole app stays on GTK3.
- The menu is exported over D-Bus (dbusmenu) and drawn by the shell: use only `Gtk.MenuItem` / `CheckMenuItem` / `SeparatorMenuItem` with the `activate` signal; custom widgets never show. Call `show_all()` on the menu and rebuild it when state changes.
- No left-click action on GNOME: everything goes through the menu.
- GNOME has no native tray: document the AppIndicator extension requirement (preinstalled on Ubuntu).

## Startup and environment
- `gi.require_version(...)` before each `from gi.repository import ...`; at the entry point catch `ValueError`/`ImportError` and name the missing package.
- System deps (`python3-gi`, `gir1.2-ayatanaappindicator3-0.1`) come from the distro, not pip; a venv needs `--system-site-packages`.
- `Gtk.Application` (with `hold()` when there is no window) for single instance, or plain `Gtk.main()` in GTK3. Either way, `GLib.unix_signal_add` for SIGINT/SIGTERM so cleanup runs.
- Ship a `.desktop` file and an autostart entry (`~/.config/autostart`, `X-GNOME-Autostart-enabled=true`); panel icons as themed `*-symbolic` names.

## Common mistakes
| Symptom | Cause |
|---|---|
| Random crashes / warnings | GTK touched from a worker thread or thread-emitted signal |
| UI freezes | Blocking I/O or `sleep` on the main loop |
| Menu item does nothing or is missing | Custom widget or non-`activate` signal in the indicator menu |
| Untestable code | Logic inside widget handlers |

Sources: PyGObject threading and asynchronous guides (LGPL-2.1), AyatanaAppIndicator docs (GPL-3), GNOME HIG (CC BY-SA), ubuntu/gnome-shell-extension-appindicator (~1k stars, GPL-2).
