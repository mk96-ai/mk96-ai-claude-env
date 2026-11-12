---
name: arch-mvc
description: Use when creating, extending or reviewing an application organised as model-view-controller (MVC), or when the project's CLAUDE.md names this skill.
---

# Model-View-Controller (MVC)

## Overview
The **controller** handles user actions, calls the service and picks the view; the **service** holds the business rules; the **model** holds the data; the **view** renders model data; the **repository** talks to storage.

**Good fit for:** small apps driven by their UI, server-rendered web apps, simple desktop or tray apps and internal tools, with one storage and few business rules. Typical stacks: Spring MVC with templates, JavaFX/Swing apps, Python GTK apps, Express apps.

## Package layout (by layer, then feature)
```
com.example.<app>
├── model/<feature>          entities, value objects, enums (Order, OrderLine)
├── service/<feature>        business rules and transactions (OrderService)
├── repository/<feature>     persistence: database, files, external storage (OrderRepository)
├── view/<feature>           screens, pages, templates, components, view models
├── controller/<feature>     handles user actions, calls the service, picks the view
└── config/                  wiring, settings
```
Same idea in Python/JS: `model/`, `service/`, `repository/`, `view/`, `controller/` folders with one sub-folder or file per feature. If the framework imposes its own layout (Rails, Laravel), the framework wins.

## Naming
| Role | Name |
|---|---|
| Entity / value | `Order`, `OrderLine` |
| Business rules | `OrderService` |
| Storage access | `OrderRepository` |
| Controller | `OrderController` |
| View | `OrderListView`, `OrderDetailView` (web templates: `order-list.html`) |
| Form input | `OrderForm` (only the fields the user may set) |
| View model | `OrderViewModel`: plain data shaped for one view, no behavior or binding |

## Dependencies
- Controller → service and controller → view.
- View reads the model data it is given or observes; it never changes it.
- `*Service` → repository. **Only services call repositories**: not controllers, not views, not entities.
- Model and service never depend on views or controllers.

## Rules
- **Service**: all business rules live here (`OrderService`), never in controllers or views. No UI types (colors, widgets, HTML).
- **Model**: data and its own invariants (entities, value objects); no persistence or UI code.
- **Repository**: the only place with persistence connections and queries.
- **Controller** is thin: bind input, validate format, call the service, choose the view or response. No storage access, no business decisions.
- **View**: renders data and emits user events. No rules, no repository calls.
- Bind user input to a form object with only the allowed fields; never bind directly into entities.
- Transactions start and end in the `*Service`.
- Errors handled in one place (`@ControllerAdvice`, Express error middleware) and mapped to an error view or status.
- Web: after a successful POST, redirect (Post/Redirect/Get).
- Desktop: long work off the UI thread; views updated only on it (JavaFX `Platform.runLater`, Swing `invokeLater`, `GLib.idle_add`).
- One controller per feature; split when it handles unrelated screens.

## Tests
- Services: unit tests with the repository mocked (the most valuable).
- Repositories: against a real or embedded storage.
- Controllers: with the service mocked (e.g. `@WebMvcTest`).
- Views: only a few end-to-end checks.

## Common mistakes
| Mistake | Fix |
|---|---|
| "Fat controller" with rules and queries | Rules to `*Service`, queries to `*Repository` |
| Controller calling the repository | Go through the `*Service` |
| Form posted straight into an entity | Bind to an `*Form` with allowed fields |
| Service or model building SQL or opening files | Move it to the `*Repository` |
| View querying data itself | The controller passes the data in |
| Shared "utils" holding business rules | Move them to the feature's `*Service` |
