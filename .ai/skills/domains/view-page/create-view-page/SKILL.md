---
name: create-view-page
description: Reusable DockHub procedure for creating a new View.Page using the currently confirmed Page/Composition architecture, without inventing contracts, types, Theme tokens, or folder structure.
scope: DockHub View.Page Creation / Runtime Composition
language: pt-BR
category: implementation
status: ACTIVE
---

# Create View Page

## 1. Purpose

Padronizar a criação de uma nova Page do DockHub a partir do estado real do repositório.

A Skill coordena o procedimento; a autoridade de domínio permanece no `dockhub-view-page`.

---

## 2. When to use

Use quando a tarefa exigir uma nova View/Page FMX que deva seguir a arquitetura runtime de Page Composition vigente.

---

## 3. When not to use

Não use para:

```text
alterar somente uma Page existente
criar um TFrame que não pertença ao modelo atual de Page
criar diálogo/modal com arquitetura diferente já existente
forçar interface específica sem ações/contrato real
forçar Types ou Theme tokens preventivamente
```

---

## 4. Inputs

Confirme antes de gerar arquivos:

```text
Page name
responsabilidade da Page
ações conhecidas
informações exibidas
textos destinados ao usuário
necessidades de Theme
referência visual, quando existir
comportamento que deve ser preservado
```

Se esses dados forem insuficientes para decidir o comportamento, pare em vez de inventar.

---

## 5. Dependencies

```text
inspect-current-state
validate-architecture
review-code-consistency
review-method-toxicity
evaluate-test-impact
evaluate-documentation-impact
```

O grafo deve permanecer acíclico.

---

## 6. Procedure

### Step 1 — Inspecionar estado atual

Leia no snapshot atual, quando existirem:

```text
src/view/Page/
DockHub.View.Page.Types
DockHub.View.Page.Contracts
DockHub.View.Page.Composition.Impl.Base
uma Page representativa
tests/View/
docs/modules/view/
DockHub.dpr
DockHub.dproj
```

Não utilize template antes dessa inspeção.

### Step 2 — Confirmar responsabilidade

Defina em uma frase o papel da nova Page.

Separe:

```text
Page
→ lifecycle, colaboradores, semântica

Composition
→ construção e apresentação runtime
```

### Step 3 — Avaliar `Types`

Pergunte:

```text
o tipo é estrutural/compartilhado no domínio View.Page?
```

Se sim, avalie `DockHub.View.Page.Types`.

Se for detalhe privado de uma implementação, mantenha-o privado quando apropriado.

Não crie `DockHub.View.Page.<Page>.Types` automaticamente.

### Step 4 — Avaliar contrato específico

Pergunte:

```text
A Page possui ações ou contrato próprio real/já conhecido?
```

Se sim, uma interface específica pode ser justificada.

Se não, use o contrato comum existente.

Não crie interface vazia por cerimônia.

### Step 5 — Avaliar Language

Identifique todos os textos destinados ao usuário.

Reutilize chaves existentes quando semanticamente corretas.

Crie novas chaves e traduções somente quando necessárias.

### Step 6 — Avaliar Theme

Mapeie papéis visuais para tokens existentes.

Somente proponha novo token quando existir papel semântico real não representado pelo contrato atual.

### Step 7 — Avaliar RickUIBuilder

Consulte a API/documentação atual e decida por controle:

```text
Factory
Fluent Builder
TRickUIBuilder.On(...)
FMX direto quando não houver abstração correspondente
```

Considere necessidade de referência posterior para Theme, Language, estado e eventos.

### Step 8 — Aplicar templates

Use:

```text
.ai/templates/delphi/view-page/PAGE.template.pas
.ai/templates/delphi/view-page/PAGE.template.fmx
.ai/templates/delphi/view-page/COMPOSITION.template.pas
```

Preencha todos os placeholders documentados.

Nenhum placeholder pode permanecer no artefato final.

### Step 9 — Registrar projeto

Verifique o projeto Delphi real.

Atualize `.dpr`, `.dproj`, Search Paths ou recursos somente quando o snapshot atual exigir.

Não deduza que uma unit já está registrada.

### Step 10 — Avaliar testes

Execute `evaluate-test-impact` e envolva `dockhub-tests` quando houver teste novo/alterado.

Considere:

```text
lifecycle/contract
FMX integration
Language runtime
Theme runtime
events/actions
lifetime
error paths
```

### Step 11 — Revisar Method Toxicity

Execute `review-method-toxicity` sobre código Delphi novo/alterado, inclusive testes.

Quando RAD Studio/CSV estiver disponível, use as métricas reais.

Sem ferramenta, faça avaliação estática e não invente `Toxicity`.

### Step 12 — Avaliar documentação

Execute `evaluate-documentation-impact`.

Atualize documentação apenas para o comportamento final implementado.

---

## 7. Stop Conditions

Pare quando houver:

```text
estrutura atual de View.Page não confirmada
responsabilidade da Page ambígua
comportamento visual essencial indefinido
contrato específico sem justificativa
novo tipo sem domínio claro
mudança de lifetime/ownership não autorizada
mudança arquitetural transversal não autorizada
Theme ou Language insuficiente sem decisão aprovada
API do RickUIBuilder necessária não confirmada
template incompatível com o padrão atual
```

Ao parar:

```text
não inventar
não completar por analogia
reportar o ponto pendente
```

---

## 8. Output format

```text
Create View Page Result

Page:
- ...

Structure inspected:
- ...

Files created:
- ...

Files modified:
- ...

Contract decision:
- common / page-specific + justification

Types decision:
- ...

Language impact:
- ...

Theme impact:
- ...

RickUIBuilder usage:
- ...

Tests:
- ...

Method Toxicity:
- real metrics / static evaluation / not confirmed

Documentation:
- ...

Pending:
- ...
```

---

## 9. Quality Gate

```text
[ ] snapshot atual foi inspecionado
[ ] Page possui responsabilidade clara
[ ] estrutura não foi inferida por template
[ ] Types foram avaliados antes de tipo novo
[ ] interface específica foi justificada quando criada
[ ] lifecycle atual foi preservado
[ ] lifetime por interface foi preservado
[ ] toda criação visual pertence à Composition
[ ] textos traduzíveis usam Language
[ ] Theme usa tokens semânticos existentes quando suficientes
[ ] RickUIBuilder foi usado conforme API atual
[ ] arquivos de projeto foram avaliados
[ ] testes foram avaliados
[ ] código de teste também passou por Method Toxicity quando alterado
[ ] documentação foi avaliada
[ ] nenhum placeholder permaneceu
[ ] nenhuma execução foi inventada
```

---

## 10. Relationship with Agents

Principais consumidores/autoridades:

```text
dockhub-view-page
dockhub-delphi-coding
dockhub-tests
dockhub-documentation
```

A Skill não sobrescreve Agents.

---

## 11. Final rule

```text
INSPECT
THEN DECIDE
THEN MATERIALIZE
```
