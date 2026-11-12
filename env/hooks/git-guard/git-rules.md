# Git rules

Injected by the git-guard hook the first time a git command runs in a session.

- **Never commit or push unless the user explicitly asks.** Approval for one commit does not cover the next one.
- Don't work directly on `main`/`master`/`develop`: create a branch first.
- **Ask before hard-to-undo git actions** and say what would be lost: `reset --hard`, force push, deleting branches, rebasing or amending already pushed commits, `clean -f`, dropping stashes, and discarding uncommitted changes (`checkout -- <path>`, `checkout .`, `restore`).
- Never skip hooks (`--no-verify`) unless asked. If a pre-commit hook fails, fix the issue and create a NEW commit, never `--amend`.
- Stage files explicitly by path (no `git add -A` / `git add .`) and review `git diff --staged` before committing.
- Never change git config (user, email, hooks path, signing) unless asked.
- Commit messages in English.
- Never commit secrets, `.env` files, build output or local IDE files.

## Branching and commit naming
Default convention. If the repo already follows another one (check `git branch -a` and `git log -20`), follow the repo instead. git-guard asks for confirmation when a new branch or commit breaks the convention in a repo that uses it.

**Branches (Git Flow)**
- `main`: released code only, each release tagged `vX.Y.Z`. `develop`: integration branch. Changes reach both only by merge/PR.
- `feature/<name>` and `bugfix/<name>`: from `develop`, back to `develop`.
- `release/X.Y.Z`: from `develop`; only fixes and version bumps; merged into `main` (tag `vX.Y.Z`) and back into `develop`.
- `hotfix/<name>` or `hotfix/X.Y.Z`: from `main`; merged into `main` (tag) and back into `develop`.
- `<name>` is a task id, a description or both: `1234`, `PROJ-123`, `discount-validation`, `PROJ-123-discount-validation`. Description in lowercase kebab-case.

**Commits (Conventional Commits 1.0.0)**
- `<type>(<optional scope>)!: <summary>`, e.g. `feat(orders): validate discount codes`.
- Types: feat, fix, build, chore, ci, docs, perf, refactor, revert, style, test.
- Summary: imperative, lowercase start, no final period; header ≤ 100 chars.
- Breaking change: `!` after type/scope plus a `BREAKING CHANGE: <what>` footer.
- Body (after a blank line) explains why.
