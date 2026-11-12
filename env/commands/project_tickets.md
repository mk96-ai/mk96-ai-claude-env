---
description: Split a feature or idea into small tickets with acceptance criteria. Read-only
allowed-tools: Bash(git ls-files:*), Bash(git grep:*), Bash(git log:*)
---

Turn a feature or idea into tickets a developer can pick up. Read-only: do not create files or tickets in any tool.

Feature or idea (if empty, ask for it in one line and stop): $ARGUMENTS

Steps:
1. Look at the real code first so the tickets match what exists: related modules, similar features, tests.
2. If something important is ambiguous (scope, rules, who it is for), ask the user up to three short questions before writing the tickets.
3. Split the work into small tickets that can be delivered and verified on their own. Order them so each one can be done with what the previous ones provide.
4. For each ticket give:
   - **Title**: short, in action form.
   - **Description**: what and why, in plain words, in two or three lines.
   - **Acceptance criteria**: a checklist that can be verified.
   - **Where it touches**: modules or areas, each with a one-line explanation.
   - **Depends on**: other tickets, if any.
   - **Size**: S, M or L. Mark it as an estimate.
5. End with the suggested order, the main risks or open decisions for the user, and what was left out of scope on purpose.

Reply following the global communication rules.
