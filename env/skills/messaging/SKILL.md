---
name: messaging
description: Use when producing or consuming asynchronous messages or events through any broker (Kafka, RabbitMQ or others), including event and payload design, publishing after a database write, transactional outbox, duplicates, idempotent consumers, retries, dead-letter queues, ordering, replay and message contract tests.
---

# Messaging

## Overview
Delivery is at-least-once: design for loss, duplicates and reordering. Broker specifics: `messaging-kafka`, `messaging-rabbitmq`. Hexagonal: listeners are driving adapters, publishers sit behind an outbound port.

## Message design
- Events in the past tense (`OrderPlaced`); commands imperative, one owner.
- Payload is a versioned DTO (record), never a persistence entity. Only backward-compatible changes; breaking ones get a new type or destination.
- Metadata in headers: `messageId` (UUID), `type`, `occurredAt`, `correlationId`, trace context. CloudEvents is a good envelope across teams.
- Key or routing key = aggregate id when per-entity order matters.
- Large payloads: send a reference (claim check).

## Producing
- Never publish inside the database transaction: rollback leaves a phantom event, a crash loses it.
- Loss is unacceptable → **transactional outbox**: store the event in the same transaction; a relay (polling or CDC, e.g. Debezium) publishes it.
- Loss is acceptable → publish after commit: Spring `@TransactionalEventListener(phase = AFTER_COMMIT)`, CDI `@Observes(during = TransactionPhase.AFTER_SUCCESS)`.
- Wait for the broker acknowledgement and handle failure; never fire-and-forget.

## Consuming
- Idempotent handlers: dedupe on `messageId` (processed-ids table in the effect's transaction) or natural upsert.
- Acknowledge only after the work and its commit succeeded.
- Tolerate reordering: ignore messages older than the stored version.
- Never swallow exceptions in a listener: the error handler decides.

## Retries and dead letters
- Transient errors (timeout, 5xx, lock): retry with exponential backoff, jitter and a cap.
- Permanent errors (validation, deserialization, unknown type): dead-letter at once, no retries.
- Never retry or requeue forever: a poison message blocks or loops.
- Every consumer has a dead-letter destination with owner, alert and replay procedure; keep original headers and error cause.
- Retries that move a message aside (retry topics, delay queues) break ordering.

## Observability
- Alert on backlog growth (lag, queue depth), dead letters > 0, retry rate, handler latency.
- Propagate trace context in headers.
- Log `messageId`, key and destination, never payload personal data; ids never as metric tags.

## Testing
- Integration tests against a real broker (Testcontainers, pinned image); wait with Awaitility, never `Thread.sleep`.
- Cover duplicates, a poison message reaching the dead letter, retries and the outbox relay.
- Schema compatibility check in CI (registry or consumer-driven contracts).

## Common mistakes
| Mistake | Fix |
|---|---|
| Publishing inside the DB transaction | Outbox or after-commit |
| Non-idempotent handler | Dedupe on `messageId` |
| Ack before the work commits | Ack after success |
| Poison message retried forever | Classify errors, dead-letter |
| Entity as payload | Versioned DTO |
| Dead letters nobody watches | Owner, alert, replay |

Sources: microservices.io transactional outbox and idempotent consumer patterns, CloudEvents spec (CNCF, Apache-2.0), RabbitMQ reliability guide, Confluent docs, github/awesome-copilot java-springboot messaging reference (~41k stars, MIT).
