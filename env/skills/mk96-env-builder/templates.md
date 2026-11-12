# Templates for mk96-env-builder

Contents: Rule · Skill · Hook · Permission deny · Research brief for a subagent · Report to the user

## Rule (`~/.claude/rules/<lang>.md`)
```markdown
---
paths:
  - "**/*.<ext>"
  - "**/<build-file>"
---

# <Language>

Applies on top of `coding.md`. Frameworks and architecture come from skills.

## Naming
## Language
## Errors
## Tests
## Build

Sources: <source (license)>, <source (license)>.
```

## Skill (`~/.claude/skills/<name>/SKILL.md`)
```markdown
---
name: <name>
description: Use when <situations, technologies, symptoms that should trigger it>.
---

# <Title>

## Overview
<Core idea in 1-2 sentences.> **Good fit for:** <cases and stacks> (architecture skills only).
<One line pointing to related skills instead of repeating them.>

## <Topic sections with imperative bullets>

## Common mistakes
| Mistake | Fix |
|---|---|

Sources: <source (license)>, <source (license)>.
```

## Hook (`~/.claude/hooks/<name>/<name>.sh`)
```bash
#!/usr/bin/env bash
# <name>: PreToolUse hook for <Tool>. <What it does in one line>.
# Usage: configured in ~/.claude/settings.json (hooks.PreToolUse, matcher "<Tool>"). Needs jq.
set -euo pipefail

main() {
  local input command
  input="$(cat)"
  command="$(jq -r '.tool_input.command // ""' <<<"$input")"
  [[ "$command" =~ <pattern> ]] || exit 0
  jq -n '{hookSpecificOutput: {hookEventName: "PreToolUse",
    permissionDecision: "ask", permissionDecisionReason: "<why>"}}'
}

main "$@"
```
Settings entry (merge with `jq`, never replace existing hooks):
```json
{"matcher": "<Tool>", "hooks": [{"type": "command", "command": "\"$HOME/.claude/hooks/<name>/<name>.sh\"", "timeout": 10}]}
```
Pipe-test: `jq -nc --arg c '<cmd>' '{session_id:"t",tool_input:{command:$c}}' | <script>`.

## Permission deny
```json
"permissions": {"deny": ["Read(//**/<file>)", "Edit(//**/<file>)"]}
```

## Research brief for a subagent
```
Task: <create|review|split> <path(s)>. Touch only these files.
Context: read <neighbour files> and do not repeat them; mirror the style of <reference skill>.
Validate every line against popular, well-starred sources (web): <official docs, current version>, <2-4 repos>. Give approx stars + license.
Review both directions: fix wrong/outdated, remove noise/duplicates, add only high-value items.
Format: <frontmatter>, English body, max <N> words, "Sources:" line. Validate frontmatter with python3 -I + yaml.
Report in SPANISH plain words (under 400 words): what changed and why, word count, sources, rejected items.
```

## Report to the user (Spanish)
```markdown
## <pieza>

**Lo que está mal**
| # | Qué pone ahora | Problema | Cambio |

**Lo que sobra** — <lista corta>

**Lo que falta**
| # | Qué es, en palabras normales | Por qué aporta | Recomendación |

**Descartados** — <lista corta con el porqué>

¿Lo aplico así?
```
