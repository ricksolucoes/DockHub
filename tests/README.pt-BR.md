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
├── Runner/
│   └── DockHub.Tests.Runner.FMX.pas
├── DockHub.Tests.dpr
└── DockHub.Tests.dproj
```

## Inventário de testes no fonte

O código-fonte atual declara **59 testes**:

```text
TDockHubLanguageTypeTests            : 10
TDockHubLanguageTests                :  7
TDockHubThemeTests                   : 17
TDockHubPageCompositionBaseTests     : 16
TDockHubPageMainCompositionTests     :  9
                                        --
Total                                : 59
```

O XML NUnit mais recente fornecido corresponde a esse inventário: todos os **59 testes** foram executados e reportados como `Success`. A contagem no fonte e a evidência de execução continuam documentadas separadamente para que futuras alterações no fonte não sejam tratadas automaticamente como execuções aprovadas.

## Framework e runner

O projeto de testes utiliza DUnitX com o runner FMX code-only do DockHub (`DockHub.Tests.Runner.FMX`). O `DockHub.Tests.dpr` atual chama `RunDockHubTests` diretamente. Cada execução efetiva registra `TDUnitXXMLNUnitFileLogger`, portanto a execução gráfica gera XML NUnit para a suíte ou subconjunto realmente executado. `dunitx-results.xml` é um artefato regenerável de execução e não documentação do projeto.

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

Os 16 testes declarados cobrem:

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
- regressão de geometria dos controles de janela, incluindo cenário `Width <> ClientWidth`, visibilidade, bounds da área cliente, ordem e ausência de sobreposição;
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

O `dunitx-results.xml` fornecido registra uma execução real em **2026-09-19 12:14:29** com:

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

Os **59 `test-case`** estão marcados como executados com `result="Success"` / `success="True"`. A execução inclui `WindowButtons_AreVisibleAndInsideClientBounds`, também reportado como sucesso. Esse XML é evidência daquela execução específica e pode ser substituído por uma execução posterior; ele deve permanecer fora do versionamento por padrão.

## Executando a suíte atual

1. Abrir `Dock.Hub.groupproj` ou `tests/DockHub.Tests.dproj` no RAD Studio.
2. Selecionar o projeto `DockHub.Tests`.
3. Selecionar configuração/plataforma desejada.
4. Compilar o projeto de testes.
5. Executar o projeto normalmente para abrir `DockHub.Tests.Runner.FMX`.
6. Executar o subconjunto necessário ou a suíte completa.
7. Tratar o resultado real do runner/XML NUnit como autoridade da execução.

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
- atualizar evidência documentada somente a partir de um novo resultado real do runner/XML;
- tratar `dunitx-results.xml` como artefato regenerável de execução, não como documentação versionada.
