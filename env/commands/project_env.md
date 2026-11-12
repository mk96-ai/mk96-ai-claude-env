---
description: List the configuration and environment variables the project needs and which are documented or unset. Never reads or shows values
allowed-tools: Bash(git grep:*), Bash(git ls-files:*), Bash(git log:*)
---

Find out what configuration the project needs to run. Read-only: never read, open or show the contents of `.env` files or any secret value.

Focus (optional: a module or an environment such as production): $ARGUMENTS

Steps:
1. Find the environment variables and configuration keys the code reads (`process.env`, `os.environ`, `System.getenv`, framework placeholders in properties or config files, and similar), with the file where each one is used.
2. Compare with what is documented: README, docs, and example files such as `.env.example` (these are safe to read). Do not open real `.env` files.
3. Check which names are set in the current shell, only as set or unset (for example with `[ -n "${NAME+x}" ]`), never printing values. If the real values live in `.env`, say you cannot verify them and ask the user to check.
4. Output, short and schematic: a table with name, what it is for in plain words, whether it is required or has a default, whether it is documented, and whether it is set in this shell.
5. Highlight: required and undocumented, documented but never used, and any that look like secrets (mark them so they are never logged or committed).

Reply following the global communication rules.
