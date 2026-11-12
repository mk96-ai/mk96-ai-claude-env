---
description: Explain and resolve merge or rebase conflicts file by file (asks before applying)
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git show:*), Bash(git branch:*)
---

Help resolve the conflicts of an ongoing merge, rebase, pull or stash pop.

Extra instructions (optional): $ARGUMENTS

Context:
- Status: !`git status`
- Conflicted files: !`git diff --name-only --diff-filter=U`

Steps:
1. If there are no conflicts, say so and stop.
2. For each conflicted file, explain in plain words what each side did and why they collide (use `git log` on both sides to understand intent). Do not just paste the markers.
3. Propose a resolution per file: keep one side, keep both, or a combination. Mark the recommendation and any guess. If the right choice depends on a business decision, ask the user.
4. Apply a resolution only after the user confirms it. Resolve the file so no conflict markers are left, and keep the code consistent (it should still make sense and compile).
5. After resolving files, stage them with `git add <file>`. Do NOT finish the merge or rebase, and do not commit, unless the user asks. Tell the user what is left.
6. Never discard one side silently, and never use `--ours` or `--theirs` on whole files without saying what will be lost.

Reply following the global communication rules.
