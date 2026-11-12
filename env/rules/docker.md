---
paths:
  - "**/Dockerfile*"
  - "**/*.dockerfile"
  - "**/docker-compose*.{yml,yaml}"
  - "**/compose*.{yml,yaml}"
  - "**/.dockerignore"
---

# Docker and Compose

Validate with `docker build`, `docker compose config`, hadolint, and an image scan (`docker scout cves` or `trivy image`).

## Dockerfile
- Multi-stage builds: tools and dev dependencies in the build stage, only artifacts copied with `COPY --from=build`.
- Pinned base images: exact version tag (ideally digest, updated by Dependabot/Renovate). Never `:latest`. Rebuild regularly with `--pull` for patches.
- Prefer `-slim` (glibc) or distroless. Alpine (musl) only if native dependencies are known to work on it.
- Cache order: lockfile first, reproducible install (`npm ci`, `pip install --no-cache-dir -r requirements.txt`), then source. Optional `RUN --mount=type=cache`.
- Never put secrets in `ARG`/`ENV` or copy `.env`. Use `RUN --mount=type=secret`.
- Strict `.dockerignore` (`.git`, `.env*`, `node_modules`, `__pycache__`, build output).
- Non-root `USER` with fixed UID; `COPY --chown`.
- `COPY`, not `ADD` (only for tar extraction or remote files with `--checksum`).
- `CMD`/`ENTRYPOINT` in exec (JSON) form; start the runtime directly (`node app.js`, not `npm start`). Entrypoint scripts end with `exec "$@"`.
- One `RUN` for `apt-get update && apt-get install -y --no-install-recommends ... && rm -rf /var/lib/apt/lists/*`.
- Pipes in `RUN`: `SHELL ["/bin/bash", "-o", "pipefail", "-c"]` first.
- Long-running services get a healthcheck in exec form, using a tool present in the image (slim images have no `curl`).

## Compose
- File named `compose.yaml`; no `version:` key (obsolete, ignored with a warning).
- Secrets from `env_file` (not committed) or Compose `secrets:`, never hardcoded. Required variables as `${VAR:?missing VAR}`.
- `depends_on` with `condition: service_healthy` instead of sleeps.
- Named volumes for persistent data; bind mounts for development only (`compose.override.yaml`).
- Publish only needed ports; `127.0.0.1:` when local-only. `restart: unless-stopped`.
- `init: true` when the process spawns children (browsers, shells) so zombies are reaped and signals forwarded.
- Hardening where it fits: `read_only: true`, `cap_drop: [ALL]`, `security_opt: [no-new-privileges:true]`, memory limits.
- Logs to stdout/stderr; containers stateless.

Sources: Docker docs build best practices (Apache-2.0), Compose spec (~3k stars, Apache-2.0), hadolint (~13k, GPL-3.0), docker/awesome-compose (~47k, CC0), Trivy (~39k, Apache-2.0), github/awesome-copilot containerization (~41k, MIT); all paraphrased.
