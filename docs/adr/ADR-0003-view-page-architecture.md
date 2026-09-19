# ADR-0003 — View Page and Runtime Composition Architecture

[Português (Brasil)](./ADR-0003-view-page-architecture.pt-BR.md)

- **Status:** Superseded
- **Scope:** `DockHub.View.Page`
- **Decision type:** View structural organization / runtime visual composition

> **Superseded by:** [ADR-0004 — View Page Composition Architecture](./ADR-0004-view-page-composition-architecture.md)
>
> This ADR is preserved as the historical decision that preceded the current `Types / Contracts / Impl` composition architecture.

## Context

DockHub started its presentation layer with `TPageMain` in `DockHub.View.Page.Main`. As the application evolves, additional Pages may be introduced and each one may own a runtime-created visual tree together with state, Theme, Language, handlers and other screen-specific responsibilities.

Keeping every Page and its helpers directly under `src/view/Page/` would progressively create a flat directory and reduce locality between artifacts that belong to the same screen. At the same time, concentrating all control creation inside the `TForm` class tends to increase responsibility, method size and Page coupling as the UI grows.

The existing architecture already establishes relevant boundaries:

```text
Language
→ does not know FMX

Theme
→ does not know concrete Forms

View
→ applies Language and Theme to its own controls
```

The new organization must preserve these boundaries and allow growth without prematurely introducing global navigation, managers, generic interfaces or artificial hierarchies.

## Decision

The following decisions are accepted for `View.Page`.

### 1. Each Page receives its own physical boundary

The Page pattern is:

```text
src/view/Page/<Page>/
├── DockHub.View.Page.<Page>.pas
├── DockHub.View.Page.<Page>.fmx          # when applicable
└── Composition/
    └── DockHub.View.Page.<Page>.Composition.pas
```

The `<Page>` directory groups artifacts exclusive to that Page.

The first adopted case is `Main`:

```text
src/view/Page/Main/
├── DockHub.View.Page.Main.pas
├── DockHub.View.Page.Main.fmx
└── Composition/
    └── DockHub.View.Page.Main.Composition.pas
```

### 2. The physical directory does not add an artificial role to the main unit

The Main class remains in:

```pascal
unit DockHub.View.Page.Main;
```

There is no need to rename it to `DockHub.View.Page.Main.Form` merely because the file now lives inside the `Main` directory.

### 3. Composition is an explicit Page responsibility

The unit:

```text
DockHub.View.Page.<Page>.Composition
```

represents page-specific visual composition created at runtime.

This responsibility may include:

- FMX control creation;
- use of the UI-building mechanism adopted by the application;
- visual hierarchy and `Parent`;
- position, dimensions, alignment and structural properties;
- association of handlers/callbacks supplied by the consumer;
- exposure of control references when the Page genuinely needs to update them.

The concrete Page-to-Composition API is intentionally not defined by this ADR before implementation.

### 4. The Page retains behavior and presentation coordination

The Page class remains responsible for:

- Form/View lifecycle;
- local state;
- required collaborators;
- `ApplyLanguage` or equivalent;
- `ApplyTheme` or equivalent;
- semantics of user-triggered actions;
- coordination with navigation when a navigation mechanism is actually defined.

Composition does not replace the Page.

### 5. Event wiring does not imply ownership of the action

Composition may associate an `OnClick` or callback while creating a control.

That is structural wiring:

```text
Composition
→ creates component
→ associates callback
```

The meaning of the action remains outside Composition:

```text
Page / appropriate collaborator
→ interprets action
→ performs application behavior
```

### 6. Composition does not navigate directly between Pages

A concrete navigation decision is not part of this architecture yet.

Composition must not directly create another Form/Page as a convenience while handling a visual event.

When multiple Pages exist and real navigation becomes necessary, the solution must be evaluated separately with ownership, lifetime, shared state and dependency direction in mind.

This ADR does not pre-create or authorize:

```text
Navigator
Router
PageManager
Service Locator
DI Container
global singleton
```

### 7. Language remains outside concrete visual structure

`Core.Language` does not start knowing `TLabel`, `TButton`, `TForm` or Composition.

The View continues applying translated text to its own controls:

```text
Language
    ↓
View
    ↓
ApplyLanguage
    ↓
View controls
```

If runtime controls need later updates, the Page ↔ Composition integration should provide only the references/contracts actually required.

### 8. Theme remains independent of concrete Pages

`View.Theme` remains responsible for reusable values and visual behavior that belong to Theme.

The View remains responsible for deciding where those values are applied:

```text
Theme
    ↓
View
    ↓
ApplyTheme
    ↓
View controls
```

Composition does not authorize Theme to locate or directly manipulate Page-internal controls.

### 9. Additional subdivisions require real responsibility

If a Page grows, `Composition` may later be subdivided into smaller visual responsibilities.

That subdivision should occur only after the implementation demonstrates a cohesive separation.

Do not pre-create:

```text
Header
Sidebar
Content
Footer
Components
Actions
```

as empty or speculative structure.

### 10. Reuse between Pages will be decided when real reuse exists

Artifacts under `Page/<Page>/` are page-specific by default.

If a visual responsibility becomes shared by multiple Pages, extraction to a shared `View` area should be evaluated at that time.

This ADR intentionally does not predefine the name, path or contract for that future area.

### 11. RickUIBuilder is the runtime-construction dependency, not the behavior boundary

RickUIBuilder was analyzed as the UI-construction dependency relevant to this Page/Composition architecture. The DockHub-specific integration reference is maintained in [RickUIBuilder — DockHub Integration Reference](../dependencies/rickuibuilder/README.md).

Its current source is directly related to the original reference-screen construction helpers: the Factory source states that `CreateText`, `CreateDivider`, `CreateBadge` and `CreateButton` were extracted from that screen and decoupled from a concrete Form. DockHub should therefore reuse the public library behavior instead of recreating those helpers locally without a real requirement.

This ADR distinguishes two meanings of Composition:

```text
DockHub.View.Page.<Page>.Composition
→ architectural Page responsibility

Rick.UIBuilder.Composition / TRickUIBuilder.On(AParent)
→ one RickUIBuilder usage style
```

The DockHub Composition may select Factory, Fluent Builders, `TRickUIBuilder.On(...)`, or a justified combination. The selection depends on the Page's concrete needs, including whether a created control must remain available for `ApplyLanguage`, `ApplyTheme`, event/state changes or other runtime updates.

This matters because the analyzed `TRickUIBuilder.On(...)` API does not return created Text, Divider or Button controls, while individual fluent builders return their generated control and Badge exposes a public handle. Therefore no project rule should force `TRickUIBuilder.On(...)` merely because the DockHub unit is named `Composition`.

RickUIBuilder does not become responsible for:

- business rules;
- navigation decisions;
- application state;
- the semantic meaning of clicks;
- ownership of Theme or Language.

RickUIBuilder receives concrete values/callbacks and creates/configures FMX controls. DockHub remains responsible for resolving Theme semantic tokens and Language strings before or while applying presentation to those controls.

The analyzed Button hover implementation also stores normal/hover colors at build time. Runtime Theme changes must account for that behavior when `HoverFillColor` is used; updating only the current button fill does not rewrite the stored hover-state colors.

The integration reference must be revalidated when the RickUIBuilder dependency revision changes materially.

## Initial state of this decision

The physical `Page/Main/Composition` structure is implemented and `Main` now uses `TPageMainComposition` at runtime.

The current implementation confirms:

- Main physical boundary;
- `DockHub.View.Page.Main` namespace;
- `DockHub.View.Page.Main.Composition` namespace;
- `TPageMain` responsible for lifecycle, Language, Theme, and window-action semantics;
- `TPageMainComposition` responsible for all Main runtime visual creation;
- RickUIBuilder used by Composition for controls supported by the library;
- the structural card created by Composition through FMX;
- `ApplyLanguage` and `ApplyTheme` delegated to Composition for internal controls;
- explicit minimize and close callbacks;
- unimplemented administrative actions kept disabled.

## Consequences

### Positive

- each Page has a clear physical boundary;
- page-specific artifacts remain close together;
- runtime visual construction gains an explicit responsibility;
- `TForm` can remain focused on lifecycle, state and coordination;
- the structure can grow without turning `Page/` into a flat directory;
- current Theme and Language boundaries are preserved;
- event wiring can evolve without automatically mixing navigation or business rules;
- additional subdivisions may appear from real need instead of being imposed in advance.

### Trade-offs

- each Page with runtime composition may have more than one unit and directory;
- the Page-to-Composition API will need to be defined when real integration is implemented;
- runtime-created controls will require an explicit strategy for references that participate in `ApplyLanguage`, `ApplyTheme` or state updates;
- navigation between Pages remains a separate future decision.

## Rejected/deferred alternatives

### All Pages directly under `src/view/Page/`

Rejected as the growth direction because it mixes artifacts from unrelated screens in a flat directory and reduces physical cohesion as the project expands.

### One global `src/view/Composition/` directory for all Pages

Rejected for page-specific compositions because it would physically separate a Composition from its Page and tend to mix independent compositions.

A genuinely shared visual responsibility may receive another organization in the future when concrete reuse exists.

### All composition inside the `TForm` class

Suitable only while the composition remains small and cohesive. It is not adopted as the growth rule because a large Page could otherwise concentrate lifecycle, state, events, Language, Theme and the entire visual construction in the same class.

### Generic Page framework now

Rejected/deferred. There is no confirmed need for a custom base class, Page manager, generic router, registry or Page factory.

## Re-evaluation triggers

Re-evaluate this ADR when one or more of the following occurs:

- multiple Pages require real navigation;
- a visual responsibility is reused by several Pages;
- the same Page gains large visual regions with their own lifecycle;
- Theme or Language gain shared state across multiple Views;
- multiple independent Views need to remain open simultaneously;
- the Page ↔ Composition contract shows recurring needs that justify a shared abstraction;
- runtime-control ownership/lifetime requires a significant architectural change.

## Validation

This decision was structurally reviewed against the current DockHub rules for organization, SRP, Separation of Concerns, KISS, YAGNI, dependency direction and documented growth.

The runtime `Main`/`Main.Composition` integration described by this ADR is now implemented. This ADR does not, by itself, claim compilation or test execution; the current validation status is documented in [Automated Tests](../testing/README.md).

## Related documentation

- [DockHub View Pages](../modules/view/README.md)
- [RickUIBuilder — DockHub Integration Reference](../dependencies/rickuibuilder/README.md)
- [Theme Module](../modules/theme/README.md)
- [Language Module](../modules/language/README.md)
- [DockHub Documentation](../README.md)
