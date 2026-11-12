---
name: java-reactor
description: Use when writing, reviewing or debugging Java code with Project Reactor (Mono, Flux, Sinks, WebFlux, reactive Mongo, R2DBC), including long-lived reactive pipelines, retries, backpressure, hanging or silently dying subscriptions, context/MDC propagation and StepVerifier tests.
---

# Project Reactor

## Overview
Nothing happens until subscribe. Build pipelines that describe the work, subscribe only at the edges, and make every failure either handled or visible.

## Rules
- **Never `block()`** in reactive code (only in tests and `main`). Blocking libraries go behind `Mono.fromCallable(...).subscribeOn(Schedulers.boundedElastic())`; `publishOn` only moves downstream work and does not offload a blocking source.
- JDK 21+: `-Dreactor.schedulers.defaultBoundedElasticOnVirtualThreads=true` so `boundedElastic` runs blocking work on virtual threads.
- **`subscribe()` only at the edges** (driving controllers, change-stream watchers, outbox drainers). Keep the `Disposable` and dispose it on shutdown.
- Always give `subscribe` an error consumer, or end the chain in an `onErrorResume` that logs once.
- No business side effects in `subscribe(...)` or `doOnNext(...)`: put them in the chain (`flatMap`/`concatMap` returning `Mono<Void>`). `doOn*` is for logging and metrics.
- `Mono.defer` / `Flux.defer` when something must be evaluated per subscription or retry (time, ids).
- Plain values stay plain: don't wrap in `Mono` what is synchronous and in memory.
- **Never `onErrorContinue`**: handle errors per item with `onErrorResume` inside `flatMap`/`concatMap`.

## Choosing operators
| Need | Operator |
|---|---|
| Parallel work per item | `flatMap` (set concurrency for external calls) |
| Ordered / no overlap | `concatMap` |
| Wait for independent steps | `Mono.when(...)`; `Mono.zip(...)` only if every source always emits (an empty one completes the zip empty and cancels the rest) |
| Default when empty | `switchIfEmpty(Mono.error(...))` or `defaultIfEmpty` |
| One failure must not cancel siblings | `onErrorResume` per item inside `flatMap` |
| External call backstop | `.timeout(d)` + `onErrorResume(TimeoutException.class, ...)` |
| Retry | `retryWhen(Retry.backoff(n, min).maxBackoff(max).doBeforeRetry(log))` |
| Keep a stream open forever | `retryWhen(Retry.backoff(Long.MAX_VALUE, min).maxBackoff(max).transientErrors(true))` + `repeatWhen(c -> c.delayElements(d))` |
| Release a resource on every outcome | `Mono.usingWhen(acquire, use, complete, error, cancel)` |
| Coalesce bursts | `sample(window)`, `bufferTimeout(max, window)` |
| Reuse a result | `cache(ttl)` keeps the value for later subscribers; `share()` is hot: late subscribers miss earlier items |
| Periodic polling | `Flux.interval` + `onBackpressureDrop`/`Latest`, or it fails with `OverflowException` when the consumer is slower than the tick |

## Sinks as internal event buses
- Multi-threaded producers: `sink.emitNext(e, EmitFailureHandler.busyLooping(Duration.ofMillis(100)))`, creating a **new** handler per call (never store it in a field). Never ignore a `tryEmitNext` result. Many producers: prefer one serialized producer.
- Buffers always bounded: `Sinks.many().unicast().onBackpressureBuffer(Queues.<T>get(n).get())` and handle `FAIL_OVERFLOW`; decide drop (with a metric) vs buffer.
- An in-memory sink is lost on restart: it is not an outbox. Durable outbox: see `messaging`.

## Startup
- Ordered warm-up: phases in sequence with `concatMap`, steps inside a phase in parallel with `Mono.when`, each step retried; runtime pipelines start when warm-up completes.

## Context and logging
- Enable automatic propagation (`Hooks.enableAutomaticContextPropagation()`, or the Spring Boot property where available) with `io.micrometer:context-propagation`, and register a `ThreadLocalAccessor` for MDC.
- Write values with `contextWrite`; never `MDC.put` inside operators.

## Debugging
- `checkpoint("name")` on key chains and `ReactorDebugAgent.init()` at startup; never `Hooks.onOperatorDebug()` in production.

## Tests
- `StepVerifier.create(mono).expectNext(x).verifyComplete()`; errors with `expectErrorMatches`.
- Time-based operators: `StepVerifier.withVirtualTime(() -> buildFlux())`, building the publisher **inside** the supplier; start with `expectSubscription()` before `expectNoEvent`.
- BlockHound installed in tests (`BlockHound.install()` or its JUnit integration) so blocking calls on non-blocking threads fail the build.

## Common mistakes
| Symptom | Cause |
|---|---|
| Nothing happens | Chain never subscribed (returned value ignored) |
| Pipeline stops forever after one error | Missing per-item `onErrorResume` or retry on a long-lived flux |
| Every later error waits the max backoff | `Retry.backoff` without `transientErrors(true)` |
| Hangs under load | Blocking call on a non-blocking thread (BlockHound finds it) |
| Same timestamp on every retry | Value captured outside `defer` |
| `zip` silently completes empty | One source was empty |

Sources: Project Reactor reference (Sinks, Context Propagation, Testing, Debugging), RetryBackoffSpec javadoc, reactor-core 3.6 release notes, reactor/BlockHound (all Apache-2.0).
