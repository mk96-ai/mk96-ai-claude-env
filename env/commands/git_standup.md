---
description: What you did yesterday or this week, from your commits and open work, ready for a standup. Read-only
allowed-tools: Bash(git log:*), Bash(git status:*), Bash(git branch:*), Bash(git config --get:*), Bash(git diff:*)
---

Summarize the user's recent work for a standup. Read-only.

Period (optional: "yesterday", "week", a date, or a number of days; default the last working day): $ARGUMENTS

Context:
- Current branch: !`git branch --show-current`
- Author: !`git config --get user.email`
- Uncommitted work: !`git status --short`

Steps:
1. Read the commits of the author across all local branches in the period (`git log --all --author=<email> --since=...`). If the email returns nothing, say so and ask which author to use.
2. Group commits that belong to the same piece of work.
3. Output, short and schematic:
   - **Done**: what was finished, one plain line each. Do not repeat cryptic commit subjects; explain them.
   - **In progress**: uncommitted changes and local commits not pushed yet, with their branch.
   - **Next**: the most natural next steps. Mark them as a suggestion, not as facts.
4. Do not invent blockers. If nothing looks blocked, say so.

Reply following the global communication rules.
