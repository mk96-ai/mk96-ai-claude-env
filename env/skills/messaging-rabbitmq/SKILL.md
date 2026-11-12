---
name: messaging-rabbitmq
description: Use when producing or consuming RabbitMQ/AMQP messages (Spring AMQP, Spring Cloud Stream Rabbit binder, Quarkus SmallRye RabbitMQ), or designing exchanges, queues and bindings, or facing quorum queues, publisher confirms, unroutable messages, acks, prefetch, dead-letter exchanges, redelivery loops, ordering, single active consumer, streams or queue depth.
---

# RabbitMQ

## Overview
RabbitMQ specifics only; common rules: `messaging`.

## Topology
- Publish to exchanges, never straight to a queue: direct for commands, topic for events (`order.placed`), fanout for broadcast.
- One queue per consuming service; its instances compete on it.
- Declare exchanges, queues and bindings in code or a definitions file; no exclusive or auto-delete queues for important data.
- Quorum queues by default (`x-queue-type=quorum`). Classic only for temporary queues; streams for huge backlogs, replay or large fan-out.

## Publishing
- Persistent messages on durable or quorum queues.
- Publisher confirms and returns: Spring Boot `publisher-confirm-type=correlated`, `publisher-returns=true`, `template.mandatory=true`; check the `CorrelationData` future and its returned message.
- Resend unconfirmed messages; route unroutable ones to returns or an alternate exchange.

## Consuming
- Ack after processing (Spring `AUTO`, Quarkus default); never `NONE` for important data.
- Set prefetch deliberately: 100-300 is a usual start (Spring default 250), lower for slow handlers, never 0 (unlimited).
- Spring AMQP requeues failed messages by default: an endless redelivery loop. Set `default-requeue-rejected=false` or throw `AmqpRejectAndDontRequeueException` for permanent errors.
- Retries: `spring.rabbitmq.listener.simple.retry.*` (in-process, holds the consumer) then reject to the DLX; `RepublishMessageRecoverer` keeps the stack trace. A recoverer that acks bypasses the DLX.
- Longer delays: TTL wait queue that dead-letters back to the work queue, not requeue.
- Spring Cloud Stream: `autoBindDlq`, `republishToDlq` binder properties. Quarkus: `failure-strategy=reject` (default, no requeue) with `auto-bind-dlq=true`, `queue.x-queue-type=quorum`, `max-outstanding-messages`.

## Dead letters
- `x-dead-letter-exchange` (plus routing key) on every queue.
- Quorum `delivery-limit` defaults to 20 (RabbitMQ 4.0+); beyond it the message is **dropped** without a DLX.
- DLQ loss matters: `dead-letter-strategy=at-least-once` with `overflow=reject-publish`.

## Ordering
- Order holds only for one queue and one consumer; requeues, prefetch with concurrency or several consumers break it.
- Ordered processing with failover: single active consumer (`x-single-active-consumer`); exclusive consumers aren't supported on quorum queues.

## Monitoring
- Prometheus plugin: queue depth, unacked count, DLQ depth, redelivery rate, consumer count, publish vs. confirm rate.
- Alert on memory/disk alarms (publishers block).

## Testing
- Testcontainers `RabbitMQContainer` (pinned `rabbitmq:<version>-management`) with `@ServiceConnection`; Dev Services in Quarkus.
- Assert a poison message ends in the DLQ, not in a redelivery loop.

## Common mistakes
| Mistake | Fix |
|---|---|
| Default requeue on exception | Reject without requeue + DLX |
| Quorum queue without DLX | Messages dropped at `delivery-limit`: add DLX |
| No confirms or `mandatory` | Confirms + returns |
| Prefetch 0 or 1 by habit | Tune, start 100-300 |
| Competing consumers expecting order | Single active consumer |
| Classic mirrored queues | Quorum queues |

Sources: RabbitMQ 4.x docs: quorum queues, confirms, consumer acks, prefetch, DLX, reliability guide (rabbitmq-server ~14k stars, MPL-2.0); Spring AMQP reference (Apache-2.0); SmallRye/Quarkus RabbitMQ connector docs (Apache-2.0); github/awesome-copilot java-springboot (~41k stars, MIT).
