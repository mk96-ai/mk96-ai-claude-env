---
description: Security review of the current changes (uncommitted work). Read-only
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*)
---

Review the security of the current changes only (staged, unstaged and untracked files; if there are none, the last commit). Read-only: do not modify anything.

Focus or extra instructions (optional): $ARGUMENTS

Steps:
1. Read the diff and trace how external input (requests, files, user data) flows through the changed code.
2. Look for: secrets in code, comments, config or logs; unvalidated external input; SQL or commands built by string concatenation; injection (SQL, command, template, path traversal); missing authentication or authorization checks; unsafe deserialization; sensitive data in logs or error messages; new dependencies or risky version changes.
3. If a secret is found, warn the user without repeating its value.
4. Report each finding by severity with file and line, how it could be abused (in plain words), and the suggested fix. If nothing is found, say what was checked and what was out of reach.

Reply following the global communication rules.
