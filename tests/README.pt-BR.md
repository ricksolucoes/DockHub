# Testes Automatizados do DockHub

[English — Official](./README.md)

O DockHub possui atualmente um projeto console DUnitX dedicado:

```text
tests/
├── DockHub.Tests.dpr
├── DockHub.Tests.dproj
└── Core/
    ├── DockHub.Tests.Core.Language.Types.pas
    └── DockHub.Tests.Core.Language.pas
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

O projeto de testes referencia atualmente:

```text
$(DUnitX)
..\src\core\Language
..\src\core\Language\Contracts
..\src\core\Language\Impl
..\src\core\Language\Keys
..\src\core\Language\Translations
```

## Fixture: `TDockHubLanguageTypeTests`

O fixture contém atualmente 10 testes:

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

O fixture contém atualmente 7 testes:

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

## Último resultado executado

A execução real DUnitX mais recente fornecida para o projeto produziu:

```text
Tests Found   : 17
Tests Ignored : 0
Tests Passed  : 17
Tests Leaked  : 0
Tests Failed  : 0
Tests Errored : 0
```

Esse é o resultado de referência atual para o comportamento documentado do Language.

## O que essa execução comprova

A execução comprova diretamente os 17 comportamentos representados pelos dois fixtures acima. Ela também demonstra que as units de Language utilizadas pelos testes foram compiláveis no ambiente onde o executável de testes foi construído e executado.

Ela **não** comprova, isoladamente, que todas as plataformas/configurações da aplicação FMX principal compilam com sucesso.

## Lacunas de cobertura atuais

A implementação possui branches adicionais ainda não exercitados diretamente pela suíte atual:

- chave ausente em `EnUS`, mas existente em `PtBR`, utilizando fallback;
- segunda consulta atingindo o valor de fallback cacheado em `FCurrentTranslations`;
- registro duplicado gerando `EDockHubTranslationDuplicate`;
- validação de chave/valor vazio gerando `EDockHubTranslationInvalid`;
- callback de tradução `nil` gerando `EDockHubTranslationInvalid`;
- `EDockHubLanguageNotSupported` através de branch real de enum não suportado.

São lacunas documentadas de cobertura, não falhas conhecidas da implementação.

## Executando os testes

### RAD Studio / runner console

1. Abrir `Dock.Hub.groupproj` ou `tests/DockHub.Tests.dproj`.
2. Selecionar o projeto `DockHub.Tests`.
3. Utilizar a configuração/plataforma desejada. O default atual é `Debug` / `Win32`.
4. Compilar o projeto de testes.
5. Executá-lo.
6. Com `--exitbehavior:Pause`, revisar o resumo antes de pressionar Enter.

Resumo esperado atualmente:

```text
Tests Found   : 17
Tests Passed  : 17
Tests Leaked  : 0
Tests Failed  : 0
Tests Errored : 0
```

### TestInsight

O `.dpr` possui suporte condicional ao TestInsight através do define `TESTINSIGHT`. Esta documentação não afirma que o TestInsight esteja instalado ou habilitado em todos os ambientes.

### CI

O runner já evita o pause quando `CI` está definido. Uma futura pipeline poderá executar o binário console e consumir o XML compatível com NUnit gerado por `TDUnitXXMLNUnitFileLogger`.

Nenhuma pipeline de CI é documentada atualmente como implementada.

## Adicionando testes

Quando o comportamento de Language mudar:

- testar preferencialmente o contrato público;
- evitar expor detalhes privados apenas para contar chamadas internas;
- adicionar regressão para um caso real de fallback quando ele existir;
- manter constantes exclusivas de teste dentro da unit de teste;
- manter nomes dos fixtures alinhados aos tipos de produção exercitados;
- nunca alterar o comportamento de produção apenas para fazer um teste passar.
