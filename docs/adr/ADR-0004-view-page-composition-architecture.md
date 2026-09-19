# ADR-0004 — View Page Composition Architecture

[Português (Brasil)](./ADR-0004-view-page-composition-architecture.pt-BR.md)

- **Status:** Accepted
- **Scope:** `DockHub.View.Page`
- **Decision type:** View structural organization / composition lifecycle
- **Supersedes:** [ADR-0003 — View Page and Runtime Composition Architecture](./ADR-0003-view-page-architecture.md)

## Context

The initial `View.Page` architecture grouped each Page under its own physical directory with a page-local `Composition` subdirectory. As the Main View implementation evolved, the project established a more reusable pattern already used elsewhere in DockHub: explicit `Types`, `Contracts` and `Impl` roles.

The current source now contains a common abstract composition lifecycle, shared Page contracts/types, and a page-specific Main composition. This architecture must support future Views without forcing business behavior into the visual composition layer or inventing additional abstraction levels before real reuse exists.

The project also deliberately keeps composition lifetime interface-based through `TInterfacedObject` and page-held interface references.

## Decision

### 1. Structural organization

`DockHub.View.Page` uses the following structure:

```text
src/view/Page/
├── Contracts/
│   └── DockHub.View.Page.Contracts.pas
├── Impl/
│   ├── DockHub.View.Page.Composition.Impl.Base.pas
│   └── <Page>/
│       └── DockHub.View.Page.Impl.<Page>.Composition.pas
├── Types/
│   └── DockHub.View.Page.Types.pas
├── DockHub.View.Page.<Page>.pas
└── DockHub.View.Page.<Page>.fmx          # when applicable
```

The roles are explicit:

```text
Types
→ shared View.Page enums/types

Contracts
→ public View.Page interfaces

Composition.Impl.Base
→ abstract reusable composition lifecycle/common behavior

Impl.<Page>.Composition
→ Page-specific runtime presentation implementation

DockHub.View.Page.<Page>
→ Form lifecycle, state, collaborators and action semantics
```

Before changing this structure, the current project must be inspected. A partial source fragment is not sufficient evidence to invent a new folder, namespace, nested type or abstraction.

### 2. Shared Page types

Structural types belonging to the `View.Page` domain are placed in `DockHub.View.Page.Types` when they are not merely an implementation-local detail.

The current lifecycle enum is:

```pascal
{$SCOPEDENUMS ON}

type
  TPageCompositionState = (
    Configuring,
    Building,
    Built,
    Failed
  );
```

Callers use qualified enum members such as `TPageCompositionState.Built`.

### 3. Common composition contract

`IPageComposition` defines the shared composition API:

```pascal
Form(...)
OnMinimize(...)
OnClose(...)
Build
ApplyLanguage(...)
ApplyTheme(...)
```

The configuration API is fluent but configuration is valid only while the composition is in `Configuring`.

### 4. Page-specific contracts are allowed when justified

`IPageCompositionMain` intentionally extends `IPageComposition`.

The interface currently adds no methods, but it is retained because Main already contains known page-specific actions whose application contracts will be introduced later, including service operations and configuration/log actions.

This decision does not require an empty page-specific interface for every future Page. A specific contract must have a real page-specific reason to exist.

### 5. Abstract base composition

`TPageCompositionBase` is an abstract `TInterfacedObject` implementing `IPageComposition`.

It contains behavior currently shared by Page compositions:

- lifecycle/state validation;
- host Form reference;
- common minimize/close callback configuration;
- common window-button creation;
- common window-button Theme mapping and hover behavior;
- current Theme storage required by runtime hover;
- RickUIBuilder Button-caption lookup helper;
- reusable button-theme helper;
- Template Method hooks for page-specific construction and presentation.

Derived compositions implement:

```pascal
DoBuild
DoApplyTheme
DoApplyLanguage
```

Shared behavior remains in the base only while it is genuinely shared. Page-specific behavior stays in the specific composition.

### 6. Composition lifecycle

The lifecycle is:

```text
Configuring
    │
    └── Build
          ↓
       Building
       ↙      ↘
    Built    Failed
```

Rules:

- construction starts in `Configuring`;
- host Form and required callbacks must be configured before Build;
- configuration is closed once Build starts;
- successful Build ends in `Built`;
- an exception during Build moves the instance to `Failed` and is re-raised;
- a second Build after `Built` is idempotent;
- Build from `Building` or `Failed` is rejected;
- Language and Theme can only be applied after `Built`;
- nil Language/Theme contracts are invalid;
- a `Failed` instance is not retried.

The lifecycle is behavioral. Tests validate it through the public API rather than exposing the private state solely for test access.

### 7. Lifetime uses interface/reference counting

The architecture deliberately keeps composition lifetime through interfaces:

```text
TPageMain
  └── IPageCompositionMain
          ↓
     TPageMainComposition : TInterfacedObject
```

The Page must retain the interface while controls created by the composition may call event handlers on the composition instance.

The interface controls the composition object's lifetime; FMX controls continue to follow their normal Owner/Parent lifecycle.

Do not clear the composition interface before the controls that reference its event handlers have been destroyed.

### 8. Page and Composition responsibilities

The Page owns/co-ordinates:

- Form/View lifecycle;
- active Language state;
- active Theme state;
- page-specific state;
- semantics of user actions;
- creation/configuration of its composition contract.

The page-specific Composition owns:

- runtime visual construction;
- visual references needed after Build;
- translation mapping to those controls;
- Theme mapping to those controls;
- visual state updates;
- visual callback wiring supplied by the Page.

Composition does not own business rules, database operations, application REST use cases or navigation decisions.

### 9. Language direction

The current direction is:

```text
TPageMain
→ IDockHubLanguage state
→ IPageCompositionMain.ApplyLanguage
→ TPageMainComposition.DoApplyLanguage
→ Form caption and runtime controls
```

`Core.Language` remains independent of FMX.

### 10. Theme direction

The current direction is:

```text
TPageMain
→ IDockHubTheme state
→ IPageCompositionMain.ApplyTheme
→ TPageMainComposition.DoApplyTheme
→ Form background and runtime controls
```

`View.Theme` remains independent of concrete Page internals.

The base composition applies the Theme to common window controls and keeps the most recently applied Theme for hover behavior.

### 11. RickUIBuilder

RickUIBuilder remains a UI-construction dependency inside Page compositions, not the architecture boundary itself.

The current Main composition uses individual fluent builders where control references are required after Build. The structural card remains direct FMX construction because the analyzed RickUIBuilder snapshot has no generic card/container builder.

The current RickUIBuilder Button API does not expose a public caption handle. The workaround is centralized in `TPageCompositionBase.FindButtonCaption`; it must not be duplicated across Pages.

### 12. Tests

The project keeps separate concerns in tests:

- `TPageCompositionBase` contract/lifecycle tests;
- `TPageMainComposition` FMX integration tests;
- independent Language/Theme tests.

Source test inventory is not execution evidence. Historical DUnitX XML remains historical until the current suite is actually executed.

## Consequences

### Positive

- shared composition lifecycle has one implementation;
- page-specific composition remains isolated;
- lifecycle failures are explicit rather than silent;
- configuration cannot silently diverge from an already-built UI;
- `Types / Contracts / Impl` follows an established DockHub structural pattern;
- `IPageCompositionMain` can grow with real Main actions without polluting the common contract;
- Theme and Language remain decoupled from concrete implementations.

### Costs and constraints

- Page code must retain the composition interface for the required lifetime;
- failed composition instances are terminal and must be recreated;
- future changes to the common lifecycle affect every derived Page composition;
- RickUIBuilder Button-caption access currently depends on one centralized implementation detail until the upstream API exposes a handle.

## Rejected / deferred alternatives

The current architecture does not introduce:

- `TComponent` ownership for composition lifetime;
- a State Pattern class hierarchy for four lifecycle states;
- a global Navigator/Router/PageManager;
- a generic Page factory;
- a DI container solely for Page construction;
- speculative methods in `IPageCompositionMain` before real action contracts exist;
- one composition unit per visual region without demonstrated need.

These may be reconsidered only if concrete requirements justify them.

## Related documentation

- [View Page Module](../modules/view/README.md)
- [RickUIBuilder — DockHub Integration Reference](../dependencies/rickuibuilder/README.md)
- [Language Architecture](./ADR-0001-language-architecture.md)
- [Theme Architecture](./ADR-0002-theme-architecture.md)
- [Superseded ADR-0003](./ADR-0003-view-page-architecture.md)
- [Automated Tests](../testing/README.md)
