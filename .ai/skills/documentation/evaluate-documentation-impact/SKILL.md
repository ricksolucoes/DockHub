---
name: evaluate-documentation-impact
description: Reusable DockHub workflow for identifying documentation changes required by code, contract, architecture, test, or configuration changes without replacing the dockhub-documentation agent.
scope: DockHub Documentation Impact Analysis
language: pt-BR
category: documentation
status: ACTIVE
---

# Evaluate Documentation Impact

## 1. Purpose

Identificar quais documentos são afetados por uma alteração.

Esta Skill não escreve a documentação.

Ela cria o mapa de impacto para o `dockhub-documentation`.

---

## 2. When to use

Use quando houver mudança em:

- contrato público;
- arquitetura;
- comportamento observável;
- configuração;
- workflow de teste;
- roadmap real;
- limitações;
- processo de manutenção;
- criação de Agent/Skill/governança.

---

## 3. When not to use

Não use para:

- afirmar que documentação está correta sem auditoria;
- reescrever docs automaticamente;
- transformar visão futura em estado atual.

---

## 4. Inputs

```text
Current State Inspection
Changed behavior
Changed files
Existing documentation
```

---

## 5. Dependencies

```text
inspect-current-state
```

---

## 6. Procedure

### Step 1 — Classificar a mudança

Use:

```text
IMPLEMENTATION
PUBLIC_CONTRACT
ARCHITECTURE
TESTING
CONFIGURATION
LIMITATION
ROADMAP
AI_GOVERNANCE
```

### Step 2 — Localizar documentação relacionada

Verifique:

- root README;
- module docs;
- ADR;
- test docs;
- examples;
- `docs/ai/README.md`;
- EN/PT counterparts.

### Step 3 — Determinar impacto por documento

Use:

```text
NO_DOCUMENTATION_IMPACT
UPDATE_REQUIRED
NEW_DOCUMENTATION_REQUIRED
ADR_REQUIRED
BILINGUAL_SYNC_REQUIRED
AUDIT_REQUIRED
```

### Step 4 — Verificar current versus future

Toda mudança deve ser classificada como:

```text
CURRENT_IMPLEMENTATION
TESTED_BEHAVIOR
CURRENT_LIMITATION
ARCHITECTURAL_DECISION
PROJECT_VISION
FUTURE_EVOLUTION
```

### Step 5 — Verificar testes

Se a documentação citar execução:

```text
exigir evidência compatível
```

### Step 6 — Verificar exemplos

Identifique exemplos de código que ficaram obsoletos.

### Step 7 — Verificar paths e links

Identifique referências que precisam mudar.

### Step 8 — Verificar bilinguismo

Quando houver EN/PT:

```text
determinar necessidade de sincronização semântica
```

### Step 9 — Verificar ADR

ADR é indicado quando existe decisão arquitetural duradoura, não para toda alteração.

### Step 10 — Produzir mapa de handoff

Não editar documentos nesta Skill.

---

## 7. Stop Conditions

Interrompa quando:

```text
documentação relacionada não puder ser localizada
estado atual da implementação não estiver confirmado
mudança arquitetural ainda não tiver decisão
evidência de testes necessária não estiver disponível
```

---

## 8. Output format

```text
Documentation Impact

Change classification:
- ...

Affected documentation:

- Document:
  Impact:
  Reason:
  Evidence required:

Root README:
- ...

Module docs:
- ...

ADR:
- YES / NO
- reason:

Testing docs:
- ...

AI governance docs:
- ...

EN/PT synchronization:
- YES / NO

Examples affected:
- ...

Links / paths affected:
- ...

Handoff to dockhub-documentation:
- ...
```

---

## 9. Quality Gate

```text
[ ] mudança foi classificada
[ ] docs relacionadas foram localizadas
[ ] current/future foram separados
[ ] claims de teste foram avaliados
[ ] exemplos foram considerados
[ ] paths/links foram considerados
[ ] EN/PT foi considerado
[ ] ADR foi avaliado sem automatismo
[ ] nenhuma documentação foi inventada
[ ] Skill não reescreveu docs por conta própria
```

---

## 10. Relationship with Agents

Criação, revisão e auditoria documental pertencem a:

```text
dockhub-documentation
```

Esta Skill produz o mapa de impacto.

---

## 11. Final rule

```text
IDENTIFY WHAT MUST CHANGE
DO NOT DOCUMENT WHAT IS NOT CONFIRMED
```
