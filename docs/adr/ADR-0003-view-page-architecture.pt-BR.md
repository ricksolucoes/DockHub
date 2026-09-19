# ADR-0003 — Arquitetura de Pages e Composição Runtime da View

[English — Official](./ADR-0003-view-page-architecture.md)

- **Status:** Substituído
- **Escopo:** `DockHub.View.Page`
- **Tipo de decisão:** Organização estrutural da View / composição visual runtime

> **Substituído por:** [ADR-0004 — Arquitetura de Composição das Pages da View](./ADR-0004-view-page-composition-architecture.pt-BR.md)
>
> Este ADR é preservado como decisão histórica que antecedeu a arquitetura atual de composition baseada em `Types / Contracts / Impl`.

## Contexto

O DockHub iniciou sua camada de apresentação com `TPageMain` em `DockHub.View.Page.Main`. À medida que a aplicação evoluir, novas Pages poderão ser adicionadas e cada uma poderá possuir uma árvore visual criada em runtime, além de estado, Theme, Language, handlers e outras responsabilidades específicas.

Manter todas as Pages e seus auxiliares diretamente em `src/view/Page/` produziria uma pasta progressivamente plana e reduziria a proximidade entre artefatos que pertencem à mesma tela. Ao mesmo tempo, concentrar toda a criação dos controles dentro da própria classe `TForm` tende a aumentar responsabilidade, tamanho de métodos e acoplamento da Page conforme a interface cresce.

A arquitetura existente já estabelece fronteiras relevantes:

```text
Language
→ não conhece FMX

Theme
→ não conhece Forms concretas

View
→ aplica Language e Theme aos próprios controles
```

A nova organização precisa preservar essas fronteiras e permitir crescimento sem introduzir antecipadamente navegação global, managers, interfaces genéricas ou hierarquias artificiais.

## Decisão

As decisões abaixo ficam aceitas para a organização de `View.Page`.

### 1. Cada Page recebe um boundary físico próprio

O padrão para uma Page é:

```text
src/view/Page/<Page>/
├── DockHub.View.Page.<Page>.pas
├── DockHub.View.Page.<Page>.fmx          # quando aplicável
└── Composition/
    └── DockHub.View.Page.<Page>.Composition.pas
```

A pasta `<Page>` agrupa artefatos exclusivos daquela Page.

O primeiro caso adotado é `Main`:

```text
src/view/Page/Main/
├── DockHub.View.Page.Main.pas
├── DockHub.View.Page.Main.fmx
└── Composition/
    └── DockHub.View.Page.Main.Composition.pas
```

### 2. A pasta física não adiciona role artificial à unit principal

A classe principal da Main continua em:

```pascal
unit DockHub.View.Page.Main;
```

Não é necessário transformar a unit em `DockHub.View.Page.Main.Form` apenas porque o arquivo passou a ficar dentro da pasta `Main`.

### 3. Composition é uma responsabilidade explícita da Page

A unit:

```text
DockHub.View.Page.<Page>.Composition
```

representa a composição visual page-specific criada em runtime.

Essa responsabilidade pode incluir:

- criação de controles FMX;
- uso do mecanismo de UI building adotado pela aplicação;
- hierarquia visual e `Parent`;
- posicionamento, dimensões, alinhamentos e propriedades estruturais;
- associação de handlers/callbacks fornecidos pelo consumidor;
- disponibilização de referências a controles quando a Page realmente precisar atualizá-los.

A forma concreta da API entre Page e Composition não é determinada por este ADR antes da implementação.

### 4. A Page mantém comportamento e coordenação da apresentação

A classe da Page continua responsável por:

- ciclo de vida da Form/View;
- estado local;
- colaboradores necessários;
- `ApplyLanguage` ou equivalente;
- `ApplyTheme` ou equivalente;
- semântica das ações disparadas pelo usuário;
- coordenação com navegação quando um mecanismo de navegação for efetivamente definido.

Composition não substitui a Page.

### 5. Wiring de evento não significa propriedade da ação

Composition pode associar um `OnClick` ou callback durante a criação de um controle.

Isso representa wiring estrutural:

```text
Composition
→ cria componente
→ associa callback
```

O significado da ação permanece fora da Composition:

```text
Page / colaborador apropriado
→ interpreta a ação
→ executa o comportamento da aplicação
```

### 6. Composition não navega diretamente entre Pages

A decisão concreta de navegação ainda não faz parte desta arquitetura.

Composition não deve, por conveniência, criar diretamente outra Form/Page ao tratar um evento visual.

Quando múltiplas Pages existirem e houver necessidade real de navegação, a solução deverá ser avaliada separadamente considerando ownership, lifetime, estado compartilhado e direção de dependências.

Este ADR não cria nem autoriza antecipadamente:

```text
Navigator
Router
PageManager
Service Locator
DI Container
singleton global
```

### 7. Language continua fora da estrutura visual concreta

`Core.Language` não passa a conhecer `TLabel`, `TButton`, `TForm` ou a Composition.

A View continua aplicando textos traduzidos aos próprios controles:

```text
Language
    ↓
View
    ↓
ApplyLanguage
    ↓
controles da View
```

Se controles runtime precisarem ser atualizados, a integração Page ↔ Composition deverá fornecer apenas as referências/contratos realmente necessários.

### 8. Theme continua independente de Pages concretas

`View.Theme` permanece responsável pelos valores e comportamentos visuais reutilizáveis que pertencem ao Theme.

A View permanece responsável por decidir onde aplicar esses valores:

```text
Theme
    ↓
View
    ↓
ApplyTheme
    ↓
controles da View
```

Composition não autoriza Theme a localizar ou manipular diretamente componentes internos da Page.

### 9. Subdivisões adicionais exigem responsabilidade real

Se uma Page crescer, `Composition` pode futuramente ser subdividida em responsabilidades visuais menores.

Essa subdivisão somente deve ocorrer depois que o código demonstrar uma separação coesa.

Não criar antecipadamente:

```text
Header
Sidebar
Content
Footer
Components
Actions
```

como estrutura vazia ou especulativa.

### 10. Reuso entre Pages será decidido quando existir reuso real

Artefatos sob `Page/<Page>/` são específicos daquela Page por padrão.

Se uma responsabilidade visual passar a ser compartilhada por múltiplas Pages, a extração para uma área compartilhada da `View` deverá ser analisada naquele momento.

Este ADR não define antecipadamente nome, path ou contrato para essa futura área.

### 11. RickUIBuilder é a dependência de construção runtime, não o boundary de comportamento

RickUIBuilder foi analisado como a dependência de construção visual relevante para esta arquitetura de Page/Composition. A referência específica de integração no DockHub é mantida em [RickUIBuilder — Referência de Integração do DockHub](../dependencies/rickuibuilder/README.pt-BR.md).

O código atual da biblioteca possui relação direta com os helpers da tela de referência original: a própria Factory declara que `CreateText`, `CreateDivider`, `CreateBadge` e `CreateButton` foram extraídos daquela tela e desacoplados de uma Form concreta. Portanto, o DockHub deve reutilizar o comportamento público da biblioteca em vez de recriar esses helpers localmente sem necessidade real.

Este ADR distingue dois significados de Composition:

```text
DockHub.View.Page.<Page>.Composition
→ responsabilidade arquitetural da Page

Rick.UIBuilder.Composition / TRickUIBuilder.On(AParent)
→ uma forma de uso do RickUIBuilder
```

A Composition do DockHub pode escolher Factory, Fluent Builders, `TRickUIBuilder.On(...)` ou combinação justificada. A escolha depende das necessidades concretas da Page, inclusive se o controle criado precisará permanecer acessível para `ApplyLanguage`, `ApplyTheme`, alterações de evento/estado ou outras atualizações runtime.

Isso é relevante porque a API analisada de `TRickUIBuilder.On(...)` não devolve os controles criados por Text, Divider ou Button, enquanto os fluent builders individuais devolvem o controle gerado e Badge possui handle público. Portanto, nenhuma regra do projeto deve forçar `TRickUIBuilder.On(...)` apenas porque a unit do DockHub se chama `Composition`.

RickUIBuilder não passa a possuir:

- regra de negócio;
- decisão de navegação;
- estado da aplicação;
- significado semântico dos clicks;
- ownership de Theme ou Language.

RickUIBuilder recebe valores/callbacks concretos e cria/configura controles FMX. O DockHub permanece responsável por resolver tokens semânticos de Theme e textos de Language antes ou durante a aplicação da apresentação nesses controles.

A implementação analisada de hover de Button também mantém as cores normal/hover recebidas no momento do build. Mudanças de Theme em runtime precisam considerar esse comportamento quando `HoverFillColor` for utilizado; alterar apenas o fill atual do botão não reescreve as cores armazenadas no hover-state.

A referência de integração deve ser revalidada quando a revisão da dependência RickUIBuilder mudar de forma relevante.

## Estado inicial desta decisão

A estrutura física de `Page/Main/Composition` está implementada e a `Main` já utiliza `TPageMainComposition` em runtime.

A implementação atual confirma:

- boundary físico da Main;
- namespace `DockHub.View.Page.Main`;
- namespace `DockHub.View.Page.Main.Composition`;
- `TPageMain` responsável por ciclo de vida, Language, Theme e semântica das ações da janela;
- `TPageMainComposition` responsável por toda a criação visual runtime da Main;
- RickUIBuilder utilizado pela Composition para os controles suportados pela biblioteca;
- card estrutural criado pela Composition através de FMX;
- `ApplyLanguage` e `ApplyTheme` delegados à Composition para os controles internos;
- callbacks explícitos de minimizar e fechar;
- ações administrativas ainda não implementadas mantidas desabilitadas.

## Consequências

### Positivas

- cada Page passa a possuir boundary físico claro;
- artefatos page-specific ficam próximos;
- a construção visual runtime ganha responsabilidade explícita;
- `TForm` pode permanecer focada em lifecycle, estado e coordenação;
- a estrutura cresce sem transformar `Page/` em um diretório plano;
- Theme e Language preservam as fronteiras atuais;
- wiring de eventos pode evoluir sem misturar automaticamente navegação ou regra de negócio;
- novas subdivisões podem surgir por necessidade real, sem serem impostas antecipadamente.

### Trade-offs

- cada Page com composição runtime pode possuir mais de uma unit e subpasta;
- a API entre Page e Composition precisará ser definida quando a integração real for implementada;
- controles criados em runtime exigirão uma estratégia explícita para referências que precisem participar de `ApplyLanguage`, `ApplyTheme` ou atualizações de estado;
- navegação entre Pages continua sendo uma decisão futura separada.

## Alternativas rejeitadas/adiadas

### Todas as Pages diretamente em `src/view/Page/`

Rejeitada como direção de crescimento porque mistura artefatos de diferentes telas em uma pasta plana e reduz coesão física conforme o projeto aumenta.

### Uma pasta global `src/view/Composition/` para todas as Pages

Rejeitada para composições page-specific porque separaria fisicamente a composição da Page à qual ela pertence e tenderia a misturar composições independentes.

Uma responsabilidade visual realmente compartilhada poderá receber outra organização no futuro, quando existir reuso concreto.

### Toda a composição dentro da classe `TForm`

Adequada somente enquanto a composição permanecer pequena e coesa. Não é adotada como regra de crescimento porque uma Page grande poderia concentrar lifecycle, estado, eventos, Language, Theme e toda a construção visual na mesma classe.

### Framework genérico de Pages desde agora

Rejeitado/adiado. Não há necessidade confirmada para base class própria, Page manager, router genérico, registry ou factory de Pages.

## Gatilhos para reavaliação

Reavaliar este ADR quando ocorrer um ou mais dos seguintes pontos:

- múltiplas Pages passarem a exigir navegação real;
- uma responsabilidade visual for reutilizada por várias Pages;
- a mesma Page adquirir regiões visuais grandes com lifecycle próprio;
- Theme ou Language passarem a possuir estado compartilhado entre múltiplas Views;
- múltiplas Views independentes precisarem permanecer abertas simultaneamente;
- o contrato Page ↔ Composition mostrar necessidade recorrente que justifique uma abstração compartilhada;
- ownership/lifetime dos controles runtime exigir mudança arquitetural relevante.

## Validação

Esta decisão foi validada estruturalmente contra as regras atuais de organização, SRP, Separation of Concerns, KISS, YAGNI, direção de dependências e crescimento documentado do DockHub.

A integração runtime `Main`/`Main.Composition` descrita por este ADR está implementada. Este ADR, isoladamente, não reivindica compilação nem execução de testes; o estado atual de validação está documentado em [tests/README.pt-BR.md](../../tests/README.pt-BR.md).

## Documentação relacionada

- [DockHub View Pages](../modules/view/README.pt-BR.md)
- [RickUIBuilder — Referência de Integração do DockHub](../dependencies/rickuibuilder/README.pt-BR.md)
- [Módulo de Theme](../modules/theme/README.pt-BR.md)
- [Módulo de Idiomas](../modules/language/README.pt-BR.md)
- [Documentação do DockHub](../README.pt-BR.md)
