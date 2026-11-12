---
description: Plain-language summary of the latest changes (what, where, why, risk)
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git show:*)
---

Summarize the latest changes for the project manager: technical knowledge and context of the app, but did not write the code. Read-only.

Scope: the uncommitted changes (staged, unstaged and untracked files). If there are none, the last commit. If the user gives something else, use that: $ARGUMENTS

Output, short and schematic:
1. **What changed**: a few bullets in plain words.
2. **Where**: files or modules touched, each with one line saying what it is and what changed. Never name a function, class or variable without saying what it does.
3. **Why**: the purpose. Mark as a guess anything inferred and not stated.
4. **Risk**: what could break, and what is not covered by tests.
5. **What to review or decide**: points that need the user's attention.

Reply following the global communication rules.
