---
paths:
  - "**/*.{java,kt,py,js,mjs,cjs,ts,tsx,jsx,c,h,cpp,hpp,cc,cs,go,rs,sh,sql,html,scss,css}"
---

# Coding

Applies to any programming work, in any language. Language-specific rules live in sibling rule files; architecture lives in skills.

## Before touching code

1. Say briefly **how** it will be implemented.
2. Give a **schema of what it affects** (repos, modules/classes, files).
3. Then implement.

- Trivial changes (one obvious edit in one file): one line is enough.
- **Larger changes** (new feature, several files, refactor, non-trivial bug): use the skills that fit (brainstorming, writing-plans, systematic-debugging, code review) and the architecture skill the project's `CLAUDE.md` names. The "one line" shortcut never replaces a fitting skill.

## Fit the existing codebase

- Read the surrounding code first and see how the repo solves similar things.
- Match its structure, naming, patterns and style, even if you would do it differently.
- Reuse existing helpers before creating new ones.
- Small change: apply it in place. Don't create a new class or file just to hold it.
- When a change clearly needs its own class/module (a new responsibility, a file doing too much), create it.

## Code quality

- **Readable by humans first**: clarity beats cleverness.
- **Separation of responsibilities**: each module/class/function does one thing. Keep business logic apart from I/O (database, HTTP, files, UI).
- **Small functions**, shallow nesting, early returns over deep `if` chains.
- **Self-descriptive names**: no cryptic abbreviations (`proc`, `mgr`, `tmp`). Booleans read as questions (`is_valid`, `has_permission`). No magic numbers or strings: use named constants.
- **No duplication** of real logic, but don't abstract two similar lines "just in case".
- **Errors**: never swallow exceptions silently. Catch only what you can handle, and keep the context when re-raising.
- **Minimum change** that solves the problem. No speculative features, abstractions or flexibility nobody asked for.
- **Surgical changes**: every changed line must trace to the request. Don't refactor or reformat adjacent code.
- Remove only the orphans (unused imports, dead variables) your own change creates, and any temporary scripts or scratch files created while working.
- **Check what else the change affects**: config files and documentation (README, docs, docstrings). Update what became outdated.
- Validate external input. Never build SQL by string concatenation.
- No defensive code for impossible cases: validate at system boundaries, trust internal code, and add no fallbacks or default values that hide a failure.

## Practices by context

Classify the work first, then apply. If the kind of code is unclear, ask.

| Practice | Production / app code | Scripts & one-offs | Prototypes / spikes | Config / infra |
|---|---|---|---|---|
| Tests | TDD (test first) | Manual check; tests only if it touches critical data | No. Add them before it becomes real code | Validate (lint / dry-run) |
| Design (SOLID, layers) | Yes, without over-engineering | No. Simple linear script | No | No |
| Logging | Yes (see below) | Basic progress output | Optional | No |
| Docs | Public API + non-obvious logic | Short header: what it does and how to run it | Not needed | Comment non-obvious settings |

- **Tests must make sense**: each one protects a real behavior or risk. Test behavior, not implementation. No trivial, redundant or overlapping tests.
- **Before finishing** (and always before a push), review the tests touched or added. **Propose** which to delete or merge and why, and wait for confirmation.
- A test that was already failing before your change: report it, don't silently fix or ignore it.
- **Never game tests**: no hard-coded values or special cases just to make tests pass, and never weaken, skip or delete a test to get green. If a test looks wrong, say so.
- **Bug fix**: first reproduce it (failing test or repeatable command), then fix, then show the same check passing.
- **SOLID** is a guide, not a goal: add an abstraction only where it clearly helps.
- Verify with the project's tools (tests, linter, build) before saying it is done.

## Logging

- Use the project's existing logger. Never `print` in production code.
- Levels: `DEBUG` developer details · `INFO` key business events · `WARNING` unexpected but recovered · `ERROR` operation failed.
- Messages in English, with useful context (ids, counts, operation name).
- **Never log secrets or personal data** (passwords, tokens, full card or ID numbers, emails in bulk).
- Log an error **once**, where it is handled. Don't log and re-raise at every layer.
- No logging inside tight loops unless it is `DEBUG`.

## Comments and documentation

- Code, comments, docstrings and logs in **English**.
- Comments explain **why**, not what. Comment only where a reader would otherwise get lost (non-obvious decisions, workarounds, business rules).
- If code needs a comment to be understood, first try to make the code clearer.
- Document public functions/classes (purpose, parameters, return, errors) and non-obvious logic.
- Known limitations: `TODO(reason)` / `FIXME(reason)`, always with the why.
- **On every code change, review the comments and docs around it** and update or delete any that no longer match.

## Risky changes

- **Ask before** adding a new dependency, running database migrations or changing data/schema.
- Don't edit generated files or lockfiles by hand.
