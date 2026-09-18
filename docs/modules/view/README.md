# DockHub View Pages

[Português (Brasil)](./README.pt-BR.md)

This document describes the structural organization adopted for DockHub Pages and the responsibility boundary for visual composition created at runtime.

The corresponding architecture decision is recorded in [ADR-0003 — View Page and Runtime Composition Architecture](../../adr/ADR-0003-view-page-architecture.md).

## 1. Purpose

The `View` layer must be able to grow to multiple Pages without turning `src/view/Page/` into a flat directory that mixes Forms, compositions and helpers from unrelated screens.

The adopted organization groups artifacts exclusive to each Page under its own physical boundary and reserves a specific responsibility for runtime visual composition.

The goals are to:

- keep artifacts from the same Page highly cohesive;
- make runtime visual construction an explicit responsibility;
- prevent a `TForm` from progressively accumulating the entire screen composition;
- preserve `ApplyLanguage` and `ApplyTheme` as presentation responsibilities coordinated by the View;
- keep event wiring separate from action semantics;
- allow growth without prematurely introducing generic abstractions or nonexistent shared components.

## 2. Adopted structure

Physical pattern for a Page:

```text
src/view/Page/<Page>/
├── DockHub.View.Page.<Page>.pas
├── DockHub.View.Page.<Page>.fmx          # when applicable
└── Composition/
    └── DockHub.View.Page.<Page>.Composition.pas
```

First adopted structural domain:

```text
src/view/Page/Main/
├── DockHub.View.Page.Main.pas
├── DockHub.View.Page.Main.fmx
└── Composition/
    └── DockHub.View.Page.Main.Composition.pas
```

The `Main` directory is the physical boundary of the Page. The main unit name remains:

```pascal
unit DockHub.View.Page.Main;
```

The `Composition` subdirectory expresses an additional responsibility and therefore also appears in the namespace:

```pascal
unit DockHub.View.Page.Main.Composition;
```

## 3. Current Main state

The `Page/Main/Composition` structure and the first Composition unit were created as the organizational foundation for Main.

At this stage, **the presence of the structure does not mean that Composition is already functionally integrated with `TPageMain`**. The runtime relationship between them must be implemented only when control construction is actually introduced.

Therefore, do not assume the following exist until the source code confirms them:

- a public or private Composition build method;
- a Composition-specific interface;
- a control-handle record;
- a navigation mechanism;
- actual runtime component creation by the new unit;
- callbacks already connected between `TPageMain` and Composition.

## 4. Page responsibility

The main Page unit represents the Form/View and coordinates behavior that belongs to that screen.

Expected responsibilities include, when applicable:

- Form lifecycle;
- local Page state;
- references to collaborators such as Language and Theme;
- `ApplyLanguage`;
- `ApplyTheme`;
- user-action handlers;
- coordination of screen-state changes;
- integration with a future navigation mechanism when one exists.

The Page should not become a single method responsible for creating and configuring the entire visual tree when that composition grows into a responsibility of its own.

## 5. Composition responsibility

`DockHub.View.Page.<Page>.Composition` is the page-specific responsibility intended to compose the visual tree created at runtime.

When implementation requires it, Composition may contain:

- FMX control creation;
- use of the visual construction mechanisms adopted by the project;
- component `Parent` hierarchy definition;
- structural configuration of position, size, alignment, anchors and equivalent properties;
- composition of visual groups exclusive to the Page;
- association of callbacks or event handlers supplied by the consumer;
- return or exposure of visual references when the Page genuinely needs to update them after construction.

The concrete shape of this API must be defined by the code that implements the integration. This document does not prematurely prescribe an interface, factory, handle record or manager object.

## 6. Events and actions

Composition may connect a control to a supplied callback, such as an `OnClick`, because that wiring is part of constructing the component.

The semantics of the action do not belong to Composition.

Expected boundary:

```text
Composition
    ↓
creates the control
    ↓
associates the supplied callback
    ↓
Page / responsible collaborator
    ↓
performs the application action
```

Avoid inside Composition:

- business rules;
- direct database access;
- REST calls that represent an application action;
- deciding which Page to open;
- directly instantiating another Page merely because a button was clicked.

## 7. Language

`Core.Language` remains independent of FMX.

The View remains responsible for applying translated text to its controls through `ApplyLanguage` or an equivalent pattern.

If controls created by Composition need translation or later updates after a language change, the integration must preserve this direction:

```text
Language
    ↓
View
    ↓
ApplyLanguage
    ↓
controls owned by the View
```

The concrete mechanism for the Page to access controls created at runtime must be defined only when implementation requires it.

## 8. Theme

`View.Theme` provides semantic tokens and reusable visual behavior but does not know concrete Forms or the internal structure of a Page.

The View remains responsible for mapping Theme tokens to its own components through `ApplyTheme` or an equivalent pattern.

Preserved boundary:

```text
Theme
    ↓
View
    ↓
ApplyTheme
    ↓
controls owned by the View
```

Introducing Composition does not transfer responsibility for locating or manipulating Page controls to Theme.

## 9. Navigation between Pages

The concrete responsibility for navigation between Pages **is not defined by the source code covered by this decision yet**.

Composition must not assume that responsibility for convenience.

When the application has multiple Pages and a real navigation need appears, the mechanism must be evaluated separately considering:

- Form/View ownership and lifetime;
- shared state;
- dependencies between Pages;
- dependency direction;
- whether contracts are actually required;
- shared Theme and Language state;
- the possibility of multiple Views being open at the same time.

Until that decision exists, do not silently introduce a `Navigator`, `Router`, `PageManager`, singleton, Service Locator or another global mechanism.

## 10. Page growth

A single Composition does not have to remain monolithic if the Page acquires large and independent visual areas.

Subdivision is allowed when a real responsibility exists, for example after implementation demonstrates that a visual region has its own maintenance lifecycle.

Do not pre-create units such as:

```text
Header
Sidebar
Content
Footer
Components
Actions
```

merely because they might be needed later.

The rule is:

```text
real responsibility
    ↓
cohesive separation

future possibility
    ↓
do not create yet
```

## 11. Shared components

An artifact under:

```text
Page/<Page>/
```

is page-specific by default.

If the same visual responsibility becomes genuinely reused by multiple Pages, extraction to a shared View responsibility should be evaluated.

The name and path of that future responsibility are intentionally not defined by this document.

## 12. RickUIBuilder relationship

When Page runtime construction uses RickUIBuilder, calls that create and compose controls specific to the Page belong to the Composition responsibility.

This does not transfer application-action semantics to RickUIBuilder or Composition. RickUIBuilder remains the visual construction mechanism; the Page or its appropriate collaborator remains responsible for what events mean.

The effective integration must be documented from the final code when it is implemented.

## 13. Convention for new Pages

When a real new Page is created and has its own runtime composition, use the pattern:

```text
src/view/Page/<Page>/
├── DockHub.View.Page.<Page>.pas
├── DockHub.View.Page.<Page>.fmx
└── Composition/
    └── DockHub.View.Page.<Page>.Composition.pas
```

Do not create directories for hypothetical Pages before the Page itself exists.

## 14. Structural quality gate

When creating or evolving a Page, verify:

```text
[ ] Page-specific artifacts remain grouped
[ ] namespace expresses product/layer/domain/responsibility
[ ] Page retains lifecycle and presentation coordination
[ ] Composition retains visual-construction responsibility
[ ] Composition contains no business rules
[ ] event wiring has not absorbed application semantics
[ ] Theme does not depend on the concrete Page
[ ] Language remains independent of FMX
[ ] navigation was not invented without its own decision
[ ] subdivisions were created only for real responsibilities
[ ] no circular dependency was introduced
```

## 15. Related documentation

- [ADR-0003 — View Page and Runtime Composition Architecture](../../adr/ADR-0003-view-page-architecture.md)
- [Theme Module](../theme/README.md)
- [Language Module](../language/README.md)
- [DockHub Documentation](../../README.md)
