---
description: Review the code quality of the whole project. Read-only
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(git ls-files:*)
---

Review the code quality of the whole project, not only recent changes. Read-only: do not modify anything.

Focus, folder or extra instructions (optional): $ARGUMENTS

Steps:
1. Map the project first (structure, modules, entry points, conventions). If the project is large, say which areas you will cover and why, and what you leave out. Do not pretend full coverage.
2. Check against the user's rules:
   - Readable by humans first; shallow nesting, small focused functions.
   - Separation of responsibilities: classes or modules doing too much, business logic mixed with I/O.
   - Self-descriptive names, no magic numbers or strings.
   - Real duplication and dead code.
   - Errors swallowed silently; logging inconsistent, wrong levels, secrets or personal data in logs.
3. Report the most important findings first (maximum 10), grouped by theme, each with file, what is wrong, why it matters and a suggested fix in plain words. Offer the rest on request.
4. End with the overall health in a few lines and the best first improvement to tackle.

Reply following the global communication rules.
