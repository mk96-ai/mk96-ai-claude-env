---
description: Create a new branch and switch to it, following the repo's naming style
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git log:*), Bash(git switch:*)
---

Create a new branch and switch to it. The user asked for this explicitly.

Name and optional base branch (if the name is empty, ask for what the branch is for and propose a name): $ARGUMENTS

Context:
- Current branch: !`git branch --show-current`
- Existing branches (naming style reference): !`git branch --all --list`
- Status: !`git status --short`

Steps:
1. Follow the naming style of the existing branches (prefixes such as `feature/`, `fix/`, separators, language). Use lowercase words separated by hyphens if there is no clear style.
2. If the name already exists locally or on the remote, stop and tell the user.
3. Base the branch on the current one unless the user named another base. State which base was used.
4. If there are uncommitted changes, mention that they come along to the new branch.
5. Create it with `git switch -c` and confirm in one line.

Reply following the global communication rules.
