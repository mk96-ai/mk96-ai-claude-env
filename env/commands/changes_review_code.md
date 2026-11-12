---
description: Review the code quality of the current changes (uncommitted work). Read-only
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*)
---

Review the code quality of the current changes only (staged, unstaged and untracked files; if there are none, the last commit). Read-only: do not modify anything.

Focus or extra instructions (optional): $ARGUMENTS

Steps:
1. Read the diff and the surrounding code of each changed file, so findings are based on how the repo already does things.
2. Check the changes against the user's rules:
   - Readable by humans first; shallow nesting, small focused functions.
   - Separation of responsibilities: business logic apart from I/O.
   - Self-descriptive names, booleans that read as questions, no magic numbers or strings.
   - No real duplication, no speculative abstractions, no unrelated refactors (surgical changes).
   - Errors never swallowed silently; logging with the right level, no secrets or personal data, no `print` in production code.
   - Practices adapted to the kind of code (production, script, prototype, config).
3. Report, ordered by severity, each with file and line, what is wrong, why it matters and a suggested fix in plain words. Include one line on what is done well.

Reply following the global communication rules.
