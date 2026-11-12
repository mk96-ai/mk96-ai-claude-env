---
name: ux-social
description: Use when designing or reviewing a social or community feature (feed, timeline, post composer, profile, followers, reactions, comments, notifications, moderation, reporting, blocking, privacy settings, user-generated content) in a web or mobile app.
---

# Social and community UX

## Overview
Builds on `ux-design`. Design for wellbeing and safety, not time-on-app; every pattern must hold for the most vulnerable user.

## Feeds
- "Why am I seeing this" in plain words plus main ranking signals (EU DSA Art. 27).
- Easy, remembered chronological or non-personalized option (required for very large platforms, Art. 38).
- Natural stopping points ("You're all caught up"); no autoplay by default.
- Ads clearly labeled, never disguised as posts.

## Composer
- Audience visible before posting; default to the least exposed sensible option.
- Drafts auto-saved; edits marked "edited"; delete always possible.
- Prompt for alt text on images and captions on video (WCAG 1.1.1, 1.2.2).
- Optional nudge before likely hurtful text ("Review before posting?"), never a block.

## Profiles and interactions
- "View as public" preview.
- Like counts hideable; deep threads collapsed; authors can limit who replies.
- Tagged people can approve or remove tags.

## Notifications
- Batched ("Ana and 4 others..."), per-type controls, quiet hours.
- Only about the user or what they follow; no re-engagement bait, fake activity or streak guilt.

## Moderation and safety
- Report from every post, comment, profile and message in ≤2 taps; plain categories; confirm receipt.
- Tell reporter and author the decision, reasons and how to appeal (DSA Art. 16, 17, 20).
- Separate block (both ways, silent) and mute (hide only); restrict DMs from strangers.
- Filter objectionable content and publish a contact (App Store 1.2).

## Privacy
- One settings place, plain words, effect previewed.
- In-app account deletion and data export; no pre-ticked sharing or silent contact upload.

## Empty network
- Suggest follows from stated interests; curated content on day one.
- Empty feed explains how to fill it, with one action.

## Minors
- Private account, no stranger recommendations, limited DMs, no profiling-based ads (DSA Art. 28, EC guidelines 2025).
- No streaks, autoplay or public counts by default.

## Common mistakes
| Mistake | Fix |
|---|---|
| Endless scroll | "Caught up" marker |
| Opaque ranking | Explanation + chronological option |
| Notifications as bait | Relevant, batched, controllable |
| Report buried | ≤2 taps, with outcome |
| Block notifies blocked user | Silent block |
| Images without alt text | Prompt at upload |
| Teens public by default | Private by default |
| Confirmshaming on leaving | Neutral wording, easy delete |

Sources: EU Digital Services Act and EC minors guidelines 2025, deceptive.design, Center for Humane Technology, Apple App Store Review Guidelines 1.2 and 5.1.1(v), Apple HIG, Material 3, NN/g, WCAG 2.2, nextlevelbuilder/ui-ux-pro-max-skill.
