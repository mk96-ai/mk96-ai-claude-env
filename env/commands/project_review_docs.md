---
description: Review comments and documentation of the whole project for outdated or missing parts. Read-only
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(git ls-files:*)
---

Review comments and documentation of the whole project. Read-only: do not modify anything.

Focus, folder or extra instructions (optional): $ARGUMENTS

Steps:
1. Read the README, docs folder, config or properties files and examples, then compare them with what the code really does (commands, paths, settings, setup steps).
2. Sample the code for comment quality against the user's rules: written in English, explain why and not what, not excessive, public functions and classes with docstrings, `TODO(reason)` or `FIXME(reason)` with a reason.
3. Report: outdated or wrong documentation (most important first), missing documentation a new developer would need, and comment excess or noise. Maximum 10 findings; offer the rest on request.
4. If the project is large, say which areas were covered.

Reply following the global communication rules.
