---
description: Create a pull request for the current branch with a clear description
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git remote:*), Bash(git push:*), Bash(gh pr:*), Bash(gh repo:*)
---

Create a pull request for the current branch. The user asked for it explicitly.

Context:
- Branch: !`git branch --show-current`
- Status: !`git status --short --branch`

Steps:
1. If the branch is `main`, `master` or `develop`, stop and tell the user a PR needs a topic branch.
2. If there are uncommitted changes, mention it and ask whether to continue without them.
3. Base branch: the one the user named; otherwise, by Git Flow prefix: `feature/` and `bugfix/` → `develop`; `release/` and `hotfix/` → `main`, and tell the user it must also be merged back into `develop` afterwards. Other branches → the repository default. Review all commits and the full diff between base and HEAD, not only the last commit.
4. If the branch is not on the remote yet, push it (`git push -u origin <branch>`). Never force push.
5. Write the PR in English:
   - Title: short, focused on the result.
   - Body: what changed, why, how it was verified, and risks or points the reviewer should check.
   - End the body with the PR attribution line given in the session instructions, if any.
6. Show the title and body, then create the PR with `gh pr create`. Return the PR URL.

Extra instructions from the user (optional, e.g. base branch or draft): $ARGUMENTS

Reply following the global communication rules.
