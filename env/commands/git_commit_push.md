---
description: Commit the current changes and push the branch
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git remote:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*)
---

Commit the current changes and then push the branch. The user asked for both actions explicitly.

Context:
- Branch: !`git branch --show-current`
- Status: !`git status --short --branch`
- Recent commits (style reference): !`git log --oneline -10`

Steps:
1. If the branch is `main` or `master`, stop and ask the user before continuing.
2. Read the diff (`git diff HEAD`) and understand what changed and why.
3. If the diff contains a secret (key, token, password, connection string), stop and warn the user without repeating it. Never stage `.env` files or similar.
4. Stage only the files that belong to this change. Tell the user which unrelated files were left out.
5. Write the commit message in English, following the style of the recent commits. Short subject line focused on the why; add a body only if the change is not obvious. Follow the commit attribution instructions of the session, if any.
6. Show the staged files and the final message, then create the commit. Never use `--no-verify` or amend existing commits.
7. Push the branch (`git push -u origin <branch>` if it has no upstream). Never force push. If the push is rejected, explain why and ask what to do.
8. Final answer: commit message, files included, and where it was pushed.

Extra instructions from the user (optional): $ARGUMENTS

Reply following the global communication rules.
