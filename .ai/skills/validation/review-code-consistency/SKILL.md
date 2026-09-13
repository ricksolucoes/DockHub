---
name: review-code-consistency
description: Reusable DockHub workflow for reviewing Delphi code consistency across structure, design, naming, dependencies, lifetime, project rules, and Method Toxicity.
scope: DockHub Code Consistency Review
language: pt-BR
category: validation
status: ACTIVE
---

# Review Code Consistency

## 1. Purpose

Executar uma revisão transversal e repetível do código Delphi contra os padrões vigentes do DockHub.

A Skill verifica conformidade.

Ela não redefine padrões.

---

## 2. When to use

Use:

- após implementação;
- em pull request;
- antes de aprovação;
- ao introduzir nova unit;
- ao alterar contrato;
- ao alterar ownership/lifetime;
- quando houver dúvida sobre consistência.

---

## 3. When not to use

Não use para:

- criar regra nova a partir de preferência pessoal;
- executar refatoração automática;
- substituir Agent de domínio.

---

## 4. Inputs

```text
Current State Inspection
Changed files or target files
Applicable Agent rules
```

---

## 5. Dependencies

```text
inspect-current-state
review-method-toxicity
```

---

## 6. Procedure

### Step 1 — Structure

Verifique:

- layer;
- namespace;
- responsabilidade;
- organização Types/Contracts/Impl quando aplicável;
- localização do arquivo.

### Step 2 — Naming

Verifique, quando aplicável:

```text
T class
I interface
E exception
F field
A argument
L local
_ constant
```

### Step 3 — Contracts

Verifique:

- foco;
- visibilidade;
- GUID quando existente;
- assinaturas;
- exposição de implementação.

### Step 4 — Encapsulation

Procure:

- members públicos desnecessários;
- internals expostos para testes;
- detalhes concretos vazando pelo contrato.

### Step 5 — Design

Avalie pragmaticamente:

- SRP;
- SOLID;
- KISS;
- YAGNI;
- DRY;
- composition over inheritance.

### Step 6 — Construction

Quando aplicável, verifique coerência com:

- `New`;
- `Create`;
- `sealed`;
- interface-based design.

Não imponha esses padrões a componentes onde não fazem sentido.

### Step 7 — Dependencies

Verifique:

- interface `uses`;
- implementation `uses`;
- direção Core/View;
- dependências novas;
- ciclos potenciais.

### Step 8 — Delphi lifetime

Verifique:

- ownership;
- `TInterfacedObject`;
- reference counting;
- `Free`;
- `FreeAndNil`;
- exception safety.

### Step 9 — Flow

Verifique:

- early exit;
- nesting;
- tratamento de exceptions;
- estado parcial.

### Step 10 — Method Toxicity

Aplique `review-method-toxicity` aos métodos novos ou materialmente alterados.

### Step 11 — Project-specific rules

Verifique:

- strings user-facing e Language;
- constantes;
- scoped enums quando aplicável;
- fronteiras de domínio.

### Step 12 — Test impact

Não crie testes aqui.

Apenas registre se comportamento mudou.

### Step 13 — Documentation impact

Não escreva documentação aqui.

Apenas registre se contrato/comportamento mudou.

### Step 14 — Classificar achados

Use:

```text
CRITICAL
HIGH
MEDIUM
LOW
INFO
```

Diferencie:

```text
REQUIRED_CHANGE
OPTIONAL_IMPROVEMENT
PREEXISTING_DEBT
```

---

## 7. Stop Conditions

Interrompa quando:

```text
padrão vigente não puder ser confirmado
arquivo estiver incompleto
contrato relacionado não estiver disponível
mudança depender de decisão arquitetural não aprovada
```

---

## 8. Output format

```text
Code Consistency Review

Status:
- PASS / CHANGES_REQUIRED / STOPPED

Files reviewed:
- ...

Conforming patterns:
- ...

Findings:

1. [SEVERITY] [TYPE]
   Location:
   Rule:
   Problem:
   Impact:
   Required action:

Method Toxicity summary:
- ...

Preexisting debt:
- ...

Test impact observed:
- ...

Documentation impact observed:
- ...

Optional improvements:
- ...

Stop conditions:
- none
ou
- ...
```

---

## 9. Quality Gate

```text
[ ] estrutura foi revisada
[ ] naming foi revisado
[ ] contratos foram revisados
[ ] encapsulamento foi revisado
[ ] design foi revisado
[ ] dependências foram revisadas
[ ] ownership/lifetime foram revisados
[ ] exception flow foi revisado
[ ] Method Toxicity foi executada quando aplicável
[ ] regras de projeto foram revisadas
[ ] dívida pré-existente foi separada
[ ] melhoria opcional não foi tratada como obrigação sem motivo
[ ] nenhuma regra nova foi inventada
```

---

## 10. Relationship with Agents

A fonte dos padrões é:

```text
dockhub-delphi-coding
Agent de domínio aplicável
AGENTS.md
```

Esta Skill somente aplica o procedimento de revisão.

---

## 11. Final rule

```text
REVIEW AGAINST CONFIRMED RULES
NOT PERSONAL PREFERENCE
```
