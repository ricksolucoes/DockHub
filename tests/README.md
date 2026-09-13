# DockHub Automated Tests

[Português (Brasil)](./README.pt-BR.md)

DockHub currently contains a dedicated DUnitX console test project:

```text
tests/
├── DockHub.Tests.dpr
├── DockHub.Tests.dproj
└── Core/
    ├── DockHub.Tests.Core.Language.Types.pas
    └── DockHub.Tests.Core.Language.pas
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

The test project currently references:

```text
$(DUnitX)
..\src\core\Language
..\src\core\Language\Contracts
..\src\core\Language\Impl
..\src\core\Language\Keys
..\src\core\Language\Translations
```

## Fixture: `TDockHubLanguageTypeTests`

The fixture currently contains 10 tests:

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

The fixture currently contains 7 tests:

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

## Latest execution result

The latest real DUnitX execution supplied for the project produced:

```text
Tests Found   : 17
Tests Ignored : 0
Tests Passed  : 17
Tests Leaked  : 0
Tests Failed  : 0
Tests Errored : 0
```

This is the current runtime validation reference for the documented Language behavior.

## What this execution proves

The run directly proves the 17 behaviors represented by the two fixtures above. It also demonstrates that the Language units required by those tests were compilable in the environment where the test executable was built and executed.

It does **not** by itself prove that every platform/configuration of the main FMX application builds successfully.

## Current coverage gaps

The implementation contains additional branches that are not yet directly exercised by the current suite:

- a key missing in `EnUS` but present in `PtBR` falling back to `PtBR`;
- the second lookup of that key hitting the fallback value cached in `FCurrentTranslations`;
- duplicate registration raising `EDockHubTranslationDuplicate`;
- empty key/value validation raising `EDockHubTranslationInvalid`;
- a nil translation callback raising `EDockHubTranslationInvalid`;
- `EDockHubLanguageNotSupported` through a real unsupported enum branch.

These are documented coverage gaps, not known implementation failures.

## Running the tests

### RAD Studio / console runner

1. Open `Dock.Hub.groupproj` or `tests/DockHub.Tests.dproj`.
2. Select the `DockHub.Tests` project.
3. Use the intended configuration/platform. The current project defaults are `Debug` and `Win32`.
4. Build/compile the test project.
5. Run it.
6. With `--exitbehavior:Pause`, review the summary before pressing Enter.

Expected current summary:

```text
Tests Found   : 17
Tests Passed  : 17
Tests Leaked  : 0
Tests Failed  : 0
Tests Errored : 0
```

### TestInsight

The `.dpr` contains conditional support for TestInsight through the `TESTINSIGHT` define. This documentation does not assert that TestInsight is installed or enabled in every developer environment.

### CI

The runner already excludes the pause behavior when `CI` is defined. A future CI pipeline can execute the console test binary and consume the NUnit-compatible XML output generated by `TDUnitXXMLNUnitFileLogger`.

No CI workflow is currently documented as implemented.

## Adding tests

When Language behavior changes:

- test the public contract whenever possible;
- avoid exposing private implementation details only to assert internal call counts;
- add regression coverage for a real fallback case when one exists;
- keep test-only constants in the test unit;
- keep fixture names aligned with the production type being exercised;
- do not change production behavior merely to make a test pass.
