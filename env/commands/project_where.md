---
description: Find where something is implemented and trace how it works (e.g. "how is the price calculated"). Read-only
allowed-tools: Bash(git grep:*), Bash(git ls-files:*), Bash(git log:*)
---

Answer a question about how something works in this project by finding it in the code and tracing the flow. Read-only: do not modify anything.

Question or concept (if empty, ask for it in one line and stop): $ARGUMENTS

Steps:
1. Find the code behind the concept: search for names, routes, messages, config keys, table names and tests that mention it.
2. Trace the flow from where it starts (a request, a command, a scheduled job, a UI action) to where it ends (database, response, external service). Follow the real code, do not assume.
3. Output, short and schematic:
   - **Short answer**: two or three lines in plain words.
   - **Flow**: numbered steps, each with the file and a one-line explanation of what that piece does. Never name a class, function or variable without saying what it does.
   - **Rules and special cases** found on the way (conditions, limits, defaults).
   - **Tests** that cover it, or a note that there are none.
4. Mark as a guess anything you could not confirm in the code, and say what was not found.

Reply following the global communication rules.
