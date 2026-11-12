---
name: ux-forms
description: Use when designing or reviewing a long form, multi-step wizard, sign-up or onboarding flow or settings page, or deciding field order, steps, progress, validation timing, error summary, required/optional marking, autosave or review step.
---

# Long forms, wizards and settings

## Overview
Builds on `ux-design` (labels, blur validation, button wording). Every field must earn its place: unused answer, remove the field.

## Structure
- One column, labels above; field width hints at expected length.
- Easy, familiar questions first; group by topic with short headings.
- Long or branching flows: one question or topic per page; skip pages that do not apply (GOV.UK).
- Never ask the same data twice in one flow: prefill or offer "same as" (WCAG 3.3.7).

## Progress
- Name the steps ("Address", "Payment") and show current/total.
- Back, including browser back, keeps every answer.
- Long flows: save and resume, stating how long data is kept.

## Fields
- Defaults only when most people choose them; never pre-tick consent or paid extras.
- Mark optional fields "(optional)"; mark required too if most are optional; no "All fields required" note (Baymard).
- Correct input type and `autocomplete`; accept any format (spaces, dashes) and normalise.

## Validation timing
- On blur or once the expected length is reached, never while typing.
- A shown error clears on the keystroke that fixes it.
- Server validation still runs on submit.

## Error summary
- On submit: summary at the top, "There is a problem", focused, each item links to its field with the same text as the inline message.
- Page title prefixed "Error:"; messages say how to fix ("Enter a date in the past").

## Save model
| Context | Use |
|---|---|
| Independent settings | Autosave per change + "Saved" status |
| Fields that must agree, payments, sends | Explicit save, warn on leaving unsaved |
| Long drafts | Autosaved draft + explicit submit |

## Review step
- Before an irreversible submit: "Check your answers" with a "Change" link per answer that returns to the review.
- Confirmation: what happens next and a reference number.

## Sign-up and authentication
- Ask the minimum; collect profile data later, when needed.
- Allow paste and password managers; no puzzles without an alternative (WCAG 3.3.8); show/hide password instead of a confirm field.

## Common mistakes
| Mistake | Fix |
|---|---|
| Multi-column long form | Single column |
| Unnamed "Step 2 of 5" | Named steps |
| Error on first keystroke | Validate on blur |
| Error stays after fixing | Clear on valid input |
| Red fields, no summary | Linked error summary |
| Address asked twice | Prefill or "same as" |
| Paste blocked in passwords | Allow paste and managers |
| Data lost on Back | Keep state per step |

Sources: GOV.UK Design System (question pages, error summary, check answers), Baymard form research, NN/g, Luke Wroblewski "Web Form Design", WCAG 2.2 (3.3.7, 3.3.8), nextlevelbuilder/ui-ux-pro-max-skill.
