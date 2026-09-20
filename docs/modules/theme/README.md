# DockHub View Theme

[Português (Brasil)](./README.pt-BR.md)

This document describes the Theme subsystem that currently exists in DockHub. It covers the public contract, implementation, semantic color model, runtime switching, gradient behavior, Main View integration, automated tests, maintenance rules and explicitly deferred evolution.

Complete palette values are kept separately in [Visual Identity Reference](./VISUAL-IDENTITY.md).

Architectural decisions and deliberately deferred runtime propagation/shared-state concerns are recorded in [ADR-0002 — Theme Architecture](../../adr/ADR-0002-theme-architecture.md).

## 1. Purpose

`View.Theme` centralizes the visual color roles used by DockHub presentation code. Its current responsibilities are to:

- expose the current theme through an interface-based contract;
- support `Blue`, `Teal`, `Light` and `Dark` palettes;
- expose semantic color tokens for surfaces, text, accents, buttons, statuses and badges;
- configure a FireMonkey background gradient from the current palette;
- switch the active palette at runtime on the same Theme instance;
- keep the visual values out of individual Views whenever they represent an existing Theme role.

The subsystem does not currently provide persistence, a visual theme selector, application-wide propagation, or an observer/event mechanism.

## 2. Architectural rule

Presentation code should request colors by semantic role through `IDockHubTheme` when that role already belongs to the Theme contract.

Preferred:

```pascal
LControl.Fill.Color := FTheme.Accent;
```

Avoid duplicating the current palette value in a View:

```pascal
LControl.Fill.Color := TAlphaColor($FF3B82F6);
```

This rule applies to values represented by the Theme subsystem. It is not a blanket prohibition on every `TAlphaColor` literal in the codebase.

The current separation is:

```text
Types
  ↓
Contracts
  ↓
Implementation
  ↓
View consumers
```

Views decide which semantic token belongs to each component. `TDockHubTheme` decides which color that token represents for the active theme.

## 3. Current structure

```text
src/view/Theme/
├── DockHub.View.Theme.Types.pas
├── Contracts/
│   └── DockHub.View.Theme.Contracts.pas
└── Impl/
    └── DockHub.View.Theme.Impl.pas
```

### Responsibility map

| Unit | Responsibility |
| --- | --- |
| `DockHub.View.Theme.Types` | Declares `TDockHubThemeType`. |
| `DockHub.View.Theme.Contracts` | Declares the public `IDockHubTheme` contract. |
| `DockHub.View.Theme.Impl` | Stores the current palette, applies the four themes, returns semantic tokens, configures gradients and implements badge helpers. |
| `DockHub.View.Page.Main` | Current consumer that owns an `IDockHubTheme` reference and applies the background gradient. |

## 4. Public type

### `TDockHubThemeType`

Declared with scoped enums enabled:

```pascal
{$SCOPEDENUMS ON}

type
  TDockHubThemeType = (Dark, Light, Blue, Teal);
```

Usage therefore requires the enum scope, for example:

```pascal
TDockHubThemeType.Blue
TDockHubThemeType.Teal
TDockHubThemeType.Light
TDockHubThemeType.Dark
```

The declaration order does **not** determine the default theme. `TDockHubTheme.Create` explicitly calls `ApplyBlue`, so a new instance starts in `Blue`.

## 5. Public contract

`DockHub.View.Theme.Contracts` defines:

```pascal
IDockHubTheme = interface(IInterface)
  ['{FABB29CC-76DA-4B97-8443-6341356B740E}']
```

The GUID is part of the current public interface identity and must be preserved unless an intentional contract-breaking change is approved.

The contract contains 36 public color tokens plus theme selection, gradient configuration and badge helper operations.

### Theme selection

```pascal
function Theme: TDockHubThemeType; overload;
function Theme(const AValue: TDockHubThemeType): IDockHubTheme; overload;
```

The getter returns the active enum. The setter-style overload applies the requested palette and returns the same interface instance for fluent use.

### Surface tokens

`Background`, `SurfaceCard`, `SurfaceElevated`, `Border`, `Divider`.

### Text tokens

`TextPrimary`, `TextSecondary`, `TextDisabled`.

### Accent and information tokens

`Accent`, `AccentHover`, `AccentLight`, `BadgeInfoBg`, `BadgeInfoText`.

### Button tokens

Primary: `ButtonPrimaryBg`, `ButtonPrimaryHoverBg`, `ButtonPrimaryText`.

Danger/ghost: `ButtonDangerBg`, `ButtonDangerHoverBg`, `ButtonDangerText`, `ButtonDangerOutlineText`, `ButtonGhostText`.

### Gradient tokens

`GradientStart`, `GradientEnd`.

### Status tokens

`StatusSuccess`, `StatusDanger`, `StatusWarning`, `StatusNeutral`.

### Status badge tokens

`BadgeSuccessBg`, `BadgeSuccessText`, `BadgeDangerBg`, `BadgeDangerText`, `BadgeWarningBg`, `BadgeWarningText`, `BadgeNeutralBg`, `BadgeNeutralText`.

### Utility token

`Transparent` always returns `$00000000` in the current implementation.

For the complete Delphi and CSS/Web values of every token in every theme, see [Visual Identity Reference](./VISUAL-IDENTITY.md).

## 6. Implementation and lifetime

The concrete implementation is:

```pascal
TDockHubTheme = class sealed(TInterfacedObject, IDockHubTheme)
```

Normal construction uses:

```pascal
FTheme := TDockHubTheme.New;
```

`New` returns `IDockHubTheme`, while the constructor is `protected`:

```pascal
class function TDockHubTheme.New: IDockHubTheme;
begin
  Result := TDockHubTheme.Create;
end;
```

Because the object derives from `TInterfacedObject`, normal lifetime is managed through interface reference counting. Consumers should keep the interface reference rather than manually freeing the object behind it.

The constructor calls `ApplyBlue`, establishing the initial theme and every token before the instance is returned.

## 7. Theme model

The same `TDockHubTheme` instance holds the current palette in fields such as `FBackground`, `FTextPrimary`, `FAccent` and `FStatusSuccess`.

Changing the theme executes one complete palette application:

```text
Theme(Blue)  → ApplyBlue
Theme(Teal)  → ApplyTeal
Theme(Light) → ApplyLight
Theme(Dark)  → ApplyDark
```

Each `Apply...` method sets `FTheme` and delegates to grouped methods for surfaces, text, accent, buttons, gradient, status and badges.

The current API does not allocate a new Theme object when switching palettes.

## 8. Semantic color groups

The groups intentionally express usage rather than raw hue names:

| Group | Purpose |
| --- | --- |
| Surfaces | Form backgrounds, cards, elevated areas and separators. |
| Text | Primary, secondary and disabled textual content. |
| Accent | Main interactive/emphasis family plus informational badge colors. |
| Buttons | Primary action, destructive action and ghost text roles. |
| Gradient | Start/end colors consumed by `BackgroundGradient`. |
| Status | Success, danger, warning and neutral states. |
| Badges | Background/text pairs for each status. |
| Utility | Transparent color. |

The complete current values belong in the separate [Visual Identity Reference](./VISUAL-IDENTITY.md), not duplicated in this architecture document.

## 9. Runtime theme switching

A consumer changes the active palette through the contract:

```pascal
FTheme.Theme(TDockHubThemeType.Dark);
```

`Theme(AValue)` selects the corresponding `Apply...` routine and returns `Self` as `IDockHubTheme`.

The implementation does not short-circuit a same-theme request. The current `TPageMain.ChangeTheme` method performs that check before calling the contract.

Changing the `IDockHubTheme` state alone does not automatically repaint every View. Each consumer must currently invoke its own presentation mapping such as `ApplyTheme`.

## 10. Background gradient

The contract exposes two overloads:

```pascal
function BackgroundGradient(AFill: TBrush;
  const AAngle: Single): IDockHubTheme; overload;

function BackgroundGradient(AFill: TBrush): IDockHubTheme; overload;
```

The overload without an angle delegates to the explicit overload with `65` degrees.

When `AFill` is assigned, the implementation:

1. sets `AFill.Kind` to `TBrushKind.Gradient`;
2. sets `AFill.Gradient.Style` to `TGradientStyle.Linear`;
3. clears existing gradient points;
4. adds exactly two points;
5. assigns `GradientStart` at offset `0`;
6. assigns `GradientEnd` at offset `1`;
7. calculates normalized start/stop positions from the supplied angle.

If `AFill` is `nil`, the method returns the current interface without raising an exception or dereferencing the brush.

The method mutates the supplied `TBrush`; it does not create or own that brush.

## 11. Badge helpers

The current Boolean helpers intentionally cover only success/danger selection:

```text
BadgeBackground(True)  → BadgeSuccessBg
BadgeBackground(False) → BadgeDangerBg
BadgeText(True)        → BadgeSuccessText
BadgeText(False)       → BadgeDangerText
```

`Warning` and `Neutral` have public tokens, but these two helpers do not select them.

## 12. Main View integration

`TPageMain` currently owns Theme and Language contracts independently and keeps the page-specific composition contract:

```pascal
FLanguage: IDockHubLanguage;
FTheme: IDockHubTheme;
FComposition: IPageCompositionMain;
```

The constructor creates Theme/Language, configures and builds the Composition, then applies both presentation concerns. `TPageMain.ApplyTheme` delegates the active Theme to the Composition:

```pascal
procedure TPageMain.ApplyTheme;
begin
  FComposition.ApplyTheme(FTheme);
end;
```

`TPageMainComposition.DoApplyTheme` maps semantic tokens to the Form background, card, text, badges and action controls. `TPageCompositionBase` applies the same Theme to the common window controls and keeps the most recently applied Theme so hover behavior follows runtime changes.

Runtime switching remains explicit through `TPageMain.ChangeTheme`: the Theme instance changes state and the existing visual tree is updated through `ApplyTheme`; controls are not rebuilt.

`ApplyTheme` is accepted only after the Composition has completed `Build` successfully. This lifecycle rule belongs to `TPageCompositionBase`, not to the Theme subsystem.

No visual Theme selector currently invokes `ChangeTheme`. The method exists, but a user-facing selection control is not documented as implemented.

## 13. Applying Theme to View controls

Page-specific Composition maps each component to the existing semantic token that represents its visual responsibility. Current Main examples include:

```text
form background       → BackgroundGradient / Background
card surface          → SurfaceCard
primary text          → TextPrimary
secondary text        → TextSecondary
primary action        → ButtonPrimary*
destructive action    → ButtonDanger*
status presentation   → Status* / Badge*
```

This documentation does not prescribe a component hierarchy that is not yet present in the source.

## 14. Changing or extending a palette

For an intentional color change:

1. update the corresponding `Apply...` group in `DockHub.View.Theme.Impl`;
2. update the expected palette in `DockHub.Tests.View.Theme`;
3. run the full DUnitX suite;
4. update [Visual Identity Reference](./VISUAL-IDENTITY.md) and its PT-BR translation;
5. update this document only when contract or behavior changes, not for every color-value change.

For a new `TDockHubThemeType`, the current implementation requires at least:

- adding the enum member;
- adding complete palette application routines;
- adding a `Theme(AValue)` branch;
- adding a complete expected palette and transition coverage in tests;
- adding the palette to the Visual Identity document.

No new theme should be documented as supported until the implementation exists.

## 15. Automated tests

The current DUnitX project declares `TDockHubThemeTests` with 17 Theme tests. This snapshot does not include a DockHub NUnit result artifact, so execution success for the current Theme tests is **not confirmed**.

Theme coverage currently includes:

- default theme is Blue;
- complete expected Blue palette;
- Blue → Teal, Light and Dark transitions;
- return to Blue;
- sequential transitions validating the complete palette after each change;
- gradient brush configuration;
- gradient colors changing with the active theme;
- default 65° gradient equivalence;
- 0° and 90° gradient positioning;
- `nil` brush behavior;
- Boolean badge background/text helpers.

The Theme tests use the real `TDockHubTheme` implementation through an `IDockHubTheme` reference. Expected palette values are centralized in test-only records/functions rather than duplicated across individual assertions.

The source also contains an FMX `TPageMainComposition` integration fixture and a `TPageCompositionBase` contract fixture. This snapshot does not include a DockHub NUnit result artifact, so their current execution status is **not confirmed**.

See [Automated Tests](../../testing/README.md) for the complete source inventory and current evidence status.

## 16. Future evolution

The following items are intentionally **not** part of the current implementation. They should be evaluated only when the application reaches the corresponding need.

### 16.1 Observer/event-based theme change

Current behavior is explicit:

```text
ChangeTheme
→ Theme(...)
→ ApplyTheme
```

This is sufficient while the UI has a single relevant consumer.

When multiple forms or independent visible components must react to the same runtime theme change, an observer/event mechanism can be evaluated:

```text
Theme changed
├── Main Form    → ApplyTheme
├── Settings     → ApplyTheme
└── Other View   → ApplyTheme
```

Each View should continue owning its own mapping between semantic tokens and controls. The future notification mechanism would change who triggers `ApplyTheme`, not move presentation mapping into the Theme implementation.

No observer interfaces, registration methods or notification APIs are implemented today and none are defined by this document.

### 16.2 Shared application theme context

Today `TPageMain` creates its own `TDockHubTheme` instance. If future windows each create independent instances, each object will maintain an independent `FTheme` and palette state.

Before introducing Observer-based notification, evaluate how the application establishes one authoritative current Theme state. Observer notification alone does not make separately constructed Theme instances share state.

This document intentionally does not select a singleton, DI container, service locator, composition root or other mechanism in advance.

### 16.3 Persisted theme preference

A future configuration subsystem may persist the selected `TDockHubThemeType`. No persistence mechanism exists in the current Theme subsystem.

### 16.4 Theme-selection UI

No visual selector currently exists. When one is implemented, it should use the Theme contract and trigger the View's normal theme-application flow rather than write component colors directly.

## 17. Maintenance checklist

Before merging a Theme change, verify:

- [ ] `IDockHubTheme` remains consistent with `TDockHubTheme`.
- [ ] Interface GUID is unchanged unless an intentional breaking contract change is approved.
- [ ] Every supported theme assigns all semantic palette fields.
- [ ] A theme transition does not retain stale values from the previous palette.
- [ ] New View styling uses semantic tokens when a matching token exists.
- [ ] Gradient behavior remains consistent with the documented contract.
- [ ] DUnitX Theme tests are updated when palette or behavior changes.
- [ ] The full DUnitX suite is executed after a Theme change.
- [ ] Visual Identity EN/PT-BR is updated when a palette value changes.
- [ ] Future Observer/shared-context behavior is not documented as implemented before code exists.

## 18. Validation status

This documentation was derived from the current Theme source, the current `TPageMain` integration supplied for the project, and the Theme test fixture. The current source declares 17 Theme tests, but this snapshot does not include a DockHub NUnit result artifact. Current Theme test execution status is **not confirmed**.
