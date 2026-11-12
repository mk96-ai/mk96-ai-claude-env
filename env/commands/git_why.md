---
description: Explain why a file or function is the way it is (who changed it, when and why), from git history. Read-only
allowed-tools: Bash(git log:*), Bash(git blame:*), Bash(git show:*), Bash(git grep:*), Bash(git ls-files:*)
---

Reconstruct the history behind a piece of code from git. Read-only.

File, folder or function (if empty, ask for it in one line and stop): $ARGUMENTS

Steps:
1. Find the file and, for a function, its line range. Read the history with `git log` (use `--follow`, and `-L` for a function) and `git blame` on the relevant lines.
2. Read the messages and diffs of the commits that shaped it, and any pull request or issue references in them.
3. Output, short and schematic:
   - **Short answer**: why it is the way it is, in two or three lines.
   - **Timeline**: date, author, and what each important change did, in plain words.
   - **Decisions and workarounds** that explain odd-looking code.
   - **Confidence**: say clearly where the history does not explain the reason and you are guessing.
4. Never invent a motive the history does not support.

Reply following the global communication rules.
