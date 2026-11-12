---
name: api-rest
description: Use when designing, implementing or reviewing a REST/HTTP API (endpoints, status codes, payloads, errors, pagination, versioning, idempotency, OpenAPI contract), in any stack.
---

# REST APIs

Contract first: the OpenAPI document is the API. Layers, validation placement, transactions and class naming come from the project's architecture skill.

## Resources & URLs
- Plural nouns, kebab-case, at most 2 nesting levels: `/orders/{orderId}/lines`.
- No verbs in paths. A non-CRUD action is a sub-resource or `POST /orders/{id}:cancel`.
- Query params camelCase. Ids are opaque strings.

## Methods & status codes
| Method | Use | Success | Common errors |
|---|---|---|---|
| GET | read | 200 | 404 |
| POST | create / action | 201 + `Location` / 202 async / 200 | 400, 409, 422 |
| PUT | full replace (idempotent) | 200 / 204 | 400, 404, 412 |
| PATCH | partial (`application/merge-patch+json`) | 200 | 400, 404, 412 |
| DELETE | remove (idempotent) | 204 | 404 |

Also: 401 not authenticated, 403 not allowed, 429 + `Retry-After`, 500 never on purpose.

## Bodies
- Dedicated request/response DTOs; never expose entities or documents.
- JSON camelCase; top level always an object, never a bare array.
- Date-times ISO-8601 UTC (`2026-11-12T10:15:30Z`), dates `2026-11-12`.
- Money: `{"amount": "12.30", "currency": "EUR"}`, decimal as string, ISO-4217 code, never float.
- Enums UPPER_SNAKE_CASE; clients tolerate unknown values. Empty collections as `[]`.

## Errors
- Always `application/problem+json` (RFC 9457): `type`, `title`, `status`, `detail`, `instance`.
- Extra members for context: `errors: [{field, message}]` on 400, business `code` on 409/422.
- Same shape for every error, including 404/405/500 raised by the framework.
- Never return stack traces, SQL, class names or internal hosts.

## Pagination, filtering, sorting
- Every collection is paginated, with a default and a maximum page size.
- Prefer cursor (`?pageSize=50&pageToken=...` → `{items, nextPageToken}`); offset only for small, stable data.
- Filters as named params (`?status=SHIPPED`); sort as `?sort=-createdAt,name`.

## Versioning & compatibility
- Only additive changes: new optional fields/params; never rename, remove or retype.
- Breaking change = new major version (`/v2/...`); the old one announced with `Deprecation`/`Sunset` headers.
- OpenAPI spec generated in the build; CI fails on breaking diffs (oasdiff / openapi-diff).

## Idempotency & concurrency
- Retryable POSTs accept `Idempotency-Key`: same key with a different body → 422, still in flight → 409.
- Optimistic locking: return `ETag`; writes require `If-Match` → 412 on mismatch, 428 if missing.

## Security basics
- `Authorization: Bearer <token>`; never tokens or personal data in URLs. HTTPS only. Validate size and format of all input.

## Spring Boot implementation
- Controller interface carries the OpenAPI annotations; its `Impl` holds the Spring wiring only.
- `@RestControllerAdvice extends ResponseEntityExceptionHandler` returning `ProblemDetail`.
- `@Valid` on request bodies; `@Validated` for path/query params.
- springdoc-openapi: `/v3/api-docs` feeds the CI diff; Swagger UI disabled in production.
- Web slice tests: `@WebMvcTest` / `@WebFluxTest` + `@MockitoBean` on the service; assert status, body and problem shape.
- Quarkus: `@ServerExceptionMapper` + `quarkus-smallrye-openapi`.

## Common mistakes
| Mistake | Fix |
|---|---|
| `200` with `{"error": ...}` | Proper 4xx/5xx + ProblemDetail |
| `POST /createOrder` | `POST /orders` |
| Unbounded list endpoint | Paginate with a max size |
| Renaming a field "quickly" | Add new, deprecate old |
| Lost updates on concurrent PUT | ETag + If-Match |

Sources: microsoft/api-guidelines and zalando/restful-api-guidelines (CC-BY-4.0, paraphrased), Google AIP, RFC 9457/9110, springdoc-openapi (Apache-2.0), github/awesome-copilot (MIT).
