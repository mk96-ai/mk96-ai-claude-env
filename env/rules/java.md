---
paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/build.gradle*"
  - "**/settings.gradle*"
  - "**/libs.versions.toml"
---

# Java

Pure Java, on top of `coding.md`. Framework and architecture come from skills.

## Framework
- Use the framework the project's `CLAUDE.md` names (skills: `java-spring`, `java-quarkus`, `java-desktop-javafx`; plus `java-jpa`, `api-rest`, `messaging` (with `messaging-kafka` / `messaging-rabbitmq`), `java-reactor` when the project uses them).
- New project or unclear: ask (Spring Boot, Quarkus, JavaFX, plain Java). Never pick one silently.

## Naming
- Packages: lowercase, no separators (`com.acme.orderbilling`).
- Types: UpperCamelCase nouns (`Invoice`, `PaymentGateway`). Enum constants UPPER_SNAKE_CASE. Exceptions end in `Exception`.
- Acronyms as words: `HttpClient`, `customerId`, never `HTTPClient` / `customerID`.
- No `I` prefix, no Hungarian notation (`mName`, `strName`).
- `Impl` suffix only when it makes sense: the interface exists to document a contract (e.g. a REST controller interface carrying the OpenAPI/Swagger annotations: `OrderController` + `OrderControllerImpl`), or there is a single implementation that does not depend on a technology (typically application inputs/controllers). When the implementation is tied to a technology or there are several, name the variant instead (`OrderMongoAdapter`, `InMemoryOrderRepository`).
- Methods: lowerCamelCase verbs (`calculateTotal`). Booleans as questions (`isActive`, `hasLines`, `canRetry`).
- Conversions: `toX` returns a new object, `asX` a view. Factories: `of` (several params), `from` (one param to convert), `create` (new instance each call).
- Records: accessors are the component name (`order.total()`); `getX`/`setX` only where a tool needs JavaBeans.
- Variables: lowerCamelCase nouns; collections plural (`orders`); maps `valueByKey` (`priceBySku`). One-letter names only for loop indexes and short lambdas.
- Constants: `static final` and deeply immutable → UPPER_SNAKE_CASE. Otherwise lowerCamelCase.
- Generic params: one capital letter (`T`, `K`, `V`).
- Tests: `<ClassUnderTest>Test`, integration `<Feature>IT`. Methods as behavior sentences: `rejectsAnOrderWithoutLines`, `whenPaymentFails_orderStaysPending`.

## Language
- **Never use `var`.** Always declare the explicit type.
- Use the declared Java version's features: records for immutable data, `switch` with pattern matching, text blocks, sealed types for closed hierarchies.
- Immutability by default: `final` fields, records, defensive copies of mutable inputs/outputs (`List.copyOf`).
- Never return `null` for collections. `Optional` only as a return type. `Objects.requireNonNull(arg, "arg")` at public boundaries.
- `equals` and `hashCode` together, from the same immutable fields; prefer a record for value types.
- Declare by interface (`List`, `Map`). Composition over inheritance; classes `final` unless designed for extension.
- No raw types; bounded wildcards in API parameters (`? extends` to read, `? super` to write).
- Money and exact decimals: `BigDecimal`. Time: inject `java.time.Clock`, never `Instant.now()` in logic.
- Streams when they read better than a loop; no side effects inside `map`/`filter`.
- Every `AutoCloseable` in try-with-resources.
- No wildcard imports. `@Override` always. One top-level type per file. Member order: constants, fields, constructors, public methods, private helpers; overloads together.
- Javadoc on public/protected API with a one-line summary.

## Lombok
- Projects with Lombok: use it for everything it can generate instead of writing it by hand: `@Getter`/`@Setter`, `@EqualsAndHashCode`, `@ToString`, `@RequiredArgsConstructor`/`@AllArgsConstructor`, `@Builder`, `@Data` where it makes sense, `@Slf4j` (instead of declaring the logger). The rules in this file still apply; Lombok only writes the code for you.
- Projects without Lombok: write it by hand and don't add Lombok without asking.
- New projects: ask whether to use Lombok.

## Exceptions
- Unchecked for programming errors (`IllegalArgumentException`, `IllegalStateException`); checked only when the caller can recover. Custom exceptions only when a caller handles them differently.
- Always pass the cause when wrapping. Never catch `Throwable`/`Error`.
- Translate exceptions at the edges (REST, messaging, UI), not in the domain.

## Concurrency
- `java.util.concurrent` only (executors, concurrent collections); no raw `Thread`/`wait`/`notify`.
- Blocking I/O on JDK 21+: virtual threads (`newVirtualThreadPerTaskExecutor`), never pooled; limit downstream calls with a `Semaphore`.
- On `InterruptedException`, restore the flag: `Thread.currentThread().interrupt()`.

## Logging
- SLF4J: one logger per class (`@Slf4j` with Lombok, otherwise `private static final Logger log`), `{}` placeholders, exception as last argument (not `e.getMessage()`).

## Tests
- JUnit 5 + AssertJ + Mockito. Test packages mirror main ones; builders/fixtures in a `fixture` package.
- Mock only ports and external systems, never the class under test or value objects.
- Layer rules enforced with ArchUnit when the project uses it.

## Build (Maven or Gradle)
- Use the wrapper (`./mvnw`, `./gradlew`) when present.
- Java release and UTF-8 encoding set explicitly; never use features newer than the declared release.
- One version per library: parent `dependencyManagement` / BOM (Maven) or version catalog (Gradle). Child modules declare no versions. Plugin versions pinned.
- Correct scopes (test libs in test, drivers and logging backends at runtime). Exactly one SLF4J backend.
- Version conflicts: find who brings it (`dependency:tree` / `dependencyInsight`), then override with a comment; no random excludes.
- Annotation processors (Lombok, MapStruct) declared explicitly.
- Release builds have no `SNAPSHOT` dependencies.
- Don't change JDK, plugin or dependency versions as a side effect of another task.
- Verify with `./mvnw -B verify` or `./gradlew build`.

Sources: Google Java Style Guide (CC-BY, paraphrased), Effective Java 3rd ed., github/awesome-copilot java-development (MIT).
