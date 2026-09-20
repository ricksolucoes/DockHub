# ADR-0001 — DockHub Language Architecture

[Português (Brasil)](./ADR-0001-language-architecture.pt-BR.md)

- **Status:** Accepted
- **Scope:** `DockHub.Core.Language`
- **Decision type:** Internal architecture / localization infrastructure

## Context

DockHub requires user-facing text to be resolved through a centralized language component rather than being embedded directly in forms and presentation code. The selected language must be changeable at runtime, while Brazilian Portuguese remains the official/default language and the mandatory fallback.

The project already uses a structural pattern in the Theme subsystem based on `Types`, `Contracts` and `Impl`, interface-oriented consumption, `TInterfacedObject`, explicit GUIDs and a `New` factory-style method. The Language module was designed to remain consistent with that project style without introducing external catalogs or a broad framework before the need exists.

## Decision

The following decisions are accepted for the current implementation.

### 1. Module structure

Language is located under `src/core/language` and is split into:

```text
Types
Contracts
Impl
Keys
Translations/<Language>
```

Each language has an independent translation unit.

### 2. Language type

Supported languages are represented by a scoped enum:

```pascal
TDockHubLanguageType = (PtBR, EnUS);
```

`TDockHubLanguageHelper` owns technical conversions (`ToString`, `ToCultureCode`, `FromString`).

### 3. Translation key type

Translation keys use a semantic string type:

```pascal
TDockHubTranslationKey = type string;
```

Keys are declared as constants near their consumer/module scope, and project constants follow the `_` prefix convention.

Example:

```pascal
_VIEW_MAIN_CAPTION = 'View.Main.Caption';
```

### 4. Contract and implementation

Consumers depend on `IDockHubLanguage`. The current implementation is `TDockHubLanguage = class sealed(TInterfacedObject, IDockHubLanguage)` and is normally created through `TDockHubLanguage.New`.

The interface GUID is:

```text
{7B6C1A0B-E84C-4EC0-93E1-F3C3C61873CD}
```

### 5. Official language and fallback

`PtBR` is the official/default catalog.

If a translation key is absent from a supported secondary language, resolution falls back to `PtBR`. If the key is absent from `PtBR` as well, `EDockHubTranslationNotFound` is raised.

A missing entire language is not treated as a fallback case. An unsupported language branch raises `EDockHubLanguageNotSupported`.

### 6. Memory model

The implementation keeps:

```text
FDefaultTranslations = PtBR, resident for object lifetime
FCurrentTranslations = selected secondary language, or nil for PtBR
```

It does not keep dictionaries for every supported language simultaneously.

### 7. Fallback cache

When a secondary-language lookup falls back successfully to `PtBR`, the resulting value is cached in `FCurrentTranslations`. Repeated access then hits the current dictionary first.

The cache is discarded when the secondary language changes or when the application returns to `PtBR`.

### 8. Transactional language replacement

A new secondary catalog is completely built before the current dictionary and current-language state are replaced. Catalog construction failure therefore preserves the previously active language state.

### 9. Central registration validation

Language units receive a registration callback rather than direct ownership of the dictionary. `TDockHubLanguage.AddTranslation` centralizes validation for empty keys, empty values and duplicates.

### 10. View update model

The current UI uses an explicit `ApplyLanguage` flow coordinated by each View. `TPageMain` owns the active `IDockHubLanguage` state and delegates presentation mapping to `IPageCompositionMain.ApplyLanguage`; `TPageMainComposition` resolves the Main translation keys and applies them to the Form caption and runtime controls.

Automatic Observer/event propagation is deliberately deferred until multiple windows or independent visible components justify it.

## Consequences

### Positive

- user-facing text has a single resolution path;
- public Language behavior remains behind an interface;
- `pt-BR` fallback policy is deterministic;
- only one optional secondary catalog is held in memory;
- translation content is separated from resolution logic;
- adding translations does not grow the implementation unit with text literals;
- a failed language load does not destroy the current valid state;
- the design can evolve to multiple views without discarding `ApplyLanguage`.

### Trade-offs

- the implementation contains an explicit `case` mapping from enum to language loader;
- adding a language requires changes to the enum helper and `BuildTranslations`;
- fallback cache entries are operational values and do not distinguish native translation from inherited `pt-BR` text inside the dictionary itself;
- `TPageMain` currently owns its own Language instance, so an application-wide language context is not yet established;
- no synchronization exists for concurrent language mutation/cache writes.

## Rejected/deferred alternatives

### External JSON/catalog files

Deferred. The current project does not require an external translation deployment/update mechanism, and introducing one now would add infrastructure without a demonstrated need.

### Single global enum for every translation key

Rejected for the current design. It would centralize all module text identities in one growing enum and increase coupling between unrelated functional areas.

### All languages permanently loaded

Rejected for the current design. The selected strategy keeps `PtBR` plus at most one secondary catalog resident.

### Observer from the first implementation

Deferred. The current UI size does not require a notification bus. The future Observer should trigger existing `ApplyLanguage` methods rather than move presentation mapping into the language service.

### Direct view-owned translation literals

Rejected. Final user-facing strings belong in translation catalogs, not in presentation code or form resources.

## Future evaluation triggers

Revisit this ADR when one or more of the following become true:

- multiple forms must react to one language change;
- a globally shared language context becomes necessary;
- language preference must persist across runs;
- translations must be updated independently of the executable;
- background threads share and mutate the Language service;
- catalog size makes memory/load performance measurable;
- automated enforcement of the no-direct-user-text rule becomes desirable.

## Validation

The current source declares 17 Language-related tests: 10 in `TDockHubLanguageTypeTests` and 7 in `TDockHubLanguageTests`. This snapshot does not include a corresponding NUnit result, so the current execution result is **not confirmed**. Direct fallback/cache branch coverage is still pending a suitable production key or a future test seam.
