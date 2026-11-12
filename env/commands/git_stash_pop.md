---
description: Bring back stashed work (lists the stashes first)
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git stash:*), Bash(git diff:*)
---

Restore work saved with a stash. The user asked for this explicitly.

Which stash (optional: number or label; default the most recent): $ARGUMENTS

Context:
- Stashes: !`git stash list`
- Status: !`git status --short`

Steps:
1. If there are no stashes, say so and stop. If there are several and the user did not choose, list them in plain words (label, branch, age) and ask which one.
2. If the working folder has uncommitted changes that overlap with the stash, warn the user and ask before continuing.
3. Show what the stash contains (`git stash show --stat`), then restore it with `git stash pop`.
4. If a conflict appears, the stash is kept by git: tell the user and point to `/git_conflicts`.
5. Confirm what was restored and whether the stash was removed.

Reply following the global communication rules.
