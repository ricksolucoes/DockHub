---
name: <verb>-<object>
description: <short reusable procedure description>
scope: <skill scope>
language: pt-BR
category: <foundation|implementation|validation|testing|documentation>
status: PROPOSED
---

# <Skill Title>

## 1. Purpose

Descreva a capacidade procedural.

Uma Skill deve responder:

```text
qual procedimento recorrente ela padroniza?
```

Não transforme regra de domínio em Skill.

---

## 2. When to use

- ...

---

## 3. When not to use

- ...

---

## 4. Inputs

```text
- ...
```

---

## 5. Dependencies

Liste somente Skills registradas em `.ai/SKILLS.md`.

```text
none
```

ou:

```text
inspect-current-state
...
```

O grafo deve permanecer acíclico.

---

## 6. Procedure

### Step 1

...

### Step 2

...

---

## 7. Stop Conditions

Pare quando:

```text
- ...
```

Ao parar:

```text
não inventar
não ampliar escopo
reportar
```

---

## 8. Output format

```text
<Structured Output>

Status:
- ...

Findings:
- ...

Pending:
- ...
```

---

## 9. Quality Gate

```text
[ ] inputs foram verificados
[ ] procedimento foi seguido
[ ] stop conditions foram avaliadas
[ ] output foi produzido
[ ] nenhuma autoridade arquitetural foi assumida
[ ] nenhuma execução foi inventada
```

---

## 10. Relationship with Agents

Defina consumidores principais.

```text
- dockhub-...
```

A Skill não sobrescreve Agents.

---

## 11. Final rule

Defina a regra operacional curta.

---

## Registration checklist

Antes de mudar `status` para `ACTIVE`:

```text
[ ] diretório existe em .ai/skills/
[ ] arquivo se chama SKILL.md
[ ] front matter está completo
[ ] name é único
[ ] category está correta
[ ] purpose é procedural
[ ] dependencies são oficiais
[ ] grafo continua acíclico
[ ] Stop Conditions existem
[ ] Output format existe
[ ] Quality Gate existe
[ ] Skill está registrada em .ai/SKILLS.md
```
