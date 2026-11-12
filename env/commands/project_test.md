---
description: Run the project tests and explain the result in plain words (what fails and why). Does not fix anything
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git ls-files:*)
---

Run the tests of the project and explain the result to the project manager. Do not modify code or tests.

Scope (optional: a folder, a file or a name filter; default the whole suite): $ARGUMENTS

Steps:
1. Find how the project runs its tests (package scripts, build files, test framework configuration, README). If it is unclear, say what you found and ask before guessing a command.
2. Run them. If the suite is very long, tell the user before starting.
3. Output, short and schematic:
   - **Result**: passed, failed and skipped counts, and the run time.
   - **For each failure**: what the test checks in plain words, what went wrong, and whether the probable cause is the code or the test. Say whether it relates to the files currently changed (compare with `git status`). Never name a test or function without saying what it checks.
   - **Skipped or flaky tests** worth knowing about.
4. If a test was failing before the current changes, say so and do not fix it silently.
5. Do not propose fixes unless asked. Mention `/debug_error` for a deeper investigation of a failure.

Reply following the global communication rules.
