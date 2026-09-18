# DockHub View Pages

[English — Official](./README.md)

Este documento descreve a organização estrutural adotada para Pages do DockHub e a fronteira de responsabilidade da composição visual criada em runtime.

A decisão arquitetural correspondente está registrada em [ADR-0003 — Arquitetura de Pages e Composição Runtime da View](../../adr/ADR-0003-view-page-architecture.pt-BR.md).

## 1. Objetivo

A camada `View` deve poder crescer para múltiplas Pages sem transformar `src/view/Page/` em uma pasta plana com Forms, composições e auxiliares de diferentes telas misturados.

A organização adotada agrupa os artefatos exclusivos de cada Page em um boundary físico próprio e reserva uma responsabilidade específica para a composição visual criada em runtime.

Os objetivos são:

- manter alta coesão entre os artefatos de uma mesma Page;
- deixar explícita a responsabilidade de construção visual runtime;
- impedir que `TForm` concentre progressivamente toda a composição da tela;
- preservar `ApplyLanguage` e `ApplyTheme` como responsabilidades coordenadas pela View;
- manter eventos estruturais separados da semântica da ação;
- permitir crescimento sem antecipar abstrações genéricas ou componentes compartilhados inexistentes.

## 2. Estrutura adotada

Padrão físico para uma Page:

```text
src/view/Page/<Page>/
├── DockHub.View.Page.<Page>.pas
├── DockHub.View.Page.<Page>.fmx          # quando aplicável
└── Composition/
    └── DockHub.View.Page.<Page>.Composition.pas
```

Primeiro domínio estrutural adotado:

```text
src/view/Page/Main/
├── DockHub.View.Page.Main.pas
├── DockHub.View.Page.Main.fmx
└── Composition/
    └── DockHub.View.Page.Main.Composition.pas
```

A pasta `Main` representa o boundary físico da Page. O nome da unit principal continua:

```pascal
unit DockHub.View.Page.Main;
```

A subpasta `Composition` expressa uma responsabilidade adicional e, por isso, aparece também no namespace:

```pascal
unit DockHub.View.Page.Main.Composition;
```

## 3. Estado atual da Main

A estrutura `Page/Main/Composition` e a primeira unit de Composition foram criadas como base da organização da Main.

Neste estágio, **a existência da estrutura não significa que a Composition já esteja integrada funcionalmente à `TPageMain`**. A relação runtime entre as duas deve ser implementada somente quando a montagem dos controles for efetivamente adicionada.

Portanto, não assumir como existente até que o código confirme:

- método público ou privado de construção da Composition;
- interface específica de Composition;
- record de handles de controles;
- mecanismo de navegação;
- criação runtime efetiva de componentes pela nova unit;
- callbacks já conectados entre `TPageMain` e a Composition.

## 4. Responsabilidade da Page

A unit principal da Page representa a Form/View e coordena comportamento pertencente àquela tela.

Responsabilidades esperadas incluem, quando aplicáveis:

- ciclo de vida da Form;
- estado local da Page;
- referências a colaboradores como Language e Theme;
- `ApplyLanguage`;
- `ApplyTheme`;
- handlers das ações do usuário;
- coordenação de mudanças de estado da tela;
- integração com um futuro mecanismo de navegação, quando ele existir.

A Page não deve se transformar em um método único responsável por criar e configurar toda a árvore visual quando essa composição crescer a ponto de formar uma responsabilidade própria.

## 5. Responsabilidade de Composition

`DockHub.View.Page.<Page>.Composition` é a responsabilidade page-specific destinada à composição da árvore visual criada em runtime.

Ela pode concentrar, quando a implementação exigir:

- criação de controles FMX;
- uso de mecanismos de construção visual adotados pelo projeto;
- definição da hierarquia `Parent` dos componentes;
- configuração estrutural de posição, tamanho, alinhamento, anchors e propriedades equivalentes;
- composição de grupos visuais pertencentes exclusivamente à Page;
- associação de callbacks ou event handlers fornecidos pelo consumidor;
- retorno ou disponibilização de referências visuais quando a Page realmente precisar atualizá-las depois da construção.

A forma concreta dessa API ainda deve ser definida pelo código que implementar a integração. Este documento não prescreve antecipadamente interface, factory, record de handles ou objeto manager.

## 6. Eventos e ações

A Composition pode conectar um controle a um callback recebido, por exemplo um `OnClick`, porque essa ligação faz parte da construção do componente.

Entretanto, a semântica da ação não pertence à Composition.

Fronteira esperada:

```text
Composition
    ↓
cria o controle
    ↓
associa o callback recebido
    ↓
Page / colaborador responsável
    ↓
executa a ação da aplicação
```

Evitar dentro da Composition:

- regra de negócio;
- acesso direto a banco;
- chamadas REST que representem ação da aplicação;
- decisão de qual Page abrir;
- instanciação direta de outra Page apenas porque um botão foi clicado.

## 7. Language

`Core.Language` continua independente de FMX.

A View continua responsável pela aplicação dos textos traduzidos aos seus controles através de `ApplyLanguage` ou padrão equivalente.

Se controles criados pela Composition precisarem receber tradução ou ser atualizados após troca de idioma, a integração deve preservar esta direção:

```text
Language
    ↓
View
    ↓
ApplyLanguage
    ↓
controles da própria View
```

O mecanismo concreto para a Page acessar os controles criados em runtime deve ser definido somente quando a implementação exigir.

## 8. Theme

`View.Theme` fornece tokens semânticos e comportamentos visuais reutilizáveis, mas não conhece Forms específicas nem a estrutura interna de uma Page.

A View continua responsável por mapear os tokens para os próprios componentes através de `ApplyTheme` ou padrão equivalente.

Fronteira preservada:

```text
Theme
    ↓
View
    ↓
ApplyTheme
    ↓
controles da própria View
```

A introdução de Composition não transfere para Theme a responsabilidade de localizar ou manipular os controles da Page.

## 9. Navegação entre Pages

A responsabilidade concreta de navegação entre Pages **ainda não está definida pelo código atual desta decisão**.

A Composition não deve assumir essa responsabilidade por conveniência.

Quando a aplicação possuir múltiplas Pages e surgir necessidade real de navegação, o mecanismo deverá ser avaliado separadamente considerando:

- ownership e lifetime das Forms/Views;
- estado compartilhado;
- dependências entre Pages;
- direção de dependências;
- necessidade ou não de contratos;
- Theme e Language compartilhados;
- possibilidade de múltiplas Views abertas simultaneamente.

Até essa decisão existir, não criar silenciosamente `Navigator`, `Router`, `PageManager`, singleton, Service Locator ou outro mecanismo global.

## 10. Crescimento de uma Page

Uma única Composition não precisa permanecer monolítica se a Page adquirir áreas visuais grandes e independentes.

A subdivisão é permitida quando existir responsabilidade real, por exemplo após a implementação demonstrar que uma região visual possui ciclo de manutenção próprio.

Não criar antecipadamente units como:

```text
Header
Sidebar
Content
Footer
Components
Actions
```

apenas por possibilidade futura.

A regra é:

```text
responsabilidade real
    ↓
separação coesa

possibilidade futura
    ↓
não criar ainda
```

## 11. Componentes compartilhados

Um artefato dentro de:

```text
Page/<Page>/
```

é considerado específico daquela Page por padrão.

Se a mesma responsabilidade visual passar a ser reutilizada de forma real por múltiplas Pages, deve-se avaliar uma extração para uma responsabilidade compartilhada da camada `View`.

O nome e o path dessa futura responsabilidade não são definidos antecipadamente por este documento.

## 12. Relação com RickUIBuilder

Quando a montagem runtime da Page utilizar RickUIBuilder, as chamadas destinadas a criar e compor os controles específicos da Page pertencem à responsabilidade de Composition.

Isso não transfere para RickUIBuilder nem para Composition a semântica das ações da aplicação. RickUIBuilder permanece o mecanismo de construção visual; a Page ou seu colaborador apropriado continua responsável pelo significado dos eventos.

A integração efetiva deve ser documentada a partir do código final quando for implementada.

## 13. Convenção para novas Pages

Quando uma nova Page real for criada e possuir composição runtime própria, utilizar o padrão:

```text
src/view/Page/<Page>/
├── DockHub.View.Page.<Page>.pas
├── DockHub.View.Page.<Page>.fmx
└── Composition/
    └── DockHub.View.Page.<Page>.Composition.pas
```

Não criar diretórios de Pages hipotéticas antes de existir a própria Page.

## 14. Quality Gate estrutural

Ao criar ou evoluir uma Page, verificar:

```text
[ ] artefatos específicos da Page permanecem agrupados
[ ] namespace expressa produto/layer/domínio/responsabilidade
[ ] Page mantém ciclo de vida e coordenação da apresentação
[ ] Composition mantém responsabilidade de construção visual
[ ] Composition não contém regra de negócio
[ ] eventos estruturais não absorveram a semântica da aplicação
[ ] Theme não passou a depender da Page concreta
[ ] Language continua independente de FMX
[ ] navegação não foi inventada sem decisão própria
[ ] subdivisões foram criadas apenas por responsabilidade real
[ ] nenhuma dependência circular foi introduzida
```

## 15. Documentação relacionada

- [ADR-0003 — Arquitetura de Pages e Composição Runtime da View](../../adr/ADR-0003-view-page-architecture.pt-BR.md)
- [Módulo de Theme](../theme/README.pt-BR.md)
- [Módulo de Idiomas](../language/README.pt-BR.md)
- [Documentação do DockHub](../../README.pt-BR.md)
