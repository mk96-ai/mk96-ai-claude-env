---
description: Analyze and fix one of the user's custom commands (explains it, judges the request, proposes the change and applies it after confirmation)
allowed-tools: Bash(ls:*), Bash(find:*), Read, Glob, Grep
---

Improve or fix one custom command (slash command) of the user. The user wrote these commands but has not tested them yet, and reports problems one by one. This command edits files, so propose first and wait for confirmation.

Input: $ARGUMENTS
Format: `<command name> [what to fix and how]`. The first word is the command name (with or without the leading `/`). Everything after it is the explanation, free text, and may be empty.

Phase 1 - Locate and read (read-only)
- Find the command file: `~/.claude/commands/<name>.md` first, then `.claude/commands/<name>.md` in the current project. If it does not exist, list the closest names and ask; do not guess.
- Read it fully. Also read one or two sibling commands in the same folder to know the conventions (frontmatter, tone, closing line).
- If the name is missing, ask for it and stop.

Phase 2 - Analyze (nothing is edited yet)
Show these parts, in this order:
1. **What the command does today**: a few plain lines (purpose, steps, which tools it can use, whether it edits files or is read-only).
2. **Is the request sensible?** Answer yes, partly or no, with the reason. If the explanation is empty, review the command itself and list the real problems you find (contradictions, steps that need a tool missing in `allowed-tools`, rules from the global CLAUDE.md it breaks, ambiguity, missing confirmation before risky actions); do not invent problems.
3. **Can it be done?** A command is only a prompt plus allowed tools. Say clearly if the request needs something a command cannot do (changing Claude Code itself, a hook, a setting, a permanent rule); in that case propose the right mechanism instead (hook, settings, CLAUDE.md, skill).
4. **How I would fix it**: the concrete changes, each in one line with the reason. If there are several ways, present them with a recommendation; if something is ambiguous, ask instead of choosing.
5. **What the command will do after the change**: a short summary, written as the new behavior and not as the list of edits.
6. **Diff**: the exact proposed edit, with the file path.

Then ask for confirmation and stop. Accept answers such as "apply", "apply but without X" or new instructions (in that case go back to the analysis).

Phase 3 - Apply (only after confirmation)
- Edit only the confirmed lines of that command file. Do not touch other commands, even if you notice problems in them: mention them in one line at the end.
- Keep the file consistent: `allowed-tools` must cover every tool its steps use, `description` must match the new behavior, instructions in English, same structure as the sibling commands.
- Never run the command being fixed to test it, and do not create new commands or dependencies without asking.
- Check the result: read the file again, confirm the frontmatter is valid and no step contradicts another. Say plainly that the command has not been run, so behavior is reviewed but not tested.

Reply following the global communication rules.
