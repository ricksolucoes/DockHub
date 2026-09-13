---
name: dockhub-<agent-name>
description: <short specialized agent description>
scope: <agent scope>
language: pt-BR
category: <transversal|domain>
status: PROPOSED
---

# <Agent Title>

## 1. Missão

Defina a responsabilidade principal do Agent.

Responda:

```text
qual decisão este Agent possui?
qual domínio ele protege?
por que um Agent existente não é suficiente?
```

---

## 2. Escopo

### Pode

- ...

### Não pode

- ...

---

## 3. Fonte da verdade

Defina quais arquivos atuais devem ser lidos.

Nunca use memória/conversa como substituto do código vigente.

---

## 4. Modos

Quando aplicável:

```text
EXPLAIN
REVIEW
IMPLEMENT
AUDIT
```

Defina apenas modos necessários.

---

## 5. Required inspection

Antes de agir:

```text
- ...
```

---

## 6. Regras arquiteturais

Liste apenas regras específicas deste Agent.

Não duplique `.ai/AGENTS.md`.

---

## 7. Convenções do domínio

- ...

---

## 8. Workflows

### Workflow A

```text
1. ...
2. ...
```

### Workflow B

```text
1. ...
2. ...
```

---

## 9. Stop Conditions

Pare quando:

```text
- ...
```

Nunca invente decisão ausente.

---

## 10. Skills registradas utilizadas

Liste somente Skills oficiais de `.ai/SKILLS.md`.

```text
- inspect-current-state
- ...
```

Explique por que cada Skill é utilizada.

---

## 11. Relação com outros Agents

```text
- ...
```

Evite sobreposição de autoridade.

---

## 12. Formato antes de agir

```text
Files inspected:
- ...

Current behavior:
- ...

Planned action:
- ...

Architecture impact:
- ...

Tests:
- ...

Documentation:
- ...
```

---

## 13. Formato depois de agir

```text
Files changed:
- ...

Behavior:
- ...

Validation:
- ...

Tests:
- ...

Documentation:
- ...

Pending:
- ...
```

---

## 14. Quality Gate

```text
[ ] ...
```

---

## 15. Regra final

Defina uma regra curta que preserve a responsabilidade do Agent.

---

## Registration checklist

Antes de mudar `status` para `ACTIVE`:

```text
[ ] arquivo está em .ai/agents/
[ ] front matter está completo
[ ] name é único
[ ] responsabilidade é distinta
[ ] scope está claro
[ ] Stop Conditions existem
[ ] Skills utilizadas estão registradas
[ ] Quality Gate existe
[ ] Agent está registrado em .ai/AGENTS.md
[ ] não há conflito silencioso com Agent existente
```
