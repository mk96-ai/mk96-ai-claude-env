---
description: Before changing something, map what it would affect (files, callers, tests, config, docs). Read-only
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(git ls-files:*), Bash(git grep:*)
---

Analyze the impact of a planned change. Read-only: do not modify anything, only investigate.

Planned change: $ARGUMENTS

If no change was described, ask for it in one line and stop.

Steps:
1. Find the code that implements what will change, then everything that depends on it: callers, subclasses or implementations, imports, configuration, database or API contracts, scheduled jobs.
2. Find the tests that cover it and the documentation that mentions it (README, docs, docstrings, config or properties files).
3. Output a schema of what is affected, grouped by repo, module or class, and file. Each entry gets one plain-words line saying what it is and how it is affected.
4. Close with: risk level (low, medium, high) and why, what would need new or updated tests, and a suggested order to apply the change.

Reply following the global communication rules.
