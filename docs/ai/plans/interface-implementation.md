# Plan — Delphi Interface + Concrete Implementation

## Status

```text
IMPLEMENTED
```

Este documento consolida e revisa o plano para criação padronizada de interface Delphi e implementação concreta no DockHub.

---

## 1. Objetivo

Padronizar a criação de:

```text
IDockHubSomething
        ↓
TDockHubSomething
```

sem transformar toda classe em interface e sem introduzir arquitetura desnecessária.

---

## 2. Revisão das decisões anteriores

Após revisar o desenho anterior de Agents, Skills e Templates, foram mantidas as seguintes decisões:

```text
- interface-based design somente quando justificado
- Types / Contracts / Impl quando fizer sentido
- classe concreta sealed por default do padrão
- TInterfacedObject por default
- métodos da interface em protected quando apropriado
- class function New retornando interface
- constructor Create protegido
- interface GUID obrigatório e estável
- interface uses mínimo
- implementation uses para dependências concretas
- Core não depende indevidamente de FMX
- KISS / YAGNI / SRP / ISP
- Method Toxicity obrigatória na revisão
- testes e documentação avaliados após criação
```

---

## 3. Correção arquitetural importante

Não foi criado um novo Agent do tipo:

```text
dockhub-interface-implementation
```

Motivo:

```text
Agent
→ responsabilidade/autoridade

Skill
→ procedimento recorrente
```

Criar um Agent apenas para gerar um par Interface + Implementation duplicaria a autoridade do:

```text
dockhub-delphi-coding
```

Portanto:

```text
dockhub-delphi-coding
→ Agent responsável

create-interface-implementation
→ Skill responsável pelo workflow

delphi/interface-implementation
→ Template responsável pela estrutura
```

---

## 4. Melhoria de governança adicionada

Foi identificado um ponto que não estava formalizado anteriormente:

```text
registro de Templates
```

Foi criado:

```text
.ai/TEMPLATES.md
```

Agora a governança possui três registros:

```text
AGENTS.md
→ responsabilidade

SKILLS.md
→ procedimento

TEMPLATES.md
→ estrutura reutilizável
```

---

## 5. Estrutura implementada

```text
.ai/
├── AGENTS.md
├── SKILLS.md
├── TEMPLATES.md
├── agents/
├── skills/
│   └── implementation/
│       └── create-interface-implementation/
│           └── SKILL.md
└── templates/
    └── delphi/
        └── interface-implementation/
            ├── CONTRACT.template.pas
            ├── IMPLEMENTATION.template.pas
            └── README.md
```

---

## 6. Template Contract

Responsável por:

```text
unit
interface uses
interface name
GUID
public contract methods
```

Não contém regras de negócio.

---

## 7. Template Implementation

Default:

```text
sealed
TInterfacedObject
protected Create
public static New
New returns interface
interface methods protected
```

Dependências concretas devem preferir `implementation uses`.

---

## 8. `Types`

Não foi criado `TYPES.template.pas`.

Isso é intencional.

Motivo:

```text
nem todo Contract precisa de Types próprio
```

Criar arquivo Types vazio seria cerimônia e violaria KISS/YAGNI.

Quando necessário, a Skill detecta e utiliza o padrão real do domínio.

---

## 9. Workflow final

```text
request
↓
dockhub-delphi-coding
↓
inspect-current-state
↓
confirm interface justification
↓
confirm layer/domain
↓
confirm Types decision
↓
define focused contract
↓
generate new GUID
↓
apply CONTRACT.template.pas
↓
apply IMPLEMENTATION.template.pas
↓
validate-architecture
↓
review-code-consistency
↓
review-method-toxicity
↓
evaluate-test-impact
↓
dockhub-tests when needed
↓
evaluate-documentation-impact
↓
dockhub-documentation when needed
```

---

## 10. Stop Conditions

```text
interface not justified
existing equivalent contract
undefined layer
undefined domain
ambiguous responsibility
undefined public contract
unapproved architecture change
unclear ownership/lifetime
Core would require improper FMX dependency
template incompatible with established domain pattern
```

---

## 11. Growth model

Futuras estruturas Delphi podem receber templates próprios somente quando existir repetição real.

Exemplos possíveis, não implementados:

```text
record/value-object
REST resource
configuration service
repository
```

A existência futura de um conceito não autoriza criar template agora.

---

## 12. Quality principles

```text
CURRENT CODE
    >
AGENT RULES
    >
SKILL PROCEDURE
    >
TEMPLATE STRUCTURE
```

Moderado por:

```text
KISS
YAGNI
SRP
ISP
LOW METHOD TOXICITY
NO SILENT ARCHITECTURAL CHANGE
```

---

## 13. Resultado

O plano agora está materializado em arquivos executáveis de governança:

```text
Agent atualizado
Skill criada
Templates criados
Template registry criado
Skill registry atualizado
Human documentation atualizada
Validation atualizada
```
