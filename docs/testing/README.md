# DockHub Automated Tests

[Português (Brasil)](./README.pt-BR.md)

DockHub uses DUnitX. This document distinguishes the current source test inventory from the current execution evidence supplied for this snapshot.

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

The current source inventory contains **59 declared tests**. The latest real execution evidence remains the previously supplied **58-test** XML run; the new window-control geometry regression test does not yet have real execution evidence.

## Framework and runner

The test project uses DUnitX with DockHub's own FMX GUI runner (`DockHub.Tests.Runner.FMX`), created entirely in code with no `.fmx` resource. The current `DockHub.Tests.dpr` calls `RunDockHubTests` directly; this snapshot has no active `TESTINSIGHT` or `CI` branches in the project entry point.

The project no longer uses `DUNitX.Loggers.GUIX`. In the current Delphi environment, that runner's embedded FMX resource raised `EReadError` while loading `GUIXTestRunner.FormFactor.Devices`, with `Invalid property value`. The local runner avoids that dependency by creating the full interface at runtime through `CreateNew`.

The project remains an FMX application (`AppType=Application`). `RunDockHubTests` calls `TDUnitX.CheckCommandLine`, initializes the application and opens `TDockHubTestsRunnerForm`.

Every effective full-suite or subset execution passes through `RunSuite`. At that point the runner registers `TDUnitXXMLNUnitFileLogger` with `TDUnitX.Options.XMLOutputFile` before `Execute`. Therefore the GUI flow itself generates NUnit XML for the execution that actually ran; selective execution produces XML for the selected subset.

`dunitx-results.xml` is a **regenerable execution artifact**, not project documentation. It should be used as evidence for updating documented numbers, but it should not be versioned by default. In the current repository the `app/` output directory is already covered by `.gitignore`. When no alternate XML destination is supplied to DUnitX, the supplied execution shows the file being generated next to the test executable under `App\Debug`.

The interactive runner has two complementary surfaces: **test selection before execution** and **result diagnosis after execution**. The selection pane exposes the DUnitX fixture/test hierarchy with checkboxes, fixture/test search, `All` / `None` / `Invert`, selected-test count, **Run selected** and **Run all**, plus single-test execution by double-click without changing the current selection. Fixture rows show `selected/total`, keeping partial selection visible even with the FMX TreeView's binary checkbox.

The result surface remains independent from execution selection: summary cards expose counters from the latest execution, tests are grouped by fixture, each result combines textual status with semantic color and a side indicator, quick filters isolate failures/errors/leaks/ignored cases, and selecting a row opens message/expected/actual/stack-trace details when available. The runner owns a small private palette and does not depend on production `IDockHubTheme`, so a Theme-module failure cannot prevent the test UI itself from rendering.

The runner provides **Dark** and **Light** themes, selectable from the toolbar and applied at runtime without rebuilding the suite or changing test selection. The preference is persisted only as the `Dark`/`Light` identifier in `DockHub.Tests.ini`, in the **same directory as the test executable**, obtained through `TPath.GetDirectoryName(ParamStr(0))`, section `[Appearance]`, key `Theme`. **Dark** is the safe default: it is used when the file does not exist, the key is missing, the stored value is invalid, or the preference cannot be read. A persistence-write failure does not prevent the GUI from operating; a later start falls back to Dark if no valid preference is available. Individual palette colors are not serialized.

Selection uses DUnitX's own runtime model. The runner builds its catalog with `ITestRunner.BuildFixtures`, preserves user choices in discovered `ITest.Enabled` flags, and applies the selected tests' full names to the execution runner before `Execute`. `Run all` temporarily ignores the subset without modifying it; `Run selected` executes only checked tests; double-click runs only that test while preserving the existing selection.

All current fixtures explicitly call `TDUnitX.RegisterTestFixture`. Explicit fixture registration is the current DockHub convention and should be preserved so the current runner sees the same suite on every execution.

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
- regression coverage for window-control geometry, requiring a `Width <> ClientWidth` scenario and validating visibility, client-area bounds, ordering, and non-overlap;
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

## Latest executed result

The supplied `dunitx-results.xml` for the current runner records a real execution at **2026-09-19 10:52:19** with:

```text
total        : 58
errors       : 0
failures     : 0
ignored      : 0
inconclusive : 0
not-run      : 0
skipped      : 0
invalid      : 0
assembly     : Success
```

All **58 `test-case`** elements in the XML are marked as executed with `result="Success"` / `success="True"`. The current source inventory contains **59 tests**; therefore this run remains the latest real execution evidence, but it does not include the new `WindowButtons_AreVisibleAndInsideClientBounds` regression test.

This XML proves the cases and results it contains. By itself it does not prove code coverage, thread safety, behavior outside the executed cases, or a separate memory-leak count because the supplied NUnit format has no dedicated leak field.

The XML is evidence for one execution and may be replaced by the next run; the confirmed numbers are therefore documented here while `dunitx-results.xml` remains out of version control by default.

### Build evidence

The supplied RAD Studio capture records a real compilation of `DockHub.Tests.dproj` in **Debug / Win32** with result **Success**.

The same compilation also reports:

```text
DockHub.View.Page.Composition.Impl.Base.pas(1): Line endings are LF, but RAD Studio requires CRLF. Consider converting or check your source control settings.
```

Therefore real compilation is confirmed for that configuration, but a **warning/message-free build is not confirmed**.

## Method Toxicity — test project

A real RAD Studio Method Toxicity report was supplied for `DockHub.Tests.dproj`. The highest **reported/displayed Toxicity value** in the current capture, sorted by Toxicity, is:

```text
0.508
```

Project threshold for `Toxicity`:

```text
1
```

Therefore the highest displayed value in the supplied evidence is below the project threshold.

The capture is used only for values actually visible in it. It is not used to claim project-wide maxima for `Length`, `Parameters`, `If Depth` or `Cyclomatic Complexity` beyond what the image proves, nor to reconstruct the internal `Toxicity` formula manually.

## Running the current suite

1. Open `Dock.Hub.groupproj` or `tests/DockHub.Tests.dproj` in RAD Studio.
2. Select the `DockHub.Tests` project.
3. Select the desired configuration/platform.
4. Compile the test project.
5. Run the project normally to open `DockHub.Tests.Runner.FMX`. On first run, or whenever no valid theme preference exists, the runner starts in **Dark**.
6. Use the toolbar **Theme** selector to switch between **Dark** and **Light**. A valid choice is restored on the next start through `DockHub.Tests.ini`, stored next to the test executable.
7. Use the left selection tree to check/uncheck an entire fixture or individual tests. Use the search field to locate fixtures/tests; `All`, `None` and `Invert` operate on the complete catalog, not only on currently visible search results.
8. Use **Run selected** to execute the checked subset, **Run all** to execute the complete suite without losing the current subset, or double-click a test to execute only that test while preserving the current selection.
9. Use the summary cards, fixture groups and quick result filters to navigate the result set. Select a result row to inspect status, message, comparable expected/actual values when available, and stack trace.
10. After each execution, use the generated NUnit XML as regenerable evidence for that run when results must be recorded or integrated with external tooling.
11. Do not version `dunitx-results.xml` as documentation. Update documented numbers only from an identifiable real execution.

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
- explicitly register each fixture with `TDUnitX.RegisterTestFixture` unless the current runner strategy is deliberately changed and revalidated;
- preserve the current code-only FMX entry point and per-execution NUnit XML generation; do not document TestInsight/CI as active unless they exist in the current `DockHub.Tests.dpr`;
- preserve semantic result communication with both text and color; color alone must never be the only state indicator;
- preserve the separation between pre-execution selection and post-execution result filters; changing a result filter must never silently change which tests will execute;
- keep `Run all` independent from the current subset, keep `Run selected` driven by checked tests, and preserve the user's selection when a single test is executed by double-click;
- implement focused execution through DUnitX `BuildFixtures` / `ITest.Enabled` rather than a parallel test-discovery mechanism;
- keep the interactive runner independent from production Theme contracts; its private `Dark`/`Light` palettes are infrastructure-only and must not make the test runner depend on the module it may need to test;
- preserve `Dark` as the fallback when the appearance preference is missing, invalid or unreadable; persist only the theme identifier in `DockHub.Tests.ini`, next to the test executable, never individual color tokens;
- preference read/write failures must never prevent the runner from starting or executing tests;
- do not reintroduce `DUNitX.Loggers.GUIX` without revalidating its FMX resource in the actual Delphi version; the current runner is code-only specifically to avoid `.fmx` streaming incompatibility;
- do not report a source test count as an executed/passed count;
- update execution evidence only from a real runner/XML result; do not infer pass status from source test counts;
- treat `dunitx-results.xml` as a regenerable execution artifact, not versioned documentation;
- apply Method Toxicity Metrics to test code as well as production code.
