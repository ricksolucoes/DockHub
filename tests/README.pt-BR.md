# Testes Automatizados do DockHub

[English — Official](./README.md)

O DockHub possui atualmente um projeto console DUnitX dedicado:

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

O projeto também está incluído em `Dock.Hub.groupproj` juntamente com a aplicação FMX principal.

## Framework e runner

O projeto utiliza DUnitX.

`DockHub.Tests.dpr` possui dois caminhos de execução:

- `TestInsight.DUnitX.RunRegisteredTests` quando `TESTINSIGHT` estiver definido;
- runner console normal do DUnitX nos demais casos.

O runner console adiciona atualmente:

- `TDUnitXConsoleLogger`;
- `TDUnitXXMLNUnitFileLogger`.

`DockHub.Tests.dproj` utiliza por padrão `Debug` / `Win32`.

O parâmetro atual armazenado no projeto é:

```text
--exitbehavior:Pause
```

Isso mantém o console aberto após a execução no runner normal fora de CI.

## Search paths

O projeto de testes referencia os paths existentes de Language e os paths de Theme exigidos por `TDockHubThemeTests`:

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

O fixture contém 10 testes:

| Teste | Comportamento validado |
| --- | --- |
| `PtBR_ToString` | Nome técnico de `PtBR` é `PtBR`. |
| `EnUS_ToString` | Nome técnico de `EnUS` é `EnUS`. |
| `PtBR_ToCultureCode` | `PtBR` mapeia para `pt-BR`. |
| `EnUS_ToCultureCode` | `EnUS` mapeia para `en-US`. |
| `FromString_PtBR_CultureCode` | `pt-BR` converte para `PtBR`. |
| `FromString_PtBR_EnumName` | `PtBR` converte para `PtBR`. |
| `FromString_EnUS_CultureCode` | `en-US` converte para `EnUS`. |
| `FromString_EnUS_EnumName` | `EnUS` converte para `EnUS`. |
| `FromString_IsCaseInsensitive` | Formatos aceitos não diferenciam maiúsculas/minúsculas. |
| `FromString_Invalid_RaisesException` | Texto não suportado, como `es-ES`, gera `EArgumentException`. |

## Fixture: `TDockHubLanguageTests`

Cada teste recebe uma nova instância de `IDockHubLanguage` em `Setup` e a libera em `TearDown`.

O fixture contém 7 testes:

| Teste | Comportamento validado |
| --- | --- |
| `New_DefaultLanguage_IsPtBR` | Nova instância inicia em `PtBR`. |
| `Language_ChangesTo_EnUS` | Troca em runtime para `EnUS` é mantida. |
| `Language_ReturnsTo_PtBR` | É possível retornar de `EnUS` para `PtBR`. |
| `Translate_PtBR_ReturnsPortugueseCaption` | Caption resolve para `DockHub - Hub de Integração`. |
| `Translate_EnUS_ReturnsEnglishCaption` | Caption resolve para `DockHub - Integration Hub`. |
| `Translate_PtBR_UnknownKey_RaisesNotFound` | Chave desconhecida em modo default gera `EDockHubTranslationNotFound`. |
| `Translate_EnUS_UnknownKey_RaisesNotFound` | Chave sem resolução enquanto `EnUS` está ativo também gera `EDockHubTranslationNotFound`. |

Os testes de chave desconhecida utilizam uma constante exclusiva do teste:

```pascal
_UNKNOWN_TRANSLATION_KEY:
  TDockHubTranslationKey = 'Tests.Unknown.Translation';
```

Ela segue a convenção do projeto de constantes iniciadas por `_`.

## Fixture: `TDockHubThemeTests`

Cada teste recebe em `Setup` uma instância real de `TDockHubTheme` através de uma referência `IDockHubTheme` e libera a interface em `TearDown`.

Os valores esperados para Blue, Teal, Light e Dark ficam centralizados em dados `TDockHubExpectedTheme` exclusivos da suíte. O fixture contém 17 testes:

| Teste | Comportamento validado |
| --- | --- |
| `New_DefaultTheme_IsBlue` | Novas instâncias de Theme iniciam em `Blue`. |
| `New_DefaultTheme_HasExpectedBluePalette` | A instância default expõe toda a paleta Blue esperada. |
| `Theme_ChangesFromBlueToTeal` | A troca para Teal altera o background e expõe toda a paleta Teal esperada. |
| `Theme_ChangesFromBlueToLight` | A troca para Light altera o background e expõe toda a paleta Light esperada. |
| `Theme_ChangesFromBlueToDark` | A troca para Dark altera o background e expõe toda a paleta Dark esperada. |
| `Theme_ChangesBackToBlue` | Um Theme alterado consegue retornar para toda a paleta Blue. |
| `Theme_SequentialChanges_UpdateEntirePalette` | A sequência Blue → Teal → Dark → Light → Blue valida a paleta completa após cada transição. |
| `BackgroundGradient_ConfiguresGradientBrush` | Kind, estilo linear, dois pontos, cores e offsets do gradiente são configurados pelo Theme ativo. |
| `BackgroundGradient_ChangesWithTheme` | Reaplicar o brush após a troca de Theme utiliza as novas cores de gradiente. |
| `BackgroundGradient_DefaultAngle_Equals65Degrees` | O overload sem ângulo produz as mesmas posições que `65` graus explícitos. |
| `BackgroundGradient_ZeroDegrees` | As posições para 0° correspondem às extremidades horizontais esperadas. |
| `BackgroundGradient_NinetyDegrees` | As posições para 90° correspondem às extremidades verticais esperadas. |
| `BackgroundGradient_Nil_DoesNotRaiseException` | Informar `nil` não gera exception. |
| `BadgeBackground_True_ReturnsSuccess` | `True` retorna `BadgeSuccessBg`. |
| `BadgeBackground_False_ReturnsDanger` | `False` retorna `BadgeDangerBg`. |
| `BadgeText_True_ReturnsSuccess` | `True` retorna `BadgeSuccessText`. |
| `BadgeText_False_ReturnsDanger` | `False` retorna `BadgeDangerText`. |

## Último resultado executado

O último resultado XML DUnitX fornecido está datado de 2026-09-13 e registra:

```text
Total de testes : 34
Aprovados        : 34
Ignorados        : 0
Falhas           : 0
Erros            : 0
```

O XML também registra `not-run=0`, `skipped=0`, `invalid=0` e `inconclusive=0`.

O formato XML fornecido para esta execução não contém campo de contagem de leaks. Por isso esta documentação não deduz uma quantidade de leaks a partir do artefato.

Os 34 testes estão distribuídos em:

```text
TDockHubLanguageTypeTests : 10
TDockHubLanguageTests     :  7
TDockHubThemeTests        : 17
                              --
Total                     : 34
```

## O que essa execução comprova

A execução comprova diretamente os 34 comportamentos representados pelos três fixtures acima e apresenta todos os casos listados com resultado de sucesso no XML fornecido.

Ela demonstra que as units de produção necessárias para esses testes foram compiláveis no ambiente onde `DockHub.Tests.exe` foi construído e executado.

Ela **não** comprova, isoladamente, que todas as plataformas/configurações da aplicação FMX principal compilam com sucesso e **não** comprova a renderização do Theme em `TPageMain`, pois ainda não existe fixture de integração da Main View.

## Lacunas de cobertura atuais

### Language

A implementação possui branches adicionais ainda não exercitados diretamente pela suíte atual:

- chave ausente em `EnUS`, mas existente em `PtBR`, utilizando fallback;
- segunda consulta atingindo o valor de fallback cacheado em `FCurrentTranslations`;
- registro duplicado gerando `EDockHubTranslationDuplicate`;
- validação de chave/valor vazio gerando `EDockHubTranslationInvalid`;
- callback de tradução `nil` gerando `EDockHubTranslationInvalid`;
- `EDockHubLanguageNotSupported` através de branch real de enum não suportado.

### Theme / integração da View

O contrato e a implementação de Theme estão cobertos pelos 17 testes descritos acima. A própria `TPageMain` deliberadamente não possui teste de integração de Theme nesta etapa, portanto a construção da View e a aplicação visual de `BackgroundGradient(Fill)` não são validadas por essa suíte.

São lacunas documentadas de cobertura, não falhas conhecidas da implementação.

## Executando os testes

### RAD Studio / runner console

1. Abrir `Dock.Hub.groupproj` ou `tests/DockHub.Tests.dproj`.
2. Selecionar o projeto `DockHub.Tests`.
3. Utilizar a configuração/plataforma desejada. O default atual é `Debug` / `Win32`.
4. Compilar o projeto de testes.
5. Executá-lo.
6. Com `--exitbehavior:Pause`, revisar o resumo antes de pressionar Enter.

O baseline atual de regressão é de 34 testes aprovados, sem falhas/erros. Em cada nova execução, utilizar como autoridade o resultado real do runner/XML em vez de presumir o resultado anterior.

### TestInsight

O `.dpr` possui suporte condicional ao TestInsight através do define `TESTINSIGHT`. Esta documentação não afirma que o TestInsight esteja instalado ou habilitado em todos os ambientes.

### CI

O runner já evita o pause quando `CI` está definido. Uma futura pipeline poderá executar o binário console e consumir o XML compatível com NUnit gerado por `TDUnitXXMLNUnitFileLogger`.

Nenhuma pipeline de CI é documentada atualmente como implementada.

## Adicionando testes

Quando um comportamento de produção mudar:

- testar preferencialmente o contrato público;
- evitar expor detalhes privados apenas para contar chamadas internas;
- manter nomes dos fixtures alinhados aos tipos de produção exercitados;
- manter as paletas esperadas de Theme centralizadas em estruturas exclusivas de teste;
- adicionar regressão quando houver uma alteração intencional de comportamento de Theme;
- adicionar cobertura de fallback do Language quando existir um caso legítimo de chave ausente no idioma secundário;
- não adicionar teste de integração de `TPageMain` até que esse escopo seja introduzido intencionalmente;
- nunca alterar o comportamento de produção apenas para fazer um teste passar.
