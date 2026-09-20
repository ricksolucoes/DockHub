# RickUIBuilder — DockHub Integration Reference

[Português (Brasil)](./README.pt-BR.md)

This document is the DockHub technical reference for consuming **RickUIBuilder**. It records the library behavior that was actually inspected so future runtime-UI work does not depend on assumptions or only on examples from another application.

It does not replace the upstream RickUIBuilder documentation. It records what DockHub must know before using that dependency.

> **DockHub integration status:** `DockHub.View.Page.Impl.Main.Composition` now uses RickUIBuilder at runtime to create Labels, Badges, Dividers, and Buttons. Main's structural card is still created directly through FMX inside Composition because the analyzed snapshot does not expose a generic container/card builder.

## 1. Analyzed snapshot

The DockHub snapshot supplied for this integration resolves RickUIBuilder `0.2.1` through Boss:

```text
Repository: ricksolucoes/RickUIBuilder
boss.json constraint: ^0.2.1
boss-lock resolved version: 0.2.1
boss-lock module hash: bc2cd0b95e2a8a6bea7cee9b6ae6e48b
```

The source supplied under `modules/github_com_ricksolucoes_RickUIBuilder` contains the `BuildHandle` and mutable HoverState APIs documented below. Its own internal `boss.json` declares version `0.1.0`, which does not match the root `boss-lock.json` resolved version. The authoritative dependency resolution for DockHub is the root `boss.json`/`boss-lock.json`; the module-internal version mismatch is recorded here rather than reconciled by assumption.

The analysis covered the public API and implementation areas relevant to DockHub, including:

```text
README.md
README.pt-BR.md
sample/Readme.md
sample/src/RickUIBuilderSample.Main.pas

src/Rick.UIBuilder.pas
src/Rick.UIBuilder.Types.pas
src/Rick.UIBuilder.Interfaces.pas
src/Rick.UIBuilder.Factory.pas
src/Rick.UIBuilder._Label.pas
src/Rick.UIBuilder.Button.pas
src/Rick.UIBuilder.Button.Handle.pas
src/Rick.UIBuilder.Button.HoverState.pas
src/Rick.UIBuilder.Badge.pas
src/Rick.UIBuilder.Badge.Handle.pas
src/Rick.UIBuilder.Divider.pas
src/Rick.UIBuilder.Composition.pas

relevant DUnitX tests under tests/src/
```

Before relying on this document after the dependency changes version or source revision, revalidate the upstream API and update this reference when behavior differs.

## 2. Origin and responsibility

RickUIBuilder is a Delphi FireMonkey library for creating and composing UI controls in code.

The source header of `Rick.UIBuilder.Factory` explicitly states that the Factory creation helpers were extracted from the original reference screen that motivated the component. That is important for DockHub: the library already encapsulates the repeated creation logic for the visual elements for which it exposes public APIs; DockHub should not recreate that logic locally without a concrete reason.

The library does not own DockHub application behavior. It receives values, callbacks and a parent and creates/configures FMX controls.

## 3. Public facade

`Rick.UIBuilder` exposes `TRickUIBuilder` as the main entry point:

```text
TRickUIBuilder
├── Factory
├── Label_
├── Button
├── Badge
├── Divider
└── On(AParent)
```

The analyzed snapshot exposes no additional generic visual builder through this facade.

## 4. Three usage styles

The library provides three complementary styles. They are not interchangeable aliases.

| Style | Entry point | Creation moment | Typical reason to use |
| --- | --- | --- | --- |
| Factory | `TRickUIBuilder.Factory` | immediate | direct creation from a configuration record |
| Fluent Builders | `Label_`, `Button`, `Badge`, `Divider` | when `Build`/`BuildHandle` is called | richer per-control configuration and returned control/handle |
| Composition | `TRickUIBuilder.On(AParent)` | each `Add*` creates immediately | short fixed sequences on the same parent |

Using an `IRickUIBuilder*` explicitly is not a fourth creation style; it is the contract of the same fluent builders/composer.

## 5. Factory

`TRickUIBuilderFactory` implements direct creation and receives `AOwner`, `AParent` and a configuration record.

| Method | Created result |
| --- | --- |
| `CreateText` | `TLabel` |
| `CreateDivider` | `TRectangle` |
| `CreateBadge` | badge `TRectangle` plus internal `TLabel` through `out` |
| `CreateButton` | button `TRectangle` containing its caption `TLabel`; an overload also returns that label through `out` |

Factory behavior relevant to DockHub:

- `AOwner` controls component lifetime;
- `AParent` controls the FMX visual hierarchy;
- Factory colors come from the supplied config; it does not know a consumer palette;
- `CreateBadge` creates a pill-shaped container and exposes its text label through an `out` parameter;
- `CreateButton` enables hit testing and creates the caption label as a child; the additive overload returns the exact created label through `out`;
- direct `CreateButton` does **not** install the fluent builder hover behavior.

## 6. Configuration records

`Rick.UIBuilder.Types` provides:

```text
TRickUIBuilderTextConfig
TRickUIBuilderBadgeConfig
TRickUIBuilderButtonConfig
TRickUIBuilderDividerConfig
TRickUIBuilderSpacing
```

Each configuration record provides `Default` values. Those defaults are library defaults, not DockHub visual identity.

DockHub rule:

```text
RickUIBuilder Default
→ safe starting configuration

IDockHubTheme semantic token
→ authoritative DockHub visual value when a matching role exists
```

Do not treat `Dodgerblue`, black, white, light gray or any other RickUIBuilder default as a DockHub Theme value.

## 7. Fluent Label Builder

`TRickUIBuilder.Label_` returns `IRickUIBuilderLabel` and `Build(AParent)` returns the created `TLabel`.

The builder supports, among other options:

- text;
- position and size;
- anchors;
- margin and padding;
- font family, size and color;
- bold and italic;
- horizontal and vertical alignment;
- word wrap and trimming;
- opacity and visibility;
- hit testing;
- tag.

Important lifetime behavior: the current implementation uses the `AParent` supplied to `Build` as both `Owner` and `Parent` of the created control.

Because `Build` returns the `TLabel`, this style is appropriate when DockHub needs a stable reference for later `ApplyLanguage`, `ApplyTheme` or state updates.

## 8. Fluent Button Builder

`TRickUIBuilder.Button` returns `IRickUIBuilderButton`. The original `Build(AParent)` API remains available and returns the button container as `TRectangle`. The supplied RickUIBuilder source provides the additive `BuildHandle(AParent)` API, which returns `IRickUIBuilderButtonHandle`.

It adds behavior/configuration beyond direct Factory creation, including:

- anchors;
- corner radius;
- margin and padding;
- border thickness;
- font family and bold;
- hover fill color;
- enabled/disabled state and disabled opacity;
- cursor;
- opacity and visibility;
- tag;
- `OnClick`;
- `OnHover`.

The Button handle exposes the exact controls and runtime hover state created for that Button:

```text
Container: TRectangle
TextLabel: TLabel
HoverState: IRickUIBuilderButtonHoverState
```

`IRickUIBuilderButtonHandle` is non-owning with respect to the FMX controls. It does not free or extend the lifetime of `Container` or `TextLabel`; lifetime continues to be controlled by the Owner used during creation. In the fluent builder, the supplied `AParent` is used by the current implementation as the Owner/Parent for the generated controls. The handle may retain the logical HoverState interface, but that state does not own the Button. None of these references should be dereferenced after the FMX controls have been destroyed.

`BuildHandle` returns a non-nil `HoverState` associated with the same built Button. The compatibility overload `TRickUIBuilderButtonHandle.New(Container, TextLabel)` remains available to direct callers and has no HoverState to expose, so that overload returns a handle whose `HoverState` is `nil`.

DockHub uses `BuildHandle` when it needs to retain the Button container and caption for later Theme or Language updates. Code that only needs the `TRectangle` can continue using `Build`. DockHub must not inspect the Button's child collection to locate its caption.

### Hover lifetime and mutability

`IRickUIBuilderButtonHoverState` remains the fluent state contract. `TRickUIBuilderButtonHoverState.New` creates the state without parameters; `Build(AOwner)` materializes the runtime hover behavior with lifetime tied to the supplied Owner. The behavior keeps the same HoverState alive and reads the current `FillColor`, `HoverFillColor`, `OnEnter`, and `OnLeave` values when the corresponding mouse event occurs.

Consequently, changing those values after `Build` affects subsequent events without rebuilding the Button: `HoverFillColor` is consumed by the next `MouseEnter`, `FillColor` by the next `MouseLeave`, and updated enter/leave handlers by their next corresponding callbacks. The setters do not repaint the Button immediately. Changing `Button(AValue)` after `Build` also does not retarget a behavior that was already materialized; that behavior remains attached to the Button it was built for.

The current DockHub window buttons have **not yet been migrated** to use `IRickUIBuilderButtonHandle.HoverState`; they still use `OnHover` callbacks that read `FCurrentTheme` at event time. That is the current DockHub implementation state, not a limitation of the updated RickUIBuilder source.

## 9. Fluent Badge Builder and handle

`TRickUIBuilder.Badge` returns `IRickUIBuilderBadge`; `Build(AParent)` returns `IRickUIBuilderBadgeHandle`.

The handle exposes:

```text
Container: TRectangle
TextLabel: TLabel
```

This is the public mechanism for retaining both generated badge controls and updating them after construction.

The builder supports pill/corner-radius behavior, margins, padding, background/text/border colors, font size, bold, opacity, visibility and tag.

For DockHub, the handle is especially relevant when status text or status colors need to change at runtime.

## 10. Fluent Divider Builder

`TRickUIBuilder.Divider` returns `IRickUIBuilderDivider`; `Build(AParent)` returns `TRectangle`.

It supports position, length (`Width`), thickness, horizontal/vertical orientation, margin, color, opacity and visibility.

The Factory creates the base one-pixel horizontal rectangle; the fluent builder applies requested thickness and orientation after creation.

## 11. RickUIBuilder Composition mode

`TRickUIBuilder.On(AParent)` returns `IRickUIBuilderComposer` tied to one FMX parent.

Unlike individual fluent builders, the composer has no final `Build`. Every operation creates immediately:

```text
AddText
AddDivider
AddBadge
AddButton
```

Behavior relevant to DockHub:

- `AddText` creates a label but does not return that label to the caller;
- `AddDivider` creates a divider but does not return that divider;
- `AddBadge` returns an `IRickUIBuilderBadgeHandle` through `out`;
- `AddButton` accepts an optional `TNotifyEvent`, but does not return the created button;
- every created control uses the composer's parent as both Owner and Parent;
- calls preserve creation order in the parent's children sequence according to the analyzed tests.

This mode is useful for short fixed sequences where later direct control references are not required, except for Badge where a handle is explicitly available.

## 12. DockHub `Composition` is not RickUIBuilder `Composition`

These two concepts must not be conflated:

```text
DockHub.View.Page.Impl.<Page>.Composition
→ DockHub page-specific implementation for composing one Page

TRickUIBuilder.On(AParent)
→ one optional RickUIBuilder API style
```

A DockHub Page Composition may use:

- Factory;
- fluent builders;
- `TRickUIBuilder.On(...)`;
- or a justified combination of them.

The existence of a DockHub Page Composition does **not** require all controls to be created through `TRickUIBuilder.On(...)`.

## 13. Selection rule for DockHub runtime Pages

Choose the narrowest RickUIBuilder API that preserves the Page's real runtime needs:

```text
Need direct record-based creation
→ Factory

Need richer per-control configuration
→ Fluent Builder

Need later direct reference to Label/Button/Divider
→ prefer the API that returns that control

Need Button container/caption/hover state after build
→ Button Builder + IRickUIBuilderButtonHandle

Need Badge container/text after build
→ Badge Builder + IRickUIBuilderBadgeHandle

Need a short fixed sequence on one Parent and no later references
→ TRickUIBuilder.On(AParent)
```

Do not choose an API only because its name resembles the DockHub architectural unit name.

## 14. Integration with DockHub Theme

RickUIBuilder has no dependency on `IDockHubTheme` and should remain unaware of it.

Expected direction:

```text
IDockHubTheme
    ↓
DockHub View/Page Composition
    ↓ resolves semantic token for the current visual role
RickUIBuilder
    ↓
FMX control
```

When a semantic Theme token exists, DockHub passes that value to RickUIBuilder instead of adopting a library default or duplicating a palette hexadecimal.

The View remains responsible for reapplying Theme to controls that must react to runtime Theme changes.

## 15. Integration with DockHub Language

RickUIBuilder receives final strings; it does not know `IDockHubLanguage` or translation keys.

Expected direction:

```text
IDockHubLanguage
    ↓ Translate(key)
DockHub View/Page
    ↓
RickUIBuilder / generated controls
```

For controls that must react to runtime language changes, the DockHub implementation must retain or otherwise legitimately access the required generated control reference. This is a factor when choosing between an individual builder and `TRickUIBuilder.On(...)`.

Do not embed user-facing text directly in a Page Composition when the DockHub Language rules require a translation key.

## 16. Events and application behavior

RickUIBuilder can wire events such as Button `OnClick` and `OnHover`, but it does not define the meaning of those events for DockHub.

Boundary:

```text
RickUIBuilder
→ creates/configures control and wires supplied callback

DockHub Page / appropriate collaborator
→ defines what the callback means for the application
```

Business rules, navigation decisions, REST/database operations and application state do not become RickUIBuilder responsibilities.

## 17. Ownership and cleanup summary

The analyzed APIs follow these patterns:

```text
Factory
→ caller supplies AOwner and AParent explicitly

Fluent Build(AParent)
→ implementation uses AParent as Owner and Parent

TRickUIBuilder.On(AParent)
→ composer uses AParent as Owner and Parent for created controls

Button hover state
→ reference-counted interface; Build(AOwner) materializes Owner-managed runtime behavior that keeps and reads the same mutable state on subsequent events

Button/Badge handles
→ interface objects reference already-owned FMX controls; they do not own those controls; Button handles created by BuildHandle also expose the associated HoverState
```

Any DockHub integration must preserve these lifetime assumptions and must not manually free controls that are owned by their parent unless ownership is intentionally changed.

## 18. Tests inspected and execution-evidence status

The supplied RickUIBuilder module contains its DUnitX test project and source fixtures. Those test sources are behavioral support for the API analysis in this document.

This DockHub snapshot does **not** contain a RickUIBuilder NUnit result XML, console result artifact, or RAD Studio Method Toxicity CSV. Therefore upstream test execution success, leak counts, measured method totals, and measured Toxicity maxima are **not confirmed** for this snapshot.

Source-level API assertions in this document are based on the supplied RickUIBuilder implementation and test source, not on an inferred execution result.

### Current use in DockHub Main

The current `Main` implementation uses individual fluent builders because controls must remain accessible after construction for Language, Theme, and presentation-state updates. `TRickUIBuilder.On(AParent)` is not the primary mechanism for this screen because `AddText`, `AddDivider`, and `AddButton` do not return the controls they create.

DockHub stores `IRickUIBuilderButtonHandle` for Buttons whose container and caption must remain accessible after construction. Production code uses the public `Container`/`TextLabel` contract and does not inspect the Button visual tree to recover its internal `TLabel`.

The common window controls are built by `TPageCompositionBase` with `OnHover` callbacks. Those callbacks read the current `IDockHubTheme` at event time; the DockHub implementation does not currently consume `IRickUIBuilderButtonHandle.HoverState` for those window buttons.

## 19. Known documentation inconsistency upstream

Several RickUIBuilder source comments reference:

```text
docs/usage-guide.md
```

That file is not present in the analyzed repository tree.

Do not treat it as an available source until the upstream repository actually contains it.

## 20. Maintenance rule

Before implementing or reviewing DockHub runtime UI that depends on RickUIBuilder:

1. confirm the dependency version/source revision actually in use;
2. consult this reference;
3. inspect upstream source again when the task depends on behavior not documented here;
4. prefer public facade/contracts over internal implementation coupling;
5. preserve DockHub Theme and Language boundaries;
6. choose Factory, Fluent Builder or `On(...)` from the Page's actual needs;
7. do not recreate locally behavior already supplied by RickUIBuilder without technical justification;
8. update this document when an upstream API change affects DockHub integration.

## Related documentation

- [DockHub View Pages](../../modules/view/README.md)
- [ADR-0004 — View Page Composition Architecture](../../adr/ADR-0004-view-page-composition-architecture.md)
- [Theme Module](../../modules/theme/README.md)
- [Language Module](../../modules/language/README.md)
- [DockHub Documentation](../../README.md)
- [RickUIBuilder upstream repository](https://github.com/ricksolucoes/RickUIBuilder)
