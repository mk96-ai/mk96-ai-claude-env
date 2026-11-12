---
description: Undo the last commit keeping the changes (only if it was not pushed)
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git log:*), Bash(git show:*)
---

Undo the last commit but keep all its changes staged, so they can be committed again. The user asked for this explicitly.

Extra instructions (optional): $ARGUMENTS

Context:
- Branch and sync: !`git status --short --branch`
- Last commits: !`git log --oneline -3`

Steps:
1. Show the last commit (hash, message, files).
2. Check whether it was already pushed (`git branch -r --contains HEAD`). If it was, do NOT rewrite history: explain why and offer `git revert` instead, then wait.
3. Never use `--hard`. Only `git reset --soft HEAD~1`, so the work is not lost.
4. After the reset, confirm that the changes are staged and the commit is gone. Tell the user how to recover the old commit if needed (`git reflog`).

Reply following the global communication rules.
