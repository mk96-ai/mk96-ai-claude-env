---
description: Scan the current project to gather context before working on it (stack, structure, conventions, commands). Brief output by default, full report with --full. Read-only
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(git ls-files:*), Bash(git branch:*)
---

Scan the project in the current directory to build the context needed to work on it well. Read-only: do not modify anything and do not run builds or tests.

Arguments (optional): $ARGUMENTS
- No `--full` (default, brief mode): the scan is for Claude's own context, so the user does not want to read a report.
- `--full`: the user wants to read about the project, so give the full context map.
- Any other text is extra instructions for the scan, in both modes.

Always scan everything below, in both modes, and keep the full context in mind for the rest of the session:
- Project instructions: any `CLAUDE.md`, README, contributing or docs files.
- Stack: manifests and config files (package.json, pom.xml, build.gradle, pyproject, requirements, Dockerfile, CI files).
- Structure: main folders, entry points, where tests live.
- Conventions the repo already follows: naming, layering, error handling, logging library and style, test framework, formatter and linter.
- Commands to build, test, lint and run, only if found.
- Git: current branch, recent commit style, activity.
- Kind of code per area (production app, scripts, prototype, config), since the user's practices depend on it.

Output in brief mode (default), nothing more than:
1. One line: project scanned, context saved, plus the stack in a few words.
2. A very simple tree of the main folders (max two levels, max 15 lines), each with a few words on what it holds.
3. Only if a rule from the user's global instructions conflicts with what the project already does: one extra line saying which.

Output in full mode (`--full`), short and schematic: a context map with those points, what could not be determined, and any rule from the user's global instructions that conflicts with what the project already does.

Reply following the global communication rules.
