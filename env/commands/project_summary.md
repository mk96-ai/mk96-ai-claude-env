---
description: Plain-language summary of the whole project (purpose, structure, state). Read-only
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(git ls-files:*)
---

Explain the project to the project manager: technical knowledge and context of the app, but did not write the code. Read-only.

Focus (optional): $ARGUMENTS

Sources: README, docs, manifests (package.json, pom.xml, pyproject, etc.), folder structure, entry points, recent git history.

Output, short and schematic:
1. **What it is**: purpose of the app in two or three lines.
2. **Main parts**: modules or components, each with one line saying what it is responsible for. Never name a class, function or file without saying what it does.
3. **How it is built**: languages, frameworks, database, external services.
4. **How it runs and is tested**: main commands, only if found in the project.
5. **Current state**: recent activity, open `TODO` or `FIXME`, anything that looks unfinished. Mark guesses as guesses.

Reply following the global communication rules.
