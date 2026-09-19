# RickUIBuilder — Referência de Integração do DockHub

[English — Official](./README.md)

Este documento é a referência técnica do DockHub para consumo do **RickUIBuilder**. Ele registra o comportamento da biblioteca que foi efetivamente analisado para que futuras tarefas de UI runtime não dependam de suposições nem apenas de exemplos de outro aplicativo.

Ele não substitui a documentação upstream do RickUIBuilder. Registra especificamente o que o DockHub precisa conhecer antes de consumir essa dependência.

> **Status da integração no DockHub:** `DockHub.View.Page.Impl.Main.Composition` utiliza o RickUIBuilder em runtime para criar Labels, Badges, Dividers e Buttons. O card estrutural da Main continua sendo criado diretamente por FMX dentro da própria Composition porque o snapshot analisado não expõe um builder genérico de container/card.

## 1. Snapshot analisado

O seguinte estado upstream foi analisado em 2026-09-18:

```text
Repositório: ricksolucoes/RickUIBuilder
Branch: main
Versão em boss.json: 0.1.0
Repository tree SHA: 75b52bfb7d017e4e9be525d03a575c484b7b166d
```

A análise incluiu:

```text
README.md
README.pt-BR.md
sample/Readme.md
sample/src/RickUIBuilderSample.Main.pas

src/Rick.UIBuilder.pas
src/Rick.UIBuilder.Types.pas
src/Rick.UIBuilder.Interfaces.pas
src/Rick.UIBuilder.Factory.pas
src/Rick.UIBuilder._Label.pas
src/Rick.UIBuilder.Button.pas
src/Rick.UIBuilder.Button.HoverState.pas
src/Rick.UIBuilder.Badge.pas
src/Rick.UIBuilder.Badge.Handle.pas
src/Rick.UIBuilder.Divider.pas
src/Rick.UIBuilder.Composition.pas

testes DUnitX relevantes em tests/src/
```

Se a dependência mudar de versão ou revisão de código, a API upstream deve ser revalidada antes de continuar confiando neste documento quando o comportamento tiver mudado.

## 2. Origem e responsabilidade

RickUIBuilder é uma biblioteca Delphi FireMonkey para criação e composição de controles de UI por código.

O cabeçalho de `Rick.UIBuilder.Factory` declara explicitamente que os helpers de criação da Factory foram extraídos da tela de referência original que motivou o componente. Isso é importante para o DockHub: a biblioteca já encapsula a lógica repetitiva de criação dos elementos visuais para os quais expõe APIs públicas; o DockHub não deve recriar localmente essa lógica sem uma razão concreta.

A biblioteca não possui o comportamento da aplicação DockHub. Ela recebe valores, callbacks e um parent e cria/configura controles FMX.

## 3. Facade pública

`Rick.UIBuilder` expõe `TRickUIBuilder` como principal ponto de entrada:

```text
TRickUIBuilder
├── Factory
├── Label_
├── Button
├── Badge
├── Divider
└── On(AParent)
```

O snapshot analisado não expõe outro builder visual genérico através dessa facade.

## 4. Três formas de uso

A biblioteca oferece três formas complementares de uso. Elas não são aliases intercambiáveis.

| Forma | Ponto de entrada | Momento de criação | Uso típico |
| --- | --- | --- | --- |
| Factory | `TRickUIBuilder.Factory` | imediato | criação direta a partir de record de configuração |
| Fluent Builders | `Label_`, `Button`, `Badge`, `Divider` | ao chamar `Build` | configuração mais rica por controle e retorno do controle/handle |
| Composition | `TRickUIBuilder.On(AParent)` | cada `Add*` cria imediatamente | sequências curtas e fixas no mesmo parent |

Usar explicitamente uma interface `IRickUIBuilder*` não representa uma quarta forma; é o contrato dos mesmos fluent builders/composer.

## 5. Factory

`TRickUIBuilderFactory` implementa criação direta e recebe `AOwner`, `AParent` e um record de configuração.

| Método | Resultado criado |
| --- | --- |
| `CreateText` | `TLabel` |
| `CreateDivider` | `TRectangle` |
| `CreateBadge` | `TRectangle` do badge mais `TLabel` interno via `out` |
| `CreateButton` | `TRectangle` do botão contendo o `TLabel` de caption |

Comportamentos relevantes para o DockHub:

- `AOwner` controla o lifetime do componente;
- `AParent` controla a hierarquia visual FMX;
- as cores da Factory vêm do config fornecido; ela não conhece a paleta do consumidor;
- `CreateBadge` cria container em formato pill e expõe seu label interno via `out`;
- `CreateButton` habilita hit testing e cria o caption como label filho;
- `CreateButton` direto **não** instala o comportamento de hover do fluent builder.

## 6. Records de configuração

`Rick.UIBuilder.Types` fornece:

```text
TRickUIBuilderTextConfig
TRickUIBuilderBadgeConfig
TRickUIBuilderButtonConfig
TRickUIBuilderDividerConfig
TRickUIBuilderSpacing
```

Cada record possui valores `Default`. Esses defaults pertencem à biblioteca, não à identidade visual do DockHub.

Regra no DockHub:

```text
RickUIBuilder Default
→ ponto de partida seguro de configuração

Token semântico de IDockHubTheme
→ valor visual autoritativo do DockHub quando existir papel correspondente
```

Não tratar `Dodgerblue`, preto, branco, cinza claro ou qualquer outro default do RickUIBuilder como valor de Theme do DockHub.

## 7. Fluent Label Builder

`TRickUIBuilder.Label_` retorna `IRickUIBuilderLabel` e `Build(AParent)` retorna o `TLabel` criado.

O builder suporta, entre outras opções:

- texto;
- posição e tamanho;
- anchors;
- margin e padding;
- família, tamanho e cor da fonte;
- bold e italic;
- alinhamento horizontal e vertical;
- word wrap e trimming;
- opacity e visibility;
- hit testing;
- tag.

Comportamento de lifetime importante: a implementação atual usa o `AParent` fornecido a `Build` simultaneamente como `Owner` e `Parent` do controle criado.

Como `Build` retorna o `TLabel`, essa forma é adequada quando o DockHub precisa manter referência estável para `ApplyLanguage`, `ApplyTheme` ou atualizações posteriores de estado.

## 8. Fluent Button Builder

`TRickUIBuilder.Button` retorna `IRickUIBuilderButton` e `Build(AParent)` retorna o container do botão como `TRectangle`.

Ele adiciona comportamento/configuração além da criação direta pela Factory, incluindo:

- anchors;
- corner radius;
- margin e padding;
- border thickness;
- font family e bold;
- hover fill color;
- enabled/disabled e disabled opacity;
- cursor;
- opacity e visibility;
- tag;
- `OnClick`;
- `OnHover`.

O caption é implementado como um `TLabel` filho criado internamente pela Factory. A API pública analisada **não** expõe um Button handle específico para esse label.

Portanto, se o DockHub precisar alterar o caption de um botão depois da construção, a implementação deve escolher deliberadamente uma estratégia suportada pela API atual. Não inventar um Button handle do RickUIBuilder que não existe.

### Lifetime do hover

`Rick.UIBuilder.Button.HoverState` é um `TComponent` separado, owned pelo mesmo `AParent` usado em `Build`. Isso evita que eventos de mouse apontem para a instância temporária do builder após o fim do encadeamento fluente.

O objeto de hover guarda as cores normal e hover fornecidas no momento do build. Consequentemente, uma tela DockHub que suporte troca de Theme em runtime precisa considerar esses valores armazenados. Alterar apenas o `Fill.Color` atual do botão não reescreve, por si só, as cores já guardadas dentro do hover-state.

Esse ponto deve ser avaliado sempre que `HoverFillColor` e troca runtime de Theme coexistirem.

## 9. Fluent Badge Builder e handle

`TRickUIBuilder.Badge` retorna `IRickUIBuilderBadge`; `Build(AParent)` retorna `IRickUIBuilderBadgeHandle`.

O handle expõe:

```text
Container: TRectangle
TextLabel: TLabel
```

Esse é o mecanismo público para manter os dois controles gerados e atualizá-los após a construção.

O builder suporta pill/corner radius, margin, padding, background/text/border colors, font size, bold, opacity, visibility e tag.

No DockHub, o handle é especialmente relevante quando texto ou cor de status precisar mudar em runtime.

## 10. Fluent Divider Builder

`TRickUIBuilder.Divider` retorna `IRickUIBuilderDivider`; `Build(AParent)` retorna `TRectangle`.

Suporta position, comprimento (`Width`), thickness, orientação horizontal/vertical, margin, color, opacity e visibility.

A Factory cria o retângulo horizontal base com um pixel; o fluent builder aplica thickness e orientation solicitados após a criação.

## 11. Modo Composition do RickUIBuilder

`TRickUIBuilder.On(AParent)` retorna `IRickUIBuilderComposer` vinculado a um único parent FMX.

Diferentemente dos fluent builders individuais, o composer não possui `Build` final. Cada operação cria imediatamente:

```text
AddText
AddDivider
AddBadge
AddButton
```

Comportamentos relevantes para o DockHub:

- `AddText` cria label, mas não devolve esse label ao chamador;
- `AddDivider` cria divider, mas não devolve esse divider;
- `AddBadge` devolve `IRickUIBuilderBadgeHandle` via `out`;
- `AddButton` aceita `TNotifyEvent` opcional, mas não devolve o botão criado;
- todos os controles usam o parent do composer simultaneamente como Owner e Parent;
- as chamadas preservam a ordem de criação na coleção de filhos do parent conforme os testes analisados.

Essa forma é adequada para sequências curtas e fixas em que referências diretas posteriores não sejam necessárias, exceto Badge, para o qual existe handle explícito.

## 12. `Composition` do DockHub não é `Composition` do RickUIBuilder

Esses conceitos não podem ser confundidos:

```text
DockHub.View.Page.Impl.<Page>.Composition
→ implementation page-specific do DockHub para compor uma Page

TRickUIBuilder.On(AParent)
→ uma forma opcional de uso da API do RickUIBuilder
```

Uma Composition de Page do DockHub pode utilizar:

- Factory;
- fluent builders;
- `TRickUIBuilder.On(...)`;
- ou combinação justificada entre essas formas.

A existência de uma Page Composition do DockHub **não** obriga que todos os controles sejam criados por `TRickUIBuilder.On(...)`.

## 13. Regra de seleção para Pages runtime do DockHub

Escolher a API mais estreita do RickUIBuilder que preserve as necessidades reais da Page:

```text
Precisa de criação direta baseada em record
→ Factory

Precisa de configuração mais rica por controle
→ Fluent Builder

Precisa manter referência posterior de Label/Button/Divider
→ preferir a API que retorna esse controle

Precisa do container/texto de Badge após o build
→ Badge Builder + IRickUIBuilderBadgeHandle

Precisa de sequência curta e fixa no mesmo Parent sem referências posteriores
→ TRickUIBuilder.On(AParent)
```

Não escolher uma API apenas porque seu nome se parece com o nome da unit arquitetural do DockHub.

## 14. Integração com Theme do DockHub

RickUIBuilder não depende de `IDockHubTheme` e deve continuar sem conhecê-lo.

Direção esperada:

```text
IDockHubTheme
    ↓
View/Composition do DockHub
    ↓ resolve token semântico para o papel visual atual
RickUIBuilder
    ↓
controle FMX
```

Quando existir token semântico de Theme correspondente, o DockHub passa esse valor ao RickUIBuilder em vez de adotar default da biblioteca ou duplicar hexadecimal de paleta.

A View continua responsável por reaplicar Theme aos controles que precisarem reagir a troca de Theme em runtime.

## 15. Integração com Language do DockHub

RickUIBuilder recebe strings finais; ele não conhece `IDockHubLanguage` nem chaves de tradução.

Direção esperada:

```text
IDockHubLanguage
    ↓ Translate(key)
View/Page do DockHub
    ↓
RickUIBuilder / controles gerados
```

Para controles que precisarem reagir a mudança de idioma em runtime, a implementação DockHub deve manter ou acessar legitimamente a referência necessária do controle gerado. Isso influencia a escolha entre builder individual e `TRickUIBuilder.On(...)`.

Não embutir texto destinado ao usuário diretamente numa Page Composition quando as regras de Language do DockHub exigirem chave de tradução.

## 16. Eventos e comportamento da aplicação

RickUIBuilder pode ligar eventos como `OnClick` e `OnHover` de Button, mas não define o significado desses eventos no DockHub.

Fronteira:

```text
RickUIBuilder
→ cria/configura controle e conecta callback fornecido

Page / colaborador adequado do DockHub
→ define o significado do callback para a aplicação
```

Regra de negócio, decisão de navegação, operações REST/banco e estado da aplicação não passam a ser responsabilidades do RickUIBuilder.

## 17. Resumo de ownership e cleanup

As APIs analisadas seguem estes padrões:

```text
Factory
→ chamador fornece AOwner e AParent explicitamente

Fluent Build(AParent)
→ implementação usa AParent como Owner e Parent

TRickUIBuilder.On(AParent)
→ composer usa AParent como Owner e Parent dos controles criados

Button hover state
→ TComponent owned pelo mesmo Parent/Owner

Badge handle
→ interface referencia controles FMX já owned; não é owner desses controles
```

Qualquer integração do DockHub deve preservar essas premissas de lifetime e não deve liberar manualmente controles owned pelo parent, salvo mudança intencional de ownership.

## 18. Testes analisados

O repositório upstream contém testes DUnitX cobrindo:

- defaults dos records de configuração e spacing;
- criação da Factory, parent, geometria, hit testing e bordas;
- encadeamento/build de Label e propriedades configuradas;
- encadeamento/build de Button, click, hover, enabled, opacity e margin;
- encadeamento/build de Badge, handle, hierarquia parent, pill/corner radius, cores e tag;
- encadeamento/build de Divider, thickness/orientation e visibility;
- criação por Composer, ordem, parent comum, badge handle e click de Button;
- entradas da facade e isolamento de estado entre builders.

Esses testes foram inspecionados como evidência comportamental. Esta atualização de documentação do DockHub **não** afirma que a suíte upstream foi executada durante esta tarefa.

### Uso atual na Main do DockHub

A implementação atual da `Main` utiliza fluent builders individuais porque os controles precisam continuar acessíveis depois do `Build` para Language, Theme e estado visual. `TRickUIBuilder.On(AParent)` não é utilizado como mecanismo principal desta tela porque `AddText`, `AddDivider` e `AddButton` não devolvem as referências criadas.

Como Button ainda não possui handle público para o caption, `TPageCompositionBase.FindButtonCaption` concentra a localização do `TLabel` filho gerado para todas as compositions de Page. Esse conhecimento não é duplicado nas implementações específicas.

Os controles comuns de janela são construídos por `TPageCompositionBase` com `OnHover` e sem `HoverFillColor`. O handler da base consulta o `IDockHubTheme` corrente, evitando reutilizar cores de hover armazenadas quando o Theme é alterado em runtime.

## 19. Inconsistência conhecida na documentação upstream

Diversos comentários do código RickUIBuilder referenciam:

```text
docs/usage-guide.md
```

Esse arquivo não existe na árvore do repositório analisada.

Não tratá-lo como fonte disponível até que o repositório upstream efetivamente o contenha.

## 20. Regra de manutenção

Antes de implementar ou revisar UI runtime do DockHub que dependa do RickUIBuilder:

1. confirmar versão/revisão da dependência efetivamente utilizada;
2. consultar esta referência;
3. reinspecionar o código upstream quando a tarefa depender de comportamento não documentado aqui;
4. preferir facade/contratos públicos a acoplamento com implementação interna;
5. preservar as fronteiras de Theme e Language do DockHub;
6. escolher Factory, Fluent Builder ou `On(...)` pelas necessidades reais da Page;
7. não recriar localmente comportamento que o RickUIBuilder já fornece sem justificativa técnica;
8. atualizar este documento quando mudança da API upstream afetar a integração do DockHub.

## Documentação relacionada

- [DockHub View Pages](../../modules/view/README.pt-BR.md)
- [ADR-0004 — Arquitetura de Composição das Pages da View](../../adr/ADR-0004-view-page-composition-architecture.pt-BR.md)
- [Módulo de Theme](../../modules/theme/README.pt-BR.md)
- [Módulo de Idiomas](../../modules/language/README.pt-BR.md)
- [Documentação do DockHub](../../README.pt-BR.md)
- [Repositório upstream RickUIBuilder](https://github.com/ricksolucoes/RickUIBuilder)
