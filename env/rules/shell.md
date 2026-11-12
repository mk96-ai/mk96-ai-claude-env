---
paths:
  - "**/*.sh"
  - "**/*.bash"
---

# Shell scripts (bash)

Scripts follow the "Scripts & one-offs" column of `coding.md`: simple and linear, manual check.

## Safety
- `#!/usr/bin/env bash`, then `set -euo pipefail` (add `-E` only with an `ERR` trap).
- `set -e` is not error handling: it is ignored in `if`/`while` conditions, `&&`/`||` chains and functions called from them. Check critical commands explicitly (`cmd || die "..."`).
- `local var; var=$(cmd)`: the one-line form hides the exit code (SC2155). `shopt -s inherit_errexit` so `$(...)` failures propagate.
- Quote every expansion. Arrays for argument lists (`"${args[@]}"`). Never `eval` or `for f in $(ls)`.
- NUL-safe file loops: `find ... -print0 | while IFS= read -r -d '' f`. Command output into arrays with `mapfile -t`.
- `--` before operands and `${var:?}` on paths: `rm -rf -- "${dir:?}"` never becomes `rm -rf /`.
- Temp files with `mktemp` + `trap cleanup EXIT`.

## Style
- Header lists usage and dependencies; `-h/--help`; functions first, `main "$@"` at the bottom.
- `[[ ]]` over `[ ]`, `$(...)` over backticks, `(( ))` for arithmetic.
- `local` in functions, `readonly` for constants, `: "${VAR:?VAR is required}"` for required variables.
- Check dependencies up front: `command -v jq >/dev/null || die "jq required"`.
- `printf` over `echo`. Messages to stderr via `log()` / `die()`; stdout only for real output. Non-zero exit on failure.
- JSON/YAML with `jq` / `yq`, never grep/sed/awk.
- Idempotent. `--dry-run` for anything destructive. Timeouts on network calls (`curl --fail --max-time`).
- Pass ShellCheck; disable a check only inline, with a reason.
- Past ~100 lines of logic or needing data structures: rewrite it in Python.

Sources: Google Shell Style Guide (CC-BY-3.0), ShellCheck wiki (koalaman/shellcheck ~40k stars, GPL-3.0), dylanaraps/pure-bash-bible (~42k, MIT), wshobson/agents (~42k, MIT), github/awesome-copilot (~41k, MIT); all paraphrased.
