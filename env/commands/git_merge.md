---
description: Merge another branch into the current one (stops and explains on conflicts)
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git fetch:*), Bash(git log:*), Bash(git diff:*), Bash(git merge:*)
---

Merge another branch into the current one. The user asked for this explicitly.

Branch to merge in (if empty, ask which one): $ARGUMENTS

Context:
- Current branch: !`git branch --show-current`
- Status: !`git status --short`

Steps:
1. If the current branch is `main` or `master`, say so and ask before continuing.
2. If there are uncommitted changes, ask what to do before merging. Do not merge on top of them without the user's agreement.
3. Show what will come in: commits (count and subjects) and the files most affected.
4. Merge with `git merge <branch>`. Never force and never discard anything.
5. If there are conflicts, stop, list the conflicted files and point to `/git_conflicts`. Do not resolve them here.
6. If the merge is clean, confirm what happened. Do not push.

Reply following the global communication rules.
