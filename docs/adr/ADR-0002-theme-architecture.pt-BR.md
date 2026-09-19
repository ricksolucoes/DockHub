# ADR-0002 — Arquitetura de Theme do DockHub

[English — Official](./ADR-0002-theme-architecture.md)

- **Status:** Aceito
- **Escopo:** `DockHub.View.Theme`
- **Tipo de decisão:** Arquitetura interna / infraestrutura de tema da UI

## Contexto

O DockHub precisa centralizar os papéis visuais, em vez de representar a identidade visual por valores de cor repetidos entre as Views. A aplicação deve suportar múltiplas paletas e troca de Theme em runtime, mantendo o mapeamento da apresentação dentro da camada de View.

O subsistema Theme atual já expõe papéis visuais semânticos através de `IDockHubTheme`, suporta as paletas `Blue`, `Teal`, `Light` e `Dark`, altera a paleta ativa na mesma instância de Theme e fornece construção reutilizável do gradiente de fundo. `TPageMain` mantém seu estado `IDockHubTheme` e delega o mapeamento de apresentação por `IPageCompositionMain.ApplyTheme`; a Composition específica aplica os valores à Form e aos controles runtime.

Isso é suficiente para o estágio atual da aplicação, mas ainda não estabelece um estado de Theme compartilhado por toda a aplicação nem propagação automática para múltiplas Views independentes. Essas responsabilidades são deliberadamente adiadas até que existam consumidores que realmente necessitem delas.

## Decisão

As decisões abaixo ficam aceitas para a implementação atual.

### 1. Estrutura do módulo

Theme permanece separado em:

```text
DockHub.View.Theme.Types
DockHub.View.Theme.Contracts
DockHub.View.Theme.Impl
```

`Types` concentra tipos públicos relacionados ao Theme, `Contracts` concentra `IDockHubTheme` e `Impl` concentra o estado concreto do Theme e a implementação das paletas.

### 2. Consumo orientado a interface

Consumidores armazenam e utilizam `IDockHubTheme`, em vez de dependerem de `TDockHubTheme` como tipo público de colaboração.

A implementação atual é `TDockHubTheme = class sealed(TInterfacedObject, IDockHubTheme)` e normalmente é criada através de `TDockHubTheme.New`.

O GUID da interface é:

```text
{FABB29CC-76DA-4B97-8443-6341356B740E}
```

O GUID faz parte da identidade pública atual da interface e deve permanecer estável enquanto o contrato continuar compatível.

### 3. Theme default

Uma nova instância de `TDockHubTheme` inicia com `Blue` como Theme ativo porque a construção aplica explicitamente a paleta Blue.

A ordem de declaração de `TDockHubThemeType` não define o Theme default.

### 4. Tokens visuais semânticos

As Views consomem papéis semânticos, como fundo, texto, accent, botões e status, em vez de duplicarem o valor concreto da cor da paleta ativa.

A fronteira de responsabilidade é:

```text
View
→ escolhe o papel visual semântico do componente

Theme
→ resolve esse papel para o valor da paleta ativa
```

O inventário completo de tokens e os valores concretos das paletas permanecem fora deste ADR, na documentação do módulo Theme e na referência de Identidade Visual.

### 5. Identidade Visual permanece uma especificação separada

Os valores concretos das paletas não pertencem a este ADR.

A especificação visual reutilizável é mantida em:

```text
docs/modules/theme/VISUAL-IDENTITY.pt-BR.md
```

Este ADR registra por que existem papéis semânticos e paletas; o documento de Identidade Visual registra os valores efetivos das cores.

### 6. Troca de Theme em runtime altera a instância corrente

Alterar o Theme através de `IDockHubTheme.Theme(...)` atualiza a paleta ativa no objeto existente. Uma troca de Theme não exige que o consumidor substitua sua referência `IDockHubTheme`.

Esse comportamento com estado é relevante para uma futura propagação em toda a aplicação, pois o Theme ativo é um estado que poderá exigir um único proprietário autoritativo.

### 7. Aplicação da apresentação permanece responsabilidade de cada View

Cada View continua responsável por aplicar os valores semânticos do Theme aos seus próprios controles através de um método no padrão `ApplyTheme`.

O subsistema Theme não deve assumir a responsabilidade de localizar ou manipular diretamente controles pertencentes a Forms ou Views específicas.

A fronteira pretendida é:

```text
estado do Theme muda
       ↓
View é informada
       ↓
View executa ApplyTheme
       ↓
View atualiza seus próprios controles
```

Essa fronteira continua válida caso uma notificação automática seja introduzida futuramente.

### 8. Theme não depende de Views específicas

`DockHub.View.Theme` deve permanecer independente de Forms concretas, como `TPageMain`, e da hierarquia de controles de uma tela específica.

Theme fornece valores visuais reutilizáveis e construção visual específica do Theme. O consumidor decide onde esses valores serão aplicados.

### 9. Construção reutilizável do gradiente permanece no Theme

O subsistema Theme é responsável pela construção reutilizável de seu gradiente de fundo. A View é responsável por decidir qual `TBrush` receberá esse gradiente.

Isso evita que cada View duplique a construção específica do gradiente sem retirar da View a responsabilidade pelo mapeamento da apresentação.

### 10. Propagação automática em runtime é deliberadamente adiada

O fluxo explícito atual é suficiente para a UI existente:

```text
ChangeTheme
→ Theme(...)
→ ApplyTheme
```

A propagação automática não está implementada atualmente.

Quando múltiplas Views ou componentes visuais independentes precisarem reagir à mesma mudança de Theme em runtime, um mecanismo futuro de notificação baseado em Observer/eventos **deverá ser avaliado**. Observer representa, portanto, uma direção arquitetural atual para avaliação, e não uma implementação futura obrigatória.

Qualquer mecanismo futuro de notificação deverá disparar o fluxo de aplicação já pertencente às Views, em vez de transferir o mapeamento da apresentação para o serviço de Theme:

```text
Theme muda
      ↓
mecanismo de notificação
      ↓
┌──────────┬──────────┬──────────┐
↓          ↓          ↓
View A     View B     View C
↓          ↓          ↓
ApplyTheme ApplyTheme ApplyTheme
```

Nenhuma interface Observer, API de registro, método de notificação ou Theme manager é definido por este ADR.

### 11. Estado compartilhado de Theme é uma decisão adiada separada

Notificação, por si só, não estabelece estado compartilhado.

Se futuras Views criarem instâncias independentes de `TDockHubTheme`, cada objeto possuirá sua própria paleta corrente. Antes ou juntamente com a introdução da propagação automática, a aplicação deverá avaliar como um único estado autoritativo de Theme será compartilhado entre os consumidores.

Este ADR propositalmente não escolhe singleton, container de dependency injection, service locator, composition root, application context, Theme manager ou outro mecanismo de propriedade antes que exista uma necessidade concreta.

### 12. Persistência da preferência de Theme é adiada

Persistir o `TDockHubThemeType` selecionado pelo usuário entre execuções da aplicação não faz parte do subsistema Theme atual.

Quando a persistência se tornar necessária, o mecanismo de armazenamento deverá ser decidido a partir dos requisitos de configuração da aplicação, e não predeterminado por este ADR.

### 13. Seleção visual de Theme é adiada

A Main View atual pode alterar Theme programaticamente, mas nenhum seletor de Theme destinado ao usuário faz parte da implementação documentada neste momento.

Quando um seletor visual for introduzido, ele deverá acionar o fluxo normal de troca de Theme e permitir que a View reaplique sua apresentação. O seletor não deve gravar diretamente as cores da paleta nos controles.

## Consequências

### Positivas

- a identidade visual fica centralizada através de papéis semânticos;
- as Views permanecem desacopladas dos valores concretos das paletas;
- múltiplas paletas podem ser selecionadas sem alterar a semântica dos consumidores;
- construção visual reutilizável específica do Theme permanece centralizada;
- as Views preservam a responsabilidade pelo mapeamento dos próprios controles e pela apresentação;
- o desenho atual pode evoluir para múltiplas Views sincronizadas sem descartar `ApplyTheme`;
- notificação automática e estado compartilhado podem ser introduzidos somente quando a aplicação demonstrar a necessidade.

### Trade-offs

- o estado de Theme é atualmente local a cada instância;
- `TPageMain` atualmente possui sua própria instância de Theme, em vez de consumir um contexto de Theme compartilhado pela aplicação;
- alterações de Theme não são propagadas automaticamente para Views independentes;
- cada View é responsável por reaplicar os valores do Theme aos próprios controles;
- uma futura implementação com múltiplas Views exigirá uma decisão explícita de propriedade do estado, além de qualquer mecanismo de notificação.

## Alternativas rejeitadas/adiadas

### Valores de paleta embutidos diretamente nas Views

Rejeitada quando existir um token semântico de Theme correspondente ao papel visual. Duplicar valores da paleta nos consumidores enfraqueceria a abstração de Theme e dificultaria alterações controladas de identidade visual.

### Theme manipulando diretamente controles das Views

Rejeitada. Theme não deve depender de Forms concretas nem assumir o mapeamento de apresentação pertencente a cada View.

### Views reconstruindo a lógica de gradiente do Theme

Rejeitada para o comportamento de gradiente já fornecido por `IDockHubTheme`. A construção reutilizável específica do Theme permanece centralizada enquanto a View decide onde ela será aplicada.

### Propagação Observer/evento desde a primeira implementação

Adiada. A UI atual ainda não exige um mecanismo de notificação para toda a aplicação. Quando múltiplos consumidores independentes precisarem de sincronização em runtime, uma abordagem baseada em Observer/eventos deverá ser avaliada em vez de ser presumida antecipadamente.

### Estado global/compartilhado desde a primeira implementação

Adiado. Um modelo de lifetime/propriedade compartilhado deve ser selecionado somente quando múltiplos consumidores exigirem um único Theme corrente autoritativo.

### Persistência da preferência desde a primeira implementação

Adiada. O subsistema Theme atual não possui requisito de persistência e, portanto, não prescreve mecanismo de armazenamento.

## Gatilhos para reavaliação futura

Este ADR deve ser reavaliado quando uma ou mais das situações abaixo ocorrerem:

- uma segunda View independente precisar compartilhar o mesmo Theme corrente;
- múltiplas Views ou componentes precisarem reagir automaticamente a uma mudança de Theme em runtime;
- a preferência de Theme precisar persistir entre execuções;
- um seletor de Theme destinado ao usuário for introduzido;
- o lifetime do Theme deixar de pertencer diretamente às Views individuais;
- componentes independentes da aplicação precisarem de um único estado de Theme autoritativo;
- o estado de Theme passar a ser acessado ou alterado fora do fluxo normal da UI;
- `IDockHubTheme` exigir uma mudança arquitetural relevante.

## Validação

O baseline automatizado atual contém 34 testes DUnitX executados, com 0 falhas e 0 erros. `TDockHubThemeTests` contribui com 17 testes aprovados que exercitam o contrato e o comportamento da implementação de Theme.

O fonte atual possui uma fixture FMX de integração de `TPageMainComposition` e uma fixture separada de contrato de `TPageCompositionBase`. O baseline XML de 34 testes é anterior a essas fixtures; portanto, essa execução histórica valida apenas a suíte antiga e não comprova que os testes atuais de integração da Main passam.

O inventário detalhado e as informações de execução permanecem em [Testes Automatizados](../../tests/README.pt-BR.md).

## Documentação relacionada

- [Módulo de Theme](../modules/theme/README.pt-BR.md)
- [Identidade Visual](../modules/theme/VISUAL-IDENTITY.pt-BR.md)
- [Testes Automatizados](../../tests/README.pt-BR.md)
- [ADR-0001 — Arquitetura de Idiomas](./ADR-0001-language-architecture.pt-BR.md)
