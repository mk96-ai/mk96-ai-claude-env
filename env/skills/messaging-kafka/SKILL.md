---
name: messaging-kafka
description: Use when producing or consuming Kafka records (Kafka clients, Spring for Apache Kafka, Spring Cloud Stream Kafka binder, Quarkus SmallRye Reactive Messaging Kafka), or facing key and partition choice, ordering, consumer groups, offset commits, rebalances, poison pills, dead-letter or retry topics, exactly-once, schema registry or consumer lag.
---

# Kafka

## Overview
Kafka specifics only; common rules: `messaging`.

## Topics, keys, ordering
- Order exists only within a partition: key = aggregate id. A null key spreads records with no order.
- Partitions cap parallelism; adding them remaps keys: size up front.
- Important topics: replication factor 3, `min.insync.replicas=2`.
- Compacted topics for latest state per key.

## Producer
- Keep the defaults `acks=all`, `enable.idempotence=true` (Kafka 3.0+); conflicting settings silently disable idempotence unless set explicitly.
- Handle the send result (`CompletableFuture` in Spring Kafka 3+).
- Transactions (`transactional.id`, readers `read_committed`) cover Kafka-to-Kafka only, never a database or HTTP call.

## Consumer
- One group per logical subscriber; concurrency ≤ partitions.
- Commit offsets after processing; no auto-commit with async processing.
- `max.poll.interval.ms` above `max.poll.records` × worst handler time, or eviction and rebalance redeliver records.
- Partition-bound state needs a `ConsumerRebalanceListener`. Kafka 4.x: the new rebalance protocol is opt-in via `group.protocol=consumer`.
- Choose `auto.offset.reset` deliberately for new groups.

## Errors: Spring Kafka
- `DefaultErrorHandler` + `DeadLetterPublishingRecoverer` with an explicit `BackOff`; the default is 10 attempts, no delay. Mark permanent errors with `addNotRetryableExceptions`.
- The default DLT is `<topic>-dlt` on the same partition: it needs at least as many partitions as the source.
- Wrap deserializers in `ErrorHandlingDeserializer`, or a poison pill loops forever.
- `@RetryableTopic` gives non-blocking retries but breaks per-key order; not for batch listeners or container transactions.
- Spring Cloud Stream: `maxAttempts`/`backOff*` plus `enableDlq` (topic `error.<destination>.<group>`), not hand-made.

## Errors: Quarkus SmallRye
- `failure-strategy` defaults to `fail` (channel stops): set `dead-letter-queue` or `delayed-retry-topic` per channel.
- Default `commit-strategy=throttled` marks the app unhealthy when a record stays unacked too long: always ack or nack.
- Deserialization failures: a `DeserializationFailureHandler`, or `fail-on-deserialization-failure=false` plus the DLQ.

## Schema registry
- Avro, Protobuf or JSON Schema with a compatibility mode (`BACKWARD` default, or stricter).
- Register schemas from CI; `auto.register.schemas=false` in production.

## Monitoring
- Consumer lag per group and partition, in records and time (`records-lag-max`, exporter or Burrow).
- Alert on rebalance rate and send errors.

## Testing
- Testcontainers `org.testcontainers.kafka.KafkaContainer` (pinned `apache/kafka-native` or `apache/kafka`) with `@ServiceConnection`; Dev Services in Quarkus.
- `@EmbeddedKafka` only for fast Spring Kafka tests.

## Common mistakes
| Mistake | Fix |
|---|---|
| Random or missing key | Key = aggregate id |
| Concurrency > partitions | Match partitions |
| Default `BackOff` | Explicit backoff + not-retryable list |
| DLT with fewer partitions | Same count or custom resolver |
| Poison pill loop | `ErrorHandlingDeserializer` |
| Slow handler, rebalance storm | Raise `max.poll.interval.ms` or lower `max.poll.records` |
| Exactly-once assumed for the DB | Idempotent handler |

Sources: Apache Kafka 4.x docs (apache/kafka ~34k stars, Apache-2.0), Spring for Apache Kafka reference (~2.5k stars, Apache-2.0), Spring Cloud Stream Kafka binder docs, SmallRye Reactive Messaging Kafka docs (Apache-2.0), Confluent docs and KIP-848 blog, github/awesome-copilot java-springboot (~41k stars, MIT).
