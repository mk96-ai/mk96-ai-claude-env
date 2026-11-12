---
name: mk96-env-builder
description: Use when creating, splitting, reviewing or updating the personal Claude Code environment in ~/.claude (global CLAUDE.md, rules, skills, hooks, permission rules), e.g. a new technology, framework, architecture, protocol or domain-specific UX needs its own guidance, or a behavior must be enforced.
---

# mk96-env builder

## Overview
Every piece of guidance has **one concern, one home and evidence behind it**. Pick the right mechanism, keep it separate from its neighbours, validate it against professional sources, let the user decide, then verify it really loads.

**REQUIRED BACKGROUND:** templates in `templates.md` (same folder).

Copy this checklist and tick it as you go:
```
- [ ] 1. Mechanism chosen
- [ ] 2. Scope checked against existing pieces (split or pointer decided)
- [ ] 3. Sources researched (official + popular, stars/license noted)
- [ ] 4. Draft written within budget
- [ ] 5. Report shown to the user and answered
- [ ] 6. Verified (frontmatter, refs, hook/permission tests)
- [ ] 7. Wired up (pointers, project CLAUDE.md)
```

## 1. Choose the mechanism
| Need | Mechanism | Loads |
|---|---|---|
| Applies to every session (tone, safety, secrets) | Global `~/.claude/CLAUDE.md` | Always |
| Applies to a language/file type | Rule `~/.claude/rules/<lang>.md` with `paths:` | When a matching file is read/edited |
| Framework, architecture, protocol, platform, domain UX | Skill `~/.claude/skills/<name>/SKILL.md` | When its description matches the task |
| Must happen or be blocked no matter what | Hook in `settings.json` (script in `~/.claude/hooks/<name>/`) | On the tool event |
| A file type must never be read/edited | Permission `deny` rule with `//**/` patterns | Always |
| Only one repo | That repo's `CLAUDE.md` | In that repo |

- Rule without `paths:` loads always: use a hook instead when it only matters for some actions (e.g. git).
- Safety-critical guidance never lives only in a skill: skills load by judgment, hooks and permissions don't.

## 2. Scope and separation
Layers never mix in one file:

| Layer | Example | Home |
|---|---|---|
| Generic coding | TDD, clean code | `rules/coding.md` |
| Language + its build tool | Java + Maven | rule |
| Framework | Spring, Quarkus, Angular | skill `<lang>-<framework>` or `<framework>` |
| Architecture | hexagonal, MVC | skill `arch-<style>` |
| Protocol / integration | REST, messaging | skill `api-rest`, `messaging` |
| Platform / UI toolkit | JavaFX, Win32, GTK | skill `<lang>-<platform>` |
| Domain UX | dashboards, social pages | skill `ux-<domain>` |

- List what exists first (`ls ~/.claude/rules ~/.claude/skills ~/.claude/hooks`) and read the neighbours.
- Overlap → one line pointing to the other piece, never a copy.
- An existing piece mixing two layers → propose the split.
- Architecture skills say when they are a **good fit** and for which stacks; they never compare themselves with others.
- A pattern from one project (class names, startup orchestration) goes to that project's `CLAUDE.md`, not to a generic skill. Client/company names never appear.

## 3. Research
- Official docs of the **current** version plus at least two popular sources (prefer 10k+ stars: anthropics/skills, github/awesome-copilot, wshobson/agents, well-known style guides). Record approx stars and license.
- UX and design pieces: professional sources only (platform guidelines, NN/g, Baymard, WCAG...); the user's own projects are never a design reference.
- Paraphrase CC-BY-SA and style-guide text; adapt MIT/Apache/CC0 freely.
- Facts not checked against a source are marked as such in the report.
- Several pieces at once: one subagent per piece with the research brief from `templates.md`.

## 4. Draft
- Body in English; the user reads explanations in Spanish.
- Rule: `paths:` frontmatter, ≤400 words. Skill: `name` + `description` starting "Use when..." with triggers only (no workflow), ≤550 words; heavy reference in a supporting file.
- Concrete imperative bullets, a "Common mistakes" table, a final `Sources:` line.
- Never repeat `coding.md`, the language rule or sibling skills.

## 5. Review with the user
- Compare in **both directions**: missing, wrong/outdated, superfluous.
- Present in Spanish, plain words, using the report table in `templates.md`: what, why it adds value, recommendation. Nothing is applied before the user answers, except when the user explicitly delegated that piece.
- Expert areas of the user: their call wins over sources. Other areas: rely on the comparison.

## 6. Verify
- Frontmatter parses (`python3 -I` + `yaml.safe_load`), word count within budget.
- No stale references: `grep -rn "<old-name>" ~/.claude/CLAUDE.md ~/.claude/rules ~/.claude/skills`.
- Hooks: pipe-test with sample JSON, then trigger once in the session and check the effect.
- Permissions: test with a dummy file in the scratchpad, then delete it.

## 7. Wire up
- Update pointers in related pieces (e.g. the framework list in `rules/java.md`).
- Projects that use a new skill name it in their `CLAUDE.md`.
- Export with `/mk96-env:export` only when the user asks.

## Common mistakes
| Mistake | Fix |
|---|---|
| Framework rules inside the language rule | Separate skill |
| Skill imposes an architecture | Architecture lives in `arch-*` skills |
| Copying a sibling's content | One-line pointer |
| Project-specific pattern in a generic skill | Project `CLAUDE.md` |
| Version facts from memory | Check current docs |
| Applying changes before the user decides | Present the report table first |
| Rule paths like `**/.env` in permissions | Use `//**/.env` (absolute, any folder) |
