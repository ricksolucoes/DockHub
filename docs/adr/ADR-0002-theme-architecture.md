# ADR-0002 — DockHub Theme Architecture

[Português (Brasil)](./ADR-0002-theme-architecture.pt-BR.md)

- **Status:** Accepted
- **Scope:** `DockHub.View.Theme`
- **Decision type:** Internal architecture / UI theme infrastructure

## Context

DockHub requires visual roles to be centralized instead of being represented by repeated color literals across Views. The application must support multiple palettes and runtime Theme changes while keeping presentation mapping inside the View layer.

The current Theme subsystem already exposes semantic visual roles through `IDockHubTheme`, supports the `Blue`, `Teal`, `Light` and `Dark` palettes, changes the active palette on the same Theme instance, and provides reusable background-gradient construction. `TPageMain` owns its `IDockHubTheme` state and delegates presentation mapping through `IPageCompositionMain.ApplyTheme`; the page-specific Composition applies Theme values to the Form and runtime controls.

This is sufficient for the current application stage, but it does not yet establish an application-wide Theme state or automatic propagation to multiple independent Views. Those concerns are intentionally deferred until the application has consumers that require them.

## Decision

The following decisions are accepted for the current implementation.

### 1. Module structure

Theme remains separated into:

```text
DockHub.View.Theme.Types
DockHub.View.Theme.Contracts
DockHub.View.Theme.Impl
```

`Types` owns public Theme-related types, `Contracts` owns `IDockHubTheme`, and `Impl` owns the concrete Theme state and palette implementation.

### 2. Interface-oriented consumption

Consumers store and use `IDockHubTheme` rather than depending on `TDockHubTheme` as their public collaboration type.

The current implementation is `TDockHubTheme = class sealed(TInterfacedObject, IDockHubTheme)` and is normally created through `TDockHubTheme.New`.

The interface GUID is:

```text
{FABB29CC-76DA-4B97-8443-6341356B740E}
```

The GUID is part of the current public interface identity and should remain stable while the contract remains compatible.

### 3. Default Theme

A new `TDockHubTheme` instance starts with `Blue` as the active Theme because construction explicitly applies the Blue palette.

The declaration order of `TDockHubThemeType` does not define the default Theme.

### 4. Semantic visual tokens

Views consume semantic roles such as background, text, accent, button and status roles rather than duplicating the concrete color value of the active palette.

The responsibility boundary is:

```text
View
→ chooses the semantic visual role for a component

Theme
→ resolves that role to the value of the active palette
```

The complete token inventory and concrete palette values are documented outside this ADR in the Theme module documentation and Visual Identity reference.

### 5. Visual Identity remains a separate specification

Concrete palette values do not belong to this ADR.

The reusable visual specification is maintained in:

```text
docs/modules/theme/VISUAL-IDENTITY.md
```

This ADR records why semantic Theme roles and palettes exist; the Visual Identity document records the actual color values.

### 6. Runtime Theme change mutates the current Theme instance

Changing the Theme through `IDockHubTheme.Theme(...)` updates the active palette on the existing object. A Theme change does not require the consumer to replace its `IDockHubTheme` reference.

This stateful behavior is relevant to future application-wide propagation because the active Theme is state that may eventually need one authoritative owner.

### 7. Presentation application remains owned by each View

A View remains responsible for applying semantic Theme values to its own controls through an `ApplyTheme`-style method.

The Theme subsystem must not acquire responsibility for locating or directly manipulating controls belonging to specific Forms or Views.

The intended responsibility boundary is:

```text
Theme state changes
       ↓
View is informed
       ↓
View executes ApplyTheme
       ↓
View updates its own controls
```

This boundary remains valid if automatic notification is introduced later.

### 8. Theme does not depend on specific Views

`DockHub.View.Theme` must remain independent from concrete Forms such as `TPageMain` and from the control hierarchy of a specific screen.

The Theme provides reusable visual values and Theme-specific visual construction. The consumer decides where those values are applied.

### 9. Reusable gradient construction remains in Theme

The Theme subsystem owns the reusable construction of its background gradient. A View owns the decision about which `TBrush` receives that gradient.

This prevents each View from duplicating Theme-specific gradient construction while preserving View ownership of presentation mapping.

### 10. Automatic runtime propagation is deliberately deferred

The current explicit flow is sufficient for the current UI:

```text
ChangeTheme
→ Theme(...)
→ ApplyTheme
```

Automatic propagation is not implemented today.

When multiple independent Views or visual components need to react to the same runtime Theme change, a future Observer/event-based notification mechanism **should be evaluated**. Observer is therefore a current architectural direction for evaluation, not a mandatory future implementation.

Any future notification mechanism should trigger the existing View-owned application flow rather than move presentation mapping into the Theme service:

```text
Theme changes
      ↓
notification mechanism
      ↓
┌──────────┬──────────┬──────────┐
↓          ↓          ↓
View A     View B     View C
↓          ↓          ↓
ApplyTheme ApplyTheme ApplyTheme
```

No Observer interface, registration API, notification method or Theme manager is defined by this ADR.

### 11. Shared Theme state is a separate deferred decision

Notification alone does not establish shared state.

If future Views each create independent `TDockHubTheme` instances, each object owns an independent current palette. Before or together with automatic propagation, the application must evaluate how one authoritative Theme state should be shared between consumers.

This ADR intentionally does not choose a singleton, dependency injection container, service locator, composition root, application context, Theme manager or another ownership mechanism before a concrete need exists.

### 12. Theme preference persistence is deferred

Persisting the user's selected `TDockHubThemeType` across application runs is not part of the current Theme subsystem.

When persistence becomes necessary, its storage mechanism must be decided from the application's configuration requirements rather than being predetermined by this ADR.

### 13. Visual Theme selection is deferred

The current Main View can change Theme programmatically, but no user-facing Theme selector is currently part of the documented implementation.

When a visual selector is introduced, it should invoke the normal Theme-change flow and allow the View to reapply its Theme. The selector should not write palette colors directly into controls.

## Consequences

### Positive

- visual identity is centralized behind semantic roles;
- Views remain decoupled from concrete palette values;
- multiple palettes can be selected without changing consumer semantics;
- Theme-specific reusable visual construction remains centralized;
- Views retain ownership of their control mapping and presentation logic;
- the current design can evolve toward multiple synchronized Views without discarding `ApplyTheme`;
- automatic notification and shared state can be introduced only when the application demonstrates the need.

### Trade-offs

- Theme state is currently local to each Theme instance;
- `TPageMain` currently owns its own Theme instance rather than consuming an application-wide Theme context;
- Theme changes are not automatically propagated to independent Views;
- each View is responsible for reapplying Theme values to its own controls;
- a future multi-View implementation will require an explicit ownership decision in addition to any notification mechanism.

## Rejected/deferred alternatives

### Palette values embedded directly in Views

Rejected when an existing semantic Theme token represents the visual role. Duplicating palette values in consumers would weaken the Theme abstraction and make palette changes harder to control.

### Theme directly manipulating View controls

Rejected. Theme must not depend on concrete Forms or take ownership of presentation mapping that belongs to each View.

### Views rebuilding Theme gradient logic

Rejected for the gradient behavior already supplied by `IDockHubTheme`. Reusable Theme-specific construction remains centralized while the View decides where it is applied.

### Observer/event propagation from the first implementation

Deferred. The current UI does not yet require an application-wide notification mechanism. When multiple independent consumers need runtime synchronization, an Observer/event-based approach should be evaluated rather than assumed in advance.

### Global/shared Theme state from the first implementation

Deferred. A shared lifetime/ownership model should be selected only when multiple consumers require one authoritative current Theme.

### Theme preference persistence from the first implementation

Deferred. The current Theme subsystem has no persistence requirement and therefore does not prescribe a storage mechanism.

## Future evaluation triggers

Revisit this ADR when one or more of the following become true:

- a second independent View must share the same current Theme;
- multiple Views or components must react automatically to a runtime Theme change;
- Theme preference must persist across application runs;
- a user-facing Theme selector is introduced;
- Theme lifetime stops being owned directly by individual Views;
- independent application components need a single authoritative Theme state;
- Theme state is accessed or mutated outside the normal UI flow;
- `IDockHubTheme` requires a material architectural change.

## Validation

The current source declares 17 tests in `TDockHubThemeTests`, plus the current `TPageCompositionBase` contract fixture and FMX `TPageMainComposition` integration fixture. This snapshot does not include a corresponding DockHub NUnit result, so the current execution result is **not confirmed**.

Detailed test inventory and execution information remain in [Automated Tests](../testing/README.md).

## Related documentation

- [Theme Module](../modules/theme/README.md)
- [Visual Identity](../modules/theme/VISUAL-IDENTITY.md)
- [Automated Tests](../testing/README.md)
- [ADR-0001 — Language Architecture](./ADR-0001-language-architecture.md)
