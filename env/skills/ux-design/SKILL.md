---
name: ux-design
description: Use when designing or reviewing any user interface (web page, web app, desktop app, tray menu, form) or deciding layout, visual hierarchy, colors, typography, spacing, states, feedback or accessibility, before writing UI code.
---

# UX and visual design

## Overview
Target taste: **very visual, uncluttered, intuitive at first sight.** When in doubt, remove it. Specific domains add their own skill: `ux-dashboards`, `ux-desktop`, `ux-mobile`, `ux-landing`, `ux-ecommerce`, `ux-forms`, `ux-conversational`, `ux-social`, `ux-games`. Implementation lives in `frontend-web` (and `angular`).

## Process
1. Token plan first: 4-6 named colors, 1-2 typefaces, spacing scale, one primary action per screen.
2. "Would this same design fit any similar app?" If yes, make it specific.
3. Build, screenshot, critique hierarchy, clutter and states.

## Hierarchy and restraint
- One primary action per screen, secondary ones quieter; fewer choices decide faster (Hick).
- Hierarchy through size, weight, spacing and contrast, not color alone. Squint test: the key element still stands out.
- Boldness in one place; whitespace and grouping over borders and boxes.
- Familiar patterns over novel ones (Jakob); recognition over recall.
- Avoid template looks: identical shadowed cards, decorative gradients.

## Tokens
| Token | Default |
|---|---|
| Spacing | 4/8 pt: 8 icon-text, 16-24 fields and cards, 32-64 sections |
| Type scale | 12/14/16/18/24/32, body 16 |
| Line height | 1.5-1.7 body, 1.1-1.3 headings; lines 45-75 characters |
| Weights | 400 body, 500 labels, 600-700 headings |
| Colors | Semantic names (`surface`, `primary`, `danger`), never raw hex |

## Color, contrast, dark mode
- Text contrast at least 4.5:1 (3:1 large text, icons and control borders).
- Status never by color alone: add icon or text.
- Dark mode: desaturated colors on dark grey, not inverted or pure black; check both themes.

## States and feedback (every view)
- Empty: what will appear and the first action ("No invoices yet. Create invoice").
- Loading: skeleton matching the layout, shown after ~150-300 ms, kept ≥300-500 ms; percent progress beyond ~10 s.
- Error: what happened and how to fix it, in plain words.
- Every action gets visible feedback within ~100 ms; optimistic updates roll back with a clear error.

## Forms
- Visible labels (placeholders are examples). Validate on blur, error under the field, focus first error on submit; don't pre-disable submit; never clear what the user typed.
- Buttons name the action ("Save changes"), the result reuses the verb ("Saved").
- Destructive actions: prefer undo; confirm only when undo is impossible.

## Motion
- Only for cause and effect, 150-300 ms, interruptible, reduced motion respected; anything moving over 5 s can be paused.

## Accessibility (WCAG 2.2 AA)
- Full keyboard use; focus visible, never hidden by sticky bars; labels on icon-only buttons; native controls first.
- Targets ≥24x24 px (touch 44 pt iOS / 48 dp Android, more in `ux-mobile`); click alternative to dragging.
- Usable at 200% zoom and 320 px width without loss of content.

## Desktop apps
Windows, menus, tray, notifications, platform idioms: `ux-desktop`.

## Pre-ship checklist
- [ ] Primary action obvious in 5 seconds
- [ ] Empty, loading, error, long-text states done
- [ ] Contrast, keyboard, focus, targets pass
- [ ] Light/dark and narrow/wide checked
- [ ] Nothing removable without loss

Sources: anthropics/skills frontend-design, nextlevelbuilder/ui-ux-pro-max-skill, vercel-labs/web-interface-guidelines, wshobson/agents ui-design, NN/g, Laws of UX, Refactoring UI, WCAG 2.2, Material 3, platform HIGs.
