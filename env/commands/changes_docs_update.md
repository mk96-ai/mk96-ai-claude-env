---
description: Fix outdated comments, docstrings and docs affected by the current changes (shows the edits first, applies after confirmation)
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git ls-files:*), Bash(git grep:*)
---

Update the documentation that the current changes left outdated (staged, unstaged and untracked files; if there are none, the last commit). This command edits files, so propose first and wait for confirmation.

Focus or extra instructions (optional): $ARGUMENTS

Steps:
1. For each changed function or class, compare its docstring and nearby comments with the new behavior. Look for related documentation that mentions it: README, docs folder, config or properties files, examples, changelog.
2. Prepare the edits following the user's rules: comments and docs in English, explain why and not what, do not over-comment, docstrings for public functions and classes, `TODO(reason)` or `FIXME(reason)` for known limitations. Delete a comment instead of rewriting it when it only restates the code.
3. Show every proposed edit as a short diff with the file path and a one-line reason. Wait for the user's confirmation.
4. After confirmation, apply only the confirmed edits. Do not touch code, and do not reformat or rewrite documentation that is still correct.
5. Do not commit. Report what was updated and anything that needs a decision from the user.

Reply following the global communication rules.
