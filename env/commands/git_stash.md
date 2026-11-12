---
description: Save uncommitted work temporarily (stash) with a clear label
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git stash:*)
---

Put the uncommitted work aside temporarily so the working folder is clean. The user asked for this explicitly.

Label for the stash (optional; if empty, build one from the branch and the main files): $ARGUMENTS

Context:
- Branch: !`git branch --show-current`
- Status: !`git status --short`

Steps:
1. If there is nothing to stash, say so and stop.
2. List what will be saved. Untracked files are included (`git stash push -u`); mention it if there are any. Ignored files are not included.
3. Stash with a descriptive message in English: `git stash push -u -m "<label>"`.
4. Confirm the stash name and that the working folder is clean. Remind that `/git_stash_pop` brings the work back.

Reply following the global communication rules.
