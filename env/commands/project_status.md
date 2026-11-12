---
description: Quick snapshot of the project state (branch, changes, tests touched, open TODOs). Read-only
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git grep:*)
---

Give a quick snapshot of where the project stands. Read-only: do not modify anything and do not run tests unless the user asks: $ARGUMENTS

Context:
- Branch and sync: !`git status --short --branch`
- Last commits: !`git log --oneline -5`

Output, short and schematic:
1. **Branch**: name, and whether it is ahead of or behind its remote.
2. **Uncommitted work**: files changed, each with a plain-words note of what it is.
3. **Tests**: changed source files that have no test changed with them.
4. **Open TODO and FIXME**: count, plus the most relevant ones with their reason.
5. **Next step**: the single most sensible action (commit, push, review, fix).

Reply following the global communication rules.
