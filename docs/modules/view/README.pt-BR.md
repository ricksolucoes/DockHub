# Pages da View do DockHub

[English — Official](./README.md)

Este documento descreve a estrutura atual de `DockHub.View.Page` e o contrato de composição runtime efetivamente implementado no projeto.

A decisão arquitetural vigente está registrada em [ADR-0004 — Arquitetura de Composição das Pages da View](../../adr/ADR-0004-view-page-composition-architecture.pt-BR.md). O [ADR-0003](../../adr/ADR-0003-view-page-architecture.pt-BR.md) é preservado como decisão substituída que antecedeu esta estrutura.

## 1. Objetivo

`View.Page` separa contratos/tipos compartilhados das Pages, comportamento reutilizável de composição e apresentação específica de cada Page. A estrutura existe para manter futuras Pages coerentes sem mover regra de negócio, estado de Theme ou estado de Language para o construtor visual.

Os objetivos atuais são:

- manter contratos públicos das Pages explícitos;
- manter tipos compartilhados de Page fora das classes de implementação;
- fornecer um lifecycle abstrato e reutilizável para compositions;
- manter a construção visual runtime de cada Page em sua própria implementation;
- manter `TPageMain` focada em ciclo de vida da Form, estado e semântica das ações;
- preservar a direção das dependências de Theme e Language;
- permitir contratos específicos de Page, como `IPageCompositionMain`, quando a própria Page possui ações conhecidas que precisarão de API própria.

## 2. Estrutura atual

```text
src/view/Page/
├── Contracts/
│   └── DockHub.View.Page.Contracts.pas
├── Impl/
│   ├── DockHub.View.Page.Composition.Impl.Base.pas
│   └── Main/
│       └── DockHub.View.Page.Impl.Main.Composition.pas
├── Types/
│   └── DockHub.View.Page.Types.pas
├── DockHub.View.Page.Main.pas
└── DockHub.View.Page.Main.fmx
```

Responsabilidades:

```text
Types
→ enums e tipos compartilhados pertencentes a View.Page

Contracts
→ interfaces públicas do domínio View.Page

Composition.Impl.Base
→ lifecycle abstrato reutilizável e comportamento visual comum

Impl.<Page>.Composition
→ construção visual runtime e mapeamento de apresentação específicos da Page

DockHub.View.Page.<Page>
→ ciclo de vida da Form/View, estado, colaboradores e semântica das ações
```

`DockHub.View.Page.Types` utiliza atualmente `{$SCOPEDENUMS ON}` e contém `TPageCompositionState`.

## 3. Contratos

### `IPageComposition`

O contrato comum expõe as operações atuais de configuração/build/apresentação:

```pascal
function Form(const AForm: TForm): IPageComposition;
function OnMinimize(const ANotifyEvent: TNotifyEvent): IPageComposition;
function OnClose(const ANotifyEvent: TNotifyEvent): IPageComposition;
function ApplyLanguage(const ALanguage: IDockHubLanguage): IPageComposition;
function ApplyTheme(const ATheme: IDockHubTheme): IPageComposition;
function Build: IPageComposition;
```

A configuração é fluente, mas só é válida durante o estado `Configuring` da Composition.

### `IPageCompositionMain`

`IPageCompositionMain` estende intencionalmente `IPageComposition`, mesmo sem acrescentar métodos neste momento.

Ela é mantida como contrato específico da Main porque a Main já possui ações conhecidas cujo comportamento real será implementado posteriormente, incluindo instalar/desinstalar/iniciar/parar e ações de configuração/logs. Essas operações só devem entrar no contrato quando o comportamento de aplicação estiver realmente definido; a interface não deve receber métodos especulativos apenas para antecipá-los.

## 4. `TPageCompositionBase`

`TPageCompositionBase` é um `TInterfacedObject` abstrato que implementa o contrato comum `IPageComposition`.

Ela concentra comportamento compartilhado pelas compositions de Page:

- validação do lifecycle da Composition;
- referência da Form host;
- callbacks de minimizar/fechar;
- criação comum dos controles de janela;
- Theme comum dos controles de janela;
- referência ao Theme corrente utilizada pelo hover;
- `FindButtonCaption`, isolando a limitação atual do caption de Button do RickUIBuilder;
- `ApplyButtonTheme`;
- hooks Template Method para Build, Theme e Language específicos da Page.

As compositions derivadas implementam:

```pascal
procedure DoBuild; virtual; abstract;
procedure DoApplyTheme; virtual; abstract;
procedure DoApplyLanguage(const ALanguage: IDockHubLanguage); virtual; abstract;
```

## 5. Lifecycle da Composition

O lifecycle é representado pelo scoped enum:

```pascal
TPageCompositionState = (
  Configuring,
  Building,
  Built,
  Failed
);
```

As transições são:

```text
Configuring
    │
    └── Build
          ↓
       Building
       ↙      ↘
    Built    Failed
```

Regras implementadas pela classe base:

- uma nova Composition inicia em `Configuring`;
- `Form`, `OnMinimize` e `OnClose` só são aceitos durante configuração;
- `Build` exige Form host e os dois callbacks de janela;
- `Build` muda o estado para `Building` antes da construção específica da Page;
- construção bem-sucedida termina em `Built`;
- qualquer exception durante a construção termina em `Failed` e é relançada;
- um segundo `Build` após `Built` é idempotente e não reconstrói a árvore;
- `Build` a partir de `Building` ou `Failed` é rejeitado;
- `ApplyLanguage` e `ApplyTheme` exigem `Built`;
- contratos de Language/Theme `nil` são rejeitados;
- a configuração não pode ser alterada depois que o Build começa.

Uma instância em `Failed` não é reutilizada. Se for necessário tentar novamente, deve ser criada uma nova Composition.

## 6. Lifetime e reference counting

A arquitetura atual utiliza deliberadamente lifetime por interface/reference counting:

```text
TPageMain
  └── FComposition: IPageCompositionMain
          ↓
     TPageMainComposition
```

A Page deve manter a interface da Composition referenciada enquanto controles criados pela Composition puderem disparar event handlers na própria Composition.

Isso é especialmente relevante para os botões comuns de janela, cujos handlers de hover apontam para métodos de `TPageCompositionBase`.

Não zere explicitamente a interface da Composition da Page enquanto os controles FMX ainda estiverem vivos e puderem disparar esses callbacks.

Os controles FMX continuam sendo gerenciados pela hierarquia Owner/Parent do FMX; a interface não é dona desses controles.

## 7. Responsabilidade de `TPageMain`

`TPageMain` atualmente mantém:

- o estado `IDockHubLanguage`;
- o estado `IDockHubTheme`;
- a referência `IPageCompositionMain`;
- configuração da Form;
- configuração/build da Composition;
- mudanças de estado de Language/Theme;
- semântica das ações minimizar/fechar.

`TPageMain` não cria diretamente a árvore visual da Main.

O fluxo atual de construção é:

```text
Create Language
Create Theme
ConfigureForm
ConfigureComposition
Build
ApplyLanguage
ApplyTheme
```

## 8. Responsabilidade da Composition da Main

`TPageMainComposition` herda de `TPageCompositionBase` e implementa `IPageCompositionMain`.

Ela cria e mantém os controles necessários para a apresentação da Main, incluindo:

- card/surface;
- título/subtítulo;
- labels, badges e valores de status runtime;
- botões de ação;
- captions traduzidos;
- mapeamento de Theme dos próprios controles.

Os controles comuns de minimizar/fechar permanecem implementados pela classe base.

Ações administrativas que ainda não possuem casos de uso de aplicação implementados permanecem desabilitadas. A Composition não inventa comportamento de serviço/negócio para elas.

## 9. Integração com Language

`Core.Language` continua independente de FMX.

A direção atual é:

```text
TPageMain
  ↓ mantém IDockHubLanguage
IPageCompositionMain.ApplyLanguage
  ↓
TPageMainComposition.DoApplyLanguage
  ↓
Caption da Form + controles runtime
```

`TPageMain` coordena o idioma ativo. `TPageMainComposition` é responsável pelo mapeamento de apresentação porque ela mantém as referências visuais.

Trocas de idioma em runtime atualizam os controles existentes; a árvore visual não é reconstruída.

## 10. Integração com Theme

`View.Theme` continua independente de Forms concretas e detalhes internos das Pages.

A direção atual é:

```text
TPageMain
  ↓ mantém IDockHubTheme
IPageCompositionMain.ApplyTheme
  ↓
TPageMainComposition.DoApplyTheme
  ↓
background da Form + controles runtime
```

A Composition base também aplica Theme aos controles comuns de janela e mantém `FCurrentTheme` para que os handlers de hover usem o Theme aplicado mais recentemente.

Trocas de Theme em runtime não reconstruem a árvore visual.

## 11. Eventos e semântica das ações

A construção visual pode conectar um callback fornecido pela Page, mas a semântica da ação permanece fora do código de composição visual.

Exemplo atual:

```text
TPageCompositionBase
→ cria botões minimizar/fechar
→ conecta callbacks fornecidos

TPageMain
→ define o significado de minimizar/fechar para a aplicação
```

As futuras ações da Main devem preservar a mesma fronteira. `IPageCompositionMain` é o contrato específico previsto para esses comportamentos quando os casos de uso reais forem implementados.

Composition não deve absorver:

- regra de negócio;
- acesso a banco;
- REST/casos de uso de aplicação;
- decisão direta de navegação;
- criação direta de outras Pages como efeito de clique.

## 12. Relação com RickUIBuilder

RickUIBuilder é um mecanismo de construção de UI utilizado dentro da arquitetura de composition do DockHub. Ele não é o boundary arquitetural.

Não confundir:

```text
DockHub.View.Page.Impl.<Page>.Composition
→ implementation page-specific de apresentação do DockHub

Rick.UIBuilder.Composition / TRickUIBuilder.On(AParent)
→ uma API possível do RickUIBuilder
```

A Main utiliza atualmente fluent builders para controles que precisam manter referência depois da criação. O card estrutural é criado diretamente com FMX porque o snapshot analisado do RickUIBuilder não possui builder genérico para card/container.

`FindButtonCaption` fica centralizado em `TPageCompositionBase` porque a API analisada de Button do RickUIBuilder retorna o `TRectangle` container, mas não expõe handle público para o caption.

Consulte [RickUIBuilder — Referência de Integração do DockHub](../../dependencies/rickuibuilder/README.pt-BR.md).

## 13. Convenção para novas Pages

Antes de decidir a estrutura de uma nova Page, inspecione primeiro o projeto atual. Não deduza pastas, tipos aninhados ou namespaces a partir de um trecho isolado de código.

Quando uma nova Page utilizar esta arquitetura, avalie sua necessidade real com base no padrão atual:

```text
src/view/Page/
├── Contracts/
├── Types/
├── Impl/
│   └── <Page>/
│       └── DockHub.View.Page.Impl.<Page>.Composition.pas
├── DockHub.View.Page.<Page>.pas
└── DockHub.View.Page.<Page>.fmx
```

Tipos compartilhados de `View.Page` pertencem a `DockHub.View.Page.Types` quando representam estado estrutural do domínio. Implementação específica permanece sob `Impl/<Page>`.

Não crie camadas adicionais de abstração antes de existir responsabilidade realmente reutilizável.

## 14. Criação de uma nova Page

A arquitetura acima possui agora um workflow operacional de IA para futuras Pages:

```text
Arquitetura normativa
→ este documento + ADR-0004

Autoridade de domínio
→ .ai/agents/dockhub-view-page.md

Procedimento reutilizável
→ create-view-page

Scaffolding
→ .ai/templates/delphi/view-page/
```

O workflow deve inspecionar o repositório atual antes de materializar arquivos.

Um template **materializa arquitetura confirmada; ele não define arquitetura**.

Ele também não cria automaticamente interface específica da Page, nova unit de `Types`, tokens Theme ou testes. Essas decisões continuam dependentes de necessidade comprovada.

---

## 15. Navegação

O código atual não define um mecanismo geral de navegação.

Não introduza `Navigator`, `Router`, `PageManager`, singleton ou Service Locator apenas porque poderão existir outras Pages. Navegação exige decisão separada quando houver caso de uso concreto.

## 16. Testes

O fonte contém:

- testes de contrato/lifecycle de `TPageCompositionBase`;
- testes de integração FMX de `TPageMainComposition`;
- fixtures independentes de Language e Theme.

A fixture da base valida o lifecycle público sem expor `FState` apenas para teste. A fixture da Main inspeciona comportamento FMX observável sem adicionar accessors de produção para controles privados.

A evidência de execução é documentada separadamente em [Testes Automatizados](../../testing/README.pt-BR.md). Inventário de testes no fonte não deve ser apresentado como prova de execução.

## 17. Quality gate estrutural

Ao evoluir `View.Page`, verificar:

```text
[ ] estrutura atual do projeto foi inspecionada antes de decidir paths/namespaces
[ ] enums/tipos compartilhados seguem o padrão existente de Types
[ ] contratos públicos permanecem em Contracts
[ ] comportamento comum permanece na base abstrata apenas quando realmente compartilhado
[ ] apresentação específica permanece em Impl/<Page>
[ ] Page mantém lifecycle/estado/semântica das ações
[ ] regras de lifecycle da Composition continuam válidas
[ ] lifetime por interface permanece seguro para callbacks de eventos
[ ] Theme continua independente dos detalhes internos da Page
[ ] Language continua independente de FMX
[ ] nenhuma regra de negócio foi movida para Composition
[ ] nenhum mecanismo de navegação foi inventado sem requisito próprio
[ ] testes cobrem lifecycle/error paths alterados
```

## 18. Documentação relacionada

- [ADR-0004 — Arquitetura de Composição das Pages da View](../../adr/ADR-0004-view-page-composition-architecture.pt-BR.md)
- [ADR-0003 — arquitetura de Pages substituída](../../adr/ADR-0003-view-page-architecture.pt-BR.md)
- [RickUIBuilder — Referência de Integração do DockHub](../../dependencies/rickuibuilder/README.pt-BR.md)
- [Módulo de Theme](../theme/README.pt-BR.md)
- [Módulo de Language](../language/README.pt-BR.md)
- [Testes Automatizados](../../testing/README.pt-BR.md)
- [Documentação do DockHub](../../README.pt-BR.md)
