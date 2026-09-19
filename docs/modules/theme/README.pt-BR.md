# DockHub View Theme

[English — Official](./README.md)

Este documento descreve o subsistema de Theme atualmente existente no DockHub. Ele cobre contrato público, implementação, modelo semântico de cores, troca em runtime, comportamento do gradiente, integração com a Main View, testes automatizados, regras de manutenção e evoluções explicitamente adiadas.

Os valores completos das paletas ficam separados em [Referência de Identidade Visual](./VISUAL-IDENTITY.pt-BR.md).

As decisões arquiteturais e as questões deliberadamente adiadas de propagação em runtime/estado compartilhado são registradas em [ADR-0002 — Arquitetura de Theme](../../adr/ADR-0002-theme-architecture.pt-BR.md).

## 1. Objetivo

`View.Theme` centraliza os papéis visuais de cor utilizados pelo código de apresentação do DockHub. Suas responsabilidades atuais são:

- expor o tema corrente através de um contrato orientado a interface;
- suportar as paletas `Blue`, `Teal`, `Light` e `Dark`;
- expor tokens semânticos de cor para superfícies, textos, accents, botões, status e badges;
- configurar um gradiente de fundo FireMonkey a partir da paleta corrente;
- trocar a paleta ativa em runtime na mesma instância de Theme;
- manter os valores visuais fora das Views individuais quando representam um papel já existente no Theme.

O subsistema não fornece atualmente persistência, seletor visual de tema, propagação global na aplicação ou mecanismo Observer/evento.

## 2. Regra arquitetural

O código de apresentação deve solicitar cores pelo papel semântico através de `IDockHubTheme` quando esse papel já fizer parte do contrato de Theme.

Preferível:

```pascal
LControl.Fill.Color := FTheme.Accent;
```

Evitar duplicar na View o valor atual da paleta:

```pascal
LControl.Fill.Color := TAlphaColor($FF3B82F6);
```

Essa regra se aplica aos valores representados pelo subsistema de Theme. Ela não representa uma proibição genérica de todo literal `TAlphaColor` no código.

A separação atual é:

```text
Types
  ↓
Contracts
  ↓
Implementation
  ↓
Views consumidoras
```

As Views decidem qual token semântico pertence a cada componente. `TDockHubTheme` decide qual cor esse token representa no tema ativo.

## 3. Estrutura atual

```text
src/view/Theme/
├── DockHub.View.Theme.Types.pas
├── Contracts/
│   └── DockHub.View.Theme.Contracts.pas
└── Impl/
    └── DockHub.View.Theme.Impl.pas
```

### Mapa de responsabilidades

| Unit | Responsabilidade |
| --- | --- |
| `DockHub.View.Theme.Types` | Declara `TDockHubThemeType`. |
| `DockHub.View.Theme.Contracts` | Declara o contrato público `IDockHubTheme`. |
| `DockHub.View.Theme.Impl` | Mantém a paleta corrente, aplica os quatro temas, retorna tokens semânticos, configura gradientes e implementa helpers de badge. |
| `DockHub.View.Page.Main` | Consumidor atual que mantém uma referência `IDockHubTheme` e aplica o gradiente de fundo. |

## 4. Tipo público

### `TDockHubThemeType`

Declarado com scoped enums habilitados:

```pascal
{$SCOPEDENUMS ON}

type
  TDockHubThemeType = (Dark, Light, Blue, Teal);
```

O uso exige o escopo do enum, por exemplo:

```pascal
TDockHubThemeType.Blue
TDockHubThemeType.Teal
TDockHubThemeType.Light
TDockHubThemeType.Dark
```

A ordem de declaração **não** determina o tema default. `TDockHubTheme.Create` chama explicitamente `ApplyBlue`, portanto uma nova instância inicia em `Blue`.

## 5. Contrato público

`DockHub.View.Theme.Contracts` define:

```pascal
IDockHubTheme = interface(IInterface)
  ['{FABB29CC-76DA-4B97-8443-6341356B740E}']
```

O GUID faz parte da identidade pública atual da interface e deve ser preservado, exceto se uma alteração intencional de quebra de contrato for aprovada.

O contrato contém 36 tokens públicos de cor, além da seleção de tema, configuração de gradiente e helpers de badge.

### Seleção do tema

```pascal
function Theme: TDockHubThemeType; overload;
function Theme(const AValue: TDockHubThemeType): IDockHubTheme; overload;
```

O getter retorna o enum ativo. O overload de alteração aplica a paleta solicitada e retorna a mesma interface para uso fluente.

### Tokens de superfície

`Background`, `SurfaceCard`, `SurfaceElevated`, `Border`, `Divider`.

### Tokens de texto

`TextPrimary`, `TextSecondary`, `TextDisabled`.

### Tokens de accent e informação

`Accent`, `AccentHover`, `AccentLight`, `BadgeInfoBg`, `BadgeInfoText`.

### Tokens de botões

Primário: `ButtonPrimaryBg`, `ButtonPrimaryHoverBg`, `ButtonPrimaryText`.

Danger/ghost: `ButtonDangerBg`, `ButtonDangerHoverBg`, `ButtonDangerText`, `ButtonDangerOutlineText`, `ButtonGhostText`.

### Tokens de gradiente

`GradientStart`, `GradientEnd`.

### Tokens de status

`StatusSuccess`, `StatusDanger`, `StatusWarning`, `StatusNeutral`.

### Tokens dos badges de status

`BadgeSuccessBg`, `BadgeSuccessText`, `BadgeDangerBg`, `BadgeDangerText`, `BadgeWarningBg`, `BadgeWarningText`, `BadgeNeutralBg`, `BadgeNeutralText`.

### Token utilitário

`Transparent` retorna sempre `$00000000` na implementação atual.

Para os valores completos Delphi e CSS/Web de todos os tokens em todos os temas, consulte [Referência de Identidade Visual](./VISUAL-IDENTITY.pt-BR.md).

## 6. Implementação e lifetime

A implementação concreta é:

```pascal
TDockHubTheme = class sealed(TInterfacedObject, IDockHubTheme)
```

A criação normal utiliza:

```pascal
FTheme := TDockHubTheme.New;
```

`New` retorna `IDockHubTheme`, enquanto o constructor é `protected`:

```pascal
class function TDockHubTheme.New: IDockHubTheme;
begin
  Result := TDockHubTheme.Create;
end;
```

Como o objeto deriva de `TInterfacedObject`, o lifetime normal é gerenciado por reference counting da interface. Os consumidores devem manter a referência da interface, em vez de liberar manualmente o objeto concreto.

O constructor chama `ApplyBlue`, estabelecendo o tema inicial e todos os tokens antes de retornar a instância.

## 7. Modelo de temas

A mesma instância de `TDockHubTheme` mantém a paleta corrente em fields como `FBackground`, `FTextPrimary`, `FAccent` e `FStatusSuccess`.

A troca de tema executa uma aplicação completa de paleta:

```text
Theme(Blue)  → ApplyBlue
Theme(Teal)  → ApplyTeal
Theme(Light) → ApplyLight
Theme(Dark)  → ApplyDark
```

Cada método `Apply...` define `FTheme` e delega para métodos agrupados de superfícies, texto, accent, botões, gradiente, status e badges.

A API atual não cria um novo objeto Theme ao trocar de paleta.

## 8. Grupos semânticos de cor

Os grupos representam finalidade de uso, e não nomes crus de tonalidade:

| Grupo | Finalidade |
| --- | --- |
| Superfícies | Fundo da Form, cards, áreas elevadas e separadores. |
| Texto | Conteúdo textual primário, secundário e desabilitado. |
| Accent | Família principal de interação/destaque e cores de badge informativo. |
| Botões | Papéis de ação primária, ação destrutiva e texto ghost. |
| Gradiente | Cores inicial/final consumidas por `BackgroundGradient`. |
| Status | Estados success, danger, warning e neutral. |
| Badges | Pares de fundo/texto para cada status. |
| Utilitário | Cor transparente. |

Os valores atuais completos pertencem à [Referência de Identidade Visual](./VISUAL-IDENTITY.pt-BR.md), sem duplicação neste documento arquitetural.

## 9. Troca de tema em runtime

Um consumidor altera a paleta ativa através do contrato:

```pascal
FTheme.Theme(TDockHubThemeType.Dark);
```

`Theme(AValue)` seleciona a rotina `Apply...` correspondente e retorna `Self` como `IDockHubTheme`.

A implementação não interrompe uma solicitação para o mesmo tema. O método atual `TPageMain.ChangeTheme` realiza essa verificação antes de chamar o contrato.

Alterar apenas o estado de `IDockHubTheme` não redesenha automaticamente todas as Views. Cada consumidor deve atualmente chamar seu próprio mapeamento de apresentação, como `ApplyTheme`.

## 10. Gradiente de fundo

O contrato expõe dois overloads:

```pascal
function BackgroundGradient(AFill: TBrush;
  const AAngle: Single): IDockHubTheme; overload;

function BackgroundGradient(AFill: TBrush): IDockHubTheme; overload;
```

O overload sem ângulo delega para o overload explícito utilizando `65` graus.

Quando `AFill` está atribuído, a implementação:

1. define `AFill.Kind` como `TBrushKind.Gradient`;
2. define `AFill.Gradient.Style` como `TGradientStyle.Linear`;
3. limpa os pontos existentes;
4. adiciona exatamente dois pontos;
5. utiliza `GradientStart` no offset `0`;
6. utiliza `GradientEnd` no offset `1`;
7. calcula posições normalizadas de início/fim a partir do ângulo informado.

Se `AFill` for `nil`, o método retorna a interface corrente sem gerar exception nem desreferenciar o brush.

O método modifica o `TBrush` recebido; não cria nem se torna proprietário desse brush.

## 11. Helpers de Badge

Os helpers Boolean atuais cobrem intencionalmente apenas a seleção success/danger:

```text
BadgeBackground(True)  → BadgeSuccessBg
BadgeBackground(False) → BadgeDangerBg
BadgeText(True)        → BadgeSuccessText
BadgeText(False)       → BadgeDangerText
```

`Warning` e `Neutral` possuem tokens públicos, mas esses dois helpers não os selecionam.

## 12. Integração com a Main View

`TPageMain` atualmente mantém os contratos de Theme e Language e a referência da composition específica:

```pascal
FLanguage: IDockHubLanguage;
FTheme: IDockHubTheme;
FComposition: IPageCompositionMain;
```

O constructor cria Theme/Language, configura e constrói a Composition e depois aplica as duas responsabilidades de apresentação. `TPageMain.ApplyTheme` delega o Theme ativo para a Composition:

```pascal
procedure TPageMain.ApplyTheme;
begin
  FComposition.ApplyTheme(FTheme);
end;
```

`TPageMainComposition.DoApplyTheme` mapeia tokens semânticos para background da Form, card, textos, badges e ações. `TPageCompositionBase` aplica o mesmo Theme aos controles comuns de janela e mantém o Theme aplicado mais recentemente para que o hover acompanhe trocas runtime.

A troca runtime continua explícita através de `TPageMain.ChangeTheme`: a instância de Theme muda de estado e a árvore visual existente é atualizada por `ApplyTheme`; os controles não são reconstruídos.

`ApplyTheme` só é aceito depois que a Composition conclui `Build` com sucesso. Essa regra de lifecycle pertence a `TPageCompositionBase`, e não ao subsistema Theme.

Nenhum seletor visual de Theme chama atualmente `ChangeTheme`. O método existe, mas um controle de seleção para o usuário não é documentado como implementado.

## 13. Aplicação do Theme nos controles da View

A Composition específica da Page mapeia cada componente para o token semântico existente que representa sua responsabilidade visual. Exemplos atuais da Main:

```text
fundo da Form          → BackgroundGradient / Background
superfície de card     → SurfaceCard
texto primário         → TextPrimary
texto secundário       → TextSecondary
ação primária          → ButtonPrimary*
ação destrutiva        → ButtonDanger*
apresentação de status → Status* / Badge*
```

Esta documentação não prescreve uma hierarquia de componentes que ainda não existe no fonte.

## 14. Alteração ou extensão de uma paleta

Para uma alteração intencional de cor:

1. atualizar o grupo `Apply...` correspondente em `DockHub.View.Theme.Impl`;
2. atualizar a paleta esperada em `DockHub.Tests.View.Theme`;
3. executar toda a suíte DUnitX;
4. atualizar [Referência de Identidade Visual](./VISUAL-IDENTITY.pt-BR.md) e a versão oficial em inglês;
5. atualizar este documento somente quando contrato ou comportamento mudar, não a cada alteração de valor de cor.

Para um novo `TDockHubThemeType`, a implementação atual exige no mínimo:

- adicionar o membro do enum;
- adicionar rotinas completas de aplicação da paleta;
- adicionar um branch em `Theme(AValue)`;
- adicionar uma paleta esperada completa e cobertura de transição nos testes;
- adicionar a paleta ao documento de Identidade Visual.

Nenhum novo tema deve ser documentado como suportado antes da implementação existir.

## 15. Testes automatizados

O projeto DUnitX atual contém `TDockHubThemeTests` com 17 testes de Theme. O último resultado XML fornecido, datado de 2026-09-13, registra o projeto completo com 34 testes, 0 falhas, 0 erros e todos os casos executados com sucesso.

A cobertura atual do Theme inclui:

- tema default Blue;
- paleta Blue esperada completa;
- transições Blue → Teal, Light e Dark;
- retorno para Blue;
- transições sequenciais validando toda a paleta após cada troca;
- configuração do brush de gradiente;
- alteração das cores do gradiente conforme o tema ativo;
- equivalência do ângulo default de 65°;
- posicionamento para 0° e 90°;
- comportamento com brush `nil`;
- helpers Boolean de fundo/texto dos badges.

Os testes de Theme utilizam a implementação real `TDockHubTheme` através de uma referência `IDockHubTheme`. Os valores esperados das paletas ficam centralizados em records/functions exclusivos dos testes, em vez de serem repetidos em cada assert.

O fonte atual possui uma fixture FMX de integração de `TPageMainComposition`, além da fixture de Theme. O último XML de execução fornecido é anterior a essa fixture de Page Composition; portanto, a evidência histórica de execução comprova apenas os testes presentes naquela execução antiga e não valida o fonte atual de integração da Main.

Consulte [Testes Automatizados](../../testing/README.pt-BR.md) para o inventário completo e a referência da última execução.

## 16. Evoluções futuras

Os itens abaixo propositalmente **não** fazem parte da implementação atual. Devem ser avaliados somente quando a aplicação atingir a necessidade correspondente.

### 16.1 Observer/notificação de troca de tema

O comportamento atual é explícito:

```text
ChangeTheme
→ Theme(...)
→ ApplyTheme
```

Isso é suficiente enquanto a interface possui um único consumidor relevante.

Quando múltiplas Forms ou componentes visuais independentes precisarem reagir à mesma troca de tema em runtime, um mecanismo de notificação baseado em Observer/eventos deverá ser avaliado. Essa é uma direção arquitetural para avaliação, e não uma implementação futura obrigatória:

```text
Theme alterado
├── Main Form    → ApplyTheme
├── Settings     → ApplyTheme
└── Outra View   → ApplyTheme
```

Cada View deve continuar responsável pelo seu mapeamento entre tokens semânticos e controles. O mecanismo futuro de notificação altera quem dispara `ApplyTheme`, não transfere o mapeamento de apresentação para a implementação de Theme.

Nenhuma interface Observer, método de registro ou API de notificação existe atualmente e nenhuma é definida por este documento.

### 16.2 Contexto compartilhado de Theme na aplicação

Hoje `TPageMain` cria sua própria instância de `TDockHubTheme`. Se futuras janelas criarem instâncias independentes, cada objeto manterá seu próprio `FTheme` e seu próprio estado de paleta.

Antes de introduzir notificações via Observer, deve-se avaliar como a aplicação estabelecerá um único estado corrente autoritativo de Theme. Observer sozinho não faz instâncias criadas separadamente compartilharem estado.

Este documento propositalmente não escolhe antecipadamente singleton, container de DI, service locator, composition root ou outro mecanismo.

### 16.3 Persistência da preferência de Theme

Um futuro subsistema de configuração poderá persistir o `TDockHubThemeType` selecionado. Nenhum mecanismo de persistência existe no subsistema atual de Theme.

### 16.4 Seletor visual de Theme

Nenhum seletor visual existe atualmente. Quando for implementado, deve utilizar o contrato de Theme e disparar o fluxo normal de aplicação da View, em vez de escrever cores diretamente nos componentes.

## 17. Checklist de manutenção

Antes de fazer merge de uma alteração de Theme, verificar:

- [ ] `IDockHubTheme` permanece consistente com `TDockHubTheme`.
- [ ] O GUID da interface não foi alterado, salvo quebra de contrato intencional e aprovada.
- [ ] Todos os temas suportados atribuem todos os fields semânticos da paleta.
- [ ] Uma transição de tema não mantém valores residuais da paleta anterior.
- [ ] Novos estilos de View utilizam tokens semânticos quando existe um token correspondente.
- [ ] O comportamento do gradiente permanece compatível com o contrato documentado.
- [ ] Os testes DUnitX de Theme são atualizados quando paleta ou comportamento mudar.
- [ ] Toda a suíte DUnitX é executada após alteração do Theme.
- [ ] A Identidade Visual EN/PT-BR é atualizada quando algum valor de paleta mudar.
- [ ] Observer/contexto compartilhado não são documentados como implementados antes de existir código.

## 18. Estado de validação

Esta documentação foi derivada do fonte atual de Theme, da integração atual de `TPageMain` fornecida para o projeto, do fixture de testes de Theme e do último resultado XML DUnitX fornecido.

Última execução automatizada fornecida (2026-09-13):

```text
Total de testes : 34
Falhas           : 0
Erros            : 0
Ignorados        : 0
```

O resultado XML não contém um campo de contagem de leaks; portanto este documento não deduz um resultado de leak a partir desse artefato.

Dentro daquela execução histórica de 34 testes, `TDockHubThemeTests` contém 17 testes de Theme executados com sucesso. O fonte atual também possui fixtures de contrato/integração de Page Composition, mas elas não aparecem naquele XML histórico.
