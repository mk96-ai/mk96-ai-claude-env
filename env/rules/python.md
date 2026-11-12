---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
---

# Python (3.10+)

Applies on top of `coding.md`; only Python specifics here. Command-line tools and scripts: skill `python-cli`.

## Project
- `pyproject.toml` holds everything (metadata, explicit `requires-python`, ruff, mypy/pyright, pytest). No `setup.py`.
- Environments and locks with `uv` (`uv add`, `uv sync`, `uv run`); dev tools in `[dependency-groups] dev` (PEP 735); commit `uv.lock` and use `uv sync --locked` in CI. If the project already uses another tool (pip, Poetry, Debian packages), keep it.
- Checks: `ruff check`, `ruff format`, the type checker and `pytest`.

## Code
- Type every public signature. Use `X | None` and built-in generics (`list[str]`). `Any` only at untyped boundaries.
- `Protocol` for "has these methods" interfaces; ABCs only when sharing behavior.
- Data as `@dataclass(frozen=True, slots=True)` (pydantic only at I/O boundaries). Don't pass raw dicts around.
- No mutable default arguments: default to `None` and build the value inside.
- Re-raise with `raise NewError(...) from err`. No bare `except:`; `except Exception` only at the top level.
- Resources with context managers (`with`, `ExitStack`). `pathlib` instead of `os.path`; `encoding="utf-8"` when opening text.
- `subprocess.run([...], check=True, timeout=...)` with an argument list; never `shell=True` with external input.
- Every network call has an explicit timeout (`requests` has none by default).
- Timezone-aware datetimes (`datetime.now(timezone.utc)`), never `utcnow()`.
- Config read once from environment into a typed settings object; fail fast if something is missing.

## Logging
- `logger = logging.getLogger(__name__)` per module. Handlers configured only in the entry point; libraries never call `basicConfig`.
- Lazy formatting: `logger.info("Saved %s", order_id)`. Inside `except`, `logger.exception(...)` keeps the traceback.

## Tests (pytest)
- New projects (pytest 9+): `[tool.pytest]` with `strict = true` and `addopts = ["--import-mode=importlib"]`; older pytest: `[tool.pytest.ini_options]` and `--strict-markers`.
- Fixtures in `conftest.py`; `@pytest.mark.parametrize` instead of copy-pasted tests.
- `tmp_path`, `monkeypatch`, `caplog` instead of hand-made temp files or global patches.
- `pytest.raises(Error, match=...)` to check the message, not only the type.
- Names: `test_<unit>_<scenario>_<expected>`.
- Mock only boundaries (HTTP, clock, filesystem, subprocess), with `autospec=True`. Inject the clock or freeze time.

Sources: Python docs (logging HOWTO, subprocess; PSF), PEP 8/484/735, astral-sh/uv (~92k stars) and astral-sh/ruff (~51k) docs (MIT/Apache-2.0), pytest docs (~15k, MIT), google/styleguide Python (~40k, CC BY 3.0), wshobson/agents python-development (~42k, MIT); paraphrased.
