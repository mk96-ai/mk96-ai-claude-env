---
description: Write the missing tests for the current changes (proposes the cases first, then writes them after confirmation)
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git ls-files:*)
---

Add tests for the current changes (staged, unstaged and untracked files; if there are none, the last commit). This command edits files, so propose first and wait for confirmation.

Focus or extra instructions (optional): $ARGUMENTS

Steps:
1. Classify the kind of code changed (production app, script, prototype, config). If it is a one-off script or a prototype, say that tests are usually not needed and ask whether to continue.
2. Read the existing tests of the project: framework, folder layout, naming, helpers and fixtures. Match them exactly and reuse what exists.
3. Find which changed behaviors have no test, including important edge cases and error paths.
4. Propose the list of tests before writing anything. For each: file, test name in plain words, what behavior or risk it protects. Include only tests that protect a real behavior or risk: no trivial, redundant or implementation-mirroring tests. Wait for the user's confirmation.
5. After confirmation, write the tests. Test behavior, not implementation. Comments and names in English.
6. Run them and report the result. If a new test fails, find out whether the code or the test is wrong and tell the user; do not change production code without asking.
7. Do not commit. Show the final diff of the tests.

Reply following the global communication rules.
