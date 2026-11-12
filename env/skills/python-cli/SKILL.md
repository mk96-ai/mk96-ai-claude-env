---
name: python-cli
description: Use when writing, changing or testing a Python command-line tool or automation script (argparse, typer or click, console entry points, exit codes, stdout/stderr output, subprocess calls, file processing, single-file uv scripts with inline dependencies, [project.scripts] packaging).
---

# Python CLI tools and scripts

## Overview
Thin CLI layer (parse, print, exit code) over plain typed functions. Language and pytest basics: Python rule; bash: `shell.md`.

## Entry point and arguments
- `def main(argv: list[str] | None = None) -> int`, run as `raise SystemExit(main())` under `if __name__ == "__main__":`.
- `argparse` by default; `typer`/`click` if the project uses them.
- `--help` with a usage example (`epilog`); `--version` from `importlib.metadata.version()`, never `-v`.
- Bad input: `parser.error(...)` (exit 2). Accept `-` for stdin/stdout.
- Destructive actions: `--dry-run`; prompt only when stdin is a TTY, otherwise require `--force`.

## Output and exit codes
- Results to stdout (`print` is fine here); logs, progress and errors to stderr.
- Exit 0 on success, 1 on failure, 2 on usage error, 130 on Ctrl-C (catch `KeyboardInterrupt` in `main`).
- Expected errors: one clear message, traceback only with `--debug`.
- Machine-readable output behind `--json`.
- Color and progress bars only on a TTY and without `NO_COLOR`.
- `logging.basicConfig(stream=sys.stderr, ...)` once in `main`; `-v`/`-q` set the level.

## Config and secrets
- Precedence: flags > environment > user config (`~/.config/<app>/config.toml`, read with `tomllib`) > defaults.
- Secrets from a file, stdin or `getpass`, never as flags (visible in `ps` and shell history).

## Subprocess and files
- On top of the rule's `subprocess` line: check tools with `shutil.which` up front; `--` before untrusted operands; report `CalledProcessError.stderr`.
- Write outputs atomically (temp file in the same folder, then `os.replace`); re-runs must be safe.

## Single-file scripts
- PEP 723 block (`# /// script` with `requires-python`, `dependencies`); `uv add --script`, `uv run script.py`; shebang `#!/usr/bin/env -S uv run --script`; `uv lock --script` when it must stay reproducible.
- Reused or growing: `[project.scripts] tool = "pkg.cli:main"`, installed with `uv tool install`.

## Testing
- Call `main([...])`; assert the return code and `capsys` output. `CliRunner` for typer/click.
- Files in `tmp_path`, env via `monkeypatch.setenv`, subprocess mocked at the boundary.

## Common mistakes
| Mistake | Fix |
|---|---|
| `sys.exit()` deep inside logic | Raise; `main` maps it to an exit code |
| Errors or logs on stdout | stderr, so pipes stay clean |
| Traceback for a user mistake | Clear message, exit 1 or 2 |
| Token passed as a flag | File, stdin or `getpass` |
| Half-written output after a crash | Temp file + `os.replace` |

Sources: Python docs (argparse, subprocess, logging), PEP 723, clig.dev (~4k stars, CC BY-SA), astral-sh/uv (~92k, MIT), typer (~20k, MIT), click (~18k, BSD), wshobson/agents (~42k, MIT), github/awesome-copilot (~41k, MIT); paraphrased.
