---
description: Delete local branches that are already merged or whose remote was deleted (asks before deleting)
allowed-tools: Bash(git branch --list:*), Bash(git branch -vv:*), Bash(git branch --merged:*), Bash(git branch --show-current:*), Bash(git fetch:*), Bash(git log:*), Bash(git status:*)
---

Clean up old local branches. Deleting branches is hard to undo, so propose first and wait for confirmation.

Extra instructions (optional): $ARGUMENTS

Steps:
1. Run `git fetch --prune`, then find the main branch (`main` or `master`).
2. Build two lists of local branches:
   - Merged into the main branch.
   - Remote deleted (`gone`) but not detected as merged (for example squash merges). For each one, show commits that exist only on that branch, because deleting it would lose them.
3. Never include: `main`, `master`, `develop`, the current branch, or any branch with commits not on any remote or in the main branch without saying so clearly.
4. Show both lists as a table (branch, last commit date, why it is a candidate, commits that would be lost, if any). Ask the user which ones to delete and wait.
5. Delete confirmed merged branches with `git branch -d`. For branches with unmerged commits, use `-D` only after the user confirms again, naming the commits that will be lost.
6. Report what was deleted. Do not touch remote branches.

Reply following the global communication rules.
