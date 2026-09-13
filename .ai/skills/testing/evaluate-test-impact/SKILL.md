---
name: evaluate-test-impact
description: Reusable DockHub workflow for mapping code changes to existing tests, required new tests, regression protection, and execution evidence without replacing the dockhub-tests agent.
scope: DockHub Test Impact Analysis
language: pt-BR
category: testing
status: ACTIVE
---

# Evaluate Test Impact

## 1. Purpose

Determinar como uma alteração afeta a suíte de testes.

Esta Skill responde:

```text
há teste existente?
ele cobre diretamente o comportamento?
precisa ser alterado?
precisa de teste novo?
há risco de regressão?
```

Ela não implementa o teste.

---

## 2. When to use

Use quando houver:

- comportamento novo;
- alteração de contrato;
- correção de bug;
- mudança de estado;
- mudança de exception;
- refatoração de fluxo;
- mudança de configuração relevante.

---

## 3. When not to use

Não use para afirmar:

- coverage percentual;
- testes passaram;
- build passou;
- zero leaks;

sem evidência apropriada.

---

## 4. Inputs

```text
Current State Inspection
Changed behavior
Affected production files
Existing tests
```

---

## 5. Dependencies

```text
inspect-current-state
```

---

## 6. Procedure

### Step 1 — Listar comportamentos alterados

Não mapear apenas arquivos.

Mapear comportamento observável.

### Step 2 — Localizar fixtures

Identifique fixture conceitualmente responsável.

### Step 3 — Mapear testes existentes

Para cada comportamento:

```text
DIRECT_COVERAGE
INDIRECT_COVERAGE
NO_COVERAGE
UNKNOWN
```

### Step 4 — Avaliar validade dos testes existentes

Pergunte:

- assertion continua correta?
- exception esperada mudou?
- setup continua válido?
- teste ainda representa contrato atual?

### Step 5 — Classificar impacto

Use:

```text
NO_TEST_IMPACT
EXISTING_TEST_SUFFICIENT
TEST_UPDATE_REQUIRED
NEW_TEST_REQUIRED
REGRESSION_TEST_REQUIRED
```

### Step 6 — Avaliar cenários

Considere:

- happy path;
- error path;
- boundary;
- state transition;
- regression;
- contract.

### Step 7 — Avaliar UI versus serviço

Não confundir teste de serviço com teste de View.

### Step 8 — Avaliar execução necessária

Defina:

```text
test isolated
fixture
full suite
```

quando aplicável.

### Step 9 — Avaliar evidência disponível

Se houver XML/log:

```text
registrar apenas o que ele comprova
```

### Step 10 — Classificar risco

Use:

```text
LOW
MEDIUM
HIGH
```

baseado em:

- alcance da mudança;
- ausência de cobertura;
- estado;
- contratos;
- regressão potencial.

---

## 7. Stop Conditions

Interrompa quando:

```text
produção afetada não puder ser confirmada
fixtures relacionadas não puderem ser localizadas
contrato esperado estiver indefinido
a análise depender de resultado de execução inexistente
```

---

## 8. Output format

```text
Test Impact

Changed behavior:
- ...

Existing fixtures:
- ...

Coverage mapping:
- behavior:
  status:
  tests:

Impact classification:
- ...

Tests to update:
- ...

Tests to add:
- ...

Regression tests:
- ...

Execution required:
- isolated:
- fixture:
- suite:

Available execution evidence:
- ...

Regression risk:
- LOW / MEDIUM / HIGH

Not proven:
- coverage percentage
- leak status
- ...
```

---

## 9. Quality Gate

```text
[ ] comportamentos foram listados
[ ] fixtures foram localizadas
[ ] coverage direta/indireta foi diferenciada
[ ] testes existentes foram avaliados
[ ] error paths foram considerados
[ ] regressão foi considerada
[ ] UI e serviço não foram confundidos
[ ] execução necessária foi definida
[ ] evidência não foi ampliada
[ ] coverage não foi inventada
[ ] leak status não foi inventado
```

---

## 10. Relationship with Agents

A implementação e execução de testes pertencem a:

```text
dockhub-tests
```

Esta Skill apenas produz análise de impacto.

---

## 11. Final rule

```text
MAP BEHAVIOR TO TESTS
DO NOT CLAIM EXECUTION
```
