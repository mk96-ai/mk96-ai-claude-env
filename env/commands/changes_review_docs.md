---
description: Check that comments, docstrings and docs affected by the current changes are not outdated. Read-only
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*)
---

Review comments and documentation related to the current changes only (staged, unstaged and untracked files; if there are none, the last commit). Read-only: do not modify anything.

Focus or extra instructions (optional): $ARGUMENTS

Steps:
1. For each changed function or class, read its docstring and the comments around it. Check they still match the new behavior.
2. Look for related documentation that may now be outdated: README, docs folder, config or properties files, examples, changelog.
3. Check comment quality against the user's rules: written in English, explain why and not what, not excessive, no comment that restates the code. Public functions and classes have docstrings; known limitations are marked `TODO(reason)` or `FIXME(reason)`.
4. Report each finding with file and line, what is outdated or missing, and the suggested fix in plain words. Group them as: outdated (must fix), missing, excess.

Reply following the global communication rules.
