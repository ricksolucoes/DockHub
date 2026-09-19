---
name: review-method-toxicity
description: Reusable DockHub workflow for validating Delphi Method Toxicity Metrics using real RAD Studio/CSV measurements when available and explicit static evaluation otherwise.
scope: DockHub Method Quality Validation
language: pt-BR
category: validation
status: ACTIVE
---

# Review Method Toxicity

## 1. Purpose

Executar de forma repetível a validação de Method Toxicity Metrics definida pelo `dockhub-delphi-coding` e pela governança do projeto.

A Skill não inventa fórmula nem score alternativo.

---

## 2. When to use

Use para código Delphi:

```text
novo
alterado
refatorado
reorganizado quando corpos de métodos forem afetados
produção
testes
```

---

## 3. When not to use

Não use para:

```text
inventar Toxicity sem RAD Studio/CSV
refatorar cosmeticamente
fragmentar métodos apenas para reduzir número
expandir escopo de código legado sem autorização
```

---

## 4. Inputs

```text
Current State Inspection
Target methods
Task scope
Project/environment thresholds when available
RAD Studio Method Toxicity report or CSV when available
```

---

## 5. Dependencies

```text
inspect-current-state
```

---

## 6. Procedure

### Step 1 — Confirmar escopo

Liste os métodos Delphi novos/alterados relevantes, inclusive em `tests/`.

### Step 2 — Confirmar thresholds

Prioridade:

```text
1. thresholds configurados no projeto/ambiente
2. política explícita da tarefa
3. baseline DockHub
```

Baseline quando não houver limite mais restritivo:

```text
Length                  20
Parameters               6
If Depth                 5
Cyclomatic Complexity    6
Toxicity                  1
```

### Step 3 — Verificar ferramenta real

Pergunte:

```text
Existe relatório Method Toxicity do RAD Studio ou CSV aplicável ao snapshot?
```

#### Se SIM

Use os valores reais:

```text
Length
Parameters
If Depth
Cyclomatic Complexity
Toxicity
```

Registre a origem da medição.

Não recalcule `Toxicity` manualmente.

#### Se NÃO

Faça avaliação estática diretamente no código quando possível.

Registre:

```text
Length: avaliação estática
Parameters: confirmado pela assinatura
If Depth: avaliação estática
Cyclomatic Complexity: avaliação estática quando possível
Toxicity: Não confirmado
```

Nunca diga que a ferramenta aprovou.

### Step 4 — Comparar com thresholds

Para código novo:

```text
não exceder thresholds sem justificativa explícita
```

Para código existente alterado:

```text
não introduzir nova violação
não agravar violação preexistente
```

### Step 5 — Revisão qualitativa complementar

Avalie, sem transformar em score alternativo:

```text
responsabilidade
coesão
acoplamento
side effects
exception flow
hidden control flow
nível de abstração
duplicação
testabilidade
```

Uma métrica baixa não autoriza design ruim.

### Step 6 — Determinar necessidade de correção

```text
violação nova causada pela alteração
→ corrigir

violação legada fora do escopo e não agravada
→ registrar

refactor necessário para segurança da tarefa
→ propor menor mudança coerente
```

### Step 7 — Reavaliar depois do refactor

Se método foi alterado para reduzir toxicidade, execute novamente a medição real quando possível ou repita a avaliação estática.

---

## 7. Stop Conditions

Pare quando:

```text
método não estiver disponível integralmente
snapshot da métrica não puder ser relacionado ao código analisado
threshold específico do projeto estiver ambíguo e puder alterar aprovação
uma refatoração necessária exceder o escopo autorizado
```

Ao parar:

```text
não inventar
não extrapolar evidência
reportar
```

---

## 8. Output format

### Com métrica real

```text
Method Toxicity Review

Method:
- ...

Source:
- RAD Studio / CSV / ...

Length:
- ...

Parameters:
- ...

If Depth:
- ...

Cyclomatic Complexity:
- ...

Toxicity:
- ...

Threshold status:
- PASS / FAIL

Qualitative findings:
- ...

Action:
- none / correction / scoped refactor
```

### Sem ferramenta

```text
Method Toxicity Review

Method:
- ...

Measurement:
- static evaluation

Length:
- ...

Parameters:
- ...

If Depth:
- ...

Cyclomatic Complexity:
- ...

Toxicity:
- Não confirmado

Qualitative findings:
- ...

Action:
- ...
```

---

## 9. Quality Gate

```text
[ ] métodos afetados foram identificados
[ ] thresholds aplicáveis foram confirmados
[ ] disponibilidade de RAD Studio/CSV foi verificada
[ ] valores reais foram usados quando disponíveis
[ ] Toxicity não foi calculada manualmente
[ ] ausência de ferramenta foi declarada quando aplicável
[ ] Length foi avaliado
[ ] Parameters foi avaliado
[ ] If Depth foi avaliado
[ ] Cyclomatic Complexity foi avaliado
[ ] Toxicity real foi usada somente quando medida
[ ] código de teste foi incluído quando alterado
[ ] nova toxicidade não foi introduzida
[ ] toxicidade existente não foi agravada
[ ] refactor não fragmentou artificialmente o código
[ ] revisão qualitativa não foi confundida com score de Toxicity
[ ] escopo foi respeitado
```

---

## 10. Relationship with Agents

A interpretação arquitetural pertence ao:

```text
dockhub-delphi-coding
```

e ao Agent de domínio aplicável.

Para testes, coopera com:

```text
dockhub-tests
```

---

## 11. Final rule

```text
REAL METRICS WHEN AVAILABLE
STATIC EVALUATION OTHERWISE
NEVER INVENT TOXICITY
```
