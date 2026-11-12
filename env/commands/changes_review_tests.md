---
description: Review the tests added or touched by the current changes and propose which to keep, merge or delete. Read-only
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*)
---

Review the tests related to the current changes only (staged, unstaged and untracked files; if there are none, the last commit). Read-only: do not delete or edit anything.

Focus or extra instructions (optional): $ARGUMENTS

Steps:
1. Identify the tests added or modified, and the production code they protect.
2. For each test decide: keep, merge or delete. A test is worth keeping only if it protects a real behavior or a real risk. Flag tests that are trivial, redundant, overlapping, or that only mirror the implementation.
3. Check what is missing: changed behavior with no test, important edge cases or error paths. Take into account the kind of code (production code needs tests; one-off scripts and prototypes usually do not).
4. Report as a table: test, verdict, reason in plain words. Then list missing tests.
5. Do not delete anything. Ask the user to confirm which tests to remove or merge.

Reply following the global communication rules.
