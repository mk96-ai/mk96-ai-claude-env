---
name: ux-games
description: Use when designing or reviewing a game's UI or player experience (HUD, menus, pause, controls, remapping, tutorials, feedback and juice, difficulty, fail states, saving, settings, loading screens, game accessibility, monetization) on any platform or input.
---

# Game UI and player experience

## Overview
Builds on `ux-design`. The world is the interface; UI appears only when it helps the next decision.

## HUD
- Show only what changes the next decision; contextual elements appear when relevant (health when hit).
- Edges and corners, action centre clear; fixed positions, icon + number.
- Text over the world gets outline or backing; default ≥26 px at 1080p on console, ≥18 px PC/mobile, scalable to 200% (XAG 101). HUD scalable or hideable.

## Menus and pause
- Pause anywhere in single player; same button resumes.
- Menus use the gameplay input; focus always visible, Back always the same button, last cursor position remembered.

## Controls
- Full remapping per device; toggle alternative for holds; no chords or mashing required.
- Sensitivity, invert and dead zones adjustable.
- Controller, keyboard/mouse and touch at parity; prompts follow the last used device. Touch: large targets in thumb reach.

## Onboarding
- Learn by doing: one mechanic, used at once, in a safe space; teach just in time, spaced out (Hodent).
- No text walls; skippable for veterans; controls reference in the pause menu.

## Feedback and juice
- Every input answered within ~100 ms (sound, animation, haptics).
- Juice (shake, flash, hit stop) supports readability and can be reduced.
- Key cues on two channels: visual + audio (+ haptic) (XAG 103).

## Difficulty, failure, saving
- Several levels, changeable mid-game without penalty; assists as options.
- Fast retry, cause shown, checkpoint near the failure.
- Autosave + manual save with a saving indicator.

## Settings and accessibility
- Accessibility offered on first launch and first in settings; graphics presets with live preview; separate volumes (music, effects, voice) + mono.
- Subtitles: large, backed, speaker named, important sounds captioned.
- Never color alone (shape, icon); colorblind presets only as extra.
- Toggles for camera shake, blur, head bob; FOV slider; no flashing patterns.

## Loading and monetization
- Loading: progress, readable tips; logos and intros skippable after first launch.
- Real-money price visible; no fake urgency or pay-to-skip walls; random purchases disclose odds before buying (Apple App Review 3.1.1).

## Common mistakes
| Mistake | Fix |
|---|---|
| HUD covering the action | Contextual HUD at the edges |
| Tutorial text dump | Teach by doing, just in time |
| Fixed controls, hold-only | Remap + toggle |
| Color-only cues | Shape or icon too |
| Small unbacked subtitles | Size option, backing, speaker |
| Death sends player far back | Nearby checkpoint, instant retry |
| Mouse-only menus | Same input everywhere |

Sources: Game Accessibility Guidelines, Xbox Accessibility Guidelines (101, 103, 107), Celia Hodent "The Gamer's Brain" (GDC 2016), Apple HIG Games and App Review Guidelines, nextlevelbuilder/ui-ux-pro-max-skill.
