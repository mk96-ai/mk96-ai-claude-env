---
name: frontend-web
description: Use when writing or reviewing web markup and styles (HTML, CSS/SCSS, form markup), including layout, responsiveness, theming, dark mode, accessibility implementation, image/font loading and layout shift, in any framework.
---

# Web frontend implementation

Framework-agnostic. Design decisions come from `ux-design`, Angular from `angular`, TypeScript from the JS/TS rule.

## HTML
- Semantic elements first: `<a href>` navigates, `<button>` acts, `<dialog>` with `showModal()` for modals; ARIA only when no native element fits.
- `<html lang>`, ordered headings, landmarks, a "Skip to content" link, an accurate `<title>` per view.
- The URL reflects state (filters, tabs, pagination) so links, refresh and Back work.
- Never disable zoom in the viewport meta.

## Forms markup
- Every control has a `<label for>`; errors linked with `aria-describedby` and flagged with `aria-invalid`.
- Correct `type`, `inputmode`, `name` and `autocomplete` (`one-time-code` for OTP); `spellcheck="false"` on emails, codes and usernames.
- Never block paste or keystrokes. Input font size ≥16px on mobile (avoids iOS auto-zoom).

## CSS / SCSS
- Tokens as CSS custom properties; SCSS variables only for build-time values.
- SCSS `@use` / `@forward`, never `@import` (deprecated in Dart Sass). Nesting at most 3 levels.
- Logical properties (`margin-inline`, `padding-block`) so RTL works.
- Never `transition: all`; animate `transform` / `opacity` and list them.
- `font-variant-numeric: tabular-nums` for numbers in tables and timers.

## Layout & responsiveness
- Mobile-first `min-width` queries on consistent breakpoints (e.g. 375/768/1024/1440); container queries for component-level changes.
- Flex/grid over JS measurement; no horizontal scroll.
- Long content must not break layouts: `min-width: 0` on flex/grid children, `overflow-wrap: anywhere`.
- `100dvh`, not `100vh`; `env(safe-area-inset-*)` for notches.

## Theming & dark mode
- Override tokens under `prefers-color-scheme` plus a `[data-theme]` attribute for the user's choice; `light-dark()` where supported.
- Set `color-scheme` per theme so native controls and scrollbars follow; `<meta name="theme-color">` matches the background.
- Native `<select>`: set `background-color` and `color` explicitly.

## Accessibility implementation
- `:focus-visible` styles always present; `scroll-margin-top` / `scroll-padding-top` so sticky bars never hide focused elements.
- Icon-only buttons get `aria-label`; decorative icons `aria-hidden="true"`.
- `aria-live="polite"` for toasts and inline validation.
- Modals trap and return focus; background `inert`.
- `prefers-reduced-motion` variant for every animation.

## Performance (Core Web Vitals, p75: LCP ≤2.5 s, INP ≤200 ms, CLS ≤0.1)
- Images with `alt`, explicit `width`/`height`, responsive `srcset`/`sizes`, AVIF/WebP.
- LCP image never lazy, `fetchpriority="high"`; below-the-fold images `loading="lazy"`.
- Fonts: WOFF2, preload only critical ones, `font-display: swap`, subset; `preconnect` to asset origins.
- Long lists virtualized or `content-visibility: auto`; long tasks off the main thread.

## Verify
- Build passes; check mobile/desktop, light/dark, 200% zoom, keyboard only; axe/Lighthouse clean.

## Common mistakes
| Mistake | Fix |
|---|---|
| `<div (click)>` / `<button>` for navigation | `<a href>` |
| `outline: none` without replacement | `:focus-visible` style |
| Lazy-loaded hero image | Eager + `fetchpriority="high"` |
| Images without dimensions | `width`/`height` or `aspect-ratio` |
| Hard-coded colors per theme | Custom-property tokens |

Sources: vercel-labs/web-interface-guidelines (~1k stars, MIT), MDN (mdn/content ~11k, CC-BY-SA-2.5, paraphrased), web.dev Core Web Vitals (GoogleChrome/web-vitals ~9k, Apache-2.0), github/awesome-copilot a11y/html-css instructions (~41k, MIT), nextlevelbuilder/ui-ux-pro-max-skill (~149k, MIT), WCAG 2.2.
