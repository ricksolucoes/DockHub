# DockHub View Pages

[Português (Brasil)](./README.pt-BR.md)

This document describes the current `DockHub.View.Page` structure and the runtime-composition contract implemented by the project.

The current architectural decision is recorded in [ADR-0004 — View Page Composition Architecture](../../adr/ADR-0004-view-page-composition-architecture.md). [ADR-0003](../../adr/ADR-0003-view-page-architecture.md) is preserved as the superseded decision that preceded this structure.

## 1. Purpose

`View.Page` separates shared Page contracts/types from reusable composition behavior and page-specific presentation. The structure exists to keep future Pages consistent without moving business rules, Theme state or Language state into the visual builder.

The current goals are:

- keep public Page contracts explicit;
- keep shared Page types outside implementation classes;
- provide one reusable abstract composition lifecycle;
- keep each Page's runtime visual construction in its own implementation unit;
- keep `TPageMain` focused on Form lifecycle, state and action semantics;
- preserve Theme and Language dependency direction;
- allow page-specific contracts, such as `IPageCompositionMain`, when the Page has known actions that will need their own API.

## 2. Current structure

```text
src/view/Page/
├── Contracts/
│   └── DockHub.View.Page.Contracts.pas
├── Impl/
│   ├── DockHub.View.Page.Composition.Impl.Base.pas
│   └── Main/
│       └── DockHub.View.Page.Impl.Main.Composition.pas
├── Types/
│   └── DockHub.View.Page.Types.pas
├── DockHub.View.Page.Main.pas
└── DockHub.View.Page.Main.fmx
```

The roles are:

```text
Types
→ shared enums/types belonging to View.Page

Contracts
→ public interfaces of the View.Page domain

Composition.Impl.Base
→ reusable abstract composition lifecycle and common visual behavior

Impl.<Page>.Composition
→ Page-specific runtime visual construction and presentation mapping

DockHub.View.Page.<Page>
→ Form/View lifecycle, state, collaborators and action semantics
```

`DockHub.View.Page.Types` currently enables `{$SCOPEDENUMS ON}` and owns `TPageCompositionState`.

## 3. Contracts

### `IPageComposition`

The common contract exposes the current configuration/build/presentation operations:

```pascal
function Form(const AForm: TForm): IPageComposition;
function OnMinimize(const ANotifyEvent: TNotifyEvent): IPageComposition;
function OnClose(const ANotifyEvent: TNotifyEvent): IPageComposition;
function ApplyLanguage(const ALanguage: IDockHubLanguage): IPageComposition;
function ApplyTheme(const ATheme: IDockHubTheme): IPageComposition;
function Build: IPageComposition;
```

Configuration is fluent but is valid only during the composition's `Configuring` state.

### `IPageCompositionMain`

`IPageCompositionMain` intentionally extends `IPageComposition` even though it currently adds no methods.

It is the page-specific contract retained for Main because Main already contains known actions whose real behavior will be added later, including install/uninstall/start/stop and configuration/log actions. Those operations must be added only when their application behavior is actually defined; the interface must not be populated with speculative methods merely to anticipate them.

## 4. `TPageCompositionBase`

`TPageCompositionBase` is an abstract `TInterfacedObject` implementing the common `IPageComposition` contract.

It owns behavior that is shared by Page compositions:

- composition lifecycle validation;
- host Form configuration reference;
- minimize/close callbacks;
- common window-control construction;
- common window-control Theme mapping;
- current Theme reference used by hover behavior;
- retained `IRickUIBuilderButtonHandle` references for common window controls, avoiding knowledge of Button internals;
- `ApplyButtonTheme`;
- Template Method hooks for Page-specific build, Theme and Language behavior.

Derived compositions implement:

```pascal
procedure DoBuild; virtual; abstract;
procedure DoApplyTheme; virtual; abstract;
procedure DoApplyLanguage(const ALanguage: IDockHubLanguage); virtual; abstract;
```

## 5. Composition lifecycle

The lifecycle is represented by the scoped enum:

```pascal
TPageCompositionState = (
  Configuring,
  Building,
  Built,
  Failed
);
```

State transitions are:

```text
Configuring
    │
    └── Build
          ↓
       Building
       ↙      ↘
    Built    Failed
```

Rules implemented by the base class:

- a new composition starts in `Configuring`;
- `Form`, `OnMinimize` and `OnClose` are accepted only while configuring;
- `Build` requires a host Form and both window callbacks;
- `Build` changes the state to `Building` before Page-specific construction starts;
- successful construction finishes in `Built`;
- any exception during construction finishes in `Failed` and is re-raised;
- a second `Build` after `Built` is idempotent and does not rebuild the tree;
- `Build` from `Building` or `Failed` is rejected;
- `ApplyLanguage` and `ApplyTheme` require `Built`;
- nil Language/Theme contracts are rejected;
- configuration cannot be changed after Build starts.

A failed instance is not retried. A new composition instance must be created if construction must be attempted again.

## 6. Lifetime and reference counting

The current architecture deliberately uses interface/reference-counted lifetime:

```text
TPageMain
  └── FComposition: IPageCompositionMain
          ↓
     TPageMainComposition
```

The Page must keep the composition interface referenced while controls created by the composition can invoke event handlers on that composition.

This is especially important for common window buttons, whose hover handlers target methods of `TPageCompositionBase`.

Do not explicitly clear the Page's composition interface while its FMX controls are still alive and able to dispatch those callbacks.

The FMX controls themselves remain owned through the FMX owner/parent hierarchy; the interface does not own those controls.

## 7. `TPageMain` responsibility

`TPageMain` currently owns:

- its `IDockHubLanguage` state;
- its `IDockHubTheme` state;
- its `IPageCompositionMain` reference;
- Form configuration;
- composition configuration/build orchestration;
- language/theme state changes;
- minimize and close action semantics.

`TPageMain` does not create the Main visual tree directly.

The current construction flow is:

```text
Create Language
Create Theme
ConfigureForm
ConfigureComposition
Build
ApplyLanguage
ApplyTheme
```

## 8. Main composition responsibility

`TPageMainComposition` derives from `TPageCompositionBase` and implements `IPageCompositionMain`.

It creates and retains the controls required for Main presentation, including:

- card/surface;
- title/subtitle;
- runtime status labels, badges and values;
- action buttons;
- translated captions;
- Theme mapping for its own controls.

The common minimize/close controls remain implemented by the base class.

Administrative actions that do not yet have implemented application use cases remain disabled. The Composition does not invent service/business behavior for them.

## 9. Language integration

`Core.Language` remains independent of FMX.

The current direction is:

```text
TPageMain
  ↓ owns IDockHubLanguage
IPageCompositionMain.ApplyLanguage
  ↓
TPageMainComposition.DoApplyLanguage
  ↓
Form caption + runtime controls
```

`TPageMain` coordinates the active language. `TPageMainComposition` owns the presentation mapping because it owns the visual references.

Runtime language changes update existing controls; they do not rebuild the visual tree.

## 10. Theme integration

`View.Theme` remains independent of concrete Forms and Page internals.

The current direction is:

```text
TPageMain
  ↓ owns IDockHubTheme
IPageCompositionMain.ApplyTheme
  ↓
TPageMainComposition.DoApplyTheme
  ↓
Form background + runtime controls
```

The base composition also applies the Theme to common window controls and keeps `FCurrentTheme` so hover handlers use the most recently applied Theme.

Runtime Theme changes do not rebuild the visual tree.

## 11. Events and action semantics

Visual construction may wire a callback supplied by the Page, but application semantics remain outside the visual construction code.

Current example:

```text
TPageCompositionBase
→ creates minimize/close buttons
→ wires supplied callbacks

TPageMain
→ defines what minimize/close mean for the application
```

Future Main actions should follow the same boundary. `IPageCompositionMain` is the intended page-specific contract for those behaviors when their real use cases are implemented.

Composition must not absorb:

- business rules;
- database access;
- REST/application use cases;
- direct navigation decisions;
- direct construction of unrelated Pages as a click side effect.

## 12. RickUIBuilder relationship

RickUIBuilder is a UI-construction mechanism used inside the DockHub composition architecture. It is not the architecture boundary itself.

Do not confuse:

```text
DockHub.View.Page.Impl.<Page>.Composition
→ DockHub Page-specific presentation implementation

Rick.UIBuilder.Composition / TRickUIBuilder.On(AParent)
→ one RickUIBuilder API style
```

Main currently uses RickUIBuilder fluent builders for controls that require retained references after construction. The structural card is created directly with FMX because the analyzed RickUIBuilder snapshot has no generic card/container builder.

RickUIBuilder `0.2.0` exposes `IRickUIBuilderButtonHandle` through `BuildHandle(AParent)`. Page compositions retain this public handle when they need both `Container` and `TextLabel` after construction; production code no longer searches the Button visual tree for its caption.

See [RickUIBuilder — DockHub Integration Reference](../../dependencies/rickuibuilder/README.md).

## 13. New Page convention

Before creating a new Page structure, inspect the current project first. Do not infer folders, nested types or namespaces from an isolated source fragment.

When a new Page uses this architecture, evaluate its real needs against the current pattern:

```text
src/view/Page/
├── Contracts/
├── Types/
├── Impl/
│   └── <Page>/
│       └── DockHub.View.Page.Impl.<Page>.Composition.pas
├── DockHub.View.Page.<Page>.pas
└── DockHub.View.Page.<Page>.fmx
```

Shared `View.Page` types belong in `DockHub.View.Page.Types` when they represent domain-level structural state. Page-specific implementation remains under `Impl/<Page>`.

Do not create additional abstraction layers until a real reusable responsibility exists.

## 14. Creating a new Page

The architecture above has an operational AI workflow for future Pages:

```text
Normative architecture
→ this document + ADR-0004

Domain authority
→ .ai/agents/dockhub-view-page.md

Reusable procedure
→ create-view-page

Scaffolding
→ .ai/templates/delphi/view-page/
```

The workflow must inspect the current repository before materializing files.

A template **materializes confirmed architecture; it does not define architecture**.

It also does not automatically create a page-specific interface, a new `Types` unit, Theme tokens or tests. Those decisions remain evidence-driven.

---

## 15. Navigation

A general navigation mechanism is not defined by the current source.

Do not introduce `Navigator`, `Router`, `PageManager`, singleton or Service Locator merely because more Pages may exist in the future. Navigation requires a separate decision when a concrete use case exists.

## 16. Tests

The source contains:

- contract/lifecycle tests for `TPageCompositionBase`;
- FMX integration tests for `TPageMainComposition`;
- separate Language and Theme fixtures.

The base fixture validates the public lifecycle rather than exposing `FState` for testing. The Main fixture inspects observable FMX behavior rather than adding production accessors for private controls.

Execution evidence is documented separately in [Automated Tests](../../testing/README.md). Source test inventory must not be presented as proof of execution.

## 17. Structural quality gate

When evolving `View.Page`, verify:

```text
[ ] current project structure was inspected before deciding paths/namespaces
[ ] shared enums/types are placed according to the existing Types pattern
[ ] public contracts remain under Contracts
[ ] common composition behavior remains in the abstract base only when genuinely shared
[ ] Page-specific presentation remains under Impl/<Page>
[ ] Page keeps lifecycle/state/action semantics
[ ] composition lifecycle rules remain valid
[ ] reference-counted lifetime remains safe for event callbacks
[ ] Theme remains independent of concrete Page internals
[ ] Language remains independent of FMX
[ ] no business rule was moved into Composition
[ ] no navigation mechanism was invented without a separate requirement
[ ] tests cover changed lifecycle/error paths
```

## 18. Related documentation

- [ADR-0004 — View Page Composition Architecture](../../adr/ADR-0004-view-page-composition-architecture.md)
- [ADR-0003 — superseded View Page architecture](../../adr/ADR-0003-view-page-architecture.md)
- [RickUIBuilder — DockHub Integration Reference](../../dependencies/rickuibuilder/README.md)
- [Theme Module](../theme/README.md)
- [Language Module](../language/README.md)
- [Automated Tests](../../testing/README.md)
- [DockHub Documentation](../../README.md)
