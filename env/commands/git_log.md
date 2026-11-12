---
description: Show recent history in plain language (optionally by number, author, file or branch). Read-only
allowed-tools: Bash(git log:*), Bash(git show:*), Bash(git branch:*), Bash(git status:*)
---

Show the recent history of the repository in a way the project manager can follow. Read-only.

What to show (optional: a number of commits, an author, a file or folder, or a branch; default the last 15 commits of the current branch): $ARGUMENTS

Steps:
1. Read the history with `git log` (use `--stat` or `--oneline --graph` as needed).
2. Present it as a table: date, author, plain-words summary of what the commit did, and the area it touched. Do not just repeat commit subjects if they are cryptic; explain them.
3. Group related consecutive commits into one line when they belong to the same piece of work.
4. Close with one line on the overall direction of the recent work.

Reply following the global communication rules.
