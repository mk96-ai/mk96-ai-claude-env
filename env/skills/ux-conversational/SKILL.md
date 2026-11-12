---
name: ux-conversational
description: Use when designing or reviewing a chatbot or messaging bot (WhatsApp, Telegram, Discord, Slack, in-app chat widget) or deciding its persona, tone, greeting, commands, buttons vs free text, error and fallback replies, human handoff, group behavior, opt-in/opt-out or platform messaging limits.
---

# Conversational UX

## Overview
Visual chat widgets: also `ux-design`. Implementation: `node-backend`. Solve the task in few turns, never make users repeat themselves, always offer a way out.

## Persona and greeting
- Disclose it is a bot; one consistent persona; tone plain for money, health and errors.
- First message: who it is, 2-4 things it can do, how to get help. Telegram: `/start`, `/help`, command menu with descriptions.

## Turns
- One question per turn, ending in a clear call to action.
- Ask only for what is missing; reuse earlier answers.
- One idea per message, key point first; split or link long content.
- Vary frequent phrasings; recognize closings ("thanks") and end cleanly.

## Buttons vs free text
- Buttons or lists for closed choices; typed equivalents always accepted.
- WhatsApp: ≤3 reply buttons (≤20 chars), lists ≤10 rows. Telegram: inline keyboard for in-place actions (edit the message, answer the callback).
- Confirm irreversible actions restating key details; then a short "Done" with the result.

## Errors and fallback
- 1st no-match: brief reprompt. 2nd: options or an example. After 2-3: menu or human; never loop.
- Admit not understanding instead of guessing; keep the flow, don't restart it.
- Failures in plain words plus next step.

## Human handoff
- Always reachable; offered automatically after repeated failures or frustration.
- Pass the context; say who takes over and expected wait or hours.

## Latency
- Typing indicator (WhatsApp, Telegram `sendChatAction`) beyond ~1-2 s; for long jobs acknowledge now, deliver later.
- Discord: answer or defer interactions within 3 s.

## Groups
- Respond only when addressed (command, mention, reply); keep Telegram privacy mode on.
- Rate-limit, stay brief, move personal or long flows to private; ephemeral replies where available.

## Consent and platform rules
- Message only opted-in users; honor "stop" at once and say how to opt out.
- WhatsApp: free-form only within 24 h of the user's last message, otherwise approved templates; human escalation path required.
- Ask for personal data only when needed; say if it goes to third parties (e.g. an AI provider).
- Length limits: Telegram 4096, Discord 2000 characters.

## Common mistakes
| Mistake | Fix |
|---|---|
| "I didn't understand" forever | Escalating reprompt, then menu or human |
| Wall of text | Split, key point first |
| Buttons only | Accept typed equivalents |
| Pretends to be human | Disclose at greeting |
| Silent while working | Typing indicator |
| Answers every group message | Only when addressed |
| Ignoring "stop" | Opt out immediately, confirm |
| WhatsApp message after 24 h | Approved template |

Sources: Google conversation design, Microsoft Bot Framework CUX guide, Meta WhatsApp Business Messaging Policy and Cloud API docs, Telegram bot features and Bot API, Discord interactions docs, NN/g chatbots, nextlevelbuilder/ui-ux-pro-max-skill.
