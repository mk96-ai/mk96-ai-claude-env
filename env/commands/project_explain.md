---
description: Explain a file, function or class in plain language for someone who did not write it. Read-only
allowed-tools: Bash(git grep:*), Bash(git ls-files:*), Bash(git log:*)
---

Explain a piece of code to the project manager: technical knowledge and context of the app, but did not write the code. Read-only.

What to explain (file path, function or class name; if empty, ask for it in one line and stop): $ARGUMENTS

Steps:
1. Read the code and the places that use it, so the explanation reflects real usage.
2. Output, short and schematic:
   - **What it is for**: its job in the app, in two or three lines.
   - **How it works**: the main steps in plain words, in order. Do not read the code line by line.
   - **What goes in and what comes out**, including side effects (database, files, calls to other services).
   - **Who uses it**: the main callers.
   - **Watch out**: special cases, limitations, anything surprising or fragile.
3. Never name a variable, function or class without saying what it is or does. Mark guesses as guesses.

Reply following the global communication rules.
