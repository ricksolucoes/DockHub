# DockHub Automated Tests

[Português (Brasil)](./README.pt-BR.md)

DockHub currently contains a dedicated DUnitX console test project:

```text
tests/
├── DockHub.Tests.dpr
├── DockHub.Tests.dproj
├── Core/
│   ├── DockHub.Tests.Core.Language.Types.pas
│   └── DockHub.Tests.Core.Language.pas
└── View/
    └── DockHub.Tests.View.Theme.pas
```

The project is also included in `Dock.Hub.groupproj` together with the main FMX application.

## Framework and runner

The test project uses DUnitX.

`DockHub.Tests.dpr` supports two execution paths:

- `TestInsight.DUnitX.RunRegisteredTests` when `TESTINSIGHT` is defined;
- the normal DUnitX console runner otherwise.

The console runner currently adds:

- `TDUnitXConsoleLogger`;
- `TDUnitXXMLNUnitFileLogger`.

The project defaults to `Debug` / `Win32` in `DockHub.Tests.dproj`.

The current debugger parameter stored in the project is:

```text
--exitbehavior:Pause
```

This keeps the console open after execution when the normal runner is used outside CI.

## Search paths

The test project currently references the existing Language paths plus the Theme paths required by `TDockHubThemeTests`:

```text
$(DUnitX)
..\src\core\Language
..\src\core\Language\Contracts
..\src\core\Language\Impl
..\src\core\Language\Keys
..\src\core\Language\Translations
..\src\view\Theme
..\src\view\Theme\Contracts
..\src\view\Theme\Impl
```

## Fixture: `TDockHubLanguageTypeTests`

The fixture contains 10 tests:

| Test | Behavior validated |
| --- | --- |
| `PtBR_ToString` | `PtBR` technical name is `PtBR`. |
| `EnUS_ToString` | `EnUS` technical name is `EnUS`. |
| `PtBR_ToCultureCode` | `PtBR` maps to `pt-BR`. |
| `EnUS_ToCultureCode` | `EnUS` maps to `en-US`. |
| `FromString_PtBR_CultureCode` | `pt-BR` parses as `PtBR`. |
| `FromString_PtBR_EnumName` | `PtBR` parses as `PtBR`. |
| `FromString_EnUS_CultureCode` | `en-US` parses as `EnUS`. |
| `FromString_EnUS_EnumName` | `EnUS` parses as `EnUS`. |
| `FromString_IsCaseInsensitive` | Accepted forms are case-insensitive. |
| `FromString_Invalid_RaisesException` | Unsupported text such as `es-ES` raises `EArgumentException`. |

## Fixture: `TDockHubLanguageTests`

Each test receives a fresh `IDockHubLanguage` instance in `Setup` and releases it in `TearDown`.

The fixture contains 7 tests:

| Test | Behavior validated |
| --- | --- |
| `New_DefaultLanguage_IsPtBR` | New instances start with `PtBR`. |
| `Language_ChangesTo_EnUS` | Runtime change to `EnUS` is retained. |
| `Language_ReturnsTo_PtBR` | Runtime change can return from `EnUS` to `PtBR`. |
| `Translate_PtBR_ReturnsPortugueseCaption` | Main caption resolves to `DockHub - Hub de Integração`. |
| `Translate_EnUS_ReturnsEnglishCaption` | Main caption resolves to `DockHub - Integration Hub`. |
| `Translate_PtBR_UnknownKey_RaisesNotFound` | Unknown key in default mode raises `EDockHubTranslationNotFound`. |
| `Translate_EnUS_UnknownKey_RaisesNotFound` | Unknown key that cannot be resolved while `EnUS` is active also raises `EDockHubTranslationNotFound`. |

The unknown-key tests use a test-only constant:

```pascal
_UNKNOWN_TRANSLATION_KEY:
  TDockHubTranslationKey = 'Tests.Unknown.Translation';
```

This constant follows the project convention that constants begin with `_`.

## Fixture: `TDockHubThemeTests`

Each test receives a fresh real `TDockHubTheme` instance through an `IDockHubTheme` reference in `Setup` and releases the interface in `TearDown`.

Expected values for Blue, Teal, Light and Dark are centralized in test-only `TDockHubExpectedTheme` data. The fixture contains 17 tests:

| Test | Behavior validated |
| --- | --- |
| `New_DefaultTheme_IsBlue` | New Theme instances start in `Blue`. |
| `New_DefaultTheme_HasExpectedBluePalette` | The default instance exposes the complete expected Blue palette. |
| `Theme_ChangesFromBlueToTeal` | Switching to Teal changes the background and exposes the complete expected Teal palette. |
| `Theme_ChangesFromBlueToLight` | Switching to Light changes the background and exposes the complete expected Light palette. |
| `Theme_ChangesFromBlueToDark` | Switching to Dark changes the background and exposes the complete expected Dark palette. |
| `Theme_ChangesBackToBlue` | A changed Theme can return to the complete Blue palette. |
| `Theme_SequentialChanges_UpdateEntirePalette` | Sequential Blue → Teal → Dark → Light → Blue changes validate the full palette after every transition. |
| `BackgroundGradient_ConfiguresGradientBrush` | Gradient kind, linear style, two points, colors and offsets are configured from the active Theme. |
| `BackgroundGradient_ChangesWithTheme` | Reapplying a brush after a Theme change uses the new gradient colors. |
| `BackgroundGradient_DefaultAngle_Equals65Degrees` | The overload without an angle produces the same positions as explicit `65` degrees. |
| `BackgroundGradient_ZeroDegrees` | The 0° gradient positions match the expected horizontal endpoints. |
| `BackgroundGradient_NinetyDegrees` | The 90° gradient positions match the expected vertical endpoints. |
| `BackgroundGradient_Nil_DoesNotRaiseException` | Passing `nil` does not raise an exception. |
| `BadgeBackground_True_ReturnsSuccess` | `True` returns `BadgeSuccessBg`. |
| `BadgeBackground_False_ReturnsDanger` | `False` returns `BadgeDangerBg`. |
| `BadgeText_True_ReturnsSuccess` | `True` returns `BadgeSuccessText`. |
| `BadgeText_False_ReturnsDanger` | `False` returns `BadgeDangerText`. |

## Latest execution result

The latest supplied DUnitX XML result is dated 2026-09-13 and reports:

```text
Total tests : 34
Passed      : 34
Ignored     : 0
Failures    : 0
Errors      : 0
```

The XML also reports `not-run=0`, `skipped=0`, `invalid=0` and `inconclusive=0`.

The XML format supplied for this run does not contain a leak-count field. This documentation therefore does not infer a leak count from the artifact.

The 34 tests are distributed as:

```text
TDockHubLanguageTypeTests : 10
TDockHubLanguageTests     :  7
TDockHubThemeTests        : 17
                              --
Total                     : 34
```

## What this execution proves

The run directly proves the 34 behaviors represented by the three fixtures above and shows every listed test case with a successful result in the supplied XML.

It demonstrates that the production units required by those tests were compilable in the environment where `DockHub.Tests.exe` was built and executed.

It does **not** by itself prove that every platform/configuration of the main FMX application builds successfully, and it does **not** prove `TPageMain` Theme rendering because there is currently no Main View integration fixture.

## Current coverage gaps

### Language

The implementation contains additional branches that are not yet directly exercised by the current suite:

- a key missing in `EnUS` but present in `PtBR` falling back to `PtBR`;
- the second lookup of that key hitting the fallback value cached in `FCurrentTranslations`;
- duplicate registration raising `EDockHubTranslationDuplicate`;
- empty key/value validation raising `EDockHubTranslationInvalid`;
- a nil translation callback raising `EDockHubTranslationInvalid`;
- `EDockHubLanguageNotSupported` through a real unsupported enum branch.

### Theme / View integration

The Theme contract and implementation are covered by the 17 Theme tests described above. `TPageMain` itself is deliberately not covered by a Theme integration test at this stage, so construction and visual application of `BackgroundGradient(Fill)` are not asserted by this suite.

These are documented coverage gaps, not known implementation failures.

## Running the tests

### RAD Studio / console runner

1. Open `Dock.Hub.groupproj` or `tests/DockHub.Tests.dproj`.
2. Select the `DockHub.Tests` project.
3. Use the intended configuration/platform. The current project defaults are `Debug` and `Win32`.
4. Build/compile the test project.
5. Run it.
6. With `--exitbehavior:Pause`, review the summary before pressing Enter.

The current regression baseline is 34 successful tests with zero failures/errors. Use the actual runner/XML output as the authority for each new execution rather than assuming the previous result.

### TestInsight

The `.dpr` contains conditional support for TestInsight through the `TESTINSIGHT` define. This documentation does not assert that TestInsight is installed or enabled in every developer environment.

### CI

The runner already excludes the pause behavior when `CI` is defined. A future CI pipeline can execute the console test binary and consume the NUnit-compatible XML output generated by `TDUnitXXMLNUnitFileLogger`.

No CI workflow is currently documented as implemented.

## Adding tests

When production behavior changes:

- test the public contract whenever possible;
- avoid exposing private implementation details only to assert internal call counts;
- keep fixture names aligned with the production type being exercised;
- keep expected Theme palettes centralized in test-only structures;
- add a regression test for an intentional Theme behavior change;
- add Language fallback regression coverage when a legitimate missing-secondary-key case exists;
- do not add a `TPageMain` integration test until that scope is intentionally introduced;
- never change production behavior merely to make a test pass.
