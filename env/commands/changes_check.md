---
description: Pre-commit check of the current changes (lint, tests, build, leftovers) with a ready or not-ready verdict
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git ls-files:*), Bash(git grep:*)
---

Check that the current changes are ready to be committed. Do not fix anything and do not commit.

Extra instructions (optional): $ARGUMENTS

Steps:
1. Find the project commands for formatting or lint checks, type checks, build or compile, and tests (package scripts, build files, CI configuration, README). Say which ones you found and which are missing; do not invent commands.
2. Run them, tests included. If the full suite is very long, run the tests related to the changed files and say so.
3. Scan the diff for leftovers:
   - Debug prints or `console.log`, commented-out code, forgotten breakpoints.
   - Secrets or `.env` files staged. If found, warn without repeating the value.
   - New `TODO` or `FIXME` without a reason.
   - Unrelated changes mixed in, and files that should not be committed (build output, logs, temporary files).
4. Output, short and schematic: a table with each check and its result (ok, failed, not available), then the verdict **ready to commit** or **not ready** with the exact list of reasons, each explained in plain words.
5. If it is ready, suggest `/git_commit`.

Reply following the global communication rules.
