#!/usr/bin/env bash
# git-guard: PreToolUse hook for the Bash tool.
# - First git command of a session: injects git-rules.md as context for Claude.
# - Destructive git commands: asks the user for confirmation, every time.
# - New branch or commit whose name breaks the convention in git-rules.md (Git Flow
#   branches, Conventional Commits): asks for confirmation, but only in repos that
#   already follow that convention or have no style yet.
# - Any other command: does nothing.
# Usage: configured in ~/.claude/settings.json (hooks.PreToolUse, matcher "Bash"). Needs jq.
set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly RULES_FILE="${SCRIPT_DIR}/git-rules.md"
readonly STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/claude-git-guard"

# git invoked as a command (start of line or after ; & | ( or whitespace)
readonly GIT_CALL='(^|[;&|(]|[[:space:]])git[[:space:]]'
readonly DESTRUCTIVE='git[[:space:]].*(reset[[:space:]].*--hard|push[[:space:]].*(--force|-f([[:space:]]|$)|--force-with-lease|[[:space:]]\+)|clean[[:space:]].*-[a-zA-Z]*f|branch[[:space:]].*-D|checkout[[:space:]](.*[[:space:]])?(--|\.)([[:space:]]|$)|restore[[:space:]]|stash[[:space:]]+(drop|clear)|rebase[[:space:]]|commit[[:space:]].*--amend|--no-verify|config[[:space:]]+(--global[[:space:]]+)?(user\.|core\.hooksPath|commit\.gpgsign))'

# --- Naming convention (keep in sync with git-rules.md) ---
readonly TASK_ID='([A-Z][A-Z0-9]+-[0-9]+|[0-9]+)'
readonly KEBAB='[a-z0-9]+(-[a-z0-9]+)*'
readonly VERSION='[0-9]+\.[0-9]+\.[0-9]+'
readonly BRANCH_OK="^(main|master|develop|(feature|bugfix|hotfix)/(${TASK_ID}-${KEBAB}|${TASK_ID}|${KEBAB})|release/${VERSION}|hotfix/${VERSION})$"
readonly GITFLOW_PREFIX='^(feature|bugfix|release|hotfix|support)/'
readonly COMMIT_OK='^(feat|fix|build|chore|ci|docs|perf|refactor|revert|style|test)(\([a-z0-9._/-]+\))?!?: [^[:space:]](.*[^.])?$'
readonly COMMIT_MAX_LEN=100
readonly MIN_COMMITS_FOR_STYLE=5

# Branch creation: git [-C dir] switch|checkout ... -c|-b|-C|-B <name>, or git [-C dir] branch <name>
readonly NEW_BRANCH_SWITCH='git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?(switch|checkout)[[:space:]]+([^;&|]*[[:space:]])?-[cbCB][[:space:]]+([^[:space:];&|]+)'
readonly NEW_BRANCH_BRANCH='git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?branch[[:space:]]+([^-[:space:];&|][^[:space:];&|]*)'
readonly GIT_COMMIT='git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?commit([[:space:]]|$)'
readonly COMMIT_MSG_FLAG='(^|[[:space:]])(-[a-zA-Z]*m|--message)([[:space:]]+|=)(.*)'

strip_quotes() {
  local s="$1"
  s="${s#[\"\']}"
  s="${s%[\"\']}"
  printf '%s' "$s"
}

# Directory the git command runs in: `git -C <dir>`, a leading `cd <dir> &&`, or the session cwd.
resolve_repo_dir() {
  local command="$1" cwd="$2" dir=""
  if [[ "$command" =~ git[[:space:]]+-C[[:space:]]+([^[:space:];&|]+) ]]; then
    dir="$(strip_quotes "${BASH_REMATCH[1]}")"
  elif [[ "$command" =~ ^[[:space:]]*cd[[:space:]]+([^[:space:];&|]+) ]]; then
    dir="$(strip_quotes "${BASH_REMATCH[1]}")"
  fi
  [[ -n "$dir" ]] || dir="$cwd"
  [[ "$dir" == "~"* ]] && dir="${HOME}${dir:1}"
  [[ "$dir" == /* ]] || dir="${cwd}/${dir}"
  printf '%s' "$dir"
}

# Subject line of `git commit -m ...` (plain quotes or the "$(cat <<'EOF' ...)" heredoc form).
# Prints nothing when the message cannot be read.
extract_commit_subject() {
  local command="$1" rest unquoted subject
  [[ "$command" =~ $COMMIT_MSG_FLAG ]] || return 0
  rest="${BASH_REMATCH[4]}"
  unquoted="${rest#\"}"
  if [[ "$unquoted" == '$(cat <<'* ]]; then
    [[ "$rest" == *$'\n'* ]] || return 0
    rest="${rest#*$'\n'}"
    subject="${rest%%$'\n'*}"
  elif [[ "${rest:0:1}" == '"' ]]; then
    rest="${rest:1}"
    subject="${rest%%\"*}"
  elif [[ "${rest:0:1}" == "'" ]]; then
    rest="${rest:1}"
    subject="${rest%%\'*}"
  else
    subject="${rest%%[[:space:]]*}"
  fi
  subject="${subject%%$'\n'*}"
  subject="${subject#"${subject%%[![:space:]]*}"}"
  subject="${subject%"${subject##*[![:space:]]}"}"
  printf '%s' "$subject"
}

# True when the repo uses Git Flow prefixes or has no topic branches yet.
repo_uses_gitflow_branches() {
  local dir="$1" name total=0 matching=0
  while IFS= read -r name; do
    case "$name" in "" | HEAD | main | master | develop) continue ;; esac
    total=$((total + 1))
    [[ "$name" =~ $GITFLOW_PREFIX ]] && matching=$((matching + 1))
  done < <({ git -C "$dir" for-each-ref --format='%(refname:lstrip=2)' refs/heads
             git -C "$dir" for-each-ref --format='%(refname:lstrip=3)' refs/remotes; } 2>/dev/null | sort -u)
  ((total == 0 || matching * 2 >= total))
}

# True when the repo is new or at least half of its last 20 commits are Conventional Commits.
repo_uses_conventional_commits() {
  local dir="$1" subject total=0 matching=0
  while IFS= read -r subject; do
    total=$((total + 1))
    [[ "$subject" =~ $COMMIT_OK ]] && matching=$((matching + 1))
  done < <(git -C "$dir" log -20 --no-merges --format=%s 2>/dev/null || true)
  ((total < MIN_COMMITS_FOR_STYLE || matching * 2 >= total))
}

# Prints one warning per line for names that break the convention.
naming_warnings() {
  local command="$1" cwd="$2" dir branch="" subject
  dir="$(resolve_repo_dir "$command" "$cwd")"
  git -C "$dir" rev-parse --git-dir >/dev/null 2>&1 || return 0

  if [[ "$command" =~ $NEW_BRANCH_SWITCH ]]; then
    branch="$(strip_quotes "${BASH_REMATCH[4]}")"
  elif [[ "$command" =~ $NEW_BRANCH_BRANCH ]]; then
    branch="$(strip_quotes "${BASH_REMATCH[2]}")"
  fi
  if [[ -n "$branch" && ! "$branch" =~ $BRANCH_OK ]] && repo_uses_gitflow_branches "$dir"; then
    echo "Branch '${branch}' breaks the Git Flow naming: feature|bugfix|hotfix/<id>|<kebab-desc>|<id>-<kebab-desc>, release/X.Y.Z or hotfix/X.Y.Z."
  fi

  if [[ "$command" =~ $GIT_COMMIT ]]; then
    subject="$(extract_commit_subject "$command")"
    if [[ -n "$subject" ]] && { [[ ! "$subject" =~ $COMMIT_OK ]] || ((${#subject} > COMMIT_MAX_LEN)); } \
      && repo_uses_conventional_commits "$dir"; then
      echo "Commit subject '${subject}' breaks Conventional Commits: <type>(<scope>)!: <summary>, types feat|fix|build|chore|ci|docs|perf|refactor|revert|style|test, no final period, max ${COMMIT_MAX_LEN} chars."
    fi
  fi
}

main() {
  local input command session_id cwd marker
  input="$(cat)"
  command="$(jq -r '.tool_input.command // ""' <<<"$input")"
  session_id="$(jq -r '.session_id // "unknown"' <<<"$input")"
  cwd="$(jq -r '.cwd // ""' <<<"$input")"
  [[ -n "$cwd" ]] || cwd="$PWD"

  [[ "$command" =~ $GIT_CALL ]] || exit 0

  mkdir -p -- "$STATE_DIR"
  marker="${STATE_DIR}/${session_id}"

  local context=""
  if [[ ! -f "$marker" ]]; then
    context="$(cat -- "$RULES_FILE")"
    touch -- "$marker"
  fi

  local reasons=()
  if [[ "$command" =~ $DESTRUCTIVE ]]; then
    reasons+=("this git command can lose work or rewrite history.")
  fi
  local warning
  while IFS= read -r warning; do
    [[ -n "$warning" ]] && reasons+=("$warning")
  done < <(naming_warnings "$command" "$cwd")

  if ((${#reasons[@]} > 0)); then
    jq -n --arg ctx "$context" --arg why "git-guard: ${reasons[*]} Confirm it." '{hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: $why,
      additionalContext: $ctx}}'
    exit 0
  fi

  [[ -n "$context" ]] || exit 0
  jq -n --arg ctx "$context" '{hookSpecificOutput: {hookEventName: "PreToolUse", additionalContext: $ctx}}'
}

main "$@"
