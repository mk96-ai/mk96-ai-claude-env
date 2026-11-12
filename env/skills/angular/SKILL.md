---
name: angular
description: Use when building, changing, reviewing or upgrading an Angular application (components, templates, signals, change detection, forms, routing, lazy loading, dependency injection, services, HttpClient, SSR/hydration, Angular tests).
---

# Angular

Markup/CSS/a11y: `frontend-web`; visual design: `ux-design`; TypeScript: the JS/TS rule; API contracts: `api-rest`. Check `@angular/core` in `package.json` first and follow what the project already uses.

## Version defaults (current major: v22)
| Feature | Default from | On older versions |
|---|---|---|
| Standalone | v19 | `standalone: true`, no new NgModules |
| Zoneless | v21 (new apps) | Opt in with `provideZonelessChangeDetection()` |
| OnPush | v22 (old default renamed `Eager`) | Set `ChangeDetectionStrategy.OnPush` |
| Vitest runner | v21 | Karma/Jasmine; CLI migration available |
| Signal Forms, `resource`/`httpResource` stable | v22 (experimental v21) | Typed Reactive forms, HttpClient |
| `@Service()` | v22 | `@Injectable({ providedIn: 'root' })` |

Never write a default explicitly (`standalone: true` on v19+, OnPush on v22+).

## Components & templates
- Small components. `input()`, `output()`, `model()` and queries `readonly`; template-only members `protected`.
- Derived state with `computed()`, dependent writable state with `linkedSignal()`; `set`/`update`, never mutate. `effect()` only for side effects outside signals, never to copy state.
- Native control flow (`@if`, `@for` with `track` by id, `@switch`); `@defer` for heavy below-the-fold blocks.
- Complex expressions go to `computed()`; no globals like `new Date()` in templates.
- `[class.x]` / `[style.x]` instead of `ngClass` / `ngStyle`; host bindings in `host: {}`, not `@HostBinding`/`@HostListener`.
- Import only the directives/pipes used, never `CommonModule`. No `::ng-deep`.
- Handlers named for the action (`saveUser()`). `NgOptimizedImage` for static images.

## State, services, HTTP
- `inject()`, not constructor injection; one responsibility per service.
- Shared feature state as signals in a service, exposed with `asReadonly()`/`computed()`.
- RxJS for event streams; bridge with `toSignal()` / `async` pipe and `takeUntilDestroyed()`.
- Reads with `httpResource()` (v22) or `HttpClient`; mutations with `HttpClient`. Functional interceptors (`withInterceptors`).

## Structure & routing
- Folders by feature, not by type (`components/`, `services/`); hyphenated file names; `.spec.ts` beside the code.
- Lazy feature routes (`loadComponent` / `loadChildren`); functional guards and resolvers; `withComponentInputBinding()` for route params.
- Forms: Signal Forms on v22+, otherwise typed Reactive forms.

## SSR & hydration
- No direct `window`/`document`/`localStorage`: `inject(DOCUMENT)` and `afterNextRender()` for browser-only code.
- No `isPlatformBrowser` branches in templates (hydration mismatch). Render mode per route in `app.routes.server.ts`.

## Testing
- `ng test` (Vitest); test through the DOM, not private members.
- `provideHttpClient()` + `provideHttpClientTesting()` with `HttpTestingController`; CDK harnesses for Material.
- Zoneless: `await fixture.whenStable()` instead of `fakeAsync`.

## Common mistakes
| Mistake | Fix |
|---|---|
| Mutating plain fields under zoneless/OnPush | Signals |
| `effect()` syncing one signal into another | `computed()` / `linkedSignal()` |
| `@for` without stable `track` | `track item.id` |
| `window` in components with SSR | `afterNextRender()` / `inject(DOCUMENT)` |
| Method calls computing values in templates | `computed()` |

Sources: angular.dev best practices, style guide, SSR and testing guides v22 (angular/angular ~101k stars, MIT; docs CC-BY-4.0), Angular v21/v22 release notes, PatrickJS/awesome-cursorrules (~41k, CC0, outdated v18 rules discarded).
