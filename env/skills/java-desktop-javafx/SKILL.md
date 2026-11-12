---
name: java-desktop-javafx
description: Use when building or changing a JavaFX desktop application (windows, pages, view models, bindings, AtlantaFX themes, Ikonli icons, i18n, global hotkeys, HUD overlays, jlink/jpackage packaging), or when the UI freezes, throws "Not on FX application thread", or its logic is hard to test.
---

# JavaFX desktop apps

## Overview
JavaFX is one driving adapter: it renders view models and forwards user intent to ports. Visual decisions: `ux-design`; Java rules: `rules/java.md`.

## Structure
- Layout, naming and dependency rules: `arch-hexagonal`. Do not invent `adapter/in|out` or `application/port` variants.
- UI: `infrastructure/controller/ui/{window,page,component,viewmodel,theme,i18n,format}`; overlays such as a HUD as `ui/hud`. Other inputs (global hotkeys) are sibling controllers: `infrastructure/controller/hotkey`.
- OS access (mouse, screen) and timers are driven adapters behind outbound ports (`infrastructure/gateway/system`, `infrastructure/gateway/scheduling`).
- One composition root wires everything (`config/`); the `Application` subclass builds it in `start()` and closes it in `stop()`.

## View models & binding
- One view model per page: JavaFX properties (`javafx.beans` only, never `javafx.scene`), calls inbound ports (`*Service`), no I/O.
- Expose `ReadOnly*Property` via `ReadOnly*Wrapper`; derived state (`canStart`, `isActive`) as bindings, not listeners that set flags.
- Views are dumb: bind, don't copy values; no rules in event handlers.
- Views in code or FXML, consistently; FXML controllers stay thin. Plain properties suffice; mvvmFX is unmaintained since 2018.

## Threading
- Scene graph and view-model properties only on the JavaFX Application Thread.
- Never block it: I/O and long work in `Task`/`Service` (or an executor), results via `succeeded()` or `Platform.runLater`.
- `Task.updateProgress/updateMessage` coalesce; check `isCancelled()` in loops.
- Events from background threads reach the UI through an outbound-port adapter that takes an `Executor` (`Platform::runLater` in prod, `Runnable::run` in tests).
- UI timing: `Timeline`/`AnimationTimer`; business scheduling: an outbound port. Background threads are daemon and closed in `stop()`.

## Look & usability
- Theme: AtlantaFX via `Application.setUserAgentStylesheet(...)` before the first scene; customise through its CSS variables (`-color-accent-fg`...) in one app stylesheet. Light and dark selectable.
- Icons: Ikonli `FontIcon` with one pack (e.g. Material Design 2); icon-only buttons get a tooltip and accessible text.
- i18n: `ResourceBundle` per locale, English base, `MessageFormat`/`NumberFormat` with the locale; no hardcoded texts; a test that every key exists in every bundle.
- Window state: persist size, position, maximized and last page; on restore, clamp to `Screen.getVisualBounds()` (monitor may be gone).
- Keyboard: accelerators (`KeyCombination`) for main actions, mnemonics, Enter/Escape on dialogs, visible focus.

## Packaging
- Ship a jlink runtime + `jpackage` installer per OS (javafx-maven-plugin `javafx:jlink`, or jlink/jpackage plugins). JavaFX jars are platform-specific: build on each target OS.
- Shaded fat jars are unsupported (warning since JavaFX 16, one OS only).

## Testing
- View models: plain JUnit, no toolkit start; inject the UI `Executor` and fakes.
- Time: a virtual-time scheduler that also implements the clock; in-memory fakes of outbound ports.
- TestFX (+ Monocle headless) sparingly: smoke tests of critical flows.
- ArchUnit: the `arch-hexagonal` rule plus "domain/application never import `javafx..`, `atlantafx..`, `java.awt..`".

## Common mistakes
| Symptom | Cause / fix |
|---|---|
| Frozen window | I/O or `Thread.sleep` on the FX thread: move to `Task` |
| `IllegalStateException: Not on FX application thread` | Property set from a worker: hop with `Platform.runLater` |
| UI flooded, lag | `runLater` per tick: coalesce or throttle |
| Untestable page | Rules in handlers: move to the view model |
| "JavaFX runtime components are missing" | Fat jar / classpath: use jlink + jpackage |
| Process never exits | Non-daemon hook/executor threads not closed in `stop()` |

Sources: openjfx.io docs + `javafx.concurrent` javadoc (GPL-2.0+CPE), mkpaz/atlantafx (~1.5k stars, MIT), kordamp/ikonli (~600, Apache-2.0), TestFX/TestFX (~1k, EUPL-1.1), sialcasa/mvvmFX (~520, Apache-2.0), openjfx/samples (~660, BSD-3), openjfx-dev mailing list (fat jars).
