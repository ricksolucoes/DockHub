---
name: validate-architecture
description: Reusable DockHub workflow for validating architectural boundaries, dependency direction, contracts, ownership, lifetime, and introduction of new architectural patterns.
scope: DockHub Architecture Validation
language: pt-BR
category: validation
status: ACTIVE
---

# Validate Architecture

## 1. Purpose

Verificar se uma alteração preserva a arquitetura atual ou introduz mudança arquitetural que exige decisão explícita.

Esta Skill não autoriza mudanças.

Ela detecta impacto.

---

## 2. When to use

Use quando a tarefa puder afetar:

- layers;
- contratos;
- direção de dependências;
- ownership;
- lifetime;
- criação de serviços;
- estado global;
- persistência;
- concorrência;
- eventos;
- factories;
- composição entre módulos.

---

## 3. When not to use

Não é necessária para:

- correção puramente textual;
- alteração de comentário;
- mudança sem impacto estrutural confirmado.

Mesmo nesses casos, use se houver dúvida.

---

## 4. Inputs

```text
Current State Inspection
Proposed or implemented change
Affected files
```

---

## 5. Dependencies

```text
inspect-current-state
```

---

## 6. Procedure

### Step 1 — Confirmar layers

Mapeie os arquivos afetados para suas camadas atuais.

Exemplo conceitual:

```text
Core
View
Tests
Documentation
```

### Step 2 — Verificar direção de dependências

Procure dependências novas ou invertidas.

Sinalize, por exemplo:

```text
Core -> View
```

quando o padrão vigente espera o contrário.

### Step 3 — Verificar contratos

Determine se houve alteração em:

- interface;
- GUID;
- enum;
- callback;
- exception pública;
- assinatura;
- construção pública.

Classifique quebra potencial.

### Step 4 — Verificar implementação concreta

Confirme se consumidores continuam dependentes apenas do necessário.

Identifique exposição nova de detalhes concretos.

### Step 5 — Verificar ownership e lifetime

Pergunte:

```text
quem cria?
quem destrói?
quem referencia?
há reference counting?
há ownership duplicado?
```

### Step 6 — Verificar estado compartilhado

Detecte introdução de:

- global mutable state;
- singleton;
- cache global;
- service locator;
- shared context.

### Step 7 — Verificar novos padrões

Sinalize introdução de:

```text
Observer
Event Bus
DI Container
Repository
Service Locator
Abstract Factory
new persistence mechanism
new threading model
remote configuration
```

Não classifique como errado automaticamente.

Classifique como mudança arquitetural.

### Step 8 — Verificar dependência circular

Analise dependências novas e estrutura de `uses`.

### Step 9 — Verificar escopo

Pergunte:

```text
a arquitetura precisa realmente mudar para atender a tarefa?
```

Se não:

```text
preferir menor alteração compatível
```

### Step 10 — Determinar gate

Resultado:

```text
NO_ARCHITECTURAL_CHANGE
ARCHITECTURAL_CHANGE_APPROVED
ARCHITECTURAL_CHANGE_REQUIRES_APPROVAL
BOUNDARY_VIOLATION
```

---

## 7. Stop Conditions

Interrompa quando:

```text
contrato vigente não puder ser confirmado
layer não puder ser determinada
mudança arquitetural for necessária mas não estiver aprovada
ownership estiver ambíguo a ponto de impedir alteração segura
```

---

## 8. Output format

```text
Architecture Validation

Status:
- PASS / APPROVAL_REQUIRED / CHANGES_REQUIRED / STOPPED

Affected layers:
- ...

Dependency direction:
- ...

Contracts affected:
- ...

Ownership / lifetime:
- ...

New architectural patterns:
- none
ou
- ...

Circular dependency risk:
- ...

Boundary violations:
- none
ou
- ...

Architecture change detected:
- YES / NO

Approval required:
- YES / NO

Required action:
- ...
```

---

## 9. Quality Gate

```text
[ ] layers foram identificadas
[ ] direção de dependências foi verificada
[ ] contratos foram verificados
[ ] ownership foi verificado
[ ] lifetime foi verificado
[ ] estado global foi avaliado
[ ] novos padrões foram identificados
[ ] ciclos foram considerados
[ ] necessidade real foi avaliada
[ ] aprovação não foi presumida
```

---

## 10. Relationship with Agents

Autoridade arquitetural permanece em:

```text
AGENTS.md
dockhub-delphi-coding
Agent de domínio aplicável
```

Esta Skill apenas executa o procedimento de validação.

---

## 11. Final rule

```text
DETECT CHANGE
DO NOT AUTHORIZE IT SILENTLY
```
