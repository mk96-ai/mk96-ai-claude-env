---
description: Pull the current branch safely (fast-forward only; explains if it diverged)
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git fetch:*), Bash(git log:*), Bash(git diff:*), Bash(git pull:*)
---

Update the current branch from its remote. The user asked for this explicitly.

Extra instructions (optional): $ARGUMENTS

Context:
- Branch: !`git branch --show-current`
- Status: !`git status --short --branch`

Steps:
1. If there are uncommitted changes, tell the user which files and whether the incoming changes touch them. Ask before continuing if they overlap.
2. Fetch, then show the incoming commits (count and subjects) before pulling.
3. Pull with `git pull --ff-only`.
4. If the branches diverged and the pull is refused, explain in plain words what happened (local and remote both have new commits) and offer the options: merge or rebase. Do not choose silently, and never force anything.
5. If a conflict appears, stop and point to `/git_conflicts`.
6. Confirm in a few lines: what came in, and files most affected.

Reply following the global communication rules.
