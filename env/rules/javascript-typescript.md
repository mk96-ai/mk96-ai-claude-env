---
paths:
  - "**/*.{js,mjs,cjs,ts,tsx,jsx}"
  - "**/package.json"
  - "**/tsconfig*.json"
---

# JavaScript / TypeScript

Applies on top of `coding.md`. Node services, APIs, bots and workers: skill `node-backend`. Frontend UI: skills `ux-design`, `frontend-web` and `angular`. HTTP API design: skill `api-rest`.

## Types & tsconfig
- New code in TypeScript. TS 6.0 changed defaults (`types: []`, so list `"node"`) and deprecated `moduleResolution: node` and `baseUrl`.
- `"strict": true` written explicitly + `noUncheckedIndexedAccess`. `module`/`moduleResolution` `nodenext` for code Node runs, `bundler` for bundled apps.
- `unknown` instead of `any`, narrowed with type guards. No non-null `!` or `as` casts to silence the compiler.
- Validate external input (HTTP, env, files, third-party payloads) with a schema (e.g. zod) and infer the types from it.
- Model states as discriminated unions with an exhaustive `switch` (`never` check), not boolean flags.
- String-literal unions or `as const` objects instead of `enum` / `namespace`. Code run as `.ts` by Node (type stripping) needs `erasableSyntaxOnly` + `verbatimModuleSyntax` + `rewriteRelativeImportExtensions`.

## Modules & naming
- ESM for new projects; existing CommonJS projects keep their module system unless asked. Built-ins with the `node:` prefix; `import type` for type-only imports.
- Named exports, no default exports.
- `camelCase` values and functions, `PascalCase` types and classes, `UPPER_SNAKE_CASE` only for true constants; no `I` prefix on interfaces.

## Async & errors
- `async`/`await` over `.then` chains and callbacks.
- Every promise is awaited, returned or explicitly `void`-ed; no async function where a void callback is expected.
- `return await` inside `try` so the `catch` and the stack trace see the failure.
- Independent calls with `Promise.all`; `Promise.allSettled` when partial failure is acceptable.
- Throw only `Error` subclasses, never strings or plain objects; wrap with `{ cause }`.

## Linting
- ESLint flat config with typescript-eslint `recommendedTypeChecked` (or `strictTypeChecked`) and `projectService: true`; this enforces `no-floating-promises` and `no-misused-promises`.
- `tsc --noEmit` in CI.

## Dependencies & tests
- Lockfile committed; CI installs with `npm ci`.
- Vitest or `node:test`, whichever the repo uses. Data created per test; external HTTP mocked at the network level (msw, nock).

Sources: microsoft/TypeScript handbook, tsconfig reference and 6.0 notes (~108k stars, Apache-2.0), typescript-eslint (~16k, MIT), Google TypeScript style guide / google/gts (~5k, Apache-2.0), goldbergyoni/nodebestpractices (~105k, CC-BY-SA-4.0, paraphrased), github/awesome-copilot (~40k, MIT), wshobson/agents (~40k, MIT).
