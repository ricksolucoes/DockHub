# DockHub Documentation

[Português (Brasil)](./README.pt-BR.md)

This directory contains documentation for components that already exist in the DockHub codebase and Architecture Decision Records for decisions that materially affect future maintenance.

## Current documentation

| Document | Purpose |
| --- | --- |
| [Language Module](./modules/language/README.md) | Architecture, contracts, runtime behavior, fallback, cache, exceptions, view integration, maintenance and evolution of `Core.Language`. |
| [Theme Module](./modules/theme/README.md) | Architecture, contract, semantic tokens, runtime switching, gradient behavior, Main View integration, tests, maintenance and planned evolution of `View.Theme`. |
| [View Page Architecture](./modules/view/README.md) | `View.Page` organization, per-Page physical boundary, `Composition` responsibility, events, Theme/Language integration and growth rules. |
| [RickUIBuilder — DockHub Integration Reference](./dependencies/rickuibuilder/README.md) | Analyzed upstream snapshot, Factory/Fluent/Composition behavior, ownership, events, handles, limitations and DockHub Theme/Language integration rules. |
| [Visual Identity](./modules/theme/VISUAL-IDENTITY.md) | Complete Delphi and CSS/Web palette values for Blue, Teal, Light and Dark, maintained as the reusable visual reference. |
| [ADR-0001 — Language Architecture](./adr/ADR-0001-language-architecture.md) | Records why the current language architecture was chosen and which trade-offs are intentionally deferred. |
| [ADR-0002 — Theme Architecture](./adr/ADR-0002-theme-architecture.md) | Records the current Theme architecture, responsibility boundaries and the runtime propagation/shared-state decisions intentionally deferred for future evaluation. |
| [ADR-0003 — View Page and Runtime Composition Architecture](./adr/ADR-0003-view-page-architecture.md) | Records per-Page organization and the boundary between Page lifecycle/behavior and runtime visual composition. |
| [Automated Tests](../tests/README.md) | DUnitX project layout, execution, current test inventory, results and known coverage gaps. |

## Documentation rules

Documentation in this repository follows these rules:

- describe only behavior that is implemented or explicitly marked as planned;
- distinguish implemented behavior from tested behavior;
- do not present architectural reorganization as a user-facing feature;
- keep public contracts, GUIDs, unit names and paths consistent with the source code;
- record future changes as evaluation items, not as current capabilities;
- keep English as the official project documentation and provide a Brazilian Portuguese translation for major documents.
