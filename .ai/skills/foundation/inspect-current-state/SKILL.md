---
name: inspect-current-state
description: Reusable DockHub workflow for inspecting the current repository state before implementation, review, testing, or documentation work.
scope: DockHub Repository Inspection
language: pt-BR
category: foundation
status: ACTIVE
---

# Inspect Current State

## 1. Purpose

Estabelecer um baseline factual da área afetada antes de qualquer implementação, revisão, teste ou documentação.

A Skill deve responder:

```text
o que existe agora?
onde está?
qual contrato está vigente?
quem consome?
quais testes existem?
quais documentos existem?
o que ainda não foi confirmado?
```

Ela não implementa alterações.

---

## 2. When to use

Use antes de:

- implementar comportamento;
- revisar arquitetura;
- revisar código;
- avaliar Method Toxicity;
- alterar testes;
- documentar comportamento;
- propor refatoração;
- criar nova abstração.

---

## 3. When not to use

Não use como substituto de:

- execução de testes;
- build;
- auditoria documental completa;
- aprovação arquitetural.

Inspeção confirma estado no fonte.

Não prova execução.

---

## 4. Inputs

Obrigatórios:

```text
Task:
- solicitação atual

Scope:
- módulo, arquivo ou comportamento afetado
```

Opcionais:

```text
Known files:
- arquivos apontados pelo usuário

Execution evidence:
- XML, logs ou artefatos disponíveis
```

---

## 5. Dependencies

```text
none
```

Esta é uma Skill Foundation.

---

## 6. Procedure

### Step 1 — Fixar o escopo

Transforme a solicitação em uma frase operacional.

Exemplo:

```text
Alterar resolução de idioma sem modificar View.
```

Não ampliar a tarefa.

### Step 2 — Localizar produção

Localize:

- unit principal;
- Types;
- Contracts;
- Impl;
- helpers;
- constants;
- resources;
- `.fmx` quando aplicável.

Não presuma paths por memória.

### Step 3 — Ler arquivo principal integralmente

Leia o arquivo de produção diretamente responsável pelo comportamento.

Não use snippets quando o fluxo depender de estado, lifetime ou contexto da unit.

### Step 4 — Ler contratos e tipos relacionados

Verifique:

- interfaces;
- enums;
- records;
- aliases;
- callbacks;
- exceptions;
- constantes públicas.

### Step 5 — Localizar consumidores

Identifique quem chama ou armazena o componente.

Verifique:

- Views;
- services;
- bootstrap;
- factories;
- tests.

### Step 6 — Identificar dependências

Registre:

```text
interface uses
implementation uses
cross-layer dependencies
ownership relationships
```

### Step 7 — Localizar testes

Identifique:

- fixtures;
- métodos;
- runner;
- dados de teste;
- evidência de execução disponível.

Não confunda teste existente com teste executado.

### Step 8 — Localizar documentação

Procure:

- README;
- module docs;
- ADR;
- test docs;
- exemplos.

Documentação é material a validar, não fonte automática da implementação.

### Step 9 — Identificar configuração relevante

Quando aplicável, verifique:

- `.dpr`;
- `.dproj`;
- `.groupproj`;
- defines;
- search paths;
- configuração condicional.

### Step 10 — Classificar fatos

Use:

```text
CONFIRMED_IMPLEMENTATION
CONFIRMED_CONTRACT
CONFIRMED_TEST_SOURCE
CONFIRMED_EXECUTION_EVIDENCE
DOCUMENTED_ONLY
NOT_CONFIRMED
```

### Step 11 — Registrar desconhecidos

Qualquer ponto necessário não confirmado deve ser explicitado.

Não preencher lacunas por inferência.

---

## 7. Stop Conditions

Interrompa quando:

```text
arquivo normativo necessário não estiver disponível
contrato estiver contraditório
snapshot estiver incompleto
a tarefa depender de evidência de execução inexistente
houver duas implementações concorrentes sem indicação da vigente
```

Saída nesses casos:

```text
STOPPED

Reason:
- ...

Missing evidence:
- ...

Required next input:
- ...
```

---

## 8. Output format

```text
Current State Inspection

Task:
- ...

Scope:
- ...

Production files:
- ...

Contracts / Types:
- ...

Consumers:
- ...

Dependencies:
- ...

Tests:
- ...

Execution evidence:
- ...

Documentation:
- ...

Confirmed behavior:
- ...

Current limitations:
- ...

Unknown / not confirmed:
- ...

Stop conditions:
- none
ou
- ...
```

---

## 9. Quality Gate

```text
[ ] escopo foi fixado
[ ] arquivo principal foi lido
[ ] contratos foram lidos
[ ] tipos relevantes foram lidos
[ ] consumidores foram localizados
[ ] dependências foram avaliadas
[ ] testes foram localizados
[ ] documentação foi localizada
[ ] execução não foi inferida
[ ] desconhecidos foram registrados
[ ] memória/conversa não substituiu fonte atual
```

---

## 10. Relationship with Agents

Pode ser usada por qualquer Agent.

Principais consumidores:

```text
dockhub-delphi-coding
dockhub-language-translator
dockhub-theme
dockhub-tests
dockhub-documentation
```

---

## 11. Final rule

```text
INSPECT FIRST
ASSUME NOTHING
REPORT UNKNOWN
```

