---
name: java-quarkus
description: Use when building or changing any Quarkus application (CDI/ArC beans, @ConfigMapping, profiles, Hibernate ORM with Panache, Dev Services, health, metrics, tracing, fault tolerance, Mutiny vs blocking vs virtual threads, @QuarkusTest, native image), whatever its architecture.
---

# Quarkus

Applies to any architecture: layout and naming come from the architecture skill. REST APIs (`api-rest`), messaging (`messaging`) and Reactor (`java-reactor`) have their own skills. Check the project's Quarkus version first and manage versions through the platform BOM.

## Wiring (CDI / ArC)
- Constructor injection (`@Inject` optional with one constructor); `@ApplicationScoped` by default. Never field injection in production code.
- Package-private, not `private`, for injected members, producers and observers: avoids reflection (native). Intercepted `private` methods fail the build.
- Unused beans are removed at build time: beans looked up only via `CDI.current()` need `@Unremovable`.
- Several candidates: qualifiers or `@Identifier`, not bare `@Named`; overridable defaults with `@DefaultBean`.
- Feature switches with `@IfBuildProperty` / `@IfBuildProfile` (build time) or `@LookupIfProperty` (runtime), never `if (profile)` in code.

## Configuration & profiles
- Own keys in `@ConfigMapping` interfaces with `@WithDefault` and validation constraints, so bad config fails at startup. `@ConfigProperty` only for a single outside key.
- One `application.properties`; `%dev.` / `%test.` / `%prod.` only for environment differences.
- Build-time properties cannot change at runtime: set them before packaging.
- Secrets from environment variables or a secret store.

## Persistence
Entities, fetching, transactions and migrations: `java-jpa`. Quarkus-specific:
- Hibernate ORM with Panache: repositories for non-trivial domains, active record only for simple CRUD; no Panache types in the domain.
- `@Transactional` on the service/use case for every write.
- `%prod.quarkus.hibernate-orm.schema-management.strategy=none` or `validate`; Dev Services default to `drop-and-create`.
- Dev Services provide databases and brokers in dev/test: don't set their URLs in `%dev`/`%test`.

## Threading model
- Plain return type runs on a worker thread; `Uni`/`Multi` on the event loop. Never block the event loop (`@Blocking` when needed).
- JDK 21+ blocking I/O: `@RunOnVirtualThread`; avoid pinning (`synchronized` before JDK 24), never pool virtual threads.

## Observability
- SmallRye Health: `@Liveness` checks only the process, `@Readiness` the dependencies.
- Metrics with Micrometer (Prometheus registry), not SmallRye Metrics; bounded tag values, ids in traces/logs.
- Tracing with `quarkus-opentelemetry`; sampler per environment; trace id in the log format.
- `quarkus.management.enabled=true` serves health and metrics on a separate port.

## Resilience
- Every outbound client (REST Client, JDBC pool, SDKs) with explicit connect and read timeouts.
- SmallRye Fault Tolerance: `@Timeout`, `@Retry` (idempotent calls only), `@CircuitBreaker`, `@Fallback`; tune values in config.

## Testing
- `@QuarkusTest` (`quarkus-junit`, formerly `quarkus-junit5`) + RestAssured with `@TestHTTPEndpoint`.
- `@InjectMock` / `@InjectSpy` (`quarkus-junit-mockito`) for CDI beans.
- `@QuarkusIntegrationTest` for a few `*IT` against the packaged artifact (no injection), run by Failsafe.
- Infrastructure through Dev Services or `QuarkusTestResourceLifecycleManager`.
- Few `QuarkusTestProfile`s: each restarts the app. Continuous testing in `quarkus dev`.

## Native/build
- No runtime reflection, dynamic proxies or classpath scanning; `@RegisterForReflection` for reflected third-party classes.
- Prefer Quarkus extensions over raw libraries; run the `*IT` suite against the `-Dnative` build.

## Common mistakes
| Mistake | Fix |
|---|---|
| Blocking call on the event loop | Blocking signature, `@Blocking` or `@RunOnVirtualThread` |
| `private` injected field | Constructor or package-private injection |
| Bean used only via `CDI.current()` vanishes | `@Unremovable` |
| `drop-and-create` in production | Migrations + `validate` |
| Runtime override of a build-time property | Set it before packaging |
| Reflection-based library fails in native | Its extension or `@RegisterForReflection` |

Sources: Quarkus 3.x guides (Apache-2.0), quarkusio/quarkus-quickstarts (Apache-2.0), github/awesome-copilot quarkus instructions (MIT), PatrickJS/awesome-cursorrules (CC0).
