---
name: ux-landing
description: Use when designing or reviewing a corporate website, homepage or landing page, or deciding hero message, value proposition, call to action, social proof, page sections, navigation, contact or lead forms, page speed, SEO content structure, cookie banner or language versions.
---

# Corporate sites and landing pages

## Overview
Builds on `ux-design`; implementation: `frontend-web`. Visitors decide in seconds: say what it is, for whom, and what to do next.

## Above the fold
- Headline states the outcome in plain words, not a slogan; one-line subhead says how.
- One primary CTA with a specific verb ("Book a demo"); at most one quieter secondary.
- One real visual (product, result, people); no stock clichés, no auto-rotating carousel, no pop-up on arrival.

## Page structure
- Hero → benefits (3-5) → how it works → proof → offer/pricing → FAQ → final CTA.
- One idea per section, scannable heading; repeat the same CTA, never a competing one.
- Campaign landing page: drop main navigation, keep one goal.

## Trust
- Real testimonials (name, photo, role), numbers, logos with permission; proof near the CTA.
- Visible About, contact details and address; dated news.

## Navigation
- 5-7 descriptive top labels ("Services", not "Solutions hub"); logo links home; contact one click away; footer repeats key and legal links.

## Contact and lead forms
- Only the fields the next step needs; say what happens next and when ("Reply within 1 working day").
- Confirmation page; also show email and phone.

## Speed is UX (Core Web Vitals, p75)
| Metric | Good |
|---|---|
| LCP (main content shown) | ≤ 2.5 s |
| INP (response to input) | ≤ 200 ms |
| CLS (layout jumps) | ≤ 0.1 |

Preload the hero image, lazy-load the rest, reserve space for media, embeds and banners.

## SEO structure
- One `h1` matching the page intent, logical headings; unique title and meta description.
- People-first content with visible author and date; descriptive URLs and link text; `Organization` structured data.

## Cookie banner (EU)
- "Reject all" on the same layer and as prominent as "Accept all"; no pre-ticked boxes; no tracking before consent.
- Withdraw as easily (footer link); banner never covers the CTA.

## Multilingual
- Switcher in the header, languages in their own name ("Español"), not flags.
- Default from browser language, never IP; remember the choice; switching keeps the same page.
- One URL per language with `hreflang`; translate everything (forms, errors); leave room for longer text.

## Common mistakes
| Mistake | Fix |
|---|---|
| Clever slogan, unclear offer | What, for whom, outcome |
| Several equal CTAs | One primary, repeated |
| Hero carousel | One message, one visual |
| Long lead form | Minimum fields, next step stated |
| "Reject" as a faint link | Equal buttons, same layer |
| Flags for languages | Language names |
| Layout jumps on load | Reserve space, preload hero |

Sources: NN/g (homepages, landing pages, carousels), web.dev Core Web Vitals, Google Search Central (helpful content, structured data, hreflang), EDPB Cookie Banner Taskforce report (2023), deceptive.design, nextlevelbuilder/ui-ux-pro-max-skill, anthropics/skills frontend-design, vercel-labs/web-interface-guidelines.
