# Plan — View.Page Creation Workflow

## Status

```text
IMPLEMENTED
```

Este documento registra a infraestrutura criada para tornar a criação de futuras Pages repetível sem transformar templates em autoridade arquitetural.

---

## 1. Objetivo

Padronizar a criação de novas Views que sigam a arquitetura atual de `View.Page`:

```text
Types / Contracts / Impl
TPageCompositionBase
Page-specific Composition
Theme / Language delegation
RickUIBuilder
```

preservando inspeção obrigatória do estado real antes de qualquer decisão estrutural.

---

## 2. Por que foram necessários três recursos

```text
Agent
→ autoridade específica de View.Page

Skill
→ procedimento recorrente

Template
→ estrutura repetível
```

Nenhum desses elementos substitui o código atual como fonte da verdade.

---

## 3. Agent criado

```text
.ai/agents/dockhub-view-page.md
```

Responsável por:

```text
estrutura View.Page
lifecycle da Composition
lifetime por interface
contratos específicos por Page
Theme / Language delegation
RickUIBuilder integration
```

---

## 4. Skill criada

```text
.ai/skills/domains/view-page/create-view-page/SKILL.md
```

Workflow resumido:

```text
inspect-current-state
↓
confirm View.Page architecture
↓
confirm responsibility
↓
evaluate Types
↓
evaluate contract
↓
evaluate Language / Theme / RickUIBuilder
↓
apply templates
↓
register Delphi project when needed
↓
tests
↓
Method Toxicity
↓
documentation
```

---

## 5. Templates criados

```text
.ai/templates/delphi/view-page/
├── PAGE.template.pas
├── PAGE.template.fmx
├── COMPOSITION.template.pas
└── README.md
```

Não foram criados templates de:

```text
Types
Contracts
Tests
```

porque esses artefatos não são obrigatórios por Page e sua criação automática produziria cerimônia ou acoplamento inadequado.

---

## 6. Contratos específicos

Uma interface `IPageComposition<Page>` não é criada automaticamente.

Ela é justificada apenas quando houver ações/contrato específico real ou já conhecido da Page.

`IPageCompositionMain` permanece exemplo atual desse caso.

---

## 7. Types

Tipos estruturais/compartilhados do domínio devem primeiro ser avaliados em:

```text
DockHub.View.Page.Types
```

Não se cria `DockHub.View.Page.<Page>.Types` apenas porque uma Page introduziu um enum.

---

## 8. Method Toxicity

A criação de Page passa obrigatoriamente por `review-method-toxicity`.

A mesma regra vale para testes Delphi alterados/criados.

Quando RAD Studio/CSV estiver disponível, a autoridade é a métrica real da ferramenta.

Sem ferramenta, a saída deve ser avaliação estática e `Toxicity: Não confirmado`.

---

## 9. Stop Conditions

```text
estrutura atual não confirmada
responsabilidade ambígua
contrato específico sem justificativa
novo tipo sem domínio claro
mudança de lifetime não autorizada
mudança arquitetural transversal não autorizada
Theme/Language/RickUIBuilder insuficiente sem decisão aprovada
```

---

## 10. Quality Gate

```text
[ ] Agent registrado
[ ] Skill registrada
[ ] Template registrado
[ ] grafo de Skills continua acíclico
[ ] template não define arquitetura
[ ] contrato específico não é automático
[ ] Types não são criados automaticamente
[ ] testes são avaliados
[ ] testes também seguem Method Toxicity
[ ] documentação é atualizada após implementação final
```

---

## 11. Recursos propositalmente não criados

```text
Agent separado apenas para scaffolding
Skill de Method Toxicity exclusiva para testes
Types.template.pas
Contracts.template.pas
Test.template.pas
novo ADR apenas para tooling de IA
```

A infraestrutura existente já cobre essas responsabilidades ou ainda não existe repetição suficiente para justificar novo artefato.

---

## 12. Crescimento futuro

Novos recursos de IA só devem ser adicionados quando um fluxo real demonstrar repetição ou risco de inconsistência.

A existência futura de outras Pages não autoriza antecipar abstrações além das já confirmadas.
