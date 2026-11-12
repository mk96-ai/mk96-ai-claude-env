---
name: java-jpa
description: Use when writing or reviewing JPA/Hibernate entities, mappings, associations or JPQL/HQL queries, or facing N+1 queries, LazyInitializationException, slow queries or inserts, OptimisticLockException, entity equals/hashCode problems or schema migrations (Flyway/Liquibase), in any Java framework.
---

# JPA / Hibernate

## Overview
Load exactly what each use case needs, inside a short transaction; migrations own the schema. Framework wiring (repositories, Panache, config keys, test slices): `java-spring` / `java-quarkus`. Check the Hibernate version: 7.x implements Jakarta Persistence 3.2.

## Entities and ids
- Protected no-arg constructor; entity classes and fields not `final` (proxies subclass them).
- Generated ids: `SEQUENCE` with `allocationSize` equal to the sequence increment; `IDENTITY` disables insert batching. Time-ordered UUIDs when the id is created in code.
- `@Enumerated(EnumType.STRING)`; value objects as `@Embeddable` or `AttributeConverter`.
- Never expose entities in API responses or messages: map to DTOs inside the transaction.

## equals, hashCode, toString
- Natural key (`@NaturalId`) or UUID assigned at construction: base both methods on it.
- Generated id: `equals` only when both ids are non-null and equal; `hashCode` a per-class constant (stable across persist); resolve proxy classes.
- Associations and lazy fields never take part in `equals`, `hashCode` or `toString`.
- Lombok `@Data` is fine with `@EqualsAndHashCode(onlyExplicitlyIncluded = true)` + `.Include` on the natural key/UUID and `@ToString(onlyExplicitlyIncluded = true)` on basic fields. Generated id: hand-write `equals`/`hashCode` (Lombok makes two new entities equal).

## Associations and fetching
- `fetch = LAZY` on every `@ManyToOne`/`@OneToOne` (default EAGER); choose fetching per query.
- `@ManyToOne` owns the relation; `@OneToMany(mappedBy)` only when needed, with helpers syncing both sides. `Set` for `@ManyToMany`.
- Cascade/`orphanRemoval` only from parent to owned children; never `REMOVE` on `@ManyToOne`/`@ManyToMany`.
- N+1: `join fetch` or an entity graph, at most one collection per query; `hibernate.default_batch_fetch_size` (~16) as safety net.
- `LazyInitializationException`: fetch inside the transaction; open-session-in-view off, never `enable_lazy_load_no_trans`.
- Read models: DTO projections (constructor expression or record).

## Queries and pagination
- Bound parameters only.
- Stable `ORDER BY` with a unique tiebreaker; keyset for deep pages.
- Never paginate a collection `join fetch` (paged in memory, HHH90003004): page ids, then fetch.
- Bulk `update`/`delete` bypass the persistence context and `@Version`: clear it afterwards.

## Transactions and persistence context
- Short transactions at the service; no remote calls inside.
- Managed entities are dirty-checked at flush: no `save`/`merge` needed; `merge` only for detached ones.
- Read-only transactions for reads (no dirty-check snapshots).
- `@Version` on concurrently edited entities; `OptimisticLockException` becomes a retry or 409.
- Batching: `hibernate.jdbc.batch_size` (20-50) + `order_inserts`/`order_updates`; flush and clear per batch, or `StatelessSession`.

## Schema and tests
- Flyway/Liquibase own the schema; Hibernate schema action `validate` or `none`.
- Test against the real engine with Testcontainers, not H2, in the narrowest persistence slice; assert statement counts on hot paths.

## Common mistakes
| Mistake | Fix |
|---|---|
| EAGER to-one | `LAZY` + fetch per query |
| Lombok `equals`/`toString` over associations | Explicit includes only |
| `hashCode` from a generated id | Per-class constant or natural key |
| `setMaxResults` with collection fetch join | Page ids, then fetch |
| `IDENTITY` for bulk inserts | `SEQUENCE` + batching |
| Lost updates | `@Version` |
| Schema `update` in production | Migrations + `validate` |

Sources: Hibernate ORM 7.x user guide (hibernate-orm ~6.5k stars, Apache-2.0), Jakarta Persistence 3.2, Vlad Mihalcea articles + hypersistence-utils (~2.7k, Apache-2.0), Thorben Janssen articles, github/awesome-copilot java-hibernate-jpa (~41k, MIT).
