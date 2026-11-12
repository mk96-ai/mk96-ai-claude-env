---
name: ux-mobile
description: Use when designing or reviewing a mobile app or mobile web screen (iOS, Android, PWA, responsive site on phones), or deciding thumb reach, touch targets, gestures, bottom navigation, safe areas, on-screen keyboard behavior, offline or slow network states, permission prompts, push notifications, or iOS vs Android conventions.
---

# Mobile apps and mobile web

## Overview
Builds on `ux-design`; long forms: `ux-forms`. One thumb, short attention, unreliable network: design for that first.

## Reach and targets
- Frequent actions in the lower-middle of the screen; top corners are hardest to reach.
- Targets ≥44x44 pt (iOS) / 48x48 dp (Android), spaced so neighbours aren't hit; enlarge the hit area, not the icon.

## Navigation
- 3-5 top-level destinations in a bottom bar, icon + label, always visible; more: drawer or tablet sidebar.
- Bottom bar only navigates; never hide or disable a tab; each keeps its scroll and history.

## Gestures
- Every gesture has a visible alternative; custom gestures only for frequent, specialised tasks.
- No swipeable content on system gesture edges.
- Back always works: iOS back button + edge swipe, Android system back; never trap it.

## Safe areas and keyboard
- Controls inside safe areas (notch, rounded corners, gesture bar); backgrounds may run edge to edge.
- Keyboard type matches the field (email, number, phone); Return key names the action (Search, Next, Send).
- Focused field and its submit button stay visible above the keyboard.
- Mobile web: never disable pinch zoom.

## Offline and slow network
- Cached content first; say plainly what still works ("Offline. Changes will sync").
- Queue actions, sync on reconnect; "last updated" when data may be stale.
- No full-screen blocking spinners for network calls; retry without losing input.

## Permissions
- Ask in context, when the user starts the feature that needs it; at launch only if the app can't work without it.
- Purpose text names the concrete benefit, not "better experience".
- Optional pre-screen: one "Continue" button that opens the system prompt, no fake "Allow".
- After denial: explain inline, link to the exact settings screen (Android stops prompting after repeated denials).

## Notifications
- Ask after the user sees value (follows, orders), not on first launch.
- Timely, personal, actionable; marketing only with explicit opt-in; honest urgency; per-type control in settings.

## iOS vs Android
| Topic | iOS (HIG) | Android (Material 3) |
|---|---|---|
| Target | 44 pt | 48 dp |
| Main nav | Tab bar | Navigation bar / rail |
| Primary action | Toolbar button | FAB |
| Back | Top-left button + edge swipe | System back (predictive) |
| Permission reason | Purpose string in alert | Own rationale screen |

## Common mistakes
| Mistake | Fix |
|---|---|
| Hamburger hides main sections | Bottom bar |
| All permissions at launch | In context, one at a time |
| Spinner blocks while offline | Cached view + queued actions |

Sources: Apple HIG (layout, tab bars, gestures, virtual keyboards, privacy, managing notifications, onboarding), Material 3 / Android developers (navigation bar, accessibility, edge-to-edge, predictive back, notification permission), NN/g (mobile navigation, permission requests), web.dev offline UX, Laws of UX (Fitts), WCAG 2.2 (2.5.8), nextlevelbuilder/ui-ux-pro-max-skill, wshobson/agents ui-design.
