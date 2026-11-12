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
1. Naming: if the existing branches follow their own style, follow it. Otherwise use the Git Flow convention from the git rules:
   - `feature/<name>` (new functionality) or `bugfix/<name>` (fix for unreleased code): base `develop`.
   - `release/X.Y.Z`: base `develop`.
   - `hotfix/<name>` or `hotfix/X.Y.Z` (urgent fix of released code): base `main`.
   - `<name>` is a task id, a lowercase kebab-case description or both: `1234`, `PROJ-123`, `discount-validation`, `PROJ-123-discount-validation`. If the user gave a task number, use it.
   If the type is not clear from the request, ask.
2. If the name already exists locally or on the remote, stop and tell the user.
3. Base: the one the user named; otherwise the Git Flow base above (`develop` must exist; if it does not, say so and ask). In repos with their own style, base on the current branch. State which base was used.
4. If there are uncommitted changes, mention that they come along to the new branch.
5. Create it with `git switch -c` and confirm in one line.

Reply following the global communication rules.
