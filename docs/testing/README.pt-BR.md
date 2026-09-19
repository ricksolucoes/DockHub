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

O projeto de testes utiliza DUnitX com um runner gráfico FMX próprio do DockHub (`DockHub.Tests.Runner.FMX`), criado integralmente em código e sem recurso `.fmx`. O `DockHub.Tests.dpr` atual chama `RunDockHubTests` diretamente; neste snapshot não existem branches ativos `TESTINSIGHT` ou `CI` no entry point do projeto.

O projeto não utiliza `DUNitX.Loggers.GUIX`. No ambiente Delphi atual, o recurso FMX embutido desse runner gerou `EReadError` ao carregar `GUIXTestRunner.FormFactor.Devices`, com a mensagem `Invalid property value`. O runner local evita essa dependência ao criar toda a interface em runtime por `CreateNew`.

O projeto continua sendo uma aplicação FMX (`AppType=Application`). `RunDockHubTests` chama `TDUnitX.CheckCommandLine`, inicializa a aplicação e abre `TDockHubTestsRunnerForm`.

Cada execução efetiva da suíte ou de um subconjunto passa por `RunSuite`. Nesse ponto, o runner registra `TDUnitXXMLNUnitFileLogger` usando `TDUnitX.Options.XMLOutputFile` antes de `Execute`. Portanto, o próprio fluxo gráfico gera XML NUnit para a execução realizada; execução seletiva gera um XML correspondente ao subconjunto efetivamente executado.

O `dunitx-results.xml` é um **artefato regenerável de execução**, não documentação do projeto. Ele deve ser utilizado como evidência para atualizar números documentados, mas não deve ser versionado por padrão. No repositório atual, o diretório de saída `app/` já está coberto pelo `.gitignore`. Quando nenhum caminho XML alternativo é informado ao DUnitX, a execução fornecida mostra o arquivo sendo gerado junto ao executável de testes em `App\Debug`.

O runner interativo possui duas superfícies complementares: **seleção de testes antes da execução** e **diagnóstico dos resultados depois da execução**. O painel de seleção expõe a hierarquia de fixtures/testes do DUnitX com checkboxes, pesquisa por fixture ou teste, ações `Todos` / `Nenhum` / `Inverter`, contador de testes selecionados, comandos **Executar selecionados** e **Executar todos**, além de execução de um único teste por duplo clique sem alterar a seleção corrente. As linhas de fixture exibem a relação `selecionados/total`, tornando a seleção parcial visível mesmo com o checkbox binário do TreeView FMX.

A superfície de resultados permanece independente da seleção de execução: cards de resumo expõem os contadores da última execução, os testes são agrupados por fixture, cada resultado combina status textual com cor semântica e um indicador lateral, filtros rápidos isolam falhas/erros/leaks/ignorados, e a seleção de uma linha abre detalhes de mensagem/expected/actual/stack trace quando esses dados existem. O runner possui uma pequena paleta privada e não depende de `IDockHubTheme` de produção, evitando que uma falha no módulo de Theme impeça a própria interface de testes de renderizar.

O runner possui os temas **Escuro** e **Claro**, selecionáveis na toolbar e aplicados em runtime sem reconstruir a suíte ou alterar a seleção de testes. A preferência é persistida somente como identificador `Dark`/`Light` em `DockHub.Tests.ini`, no **mesmo diretório do executável de testes**, obtido por `TPath.GetDirectoryName(ParamStr(0))`, seção `[Appearance]`, chave `Theme`. O tema **Escuro** é o padrão seguro: ele é utilizado quando o arquivo não existe, a chave está ausente, o valor é inválido ou a preferência não pode ser lida. Falha ao persistir a preferência não impede o funcionamento da GUI; nessa situação, uma inicialização posterior volta ao fallback Escuro se não houver preferência válida disponível. As cores das paletas não são serializadas individualmente.

A seleção utiliza o próprio modelo runtime do DUnitX. O runner monta o catálogo com `ITestRunner.BuildFixtures`, mantém as escolhas do usuário nos flags `ITest.Enabled` descobertos e aplica os nomes completos dos testes selecionados ao runner de execução antes de `Execute`. `Executar todos` ignora temporariamente o subconjunto sem modificá-lo; `Executar selecionados` executa somente os testes marcados; o duplo clique executa somente aquele teste e preserva a seleção existente.

Todas as fixtures atuais chamam explicitamente `TDUnitX.RegisterTestFixture`. O registro explícito de fixtures é a convenção atual do DockHub e deve ser preservado para que o runner atual enxergue a mesma suíte em cada execução.

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

O `dunitx-results.xml` fornecido para o runner atual registra uma execução real em **2026-09-19 10:52:19** com:

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

Os **58 `test-case`** presentes no XML estão marcados como executados com `result="Success"` / `success="True"`. Neste snapshot, o inventário no fonte e a execução registrada no XML possuem 58 testes.

Esse XML comprova os casos e resultados que ele contém. Isoladamente, ele não comprova percentual de coverage, thread safety, comportamentos fora dos casos executados nem uma contagem separada de memory leaks, pois o formato NUnit fornecido não registra um campo específico de leaks.

O XML é evidência de uma execução e pode ser substituído pela execução seguinte; por isso, os números acima ficam documentados aqui, enquanto `dunitx-results.xml` permanece fora do versionamento por padrão.

### Evidência de build

A captura do RAD Studio fornecida para este snapshot registra compilação real de `DockHub.Tests.dproj` em **Debug / Win32** com resultado **Success**.

A mesma compilação também registra a mensagem:

```text
DockHub.View.Page.Composition.Impl.Base.pas(1): Line endings are LF, but RAD Studio requires CRLF. Consider converting or check your source control settings.
```

Portanto, a compilação real dessa configuração está confirmada pela evidência fornecida, mas **build sem warnings/mensagens não está confirmado**.

## Method Toxicity — projeto de testes

Foi fornecido um relatório real de Method Toxicity do RAD Studio para `DockHub.Tests.dproj`. O maior valor de **Toxicity reportado/exibido** na captura atual, ordenada por Toxicity, é:

```text
0,508
```

Threshold do projeto para `Toxicity`:

```text
1
```

Portanto, o maior valor exibido na evidência fornecida está abaixo do threshold do projeto.

A captura é utilizada somente para os valores efetivamente visíveis. Ela não é usada para afirmar máximos globais de `Length`, `Parameters`, `If Depth` ou `Cyclomatic Complexity` além do que pode ser comprovado na imagem, nem para reconstruir manualmente a fórmula de `Toxicity`.

## Executando a suíte atual

1. Abrir `Dock.Hub.groupproj` ou `tests/DockHub.Tests.dproj` no RAD Studio.
2. Selecionar o projeto `DockHub.Tests`.
3. Selecionar configuração/plataforma desejada.
4. Compilar o projeto de testes.
5. Executar o projeto normalmente para abrir `DockHub.Tests.Runner.FMX`. Na primeira execução, ou quando não existir uma preferência de tema válida, o runner abre em **Escuro**.
6. Usar o seletor **Tema** da toolbar para alternar entre **Escuro** e **Claro**. A escolha válida é reaplicada na próxima inicialização por meio de `DockHub.Tests.ini`, armazenado junto ao executável de testes.
7. Usar a árvore de seleção à esquerda para marcar/desmarcar uma fixture inteira ou testes individuais. Usar a pesquisa para localizar fixtures/testes; `Todos`, `Nenhum` e `Inverter` atuam sobre o catálogo completo, não apenas sobre os itens visíveis pela pesquisa.
8. Usar **Executar selecionados** para rodar o subconjunto marcado, **Executar todos** para rodar a suíte completa sem perder o subconjunto corrente, ou dar duplo clique em um teste para executar somente ele preservando a seleção atual.
9. Utilizar os cards de resumo, os agrupamentos por fixture e os filtros rápidos de resultado para navegar pela última execução. Selecionar uma linha de resultado para inspecionar status, mensagem, expected/actual comparáveis quando disponíveis e stack trace.
10. Após cada execução, utilizar o XML NUnit gerado como evidência regenerável daquela execução quando for necessário registrar resultados ou integrar ferramentas externas.
11. Não versionar `dunitx-results.xml` como documentação. Atualizar números documentados somente a partir de uma execução real identificável.

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
- registrar explicitamente cada fixture com `TDUnitX.RegisterTestFixture`, salvo mudança deliberada e revalidada da estratégia atual do runner;
- preservar o entry point FMX code-only atual e a geração de XML NUnit por execução; não documentar TestInsight/CI como ativos enquanto não existirem no `DockHub.Tests.dpr` corrente;
- preservar a comunicação semântica do resultado com texto e cor; cor isolada nunca deve ser o único indicador de estado;
- preservar a separação entre seleção pré-execução e filtros de resultado pós-execução; alterar um filtro visual nunca deve mudar silenciosamente quais testes serão executados;
- manter `Executar todos` independente do subconjunto corrente, manter `Executar selecionados` dirigido pelos testes marcados e preservar a seleção do usuário ao executar um único teste por duplo clique;
- implementar execução focada por meio de `BuildFixtures` / `ITest.Enabled` do DUnitX, sem criar um mecanismo paralelo de descoberta de testes;
- manter o runner interativo independente dos contratos de Theme da produção; suas paletas `Dark`/`Light` pertencem somente à infraestrutura de testes e não devem fazer o runner depender do módulo que ele pode precisar testar;
- preservar `Dark` como fallback quando a preferência de aparência estiver ausente, inválida ou ilegível; persistir somente o identificador do tema em `DockHub.Tests.ini`, junto ao executável de testes, sem serializar tokens de cor;
- uma falha de leitura/escrita da preferência visual não pode impedir a inicialização nem a execução dos testes;
- não reintroduzir `DUNitX.Loggers.GUIX` sem revalidar seu recurso FMX no Delphi efetivamente utilizado; o runner atual é code-only justamente para evitar incompatibilidade de streaming de `.fmx`;
- não apresentar quantidade de testes no fonte como quantidade executada/aprovada;
- atualizar evidência de execução somente a partir de resultado real do runner/XML; não inferir aprovação pela contagem no fonte;
- tratar `dunitx-results.xml` como artefato regenerável de execução, não como documentação versionada;
- aplicar Method Toxicity Metrics também ao código de testes, não apenas à produção.
