---
description: Review the test suite of the whole project (value, gaps, redundant tests). Read-only
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(git ls-files:*)
---

Review the test suite of the whole project. Read-only: do not delete, edit or run anything destructive.

Focus, folder or extra instructions (optional): $ARGUMENTS

Steps:
1. Map the tests: where they live, framework, how they are organized, which parts of the code they cover.
2. Find the most important behaviors and risks of the project (business rules, data handling, integrations) and check whether they are protected.
3. Look for tests that are trivial, redundant, overlapping or that only mirror the implementation, and for fragile tests tied to implementation details.
4. Report: critical gaps (most important first), tests worth merging or removing and why, and general health of the suite. Maximum 10 findings; offer the rest on request.
5. Do not delete anything. Ask the user to confirm before any removal.

Reply following the global communication rules.
