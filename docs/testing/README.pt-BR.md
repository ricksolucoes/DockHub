# Testes Automatizados do DockHub

[English — Official](./README.md)

O DockHub utiliza DUnitX. Este documento separa o inventário atual de testes no fonte da evidência de execução realmente disponível.

## Estrutura atual

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

## Inventário de testes no fonte

O código-fonte atual declara **58 testes**:

```text
TDockHubLanguageTypeTests            : 10
TDockHubLanguageTests                :  7
TDockHubThemeTests                   : 17
TDockHubPageCompositionBaseTests     : 15
TDockHubPageMainCompositionTests     :  9
                                        --
Total                                : 58
```

A suíte atual foi executada no RAD Studio/DUnitX conforme a evidência fornecida para este snapshot: **58 encontrados, 58 aprovados, 0 ignorados, 0 leaks, 0 falhas e 0 erros**.

## Framework e runner

O runner utiliza DUnitX. Sem `TESTINSIGHT`, o projeto executa como console e registra log no console e XML compatível com NUnit. Com `TESTINSIGHT`, utiliza `TestInsight.DUnitX`.

## Search paths

O projeto de testes atual possui os paths necessários para Language, Theme e a arquitetura vigente de `View.Page`, incluindo:

```text
..\src\view\Page
..\src\view\Page\Contracts
..\src\view\Page\Types
..\src\view\Page\Impl
..\src\view\Page\Impl\Main
..\modules\github_com_ricksolucoes_RickUIBuilder\src
```

Os paths antigos `..\src\view\Page\Main` / `..\src\view\Page\Main\Composition` não fazem mais parte da estrutura atual do projeto de testes.

## `TDockHubLanguageTypeTests`

Mantém os 10 testes existentes de `TDockHubLanguageType` e helpers de conversão.

## `TDockHubLanguageTests`

Mantém 7 testes cobrindo comportamento default/troca, o conjunto de traduções usado pela Main em `pt-BR` e `en-US` e comportamento de chave desconhecida.

O conjunto atual de traduções de produção da Main inclui caption, subtítulo, rótulos de status, ações e texto de status neutro.

## `TDockHubThemeTests`

Mantém os 17 testes existentes das paletas `Blue`, `Teal`, `Light` e `Dark`, comportamento do gradiente, tokens semânticos e transições de Theme.

## `TDockHubPageCompositionBaseTests`

A fixture é marcada com:

```pascal
[Category('Contract')]
```

Ela valida o lifecycle/contrato público de `TPageCompositionBase` sem expor seu `FState` privado apenas para teste.

Os 15 testes declarados cobrem:

- rejeição de Form host `nil`;
- rejeição de callback de minimizar `nil`;
- rejeição de callback de fechar `nil`;
- validação de Build sem Form;
- validação de Build sem callback de minimizar;
- validação de Build sem callback de fechar;
- rejeição de `ApplyTheme` antes de Build bem-sucedido;
- rejeição de `ApplyLanguage` antes de Build bem-sucedido;
- rejeição de Theme `nil` após Build;
- rejeição de Language `nil` após Build;
- fechamento da configuração após Build;
- segundo Build idempotente após `Built`;
- falha de Build tornando a instância terminal e bloqueando retry;
- callbacks comuns de minimizar/fechar;
- hover comum de janela utilizando o Theme aplicado mais recentemente.

A fixture declara uma classe derivada exclusiva dos testes para implementar os hooks abstratos de Template Method. Nenhum seam de produção ou accessor público do estado de lifecycle foi criado apenas para teste.

## `TDockHubPageMainCompositionTests`

A fixture é marcada com:

```pascal
[Category('Integration')]
```

Ela utiliza um `TForm.CreateNew(nil)` real e a API atual `IPageCompositionMain` / `TPageMainComposition.New`.

Os 9 testes declarados cobrem:

- criação do card central da Main;
- Build idempotente sem duplicar a árvore visual;
- aplicação dos textos `pt-BR`;
- troca runtime para `en-US` reutilizando controles existentes;
- troca runtime de Theme no card da Main;
- hover de janela utilizando o Theme corrente após troca runtime;
- ações administrativas ainda não implementadas permanecendo desabilitadas;
- callbacks configurados de minimizar/fechar;
- destruição do host enquanto a interface mantém a Composition viva até a destruição dos controles FMX.

A fixture valida comportamento FMX observável e não expõe fields privados da Main Composition apenas para facilitar teste.

## Último resultado executado

A execução DUnitX fornecida para a suíte atual de 58 testes registra:

```text
Tests Found   : 58
Tests Ignored : 0
Tests Passed  : 58
Tests Leaked  : 0
Tests Failed  : 0
Tests Errored : 0
```

Neste snapshot, o inventário no fonte e o resultado efetivamente executado possuem 58 testes.

Esse resultado comprova o status de execução reportado acima. Isoladamente, ele não comprova percentual de coverage, thread safety ou comportamentos fora dos casos executados.

## Method Toxicity — projeto de testes

Foi fornecido um relatório Method Toxicity do RAD Studio para `DockHub.Tests.dproj`. O maior valor de **Toxicity reportado/exibido** nessa evidência é:

```text
0,400
```

Exemplos nesse valor:

```text
TDockHubPageCompositionBaseTests.FindLabelByText
TDockHubPageMainCompositionTests.FindLabelByText
```

Threshold do projeto para `Toxicity`:

```text
1
```

Portanto o maior valor reportado na evidência fornecida está abaixo do threshold do projeto.

A captura estava ordenada por Toxicity; ela não é utilizada para afirmar máximos globais de `Length`, `Parameters`, `If Depth` ou `Cyclomatic Complexity` além do que está efetivamente visível.

O refactor dos testes de Theme também agrupa assertions por áreas coesas da paleta e mantém `AssertThemePalette` como orquestrador, reduzindo toxicidade de método sem alterar o comportamento de Theme validado.

## Executando a suíte atual

1. Abrir `Dock.Hub.groupproj` ou `tests/DockHub.Tests.dproj` no RAD Studio.
2. Selecionar o projeto `DockHub.Tests`.
3. Selecionar configuração/plataforma desejada.
4. Compilar o projeto de testes.
5. Executar DUnitX ou TestInsight.
6. Tratar o resultado real do runner/XML como autoridade da execução.

Para diagnóstico focado, executar primeiro a fixture de contrato de Page Composition, depois a fixture de integração da Main e então a suíte completa.

## Lacunas atuais de cobertura

O fonte atual ainda não cobre diretamente todos os branches implementados. Lacunas conhecidas incluem:

- fallback `EnUS → PtBR` com uma chave de produção deliberadamente ausente em `EnUS`;
- reutilização do cache de fallback em `Core.Language`;
- registro duplicado de tradução;
- validação de chave/valor de tradução vazios;
- branch real de idioma não suportado;
- renderização visual pixel a pixel da Main;
- ações administrativas da Main, pois seus casos de uso de aplicação ainda não estão implementados.

## Regras de manutenção

Quando o comportamento mudar:

- testar contratos e comportamento observável em vez de fields privados;
- cobrir transições de lifecycle/erro quando forem alteradas;
- distinguir testes de contrato/unitários de testes de integração FMX;
- não alterar o design de produção apenas para facilitar um teste;
- atualizar `DockHub.Tests.dpr` e `.dproj` ao adicionar fixture;
- não apresentar quantidade de testes no fonte como quantidade executada/aprovada;
- atualizar evidência de execução somente a partir de resultado real do runner; não inferir aprovação pela contagem no fonte;
- aplicar Method Toxicity Metrics também ao código de testes, não apenas à produção.
