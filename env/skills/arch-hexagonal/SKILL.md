---
name: arch-hexagonal
description: Use when creating, extending or reviewing a service or app that follows hexagonal architecture (ports and adapters, domain/application/infrastructure layers), or when the project's CLAUDE.md names this skill. Covers package layout, class naming and dependency rules.
---

# Hexagonal architecture (ports and adapters)

## Overview
Business logic in the center, technology at the edges. The domain declares what it needs (ports); infrastructure plugs technology into it (adapters). Every layer is sliced by the **same feature names**.

**Good fit for:** APIs, microservices and long-lived services with several integrations (databases, external systems, messaging) and business rules worth isolating; also desktop apps whose logic must outlive the UI technology. Typical stacks: Spring Boot, Quarkus, JavaFX/Swing apps.

## Package layout
```
com.example.<service>
├── domain
│   ├── model/<feature>          entities, value objects, requests, events
│   ├── port/<area>              OUTBOUND ports: what the domain needs (persistence, external systems)
│   └── service/<feature>        INBOUND ports: what the outside can ask (interfaces)
├── application/<feature>        use cases implementing the inbound ports
│   ├── helper/                  collaborators of a use case (not use cases themselves)
│   └── event/                   publishers, outboxes, validators of the feature
├── infrastructure
│   ├── controller               DRIVING adapters
│   │   ├── rest/<feature>       REST controllers
│   │   ├── runtime/<feature>    event listeners, schedulers, reactive pipelines
│   │   └── startup[/impl/<group>]  ordered warm-up steps
│   ├── gateway/<system>         DRIVEN adapter for an external system
│   │   ├── config/  mapper/  <operation>/   (one handler per operation)
│   └── persistence/<tech>/<feature>/{adapter,document|entity,mapper,repository}
│       └── persistence/<tech>/config
├── config/<concern>             @Configuration that builds plain domain objects as beans
└── util/                        technical helpers (retry, tickers)
```

## Naming
| Role | Name | Package |
|---|---|---|
| Inbound port | `OrderService` (interface) | `domain/service/order` |
| Use case | `OrderUseCase implements OrderService` | `application/order` |
| Outbound port | `OrderPersistencePort`, `PaymentGatewayPort` | `domain/port/...` |
| Persistence adapter | `OrderMongoAdapter`, `OrderPostgresqlAdapter` | `infrastructure/persistence/...` |
| Gateway adapter | `PaymentHttpAdapter` + `ChargeHandler` per operation | `infrastructure/gateway/payment` |
| Stored shape | `OrderDocument` / `OrderEntity` | `.../document` or `.../entity` |
| Repository | `OrderRepository` | `.../repository` |
| Mapper | `OrderDocumentMapper`, `OrderEntityMapper`, `OrderDomainMapper` | next to the adapter |
| Controllers | `OrderGetRestController`, `OrderEventController`, `OrderSchedulerController`, `OrderCacheStartupController` | `infrastructure/controller/...` |
| Port input | `ChargeOrderRequest` | `domain/model/<feature>` |
| Event | `OrderChangeEvent` | `domain/model/<feature>` |

- No `I` prefix. Inbound port and use case are told apart by package + suffix (`*Service` / `*UseCase`), not by `Impl`.
- `Impl` is fine for a documented contract with a single technology-free implementation, e.g. a REST controller interface with the OpenAPI annotations (`OrderGetRestController` + `OrderGetRestControllerImpl`). Technology-bound adapters name their technology instead (`OrderMongoAdapter`).

## Dependency rules
- `domain` imports nothing from `application`, `infrastructure`, `config`, Spring or persistence libraries (no driver/DB types in models or events).
- `application` imports `domain` only (Spring stereotypes allowed).
- Controllers call **inbound ports** (`*Service`), never use cases directly.
- Adapters implement **outbound ports** and are the only place that maps to/from documents, entities and DTOs.
- A feature does not call another feature's use case or helper: go through its inbound port.
- No static singletons or service locators: dependencies are injected.
- Allowed by default: Reactor types (`Mono`/`Flux`) in port signatures, Lombok in models.

## Where behavior goes
- **Rich model**: state changes and their rules are methods on the domain model (`order.cancel(clock)`). The use case only orchestrates: load through a port, call the model, save, publish. A use case full of `if` on getters followed by setters is an anemic model.
- **Validation in three places**:
  - Input format (required, size, pattern): on the request DTO at the controller (Bean Validation).
  - Invariants: in the constructors/factories of domain models, failing fast; no validation library in `domain`.
  - Rules that need data from a port: in the use case.
- **Transaction boundary is the use case** (`@Transactional`, or `TransactionalOperator` in reactive code), never the controller or the adapter. One use case changes one aggregate per transaction; side effects on other features or systems go through events or the outbox after commit.

## Errors at the edge
- REST services: `domain` and `application` signal business failures with meaningful exceptions (`OrderNotFoundException`, `OrderAlreadyShippedException`), never HTTP types (`ResponseStatusException`, status codes).
- One `@RestControllerAdvice` in `infrastructure/controller/rest` maps each one to its HTTP status with a single error body format; anything unmapped is a 500.
- Services without an HTTP edge (daemons, pipelines) may instead collect errors in the request object (notification pattern) and let callers branch on it.

## Testing each layer
| Layer | Test |
|---|---|
| Domain models | Plain unit tests: no Spring, no mocks |
| Use cases | Unit tests with outbound ports mocked or faked |
| Persistence adapters | Against an embedded or containerised database |
| Gateways | Against a stubbed external system (e.g. WireMock) |
| REST controllers | Web slice test mocking the inbound `*Service` |
| Architecture | One ArchUnit test: `domain` depends only on JDK/Reactor/Lombok; `application` does not depend on `infrastructure`; `..controller..` does not depend on `*UseCase` |

## Common mistakes
| Mistake | Fix |
|---|---|
| Mapping inside the use case | Move it to the adapter's mapper |
| Domain event exposing a DB enum | Domain enum + mapping in the adapter |
| `Instant.now()` in domain/use case | Inject `Clock` |
| Controller injecting `OrderUseCase` | Inject `OrderService` |
| Rules only in people's heads | Add the ArchUnit test above |
| `@Transactional` on a controller or adapter | Move it to the use case |
