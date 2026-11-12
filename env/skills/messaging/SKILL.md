---
name: messaging
description: Use when producing or consuming messages with Kafka or RabbitMQ (Spring Kafka, Spring AMQP, Spring Cloud Stream, Quarkus Reactive Messaging), including listeners, retries, dead-letter queues, duplicates, ordering, consumer lag and outbox.
---

# Messaging (Kafka / RabbitMQ)

Architecture-neutral. In hexagonal projects, listeners are driving adapters that call an inbound port; publishers are driven adapters behind an outbound port.

## Message design
- Key = aggregate id. Ordering exists only per Kafka partition, or per queue with a single consumer.
- Payload is a versioned DTO (record), never a JPA entity. Only backward-compatible changes (add optional fields); a breaking change gets a new type or topic. Use the schema registry (Avro/Protobuf/JSON Schema) when there is one.
- Headers: `messageId` (UUID), `type`, `occurredAt`, `correlationId`, trace context. CloudEvents (`id`, `source`, `type`, `specversion`) is a good envelope across teams.
- Events named in the past tense (`OrderPlaced`). Small messages: send a reference when the payload is large.

## Producing
- Kafka: `acks=all` and `enable.idempotence=true` (default since Kafka 3.0; don't override). Handle the send result, never fire-and-forget.
- RabbitMQ: publisher confirms + `mandatory`/returns; persistent messages on durable queues.
- DB write + publish is not atomic. If losing the event matters, use a **transactional outbox**; otherwise publish with `@TransactionalEventListener(phase = AFTER_COMMIT)`.

## Consuming
- Delivery is at-least-once: handlers are **idempotent** (dedupe on `messageId` or natural upsert).
- Ack/commit only after processing succeeds; manual ack only when processing is async.
- Retry transient errors with exponential backoff and a cap. Validation and deserialization errors go straight to the DLQ/DLT, no retries.
- Every consumer has a DLQ/DLT, an owner and a replay procedure. Never drop or requeue forever.
- Concurrency at most the number of partitions; parallel consumers on one queue lose ordering.
- Never catch and swallow exceptions in a listener: let the error handler see them.

## Kafka
- `DefaultErrorHandler` + `DeadLetterPublishingRecoverer` with an explicit `BackOff` (the default is 10 attempts with no delay). The DLT needs at least as many partitions as the source topic.
- Wrap deserializers in `ErrorHandlingDeserializer` to stop poison-pill loops.
- `@RetryableTopic` for non-blocking retries, knowing it breaks ordering.
- `max.poll.interval.ms` above the worst-case batch time; handlers must survive rebalances.
- Exactly-once (`transactional.id`, `read_committed`) covers Kafka-to-Kafka only, not your database.

## RabbitMQ
- Quorum queues by default; they have a `delivery-limit`.
- DLX on every queue. Spring AMQP: throw `AmqpRejectAndDontRequeueException` or set `defaultRequeueRejected=false`.
- Set `prefetch` deliberately (start between 10 and 250).
- Spring Cloud Stream: retry/DLQ through binder properties, not by hand. Quarkus: `@Incoming`/`Emitter`, `failure-strategy=dead-letter-queue`.

## Observability
- Alert on consumer lag / queue depth, DLQ size > 0, retry rate and handler latency.
- Propagate trace context in headers (Micrometer observation enabled).
- Log `messageId`, key and topic; never personal data from the payload.

## Testing
- Integration tests with Testcontainers (`@ServiceConnection`, pinned image); `@EmbeddedKafka` only for fast Kafka tests.
- Wait with Awaitility, never `Thread.sleep`.
- Test duplicates, a poison message reaching the DLQ, and the retry path.
- The message schema is a contract: compatibility check in CI (registry or consumer-driven contract).

## Common mistakes
| Mistake | Fix |
|---|---|
| Publishing inside the DB transaction | Outbox or AFTER_COMMIT |
| Non-idempotent handler | Dedupe on `messageId` |
| Poison message requeued forever | DLQ/DLT + not-retryable exceptions |
| Random or missing key | Key = aggregate id |
| Concurrency > partitions | Match partitions |
| Entity as payload | Versioned DTO |
| No alert on the DLQ | Monitor DLQ size |

Sources: spring-kafka and Spring AMQP reference (Apache-2.0), Confluent and RabbitMQ docs, microservices.io transactional outbox, CloudEvents spec, github/awesome-copilot java-springboot references (MIT).
