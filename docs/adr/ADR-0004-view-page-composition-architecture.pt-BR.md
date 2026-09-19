# ADR-0004 — Arquitetura de Composição das Pages da View

[English — Official](./ADR-0004-view-page-composition-architecture.md)

- **Status:** Aceito
- **Escopo:** `DockHub.View.Page`
- **Tipo de decisão:** Organização estrutural da View / lifecycle de composition
- **Substitui:** [ADR-0003 — Arquitetura de Pages e Composição Runtime da View](./ADR-0003-view-page-architecture.pt-BR.md)

## Contexto

A arquitetura inicial de `View.Page` agrupava cada Page em um diretório físico próprio, com uma subpasta `Composition` local à Page. Conforme a implementação da Main evoluiu, o projeto consolidou um padrão mais reutilizável já utilizado em outras áreas do DockHub: papéis explícitos de `Types`, `Contracts` e `Impl`.

O fonte atual possui agora um lifecycle abstrato comum de composition, contratos/tipos compartilhados de Page e uma composition específica da Main. Essa arquitetura precisa suportar futuras Views sem transferir comportamento de negócio para a camada visual e sem criar níveis adicionais de abstração antes de existir reutilização real.

O projeto também mantém deliberadamente o lifetime da Composition orientado a interface através de `TInterfacedObject` e referências de interface mantidas pela Page.

## Decisão

### 1. Organização estrutural

`DockHub.View.Page` utiliza a estrutura:

```text
src/view/Page/
├── Contracts/
│   └── DockHub.View.Page.Contracts.pas
├── Impl/
│   ├── DockHub.View.Page.Composition.Impl.Base.pas
│   └── <Page>/
│       └── DockHub.View.Page.Impl.<Page>.Composition.pas
├── Types/
│   └── DockHub.View.Page.Types.pas
├── DockHub.View.Page.<Page>.pas
└── DockHub.View.Page.<Page>.fmx          # quando aplicável
```

Os papéis são explícitos:

```text
Types
→ enums/tipos compartilhados de View.Page

Contracts
→ interfaces públicas de View.Page

Composition.Impl.Base
→ lifecycle abstrato reutilizável e comportamento comum

Impl.<Page>.Composition
→ implementação de apresentação runtime específica da Page

DockHub.View.Page.<Page>
→ lifecycle da Form, estado, colaboradores e semântica das ações
```

Antes de alterar essa estrutura, o projeto atual deve ser inspecionado. Um trecho parcial de código não é evidência suficiente para inventar nova pasta, namespace, tipo aninhado ou abstração.

### 2. Tipos compartilhados de Page

Tipos estruturais pertencentes ao domínio `View.Page` ficam em `DockHub.View.Page.Types` quando não são apenas detalhe local de uma implementação.

O enum atual de lifecycle é:

```pascal
{$SCOPEDENUMS ON}

type
  TPageCompositionState = (
    Configuring,
    Building,
    Built,
    Failed
  );
```

Os membros são acessados de forma qualificada, por exemplo `TPageCompositionState.Built`.

### 3. Contrato comum de Composition

`IPageComposition` define a API compartilhada:

```pascal
Form(...)
OnMinimize(...)
OnClose(...)
Build
ApplyLanguage(...)
ApplyTheme(...)
```

A API de configuração é fluente, mas a configuração só é válida enquanto a Composition estiver em `Configuring`.

### 4. Contratos específicos de Page são permitidos quando justificados

`IPageCompositionMain` estende intencionalmente `IPageComposition`.

A interface ainda não acrescenta métodos, mas é preservada porque a Main já possui ações específicas conhecidas cujos contratos de aplicação serão introduzidos posteriormente, incluindo operações de serviço e ações de configuração/logs.

Essa decisão não exige interface específica vazia para toda futura Page. Um contrato específico precisa de motivo real da própria Page para existir.

### 5. Composition base abstrata

`TPageCompositionBase` é um `TInterfacedObject` abstrato que implementa `IPageComposition`.

Ela concentra comportamento atualmente compartilhado pelas compositions:

- validação de lifecycle/estado;
- referência da Form host;
- configuração comum de callbacks minimizar/fechar;
- criação comum de botões de janela;
- Theme e hover comuns dos botões de janela;
- armazenamento do Theme corrente necessário ao hover runtime;
- helper de localização do caption de Button do RickUIBuilder;
- helper reutilizável de Theme de Button;
- hooks Template Method para construção/apresentação específicas da Page.

As derivadas implementam:

```pascal
DoBuild
DoApplyTheme
DoApplyLanguage
```

Comportamento compartilhado permanece na base apenas enquanto for realmente compartilhado. Comportamento específico permanece na composition específica.

### 6. Lifecycle da Composition

O lifecycle é:

```text
Configuring
    │
    └── Build
          ↓
       Building
       ↙      ↘
    Built    Failed
```

Regras:

- a construção inicia em `Configuring`;
- Form host e callbacks obrigatórios precisam ser configurados antes de Build;
- a configuração é fechada quando Build começa;
- Build bem-sucedido termina em `Built`;
- exception durante Build move a instância para `Failed` e é relançada;
- segundo Build após `Built` é idempotente;
- Build em `Building` ou `Failed` é rejeitado;
- Language e Theme só podem ser aplicados depois de `Built`;
- contratos Language/Theme `nil` são inválidos;
- uma instância `Failed` não é reutilizada.

O lifecycle é comportamental. Os testes validam o contrato pela API pública, sem expor o estado privado apenas para acesso de teste.

### 7. Lifetime por interface/reference counting

A arquitetura mantém deliberadamente o lifetime da Composition através de interfaces:

```text
TPageMain
  └── IPageCompositionMain
          ↓
     TPageMainComposition : TInterfacedObject
```

A Page deve manter a interface enquanto controles criados pela Composition puderem chamar event handlers da própria Composition.

A interface controla o lifetime do objeto Composition; os controles FMX continuam seguindo normalmente seu lifecycle de Owner/Parent.

Não zere a interface da Composition antes de destruir os controles que referenciam handlers dela.

### 8. Responsabilidades de Page e Composition

A Page mantém/coordena:

- lifecycle da Form/View;
- estado ativo de Language;
- estado ativo de Theme;
- estado específico da Page;
- semântica das ações do usuário;
- criação/configuração do contrato de Composition.

A Composition específica da Page mantém:

- construção visual runtime;
- referências visuais necessárias após Build;
- mapeamento de tradução para esses controles;
- mapeamento de Theme para esses controles;
- atualizações de estado visual;
- wiring visual de callbacks fornecidos pela Page.

Composition não contém regra de negócio, operações de banco, casos de uso REST/aplicação ou decisões de navegação.

### 9. Direção de Language

A direção atual é:

```text
TPageMain
→ estado IDockHubLanguage
→ IPageCompositionMain.ApplyLanguage
→ TPageMainComposition.DoApplyLanguage
→ Caption da Form e controles runtime
```

`Core.Language` continua independente de FMX.

### 10. Direção de Theme

A direção atual é:

```text
TPageMain
→ estado IDockHubTheme
→ IPageCompositionMain.ApplyTheme
→ TPageMainComposition.DoApplyTheme
→ background da Form e controles runtime
```

`View.Theme` continua independente dos detalhes internos das Pages.

A Composition base aplica Theme aos controles comuns de janela e mantém o Theme aplicado mais recentemente para o hover.

### 11. RickUIBuilder

RickUIBuilder continua sendo dependência de construção visual dentro das compositions, e não o boundary arquitetural.

A Main atual usa fluent builders individuais quando referências de controles são necessárias após Build. O card estrutural permanece criação direta FMX porque o snapshot analisado do RickUIBuilder não possui builder genérico de card/container.

A API atual de Button do RickUIBuilder não expõe handle público do caption. O workaround fica centralizado em `TPageCompositionBase.FindButtonCaption`; não deve ser duplicado nas Pages.

### 12. Testes

O projeto separa as responsabilidades de teste:

- testes de contrato/lifecycle de `TPageCompositionBase`;
- testes de integração FMX de `TPageMainComposition`;
- testes independentes de Language/Theme.

Inventário de testes no fonte não é evidência de execução. O XML DUnitX histórico continua histórico até a suíte atual ser realmente executada.

## Consequências

### Positivas

- lifecycle comum de composition possui uma única implementação;
- composition específica permanece isolada;
- falhas de lifecycle são explícitas em vez de silenciosas;
- configuração não pode divergir silenciosamente de uma UI já construída;
- `Types / Contracts / Impl` segue padrão estrutural já existente no DockHub;
- `IPageCompositionMain` pode crescer com ações reais da Main sem poluir o contrato comum;
- Theme e Language continuam desacoplados das implementações concretas.

### Custos e restrições

- a Page precisa manter a interface da Composition pelo lifetime necessário;
- instâncias com Build falho são terminais e precisam ser recriadas;
- alterações no lifecycle comum afetam todas as compositions derivadas;
- acesso ao caption de Button do RickUIBuilder depende hoje de um único detalhe de implementação centralizado, até a API upstream expor um handle.

## Alternativas rejeitadas/adiadas

A arquitetura atual não introduz:

- ownership de Composition via `TComponent`;
- hierarquia State Pattern para quatro estados;
- Navigator/Router/PageManager global;
- Factory genérica de Pages;
- container de DI apenas para construir Pages;
- métodos especulativos em `IPageCompositionMain` antes de contratos reais de ação;
- uma classe/unit por região visual sem necessidade demonstrada.

Esses pontos só devem ser reavaliados diante de requisitos concretos.

## Documentação relacionada

- [Módulo View Page](../modules/view/README.pt-BR.md)
- [RickUIBuilder — Referência de Integração do DockHub](../dependencies/rickuibuilder/README.pt-BR.md)
- [Arquitetura de Language](./ADR-0001-language-architecture.pt-BR.md)
- [Arquitetura de Theme](./ADR-0002-theme-architecture.pt-BR.md)
- [ADR-0003 substituído](./ADR-0003-view-page-architecture.pt-BR.md)
- [Testes Automatizados](../testing/README.pt-BR.md)
