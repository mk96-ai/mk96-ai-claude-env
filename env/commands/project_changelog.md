---
description: Plain-language changelog between two versions, dates or commits. Read-only
allowed-tools: Bash(git log:*), Bash(git tag:*), Bash(git show:*), Bash(git diff:*), Bash(git branch:*)
---

Write a changelog of what changed, for people who do not read commit messages. Read-only: do not create files.

Range (optional: two tags or commits, a date such as "since 2 weeks ago", or a branch; default since the last tag, or the last 30 days if there are no tags): $ARGUMENTS

Steps:
1. Read the commits in the range and, when a commit message is cryptic, its diff.
2. Group related commits into one entry and drop noise (merge commits, formatting, typo fixes, internal renames) unless they matter to users.
3. Output in plain wording the user can read, grouped as:
   - **New**: new capabilities.
   - **Improved**: existing behavior that got better.
   - **Fixed**: bugs fixed, described by their effect and not by the code.
   - **Internal**: technical changes with no visible effect, in one short list.
   - **Watch out**: breaking changes, required configuration or data migrations.
4. State the range that was covered (from, to, number of commits). Mark as a guess any entry whose purpose you inferred.
5. Offer to save it to a file or format it for a release. Do not do it unless asked.

Reply following the global communication rules.
