---
name: ux-desktop
description: Use when designing or reviewing a desktop or system-tray app (windows, menus, keyboard shortcuts, tray or menu bar icon, notifications, settings window, multi-monitor or HiDPI behavior, first run, running in the background, update prompts) on GNOME/Linux, Windows or macOS.
---

# Desktop and tray apps

## Overview
Builds on `ux-design`; settings save model: `ux-forms`. Follow the host platform (GNOME HIG, Windows/Fluent, Apple HIG) over a custom look: familiar beats novel.

## Windows
- Resizable, default size fits the content; restore last size, position and view, only onto a monitor that still exists.
- Secondary windows (settings, about) belong to the main one, never larger, never stacked.
- Crisp at every scale factor; usable at 1024x600; content width capped on huge screens.
- macOS: no key controls at the bottom edge.

## Menus and keyboard
- Every command reachable by keyboard; standard shortcuts (Ctrl/⌘ + Q, W, F, Z, comma); Esc closes dialogs and menus.
- Show shortcuts next to menu items; never reassign standard ones; no Alt or Super shortcuts on GNOME.
- Keep menus stable: disable unavailable items instead of hiding them (macOS menu bar); context-menu actions also exist elsewhere.

## Tray / menu bar icon
- Only for status or windowless features; one monochrome symbol adapting to light/dark bars; status as a small overlay, no flashing.
- Tooltip: name + status. Windows: left click shows something, right click the menu; GNOME and macOS: menu only.
- Short menu: Open <app> (first, default), pause/resume background work, settings, quit. Remove items that don't apply.
- Never the only way in: GNOME has no native tray, macOS hides extras.

## Background and closing
- Closing the last window quits, unless the user opted in to keep running (minimize-to-tray is opt-in).
- Background work visible, pausable, quittable.
- Autostart and tray icon: user's choice in settings.

## Settings
- Few settings, smart defaults; open with Ctrl/⌘ + comma; changes apply instantly, no OK/Apply.
- Theme, accessibility and fonts follow the OS ("Use system setting"); macOS: reopen on the last pane.

## Notifications
- Only for events that matter while the user is elsewhere; no success of watched tasks, no ads.
- Title alone makes sense; click opens the app at that item; at most 3 buttons, not repeating the click action.
- Summarise bursts, withdraw stale ones, per-type opt-out; respect Do Not Disturb.

## First run and updates
- Ready to use with defaults; at most one short optional intro; no notifications on first run.
- Updates download quietly; restart offered at a natural break with "Later"; remind at most daily, 3 times; only mandatory fixes escalate to a dialog.

## Common mistakes
| Mistake | Fix |
|---|---|
| Close button hides to tray silently | Quit, or an opt-in setting |
| Colored, animated tray icon | Monochrome symbol, subtle overlay |
| Feature only in tray menu | Also in main window |
| Settings with OK/Apply | Apply immediately (Windows, macOS, GNOME) |
| "Update now" interrupts work | Defer to next restart |

Sources: GNOME HIG (windows, keyboard, pointer & touch, adaptiveness, notifications), Microsoft Learn (notification area, notifications, app settings, high DPI), Apple HIG (menu bar, settings, layout, onboarding, managing notifications), GNOME wiki (instant apply), nextlevelbuilder/ui-ux-pro-max-skill, wshobson/agents ui-design.
