---
name: review-method-toxicity
description: Reusable DockHub workflow for evaluating Method Toxicity in Delphi methods using the criteria defined by the dockhub-delphi-coding agent.
scope: DockHub Method Quality Validation
language: pt-BR
category: validation
status: ACTIVE
---

# Review Method Toxicity

## 1. Purpose

Aplicar de forma repetível a análise de Method Toxicity definida pelo:

```text
dockhub-delphi-coding
```

Esta Skill operacionaliza a revisão.

A teoria e a autoridade do padrão permanecem no Agent.

---

## 2. When to use

Use em:

- método novo relevante;
- método alterado;
- code review;
- refatoração;
- bug em fluxo complexo;
- método difícil de testar;
- método com crescimento contínuo.

---

## 3. When not to use

Não use para:

- exigir refatoração cosmética;
- impor número rígido de linhas;
- gerar score matemático inventado;
- expandir escopo automaticamente.

---

## 4. Inputs

```text
Current State Inspection
Target methods
Task scope
```

---

## 5. Dependencies

```text
inspect-current-state
```

---

## 6. Procedure

Para cada método relevante:

### Step 1 — Identificar responsabilidade

Resuma o método em uma frase.

Se precisar de várias frases independentes, registre possível responsabilidade múltipla.

### Step 2 — Avaliar tamanho executável

Observe linhas executáveis e quantidade de etapas.

Use thresholds apenas como alerta.

### Step 3 — Avaliar branches

Registre:

- `if`;
- `else`;
- `case`;
- loops;
- paths de exception.

Não invente complexidade ciclomática exata sem ferramenta.

### Step 4 — Avaliar nesting

Classifique:

```text
0–2
→ baixo risco contextual

3
→ atenção

4+
→ alto risco contextual
```

### Step 5 — Avaliar parâmetros

Verifique:

- quantidade;
- boolean blindness;
- agrupamento semântico;
- coerência com contrato.

### Step 6 — Avaliar locais

Muitas variáveis podem indicar múltiplas fases.

Registre contexto, não apenas número.

### Step 7 — Avaliar responsabilidades

Procure combinação de:

```text
validate
load
convert
persist
update UI
log
commit state
```

### Step 8 — Avaliar acoplamento

Liste colaboradores e subsistemas tocados.

### Step 9 — Avaliar side effects

Liste estado externo modificado.

### Step 10 — Avaliar condições complexas

Procure expressões booleanas difíceis de interpretar.

### Step 11 — Avaliar nível de abstração

Detecte mistura de:

```text
high-level orchestration
low-level infrastructure
UI
protocol details
```

### Step 12 — Avaliar exception flow

Procure:

- captura genérica;
- swallow;
- estado parcial;
- lógica extensa em `except`;
- tratamento em camada inadequada.

### Step 13 — Avaliar hidden control flow

Procure:

- global state;
- callbacks;
- events;
- initialization side effects;
- dependência de ordem.

### Step 14 — Avaliar duplicação

Considere apenas duplicação conceitual relevante.

### Step 15 — Avaliar testabilidade

Pergunte se o método exige:

- setup excessivo;
- dezenas de combinações;
- muitos colaboradores;
- estado externo não controlável.

### Step 16 — Classificar

Use:

```text
LOW
MODERATE
HIGH
CRITICAL
```

### Step 17 — Classificar dívida

Use:

```text
NONE
LOW
MEDIUM
HIGH
```

### Step 18 — Determinar necessidade de refactor

Pergunta:

```text
A toxicidade impede a tarefa atual ou torna a alteração insegura?
```

Se não:

```text
registrar dívida
não refatorar fora de escopo
```

---

## 7. Heuristics

Use apenas como alerta:

| Indicator | Attention | High risk |
|---|---:|---:|
| Executable lines | ~30–40 | ~70+ |
| Nesting | 3 | 4+ |
| Parameters | 4 | 6+ |
| Branches | ~5 | ~10+ |
| Responsibilities | 2 | 3+ |

Contexto prevalece.

---

## 8. Stop Conditions

Interrompa quando:

```text
método não estiver disponível integralmente
dependências essenciais não forem conhecidas
comportamento depender de geração de código não disponível
```

Não classifique com falsa precisão.

---

## 9. Output format

```text
Method Toxicity Review

Method:
- ...

Responsibility:
- ...

Method Toxicity:
- LOW / MODERATE / HIGH / CRITICAL

Indicators:
- executable size:
- branches:
- nesting:
- parameters:
- locals:
- responsibilities:
- coupling:
- side effects:
- boolean blindness:
- abstraction level:
- exception flow:
- hidden control flow:
- duplication:
- testability:

Impact:
- ...

Toxicity Debt:
- NONE / LOW / MEDIUM / HIGH

Refactor required for current task:
- YES / NO

Recommendation:
- ...
```

---

## 10. Quality Gate

```text
[ ] responsabilidade foi resumida
[ ] tamanho foi avaliado
[ ] branches foram avaliados
[ ] nesting foi avaliado
[ ] parâmetros foram avaliados
[ ] locals foram avaliados
[ ] responsabilidades foram avaliadas
[ ] acoplamento foi avaliado
[ ] side effects foram avaliados
[ ] condições foram avaliadas
[ ] abstração foi avaliada
[ ] exceptions foram avaliadas
[ ] hidden flow foi avaliado
[ ] duplicação foi avaliada
[ ] testabilidade foi avaliada
[ ] classificação foi justificada
[ ] dívida foi registrada
[ ] escopo foi respeitado
```

---

## 11. Relationship with Agents

A interpretação dos resultados pertence ao:

```text
dockhub-delphi-coding
```

e, quando aplicável, ao Agent de domínio.

---

## 12. Final rule

```text
MEASURE COGNITIVE RISK
NOT LINE COUNT ALONE
```
