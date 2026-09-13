# DockHub AI Templates

Este arquivo é o **registro normativo dos templates reutilizáveis** da infraestrutura de IA do DockHub.

Templates fornecem estrutura.

Eles não possuem autoridade de domínio e não substituem Agents ou Skills.

---

## 1. Modelo

```text
Agent
→ define regras e responsabilidade

Skill
→ define procedimento

Template
→ fornece estrutura reutilizável
```

---

## 2. Precedência

Quando um template é utilizado:

```text
1. código atual
2. solicitação explícita
3. AGENTS.md
4. Agent aplicável
5. SKILLS.md
6. Skill aplicável
7. TEMPLATES.md
8. template e README local
```

Template nunca pode sobrescrever padrão vigente do domínio.

---

## 3. Estrutura

```text
.ai/templates/
├── AGENT.template.md
├── skill/
│   └── SKILL.template.md
└── delphi/
    └── interface-implementation/
        ├── CONTRACT.template.pas
        ├── IMPLEMENTATION.template.pas
        └── README.md
```

---

## 4. Lifecycle

Estados conceituais:

```text
PROPOSED
ACTIVE
DEPRECATED
```

Templates registrados abaixo estão `ACTIVE`.

---

## 5. Templates registrados

### 5.1 Agent Template

```text
Name:
agent-template

Path:
.ai/templates/AGENT.template.md

Type:
governance

Status:
ACTIVE
```

Consumido durante criação de novo Agent.

---

### 5.2 Skill Template

```text
Name:
skill-template

Path:
.ai/templates/skill/SKILL.template.md

Type:
governance

Status:
ACTIVE
```

Consumido durante criação de nova Skill.

---

### 5.3 Delphi Interface + Implementation Template

```text
Name:
delphi-interface-implementation

Path:
.ai/templates/delphi/interface-implementation/

Type:
delphi-code

Status:
ACTIVE
```

Arquivos:

```text
CONTRACT.template.pas
IMPLEMENTATION.template.pas
README.md
```

Agent responsável:

```text
dockhub-delphi-coding
```

Skill consumidora:

```text
create-interface-implementation
```

Propósito:

> Criar uma interface focada e uma implementação concreta `sealed`, baseada em `TInterfacedObject`, com `New` público retornando o contrato e `Create` protegido, quando esse padrão for compatível com o domínio atual.

---

## 6. Regra de registro

Um template reutilizável deve ser registrado aqui quando:

```text
- for oficial
- for reutilizado
- afetar geração de código ou governança
- possuir regras próprias de preenchimento
```

Arquivos de exemplo local não precisam automaticamente de registro central.

---

## 7. Template local README

Templates de código devem possuir README local explicando:

```text
Purpose
When to use
When not to use
Placeholders
Architecture rules
Stop Conditions
Quality Gate
Consuming Skill
Responsible Agent
```

---

## 8. Placeholders

Placeholders devem usar:

```text
{{UPPER_SNAKE_CASE}}
```

Exemplo:

```text
{{CONTRACT_NAME}}
```

Regras:

```text
- nome deve indicar semântica
- placeholder deve estar documentado
- placeholder não pode permanecer no artefato final
```

---

## 9. Quando criar novo template

Crie quando:

```text
- estrutura é recorrente
- variação desnecessária gera inconsistência
- uma Skill precisa materializar o mesmo formato repetidamente
```

Não crie template para uma única ocorrência sem expectativa real de reutilização.

---

## 10. Relação com Skills

Template deve ser aplicado por procedimento claro.

Quando preenchimento não for trivial, deve existir Skill consumidora.

Exemplo:

```text
delphi-interface-implementation
        ↓
create-interface-implementation
```

---

## 11. Relação com Agents

Agent continua sendo a autoridade.

Exemplo:

```text
dockhub-delphi-coding
        ↓
create-interface-implementation
        ↓
delphi-interface-implementation
```

---

## 12. Quality Gate

Antes de registrar novo template:

```text
[ ] finalidade recorrente existe
[ ] Agent responsável está definido
[ ] Skill consumidora está definida quando necessária
[ ] placeholders estão documentados
[ ] nenhum placeholder é ambíguo
[ ] Stop Conditions estão documentadas
[ ] Quality Gate existe
[ ] template não inventa regra de domínio
[ ] template não introduz arquitetura silenciosamente
[ ] foi registrado neste arquivo
```

---

## 13. Depreciação

Não remover template utilizado por Skill ativa.

Fluxo:

```text
ACTIVE
↓
DEPRECATED
↓
migrar Skills consumidoras
↓
remover em alteração posterior
```

---

## 14. Final rule

```text
TEMPLATE = STRUCTURE

NOT
ARCHITECTURAL AUTHORITY
```
