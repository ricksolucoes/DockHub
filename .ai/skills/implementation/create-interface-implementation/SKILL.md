---
name: create-interface-implementation
description: Reusable DockHub workflow for creating a focused Delphi interface contract and sealed concrete implementation from the official interface-implementation templates while preserving architecture, lifetime, code consistency, tests, and documentation discipline.
scope: DockHub Delphi Contract + Concrete Implementation Creation
language: pt-BR
category: implementation
status: ACTIVE
---

# Create Interface + Concrete Implementation

## 1. Purpose

Criar um novo par Delphi:

```text
Interface Contract
        ↓
Concrete Implementation
```

usando os templates oficiais:

```text
.ai/templates/delphi/interface-implementation/
```

A Skill não decide que toda classe precisa de interface.

A primeira responsabilidade é verificar se o contrato por interface é realmente justificado.

---

## 2. Primary Agent

Agent responsável:

```text
dockhub-delphi-coding
```

Quando o componente pertence a domínio com Agent próprio:

```text
dockhub-delphi-coding
        +
domain Agent
```

O Agent de domínio define regras específicas.

---

## 3. When to use

Use quando:

```text
- novo componente possui contrato real
- consumidores devem depender de abstração
- o padrão Types/Contracts/Impl é compatível com o domínio
- interface-based design reduz acoplamento ou torna fronteira explícita
```

---

## 4. When not to use

Não use automaticamente para:

```text
- cada classe nova
- records
- helpers
- implementação privada
- utilitários sem fronteira
- objetos triviais
```

Se a interface não estiver justificada:

```text
STOP
```

e recomende a solução mais simples.

---

## 5. Inputs

Obrigatórios:

```text
Task
Domain
Layer
Contract responsibility
Required public behavior
```

Quando disponível:

```text
Target folder
Existing Types
Domain Agent
Current naming examples
```

---

## 6. Dependencies

```text
inspect-current-state
validate-architecture
review-code-consistency
evaluate-test-impact
evaluate-documentation-impact
```

`review-code-consistency` já executa `review-method-toxicity` quando aplicável.

---

## 7. Required templates

```text
.ai/templates/delphi/interface-implementation/CONTRACT.template.pas

.ai/templates/delphi/interface-implementation/IMPLEMENTATION.template.pas

.ai/templates/delphi/interface-implementation/README.md
```

Se qualquer template obrigatório estiver ausente:

```text
STOP
```

---

## 8. Procedure

### Step 1 — Inspect current state

Execute:

```text
inspect-current-state
```

Inspecione:

- domínio;
- layers;
- Types existentes;
- Contracts existentes;
- Impl existentes;
- consumidores;
- naming;
- testes;
- documentação.

---

### Step 2 — Confirm interface justification

Responda:

```text
Existe fronteira contratual real?
Consumidores ganham algo dependendo da interface?
O domínio atual utiliza esse padrão?
A abstração reduz acoplamento?
```

Classifique:

```text
INTERFACE_JUSTIFIED
INTERFACE_NOT_JUSTIFIED
NEEDS_ARCHITECTURAL_DECISION
```

Se:

```text
INTERFACE_NOT_JUSTIFIED
```

não gerar o par.

---

### Step 3 — Confirm no existing contract

Procure interface equivalente.

Se já existir:

```text
STOP
```

Esta Skill é para criação de novo par.

Alteração de contrato existente deve seguir `implement-change` e preservar GUID.

---

### Step 4 — Determine layer and namespace

Derive do código atual.

Padrão conceitual:

```text
DockHub.<Layer>.<Domain>.Contracts
DockHub.<Layer>.<Domain>.Impl
```

Não inventar layer.

---

### Step 5 — Decide whether `Types` is needed

Classifique:

```text
TYPES_NOT_REQUIRED
TYPES_ALREADY_EXISTS
TYPES_REQUIRED
```

`Types` é justificável quando existirem tipos compartilhados reais.

Esta Skill não cria um `Types` vazio por cerimônia.

Se novo `Types` for necessário, sua criação deve seguir o padrão vigente do domínio antes de gerar o Contract.

---

### Step 6 — Define contract name

Convenção:

```text
I...
```

Preferência DockHub:

```text
IDockHub<DomainOrResponsibility>
```

O nome deve representar responsabilidade, não detalhe técnico irrelevante.

---

### Step 7 — Define implementation name

Convenção:

```text
T...
```

Preferência DockHub:

```text
TDockHub<DomainOrResponsibility>
```

---

### Step 8 — Define contract behavior

Liste somente métodos necessários ao requisito.

Não inventar CRUD, persistence ou helper methods.

Verifique:

```text
SRP
ISP
KISS
YAGNI
```

---

### Step 9 — Generate GUID

Para interface nova:

```text
gerar GUID novo
uppercase
entre chaves
```

Exemplo de formato:

```text
{XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}
```

Nunca reutilizar GUID de outra interface.

Nunca regenerar GUID de interface existente.

---

### Step 10 — Prepare Contract placeholders

Preencher:

```text
{{CONTRACT_UNIT}}
{{CONTRACT_INTERFACE_USES}}
{{CONTRACT_NAME}}
{{INTERFACE_GUID}}
{{CONTRACT_METHOD_DECLARATIONS}}
```

`{{CONTRACT_INTERFACE_USES}}` deve ser bloco completo ou vazio.

---

### Step 11 — Generate Contract

Aplicar:

```text
CONTRACT.template.pas
```

Resultado deve ser arquivo Delphi sem placeholders restantes.

---

### Step 12 — Prepare Implementation placeholders

Preencher:

```text
{{IMPLEMENTATION_UNIT}}
{{IMPLEMENTATION_INTERFACE_USES}}
{{IMPLEMENTATION_NAME}}
{{CONTRACT_NAME}}
{{PRIVATE_SECTION}}
{{INTERFACE_METHOD_DECLARATIONS}}
{{IMPLEMENTATION_USES}}
{{CONSTRUCTOR_BODY}}
{{INTERFACE_METHOD_IMPLEMENTATIONS}}
```

---

### Step 13 — Apply construction pattern

Default oficial:

```text
sealed
+
TInterfacedObject
+
protected Create
+
public static New returning interface
```

Se o domínio atual utilizar padrão diferente:

```text
não sobrescrever silenciosamente
```

Execute architecture gate.

---

### Step 14 — Generate implementation

Aplicar:

```text
IMPLEMENTATION.template.pas
```

Resultado deve estar sem placeholders restantes.

---

### Step 15 — Validate `uses`

Verifique:

```text
Contract interface uses
→ mínimo necessário

Implementation interface uses
→ contrato + tipos necessários para declarar classe

Implementation uses
→ detalhes concretos
```

---

### Step 16 — Validate lifetime

Confirme:

```text
TInterfacedObject
→ reference counting

consumer
→ interface

no manual Free of same interfaced instance
```

---

### Step 17 — Validate architecture

Execute:

```text
validate-architecture
```

Se retornar:

```text
APPROVAL_REQUIRED
```

pare antes de considerar geração aprovada.

---

### Step 18 — Review code consistency

Execute:

```text
review-code-consistency
```

Verifique especialmente:

- naming;
- visibility;
- constants `_`;
- scoped enums quando aplicável;
- ownership;
- lifetime;
- Method Toxicity;
- Core/View boundary.

---

### Step 19 — Evaluate tests

Execute:

```text
evaluate-test-impact
```

Handoff para:

```text
dockhub-tests
```

quando testes forem necessários.

---

### Step 20 — Evaluate documentation

Execute:

```text
evaluate-documentation-impact
```

Handoff para:

```text
dockhub-documentation
```

quando documentação for necessária.

---

### Step 21 — Final placeholder check

Nenhum token:

```text
{{...}}
```

pode permanecer no `.pas` final.

---

## 9. Stop Conditions

Pare quando:

```text
INTERFACE_NOT_JUSTIFIED
interface equivalente já existe
layer não está confirmada
domínio não está confirmado
responsabilidade do contrato está ambígua
métodos públicos ainda não estão definidos
novo padrão de construção exige aprovação
ownership/lifetime não está claro
template oficial está ausente
nome conflita com tipo existente
Core precisaria depender indevidamente de FMX
```

Formato:

```text
INTERFACE_IMPLEMENTATION_STOPPED

Reason:
- ...

Current evidence:
- ...

Decision required:
- ...
```

---

## 10. Output format

```text
Interface + Implementation Creation

Status:
- CREATED / STOPPED / APPROVAL_REQUIRED

Agent:
- dockhub-delphi-coding
- optional domain Agent

Domain:
- ...

Layer:
- ...

Interface justification:
- ...

Types:
- TYPES_NOT_REQUIRED / TYPES_ALREADY_EXISTS / TYPES_REQUIRED

Contract:
- unit:
- path:
- name:
- GUID:

Implementation:
- unit:
- path:
- name:

Construction:
- sealed:
- base class:
- constructor visibility:
- factory:

Architecture validation:
- ...

Code consistency:
- ...

Method Toxicity:
- ...

Test impact:
- ...

Documentation impact:
- ...

Remaining limitations:
- ...
```

---

## 11. Quality Gate

### Contract

```text
[ ] interface está justificada
[ ] responsabilidade é única
[ ] name começa com I
[ ] GUID é novo
[ ] GUID não colide com contrato existente
[ ] methods vêm do requisito
[ ] interface é focada
[ ] details concretos não vazaram
[ ] uses está mínimo
```

### Implementation

```text
[ ] name começa com T
[ ] implementação usa contrato correto
[ ] sealed está coerente
[ ] TInterfacedObject está coerente
[ ] Create está protected
[ ] New está public/static
[ ] New retorna interface
[ ] fields estão private
[ ] interface methods têm visibilidade coerente
[ ] implementation uses contém detalhes concretos
```

### Architecture

```text
[ ] layer está confirmada
[ ] namespace segue padrão vigente
[ ] Core/View boundary está preservada
[ ] ownership está claro
[ ] lifetime está correto
[ ] nenhuma dependência circular foi criada
[ ] nenhuma arquitetura extra foi introduzida
```

### Quality

```text
[ ] KISS
[ ] YAGNI
[ ] SRP
[ ] ISP
[ ] Method Toxicity avaliada
[ ] testes avaliados
[ ] documentação avaliada
[ ] nenhum placeholder permaneceu
```

---

## 12. Relationship with other Skills

```text
inspect-current-state
→ baseline

validate-architecture
→ architecture gate

review-code-consistency
→ final code review

evaluate-test-impact
→ test handoff

evaluate-documentation-impact
→ documentation handoff
```

Esta Skill não depende de `implement-change`.

Ambas são Skills de implementação paralelas:

```text
implement-change
→ mudança genérica

create-interface-implementation
→ criação especializada de Contract + Concrete Implementation
```

Isso evita ciclo e duplicação de orquestração.

---

## 13. Final rule

```text
DO NOT CREATE AN INTERFACE
UNTIL THE INTERFACE IS JUSTIFIED

DO NOT CREATE THE IMPLEMENTATION
UNTIL THE CONTRACT IS CLEAR
```
