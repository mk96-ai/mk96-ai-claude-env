---
description: Fetch from the remote and summarize what is new (does not change your files)
allowed-tools: Bash(git fetch:*), Bash(git status:*), Bash(git branch:*), Bash(git log:*)
---

Fetch from the remote and tell the user what changed there. Fetch never touches the working files or the current branch.

Remote or extra instructions (optional): $ARGUMENTS

Steps:
1. Run `git fetch --all --prune`.
2. Summarize in plain words:
   - New branches on the remote.
   - Branches that were updated, with the number of new commits and the latest subject.
   - Branches deleted on the remote.
3. For the current branch: how many commits it is behind or ahead of its remote, and whether a `git pull` would be clean (fast-forward) or the branches have diverged.
4. Suggest `/git_pull` only if the current branch is behind.

Reply following the global communication rules.
