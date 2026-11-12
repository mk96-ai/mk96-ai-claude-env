# Git rules

Injected by the git-guard hook the first time a git command runs in a session.

- **Never commit or push unless the user explicitly asks.** Approval for one commit does not cover the next one.
- Don't work directly on `main`/`master`: create a branch first.
- **Ask before hard-to-undo git actions** and say what would be lost: `reset --hard`, force push, deleting branches, rebasing or amending already pushed commits, `clean -f`, dropping stashes, and discarding uncommitted changes (`checkout -- <path>`, `checkout .`, `restore`).
- Never skip hooks (`--no-verify`) unless asked. If a pre-commit hook fails, fix the issue and create a NEW commit, never `--amend`.
- Stage files explicitly by path (no `git add -A` / `git add .`) and review `git diff --staged` before committing.
- Never change git config (user, email, hooks path, signing) unless asked.
- Commit messages in English. Follow the repo's existing style (check `git log -10`); use Conventional Commits only when there is no clear style.
- Never commit secrets, `.env` files, build output or local IDE files.
