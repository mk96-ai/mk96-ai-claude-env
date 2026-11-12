---
name: java-spring
description: Use when building or changing any Spring Boot application (dependency injection, configuration properties, profiles, JPA/Spring Data, Actuator, metrics, tracing, timeouts, Spring tests, Testcontainers), whatever its architecture.
---

# Spring Boot

Applies to any architecture: layout and naming come from the architecture skill. REST APIs (`api-rest`), messaging (`messaging`) and Reactor (`java-reactor`) have their own skills. Check the project's Spring Boot version first: 3.x and 4.x differ in test starters and some APIs.

## Wiring
- Constructor injection with `final` fields (Lombok `@RequiredArgsConstructor` when available). Never field or setter injection.
- Stereotype annotations only on your own classes; third-party types via `@Bean` methods in `@Configuration` classes.
- Several candidates: `@Qualifier` or a distinct type; `@Primary` only for a real default.
- Optional beans and feature switches with `@ConditionalOnProperty(name = "<app>.<feature>.enabled", matchIfMissing = true)`, never `if (profile)` in code.
- `@Transactional`, `@Async`, `@Cacheable`, `@Retryable` work through proxies: self-invocation and `private` methods bypass them.
- Mapping with MapStruct (`componentModel = "spring"`); hand-written mapper only when MapStruct gets in the way.

## Configuration & profiles
- Own keys grouped in `@ConfigurationProperties` records, `@ConfigurationPropertiesScan`, plus `@Validated` and constraints so bad config fails at startup (nested objects need `@Valid`).
- `Duration` / `DataSize` types (`30s`, `10MB`); defaults with `@DefaultValue`.
- `@Value` only for a single key outside your own groups, in kebab-case.
- One `application.yml` with safe defaults; profiles only for environment differences.
- Secrets from environment variables or a secret store, never in YAML.

## Persistence
Entities, fetching, transactions and migrations: `java-jpa`. Spring-specific:
- `spring.jpa.open-in-view=false` (Boot enables it by default) and `spring.jpa.hibernate.ddl-auto=validate` or `none`.
- `@Transactional` on the service/use case, `readOnly = true` for queries.
- Spring Data repositories: `@EntityGraph` or `@Query` with `join fetch` against N+1, interface/record projections for read models, `:param` bound parameters.
- `Pageable` for unbounded reads, without leaking Spring Data types into the domain.

## Observability
- Expose only needed endpoints (`health,info,prometheus`); separate `management.server.port` when the app is public.
- Liveness/readiness probes on Kubernetes; external dependencies never in liveness.
- Metric tags with bounded values only (status, outcome, operation); ids go to traces or logs.
- Custom timings with `Observation` / `@Observed`; don't re-instrument what Spring already measures.
- Tracing with Micrometer Tracing + exporter; sampling probability per environment; `traceId` in the log pattern.

## Resilience
- Every outbound client (RestClient, WebClient, JDBC pool, SDKs) with explicit connect and read timeouts.
- Retry only idempotent calls, with backoff and max attempts (Resilience4j or Spring Retry); circuit breaker for flaky dependencies.
- JDK 21+ servlet stack: `spring.threads.virtual.enabled=true` instead of tuning thread pools.

## Testing
- Plain unit tests for logic. Narrowest slice for Spring parts: `@WebMvcTest`, `@DataJpaTest`, `@JsonTest`, `@RestClientTest`. `@SpringBootTest` only for a few end-to-end `*IT`.
- `@MockitoBean` / `@MockitoSpyBean` (`@MockBean` is deprecated since 3.4).
- Real infrastructure with Testcontainers + `@ServiceConnection`; static or `@Bean` containers.
- Conditional beans and auto-config with `ApplicationContextRunner`.
- Uniform test configuration so contexts are cached; avoid `@DirtiesContext`.

## Common mistakes
| Mistake | Fix |
|---|---|
| Lazy loading in the controller/serializer | `open-in-view=false`, fetch in the transaction |
| `@Transactional` on a self-called or private method | Public method on another bean |
| Ids as metric tags | Bounded tags; ids in traces/logs |
| `exposure.include=*` in production | Explicit list, separate port |
| Client without timeouts | Explicit connect/read timeouts |
| H2 standing in for Postgres | Testcontainers + `@ServiceConnection` |
| `@Value` scattered across classes | Properties record |

Sources: Spring Boot reference documentation (Apache-2.0), github/awesome-copilot springboot instructions and spring-boot-testing skill (MIT), spring-projects/spring-petclinic.
