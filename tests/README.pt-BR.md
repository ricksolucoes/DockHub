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

Esse total é um inventário do código-fonte. Ele **não** prova que os 58 testes compilaram ou foram executados com sucesso.

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

## Último resultado executado disponível

O XML mais recente atualmente disponível em `tests/APP/Debug/dunitx-results.xml` é de **2026-09-13** e registra:

```text
Total de testes : 34
Aprovados        : 34
Ignorados        : 0
Falhas           : 0
Erros            : 0
```

Esse XML é anterior às duas fixtures de Page Composition e às assertions ampliadas das traduções da Main. Ele é somente evidência histórica.

Ele **não** valida os 58 testes atualmente declarados no fonte e não deve ser apresentado como prova de que o projeto de testes atual passa.

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
- não substituir evidência histórica de XML sem nova execução real.
