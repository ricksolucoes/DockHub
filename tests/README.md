# DockHub Automated Tests

[Português (Brasil)](./README.pt-BR.md)

DockHub uses DUnitX. This document distinguishes the current source test inventory from the latest available execution evidence.

## Current structure

```text
tests/
├── Core/
│   ├── DockHub.Tests.Core.Language.Types.pas
│   └── DockHub.Tests.Core.Language.pas
├── View/
│   ├── DockHub.Tests.View.Theme.pas
│   ├── DockHub.Tests.View.Page.Composition.Base.pas
│   └── DockHub.Tests.View.Page.Main.Composition.pas
├── DockHub.Tests.dpr
└── DockHub.Tests.dproj
```

## Source test inventory

The current source declares **58 tests**:

```text
TDockHubLanguageTypeTests            : 10
TDockHubLanguageTests                :  7
TDockHubThemeTests                   : 17
TDockHubPageCompositionBaseTests     : 15
TDockHubPageMainCompositionTests     :  9
                                        --
Total                                : 58
```

This is a source-code inventory. It is **not** proof that all 58 tests compiled or executed successfully.

## Framework and runner

The runner uses DUnitX. Without `TESTINSIGHT`, the project runs as a console application and registers console plus NUnit-compatible XML logging. With `TESTINSIGHT`, it uses `TestInsight.DUnitX`.

## Search paths

The current test project includes the source paths required by Language, Theme and the current `View.Page` architecture, including:

```text
..\src\view\Page
..\src\view\Page\Contracts
..\src\view\Page\Types
..\src\view\Page\Impl
..\src\view\Page\Impl\Main
..\modules\github_com_ricksolucoes_RickUIBuilder\src
```

The previous `..\src\view\Page\Main` / `..\src\view\Page\Main\Composition` paths are no longer part of the current test project structure.

## `TDockHubLanguageTypeTests`

Keeps the 10 existing tests for `TDockHubLanguageType` and helper conversions.

## `TDockHubLanguageTests`

Keeps 7 tests covering default/switching behavior, the Main View translation set for `pt-BR` and `en-US`, and unknown-key behavior.

The production Main translation set currently includes caption, subtitle, status labels, actions and neutral status text.

## `TDockHubThemeTests`

Keeps the existing 17 tests for the `Blue`, `Teal`, `Light` and `Dark` palettes, gradient behavior, semantic tokens and Theme transitions.

## `TDockHubPageCompositionBaseTests`

This fixture is marked:

```pascal
[Category('Contract')]
```

It validates the public lifecycle/contract of `TPageCompositionBase` without exposing its private `FState` only for testing.

The 15 source tests cover:

- nil host Form rejection;
- nil minimize callback rejection;
- nil close callback rejection;
- Build validation when Form is missing;
- Build validation when minimize callback is missing;
- Build validation when close callback is missing;
- `ApplyTheme` rejection before successful Build;
- `ApplyLanguage` rejection before successful Build;
- nil Theme rejection after Build;
- nil Language rejection after Build;
- configuration being closed after Build;
- idempotent second Build after `Built`;
- Build failure becoming terminal and blocking retry;
- common minimize/close callbacks;
- common window hover using the most recently applied Theme.

The fixture declares a test-only derived class that implements the abstract Template Method hooks. No production seam or public lifecycle-state accessor was added solely for test purposes.

## `TDockHubPageMainCompositionTests`

This fixture is marked:

```pascal
[Category('Integration')]
```

It uses a real `TForm.CreateNew(nil)` plus the current `IPageCompositionMain` / `TPageMainComposition.New` API.

The 9 source tests cover:

- centered Main card creation;
- idempotent Build without duplicate visual tree;
- `pt-BR` text application;
- `en-US` runtime change reusing existing controls;
- Theme runtime change on the Main card;
- window hover using the current Theme after runtime change;
- unimplemented administrative actions remaining disabled;
- configured minimize/close callbacks;
- host destruction while the interface keeps the composition alive until the FMX controls are destroyed.

The fixture validates observable FMX behavior and does not expose private Main Composition fields merely for test access.

## Latest available executed result

The latest XML currently available at `tests/APP/Debug/dunitx-results.xml` is dated **2026-09-13** and reports:

```text
Total tests : 34
Passed      : 34
Ignored     : 0
Failures    : 0
Errors      : 0
```

That XML predates both Page Composition fixtures and the expanded Main View translation assertions. It is historical evidence only.

It does **not** validate the 58 tests currently declared in source and must not be presented as proof that the current test project passes.

## Running the current suite

1. Open `Dock.Hub.groupproj` or `tests/DockHub.Tests.dproj` in RAD Studio.
2. Select the `DockHub.Tests` project.
3. Select the desired configuration/platform.
4. Compile the test project.
5. Run DUnitX or TestInsight.
6. Treat the actual runner/XML result as the execution authority.

For focused diagnosis, run the Page Composition contract fixture before the Main integration fixture, then run the complete suite.

## Current coverage gaps

The current source still does not directly cover every implemented branch. Known gaps include:

- `EnUS → PtBR` fallback with a production key deliberately missing from `EnUS`;
- fallback-cache reuse in `Core.Language`;
- duplicate translation registration;
- empty translation key/value validation;
- the real unsupported-language branch;
- pixel-level visual rendering of Main;
- administrative Main actions, because their application use cases are not implemented yet.

## Maintenance rules

When behavior changes:

- test contracts and observable behavior rather than private fields;
- cover lifecycle/error transitions when they change;
- distinguish contract/unit tests from FMX integration tests;
- do not change production design merely to make a test easier;
- update `DockHub.Tests.dpr` and `.dproj` when adding a fixture;
- do not report a source test count as an executed/passed count;
- do not replace historical XML evidence until a new real execution exists.
