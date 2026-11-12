#!/usr/bin/env bash
# git-guard: PreToolUse hook for the Bash tool.
# - First git command of a session: injects git-rules.md as context for Claude.
# - Destructive git commands: asks the user for confirmation, every time.
# - Any other command: does nothing.
# Usage: configured in ~/.claude/settings.json (hooks.PreToolUse, matcher "Bash"). Needs jq.
set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly RULES_FILE="${SCRIPT_DIR}/git-rules.md"
readonly STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/claude-git-guard"

# git invoked as a command (start of line or after ; & | ( or whitespace)
readonly GIT_CALL='(^|[;&|(]|[[:space:]])git[[:space:]]'
readonly DESTRUCTIVE='git[[:space:]].*(reset[[:space:]].*--hard|push[[:space:]].*(--force|-f([[:space:]]|$)|--force-with-lease|[[:space:]]\+)|clean[[:space:]].*-[a-zA-Z]*f|branch[[:space:]].*-D|checkout[[:space:]](.*[[:space:]])?(--|\.)([[:space:]]|$)|restore[[:space:]]|stash[[:space:]]+(drop|clear)|rebase[[:space:]]|commit[[:space:]].*--amend|--no-verify|config[[:space:]]+(--global[[:space:]]+)?(user\.|core\.hooksPath|commit\.gpgsign))'

main() {
  local input command session_id marker
  input="$(cat)"
  command="$(jq -r '.tool_input.command // ""' <<<"$input")"
  session_id="$(jq -r '.session_id // "unknown"' <<<"$input")"

  [[ "$command" =~ $GIT_CALL ]] || exit 0

  mkdir -p -- "$STATE_DIR"
  marker="${STATE_DIR}/${session_id}"

  local context=""
  if [[ ! -f "$marker" ]]; then
    context="$(cat -- "$RULES_FILE")"
    touch -- "$marker"
  fi

  if [[ "$command" =~ $DESTRUCTIVE ]]; then
    jq -n --arg ctx "$context" '{hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: "git-guard: this git command can lose work or rewrite history. Confirm it.",
      additionalContext: $ctx}}'
    exit 0
  fi

  [[ -n "$context" ]] || exit 0
  jq -n --arg ctx "$context" '{hookSpecificOutput: {hookEventName: "PreToolUse", additionalContext: $ctx}}'
}

main "$@"
