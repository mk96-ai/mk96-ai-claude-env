---
description: Security review of the whole project. Read-only
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(git ls-files:*)
---

Review the security of the whole project. Read-only: do not modify anything.

Focus, folder or extra instructions (optional): $ARGUMENTS

Steps:
1. Map the entry points where external input arrives (HTTP endpoints, CLI arguments, files, queues, database content) and where secrets and configuration are handled.
2. Look for: secrets in code, config, comments, logs or git-tracked files (including `.env`); unvalidated external input; SQL or commands built by string concatenation; injection (SQL, command, template, path traversal); missing authentication or authorization checks; unsafe deserialization; sensitive data in logs; outdated or risky dependencies.
3. If a secret is found, warn the user without repeating its value.
4. Report findings by severity (maximum 10), each with file, how it could be abused in plain words, and the suggested fix. Say what was checked and what was out of reach. Offer the rest on request.

Reply following the global communication rules.
