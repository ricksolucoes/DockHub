---
name: implement-change
description: Reusable DockHub orchestration workflow for implementing a scoped code change with current-state inspection, architectural gating, code consistency review, test-impact analysis, and documentation-impact analysis.
scope: DockHub Change Implementation Workflow
language: pt-BR
category: implementation
status: ACTIVE
---

# Implement Change

## 1. Purpose

Coordenar uma alteração de código do início ao fim sem substituir as regras dos Agents especializados.

Esta é uma Skill de **orquestração**.

Ela conecta procedimentos já registrados.

---

## 2. When to use

Use para:

- feature;
- bug fix;
- alteração de comportamento;
- alteração de contrato;
- refatoração necessária;
- mudança de configuração ligada ao código.

---

## 3. When not to use

Não use para:

- revisão sem alteração;
- documentação isolada;
- teste isolado;
- mudança arquitetural ainda não aprovada.

---

## 4. Inputs

Obrigatórios:

```text
Task
Applicable Agent
Scope
```

Opcionais:

```text
User-approved architectural decisions
Known evidence
Target files
```

---

## 5. Dependencies

```text
inspect-current-state
validate-architecture
review-code-consistency
evaluate-test-impact
evaluate-documentation-impact
```

`review-code-consistency` já utiliza `review-method-toxicity`.

Principais consumidores:

```text
dockhub-delphi-coding
dockhub-language-translator
dockhub-theme
future implementation agents
```

---

## 6. Procedure

### Phase 1 — Inspect

Execute:

```text
inspect-current-state
```

Não prosseguir se o baseline necessário não estiver confirmado.

### Phase 2 — Classify change

Classifique:

```text
BUG_FIX
NEW_BEHAVIOR
CONTRACT_CHANGE
REFACTOR
CONFIGURATION_CHANGE
```

### Phase 3 — Define minimal file set

Liste apenas arquivos necessários.

Diferencie:

```text
must change
may change
must not change
```

### Phase 4 — Architecture gate

Execute:

```text
validate-architecture
```

Se retornar:

```text
APPROVAL_REQUIRED
```

pare.

Não implemente até aprovação.

### Phase 5 — Pre-implementation report

Produza o formato exigido pelo Agent aplicável.

No mínimo:

```text
Files inspected
Current behavior
Requested change
Files to change
Architecture impact
Tests affected
Documentation affected
```

### Phase 6 — Implement minimal change

Regras:

```text
preserve public contracts unless approved
preserve ownership
preserve lifetime
avoid unrelated cleanup
avoid speculative abstractions
```

### Phase 7 — Local static review

Antes de testes:

- revisar flow;
- revisar exceptions;
- revisar state transitions;
- revisar `uses`;
- revisar naming.

### Phase 8 — Code consistency

Execute:

```text
review-code-consistency
```

Corrija apenas achados necessários para a tarefa ou correção da própria alteração.

Dívida pré-existente fora do escopo deve ser registrada.

### Phase 9 — Test impact

Execute:

```text
evaluate-test-impact
```

Handoff para `dockhub-tests` quando testes precisarem ser criados/alterados.

### Phase 10 — Documentation impact

Execute:

```text
evaluate-documentation-impact
```

Handoff para `dockhub-documentation` quando docs precisarem ser alteradas.

### Phase 11 — Validation

Quando ambiente permitir:

```text
compile
run affected test
run fixture
run suite
```

somente conforme aplicável.

Não inventar execução.

### Phase 12 — Post-implementation report

Use o formato do Agent aplicável.

Registre:

- arquivos alterados;
- comportamento;
- revisão;
- testes;
- validação;
- docs;
- pendências.

---

## 7. Scope discipline

Nunca aproveitar a tarefa para:

- renomear arquivos sem necessidade;
- reorganizar pastas;
- aplicar formatter global;
- substituir arquitetura;
- remover dívida antiga não relacionada;
- introduzir framework novo.

Se dívida pré-existente bloquear a alteração:

```text
explicar
propor menor refactor
obter aprovação quando arquitetural
```

---

## 8. Stop Conditions

Pare quando:

```text
baseline não confirmado
mudança arquitetural não aprovada
contrato ambíguo
ownership/lifetime inseguros
fonte necessária indisponível
teste requerido depender de infraestrutura ausente e isso impedir conclusão segura
```

Formato:

```text
IMPLEMENTATION_STOPPED

Phase:
- ...

Reason:
- ...

Evidence:
- ...

Decision required:
- ...
```

---

## 9. Output format

```text
Change Implementation

Task:
- ...

Applicable Agent:
- ...

Files inspected:
- ...

Files changed:
- ...

Architecture validation:
- ...

Behavior implemented:
- ...

Code consistency:
- ...

Method Toxicity:
- ...

Test impact:
- ...

Tests changed:
- ...

Validation executed:
- ...

Documentation impact:
- ...

Documentation changed:
- ...

Preexisting debt:
- ...

Remaining limitations:
- ...

Status:
- COMPLETE / PARTIAL / STOPPED
```

---

## 10. Quality Gate

```text
[ ] current state foi inspecionado
[ ] mudança foi classificada
[ ] conjunto mínimo de arquivos foi definido
[ ] arquitetura foi validada
[ ] aprovação foi respeitada
[ ] alteração ficou no escopo
[ ] consistência foi revisada
[ ] Method Toxicity foi avaliada
[ ] impacto de testes foi avaliado
[ ] impacto documental foi avaliado
[ ] validação real foi registrada
[ ] execução não foi inventada
[ ] dívida pré-existente foi separada
[ ] relatório final foi produzido
```

---

## 11. Relationship with Agents

Esta Skill sempre exige um Agent responsável.

Exemplos:

```text
dockhub-delphi-coding
dockhub-language-translator
dockhub-theme
future domain agent
```

A Skill não decide regras de domínio.

---

## 12. Final rule

```text
INSPECT
GATE
IMPLEMENT MINIMALLY
REVIEW
VALIDATE
HAND OFF
```
