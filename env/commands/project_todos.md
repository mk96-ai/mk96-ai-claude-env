---
description: List all TODO and FIXME comments grouped by area, with their reason and age. Read-only
allowed-tools: Bash(git grep:*), Bash(git blame:*), Bash(git log:*), Bash(git ls-files:*)
---

Collect the pending notes left in the code. Read-only: do not modify anything.

Focus (optional: a folder or a keyword): $ARGUMENTS

Steps:
1. Search tracked files for `TODO`, `FIXME`, `HACK` and `XXX` (`git grep -n`).
2. For each one, read the surrounding code to understand what it refers to, and use `git blame` to find when it was added.
3. Output, short and schematic:
   - **Count** by type and by area.
   - **Grouped by theme or module**: file and line, what is pending in plain words (never name a function or class without saying what it does), the reason if it has one, and its age.
   - **Without a reason**: notes that do not follow the `TODO(reason)` convention, listed separately.
   - **Old or probably stale**: notes whose work looks already done or no longer applicable. Do not remove them.
4. Highlight the few that look most important or risky, and why.

Reply following the global communication rules.
