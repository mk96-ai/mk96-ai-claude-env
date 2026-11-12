---
name: node-backend
description: Use when building, changing or reviewing a Node.js backend (HTTP/API service, bot, worker, queue consumer, scheduled job), or when a Node process hangs, crashes, leaks, blocks or shuts down badly.
---

# Node.js backends

Language rules in `javascript-typescript.md`; REST design in `api-rest`; images and Compose in `docker.md`; generic logging and error rules in `coding.md`.

## Structure
- By feature; transport (Express/Fastify routes, bot handlers, queue listeners) thin, logic free of `req`/`res` and framework objects.
- Stateless processes: state in a database or cache. Scale with replicas, not `cluster`, when an orchestrator runs them.

## Errors
- Operational errors handled in one central handler. Programmer or unknown errors: log and exit, the supervisor restarts.
- `unhandledRejection` / `uncaughtException` handlers log once and exit non-zero; never keep running.
- `'error'` listener on every emitter and stream; `pipeline` from `node:stream/promises`, not `.pipe()`.

## Event loop
- No sync fs/crypto/zlib or huge `JSON.parse` on request paths; no ReDoS-prone regex on user input.
- CPU-heavy work to `worker_threads` or a job queue. Limit request body size.

## Lifecycle
- Startup: validate config, connect dependencies, then listen / report ready.
- `SIGTERM`/`SIGINT`: stop taking work, `server.close()`, finish in-flight work, close pools and consumers, exit; force exit after a deadline.
- Runtime: an LTS line, same major in `engines`, `.nvmrc` and the Docker base image (`docker.md`).

## Config & logging
- Env read once at startup into a validated, typed, frozen object; fail fast. No `process.env` scattered. Locally `node --env-file`.
- Structured JSON logger to stdout (e.g. pino) with secret redaction; operation/request id via `AsyncLocalStorage`. No `console.log`.

## Outbound calls
- Every call has a timeout: `AbortSignal.timeout(ms)`; `fetch` has no overall timeout by default.
- Retry only idempotent calls, exponential backoff with jitter, honour `Retry-After`. Bounded fan-out concurrency.

## Bots & workers
- Respect platform rate limits: outgoing queue, back off on 429.
- Handlers idempotent (dedupe by update/message id): platforms and brokers redeliver.
- Acknowledge within the platform deadline, run long work asynchronously.

## Security
- Never `eval` / `new Function`. User text never reaches a shell: `execFile` with an argument array.
- Rate-limit public endpoints; `npm audit` in CI.

## Common mistakes
| Mistake | Fix |
|---|---|
| Process keeps running after `uncaughtException` | Log and exit, let the supervisor restart |
| `fetch` without timeout | `AbortSignal.timeout()` |
| `npm start` as container command | `node` directly so signals arrive |
| Shutdown kills in-flight requests | `server.close()` + drain with deadline |
| Bot replies blocked by rate limits | Queue + backoff on 429 |
| `process.env.X` read everywhere | One validated config object |

Sources: goldbergyoni/nodebestpractices (~105k stars, CC-BY-SA-4.0, paraphrased), Node.js docs and guides ("Don't block the event loop", process, TypeScript), github/awesome-copilot nodejs instructions (~40k, MIT), wshobson/agents javascript-typescript (~40k, MIT), PatrickJS/awesome-cursorrules (~37k, CC0).
