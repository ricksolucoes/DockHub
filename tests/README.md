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
├── Runner/
│   └── DockHub.Tests.Runner.FMX.pas
├── DockHub.Tests.dpr
└── DockHub.Tests.dproj
```

## Source test inventory

The current source declares **59 tests**:

```text
TDockHubLanguageTypeTests            : 10
TDockHubLanguageTests                :  7
TDockHubThemeTests                   : 17
TDockHubPageCompositionBaseTests     : 16
TDockHubPageMainCompositionTests     :  9
                                        --
Total                                : 59
```

The latest confirmed **DockHub** NUnit execution evidence matches this inventory: `DockHub.Tests.exe`, dated **2026-09-19 22:17:23**, executed all **59 tests** with assembly result `Success`, 0 failures and 0 errors. The separate upstream execution `RickUIBuilder.Test.exe`, dated **2026-09-19 21:04:44**, reports **151 total / 0 errors / 0 failures** and remains dependency evidence rather than DockHub execution evidence. Source counts and execution evidence remain separate so future source changes are not automatically treated as passed executions.

## Framework and runner

The test project uses DUnitX with DockHub's code-only FMX runner (`DockHub.Tests.Runner.FMX`). The current `DockHub.Tests.dpr` calls `RunDockHubTests` directly. Each effective execution registers `TDUnitXXMLNUnitFileLogger`, so the GUI run generates NUnit XML for the suite or subset that actually executed. `dunitx-results.xml` is a regenerable execution artifact and is not project documentation.

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

The 16 source tests cover:

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
- window-control geometry regression coverage, including a `Width <> ClientWidth` scenario, visibility, client-area bounds, ordering and non-overlap;
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

## Latest confirmed DockHub execution result

The latest confirmed DockHub NUnit execution is the post-`IRickUIBuilderButtonHandle` run of `DockHub.Tests.exe` at **2026-09-19 22:17:23**:

```text
total        : 59
errors       : 0
failures     : 0
ignored      : 0
inconclusive : 0
not-run      : 0
skipped      : 0
invalid      : 0
assembly     : Success
```

All **59 `test-case`** elements were marked as executed with `result="Success"` / `success="True"`. The execution explicitly includes `WindowButtons_InvokeConfiguredCallbacks`, `WindowButtons_AreVisibleAndInsideClientBounds`, `WindowHover_UsesCurrentThemeAfterRuntimeChange`, `ApplyLanguage_PtBR_UpdatesMainTexts`, `ApplyLanguage_EnUS_ReusesExistingControls`, `ApplyTheme_RuntimeChange_UpdatesMainCard`, `Build_UnimplementedActions_AreDisabled`, and `FreeHost_WithBuiltComposition_DoesNotRaise` as successful.

This run is the current post-integration DockHub regression evidence for the `IRickUIBuilderButtonHandle` adaptation: **59/59 tests executed successfully**, with 0 failures and 0 errors.

The separate upstream execution `RickUIBuilder.Test.exe`, dated **2026-09-19 21:04:44**, reports **151 total / 0 errors / 0 failures**. It is RickUIBuilder dependency evidence and must remain separate from the DockHub `DockHub.Tests.exe` execution dated **2026-09-19 22:17:23**.

## Running the current suite

1. Open `Dock.Hub.groupproj` or `tests/DockHub.Tests.dproj` in RAD Studio.
2. Select the `DockHub.Tests` project.
3. Select the desired configuration/platform.
4. Compile the test project.
5. Run the project normally to open `DockHub.Tests.Runner.FMX`.
6. Execute the required subset or the complete suite.
7. Treat the actual runner/NUnit XML result as the execution authority.

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
- update documented execution evidence only from a new real runner/XML result;
- treat `dunitx-results.xml` as a regenerable execution artifact, not versioned documentation.
