---
description: Investigate an error or log to find the root cause before proposing any fix
allowed-tools: Bash(git log:*), Bash(git diff:*), Bash(git blame:*), Bash(git grep:*), Bash(git ls-files:*), Bash(git status:*)
---

Find the real cause of a problem. Follow the systematic debugging method (use the systematic-debugging skill if available). Do not change any code in this command.

Error message, stack trace, log file path or symptom description (if empty, ask for it in one line and stop): $ARGUMENTS

Steps:
1. Read the evidence completely first: the full error, stack trace and surrounding log lines. If a file path was given, read it.
2. Locate the failing code and understand what it expected versus what happened. Check recent commits touching it (`git log`, `git blame`), since many failures come from a recent change.
3. List the plausible causes, then confirm or discard each one with evidence from the code or logs. Do not stop at the first guess.
4. Only run commands that are safe and read-only. Ask before running anything that changes data, calls external services or may have side effects.
5. Output, short and schematic:
   - **Cause**: what is going wrong, in plain words, and where (file and line, each name explained).
   - **Evidence**: what confirms it.
   - **Why now**: what changed or which condition triggers it, if found.
   - **Proposed fix**: what would change and what it affects. Do not apply it.
   - **How to verify**: a test or check that proves the fix works.
6. State your confidence. If the cause is not confirmed, say what is missing and how to get it.

Reply following the global communication rules.
