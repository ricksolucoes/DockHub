# DockHub AI Development System

Este documento explica como funciona a infraestrutura de **Agents e Skills** utilizada para manter consistência no desenvolvimento do DockHub.

> Este README é explicativo.  
> Os arquivos normativos são `.ai/AGENTS.md`, `.ai/SKILLS.md`, os Agents registrados e as Skills registradas.

---

## 1. Objetivo

À medida que o DockHub cresce, diferentes tarefas precisam continuar seguindo as mesmas regras de:

- arquitetura;
- Delphi;
- testes;
- documentação;
- escopo;
- evidência;
- Method Toxicity;
- manutenção.

O sistema de IA separa essas responsabilidades em dois conceitos:

```text
Agent
→ responsabilidade, decisão e regras

Skill
→ procedimento reutilizável
```

Isso evita que cada nova tarefa reconstrua o processo do zero.

---

## 2. Estrutura

```text
.ai/
├── AGENTS.md
├── SKILLS.md
├── TEMPLATES.md
│
├── agents/
│   ├── dockhub-delphi-coding.md
│   ├── dockhub-language-translator.md
│   ├── dockhub-tests.md
│   └── dockhub-documentation.md
│
├── skills/
│   ├── foundation/
│   │   └── inspect-current-state/
│   │       └── SKILL.md
│   │
│   ├── implementation/
│   │   ├── implement-change/
│   │   │   └── SKILL.md
│   │   └── create-interface-implementation/
│   │       └── SKILL.md
│   │
│   ├── validation/
│   │   ├── validate-architecture/
│   │   │   └── SKILL.md
│   │   ├── review-code-consistency/
│   │   │   └── SKILL.md
│   │   └── review-method-toxicity/
│   │       └── SKILL.md
│   │
│   ├── testing/
│   │   └── evaluate-test-impact/
│   │       └── SKILL.md
│   │
│   └── documentation/
│       └── evaluate-documentation-impact/
│           └── SKILL.md
│
└── templates/
    ├── AGENT.template.md
    ├── skill/
    │   └── SKILL.template.md
    └── delphi/
        └── interface-implementation/
            ├── CONTRACT.template.pas
            ├── IMPLEMENTATION.template.pas
            └── README.md

docs/
└── ai/
    └── README.md
```

---

## 3. O que é `AGENTS.md`

`.ai/AGENTS.md` é o registro e contrato central dos Agents.

Ele define:

- schema;
- Agents oficiais;
- responsabilidades;
- precedência;
- cooperação;
- criação de novos Agents;
- regras transversais.

Um arquivo colocado em `.ai/agents/` não é oficialmente um Agent do DockHub enquanto não estiver registrado no `AGENTS.md`.

---

## 4. O que é `SKILLS.md`

`.ai/SKILLS.md` é o registro e contrato central das Skills.

Ele define:

- categorias;
- schema;
- Skills oficiais;
- lifecycle;
- dependências;
- grafo acíclico;
- criação;
- depreciação;
- Quality Gate.

Uma pasta em `.ai/skills/` não é Skill oficial enquanto não estiver registrada no `SKILLS.md`.

---

## 5. Agent versus Skill

| Pergunta | Agent | Skill |
|---|---|---|
| Define responsabilidade? | Sim | Não |
| Pode possuir regra de domínio? | Sim | Não como autoridade |
| Decide arquitetura dentro do seu escopo? | Pode avaliar/propor conforme governança | Não |
| Executa procedimento recorrente? | Pode coordenar | Sim |
| É reutilizável por vários domínios? | Às vezes | Frequentemente |
| Tem registro central? | `AGENTS.md` | `SKILLS.md` |

Regra prática:

```text
Se a necessidade é "quem deve decidir?"
→ Agent

Se a necessidade é "qual sequência devemos repetir?"
→ Skill
```

---

## 6. Fonte da verdade

O código atual do repositório continua sendo a fonte normativa da implementação.

A infraestrutura de IA não altera isso.

Precedência:

```text
1. código atual
2. solicitação explícita
3. .ai/AGENTS.md
4. Agent aplicável
5. .ai/SKILLS.md
6. Skill utilizada
7. .ai/TEMPLATES.md
8. template utilizado
```

---

## 7. Agents atuais

O registro oficial está em `.ai/AGENTS.md`.

Atualmente existem:

```text
dockhub-delphi-coding
dockhub-language-translator
dockhub-tests
dockhub-documentation
```

### `dockhub-delphi-coding`

Define como o código Delphi deve ser escrito e revisado.

Inclui:

- arquitetura;
- naming;
- ownership;
- lifetime;
- SOLID pragmático;
- KISS;
- YAGNI;
- DRY;
- Method Toxicity.

### `dockhub-language-translator`

Define regras específicas do domínio Language.

### `dockhub-tests`

Define criação, revisão, execução e evidência de testes.

### `dockhub-documentation`

Define criação, revisão e auditoria documental.

---

## 8. Skills atuais

O registro oficial está em `.ai/SKILLS.md`.

Categorias:

```text
foundation
implementation
validation
testing
documentation
```

Skills:

```text
inspect-current-state
implement-change
create-interface-implementation
validate-architecture
review-code-consistency
review-method-toxicity
evaluate-test-impact
evaluate-documentation-impact
```

---

## 9. Por que cada Skill possui uma pasta

Formato:

```text
.ai/skills/<category>/<skill-name>/SKILL.md
```

Hoje uma Skill pode precisar apenas de `SKILL.md`.

No futuro, a pasta permite adicionar quando realmente necessário:

```text
references/
examples/
scripts/
```

Sem reorganizar toda a estrutura.

Essas pastas auxiliares não devem ser criadas antecipadamente.

---

## 10. Front matter de Agent

Formato:

```yaml
---
name: dockhub-<domain>
description: ...
scope: ...
language: pt-BR
category: transversal
status: ACTIVE
---
```

Campos atuais:

```text
name
description
scope
language
category
status
```

---

## 11. Front matter de Skill

Formato:

```yaml
---
name: <verb>-<object>
description: ...
scope: ...
language: pt-BR
category: validation
status: ACTIVE
---
```

---

## 12. Status

Estados:

```text
PROPOSED
ACTIVE
DEPRECATED
```

### PROPOSED

Ainda em construção.

### ACTIVE

Oficialmente disponível.

### DEPRECATED

Mantido temporariamente para migração.

---

## 13. Quando criar novo Agent

Crie um Agent quando houver:

```text
responsabilidade própria
+
decisões recorrentes
+
regras específicas
+
fronteira clara
```

Perguntas:

```text
O domínio possui regras próprias?
Um Agent existente já cobre isso?
A responsabilidade será recorrente?
Existem decisões que não pertencem às Skills?
```

Se um Agent existente for suficiente, não crie outro.

---

## 14. Quando NÃO criar novo Agent

Não crie um Agent para cada operação.

Exemplo ruim:

```text
dockhub-language-add-key
dockhub-language-change-caption
dockhub-language-new-culture
```

Essas operações pertencem ao Agent de Language e podem futuramente virar Skills de domínio.

---

## 15. Como criar novo Agent

### Step 1 — Confirmar necessidade

Verifique `AGENTS.md`.

### Step 2 — Definir domínio e responsabilidade

Escreva em uma frase:

```text
Este Agent é responsável por...
```

Se a frase se sobrepõe a outro Agent, revise o desenho.

### Step 3 — Escolher nome

Padrão:

```text
dockhub-<domain>.md
```

### Step 4 — Copiar template

Use:

```text
.ai/templates/AGENT.template.md
```

### Step 5 — Preencher front matter

Defina:

```text
name
description
scope
language
category
status
```

Comece como:

```text
status: PROPOSED
```

### Step 6 — Definir fronteiras

Liste explicitamente:

```text
pode
não pode
```

### Step 7 — Definir fonte da verdade

Indique arquivos que o Agent deve inspecionar.

### Step 8 — Definir workflows

Crie somente workflows recorrentes.

### Step 9 — Definir Stop Conditions

O Agent precisa saber quando parar.

### Step 10 — Associar Skills

Use apenas Skills registradas.

### Step 11 — Definir Quality Gate

Sem Quality Gate, o Agent está incompleto.

### Step 12 — Registrar

Atualize:

```text
.ai/AGENTS.md
```

### Step 13 — Verificar conflitos

Compare responsabilidades com Agents existentes.

### Step 14 — Ativar

Depois do checklist:

```text
status: ACTIVE
```

---

## 16. Checklist para novo Agent

```text
[ ] necessidade foi confirmada
[ ] responsabilidade é única
[ ] nome segue padrão
[ ] template foi utilizado
[ ] front matter está completo
[ ] fonte da verdade está definida
[ ] fronteiras estão claras
[ ] workflows estão definidos
[ ] Stop Conditions existem
[ ] Skills utilizadas são oficiais
[ ] Quality Gate existe
[ ] registro em AGENTS.md foi feito
[ ] não há conflito de autoridade
[ ] status ACTIVE só foi aplicado após validação
```

---

## 17. Quando criar nova Skill

Uma Skill é candidata quando:

```text
a tarefa é repetida
ou
o processo precisa ser sempre igual
ou
mais de um Agent reutiliza o fluxo
ou
erro no procedimento gera risco relevante
```

---

## 18. Quando NÃO criar nova Skill

Não transforme ações triviais em Skill.

Exemplos ruins:

```text
open-file
save-file
rename-local-variable
```

Não coloque em Skill:

```text
arquitetura de domínio
regras de negócio
decisões que pertencem a Agent
```

---

## 19. Como criar nova Skill

### Step 1 — Confirmar repetição

Explique qual procedimento está sendo repetido.

### Step 2 — Procurar equivalente

Verifique `SKILLS.md`.

### Step 3 — Escolher categoria

Escolha entre:

```text
foundation
implementation
validation
testing
documentation
```

Nova categoria exige necessidade real.

### Step 4 — Escolher nome

Use:

```text
<verb>-<object>
```

### Step 5 — Criar diretório

Exemplo:

```text
.ai/skills/validation/validate-something/
```

### Step 6 — Copiar template

Use:

```text
.ai/templates/skill/SKILL.template.md
```

### Step 7 — Definir inputs

Skill sem inputs claros tende a virar instrução vaga.

### Step 8 — Definir dependências

Somente Skills registradas.

### Step 9 — Verificar ciclo

O grafo precisa permanecer acíclico.

### Step 10 — Definir procedure

Passos devem ser reproduzíveis.

### Step 11 — Definir Stop Conditions

Obrigatório.

### Step 12 — Definir output

Obrigatório.

### Step 13 — Definir Quality Gate

Obrigatório.

### Step 14 — Registrar

Atualize:

```text
.ai/SKILLS.md
```

### Step 15 — Associar consumidores

Atualize Agents quando a Skill fizer parte recorrente do workflow.

### Step 16 — Ativar

Depois do checklist:

```text
status: ACTIVE
```

---

## 20. Checklist para nova Skill

```text
[ ] necessidade recorrente existe
[ ] Skill equivalente não existe
[ ] categoria está correta
[ ] nome usa verb-object
[ ] template foi usado
[ ] front matter está completo
[ ] inputs estão definidos
[ ] dependências são oficiais
[ ] não existe ciclo
[ ] procedure é reproduzível
[ ] Stop Conditions existem
[ ] output é estruturado
[ ] Quality Gate existe
[ ] registro em SKILLS.md foi feito
[ ] consumidores foram atualizados quando necessário
[ ] status ACTIVE só foi aplicado após validação
```

---

## 21. Dependências acíclicas

O grafo de Skills deve ser um DAG.

Nunca:

```text
A -> B
B -> A
```

Nem indiretamente:

```text
A -> B -> C -> A
```

Skills de análise não iniciam alteração de produção.

Essa regra é importante para impedir loops operacionais.

---

## 22. Skill de orquestração

`implement-change` é diferente das demais.

Ela coordena outras Skills.

Isso é permitido desde que:

```text
- dependências sejam explícitas
- nenhum ciclo exista
- decisões continuem no Agent responsável
```

---

## 23. Skills de domínio futuras

Quando necessário, pode ser introduzida:

```text
.ai/skills/domains/
```

Exemplo futuro:

```text
.ai/skills/domains/language/add-translation-key/SKILL.md
```

Não crie `domains/` antes de existir uma Skill real.

---

## 24. Alterando Agent existente

Quando alterar Agent:

```text
1. confirmar necessidade
2. preservar responsabilidade
3. verificar Skills utilizadas
4. verificar conflito com outros Agents
5. atualizar AGENTS.md se metadata/responsabilidade mudar
6. atualizar este README somente se o modelo de governança mudar
```

Não precisa atualizar este README para toda mudança interna.

---

## 25. Alterando Skill existente

Quando alterar Skill:

```text
1. localizar consumidores
2. preservar compatibilidade quando possível
3. verificar dependencies
4. verificar DAG
5. verificar Stop Conditions
6. atualizar SKILLS.md se path/category/status mudar
```

---

## 26. Depreciação

Nunca apague diretamente um Agent ou Skill em uso.

Fluxo:

```text
ACTIVE
    ↓
DEPRECATED
    ↓
migrar consumidores
    ↓
remover em alteração posterior
```

Registre substituição quando existir.

---

## 27. Example — Agent ou Skill?

### Caso A

> O projeto REST ganhou autenticação, contratos, serialização, error model e regras próprias recorrentes.

Possível resultado:

```text
novo Agent
```

porque existe autoridade de domínio.

### Caso B

> Toda criação de endpoint precisa repetir a mesma sequência de inspeção e validação.

Possível resultado:

```text
nova Skill
```

porque existe procedimento recorrente.

### Caso C

> Precisamos adicionar uma chave de tradução.

Resultado atual:

```text
dockhub-language-translator
+
Skills genéricas existentes
```

Não criar novo Agent.

---

## 28. Anti-patterns

Evite:

### Agent para cada feature

Gera fragmentação de autoridade.

### Skill para cada comando

Gera burocracia sem reutilização.

### Regra duplicada

Se o padrão está no Agent, a Skill deve referenciá-lo.

### README como fonte normativa

README explica.

Registros normativos governam.

### Status ACTIVE prematuro

PROPOSED existe para evitar registrar processos incompletos como oficiais.

### Dependência circular

Skills devem compor fluxo, não loop.

---

## 29. Atualização desta documentação

Atualize `docs/ai/README.md` quando mudar:

- modelo de governança;
- estrutura principal;
- schema;
- lifecycle;
- processo de criação;
- categorias;
- precedência;
- política de depreciação.

Não é necessário atualizar este README quando apenas:

- um texto interno de Agent mudar;
- uma Skill receber melhoria procedural sem mudar governança.

---

## 30. Regra final

A infraestrutura de IA deve crescer de forma controlada.

Objetivo:

```text
mais capacidade
sem
mais ambiguidade
```

Use:

```text
Agents
→ para responsabilidade

Skills
→ para repetibilidade

Registers
→ para governança

Templates
→ para consistência

docs/ai/README.md
→ para entendimento humano
```

Sempre preserve:

```text
KISS
YAGNI
SOURCE-OF-TRUTH
NO SILENT SCOPE EXPANSION
ACYCLIC SKILLS
```


---

## 31. O que é `TEMPLATES.md`

`.ai/TEMPLATES.md` é o registro normativo dos templates reutilizáveis.

Ele existe para que o crescimento dos templates siga o mesmo modelo de governança já usado por Agents e Skills.

```text
AGENTS.md
→ responsabilidade

SKILLS.md
→ procedimento

TEMPLATES.md
→ estrutura reutilizável
```

Templates não possuem autoridade arquitetural.

---

## 32. Template Delphi — Interface + Concrete Implementation

Template oficial:

```text
.ai/templates/delphi/interface-implementation/
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

Skill:

```text
create-interface-implementation
```

Fluxo:

```text
Agent
↓
Skill
↓
Template
```

A interface deve ser justificada antes da geração.

---

## 33. Por que não existe um Agent específico para Interface + Implementation

Não foi criado:

```text
dockhub-interface-implementation
```

porque a responsabilidade é de padrão de codificação Delphi e já pertence ao:

```text
dockhub-delphi-coding
```

A criação do par é um procedimento repetível, portanto pertence a uma Skill.

Isso preserva a regra:

```text
Agent
→ authority/responsibility

Skill
→ procedure

Template
→ structure
```

---

## 34. Skill `create-interface-implementation`

Path:

```text
.ai/skills/implementation/create-interface-implementation/SKILL.md
```

Use para novo par Contract + Concrete Implementation.

A Skill:

```text
1. inspeciona o estado atual
2. confirma se interface é necessária
3. confirma layer e namespace
4. decide necessidade de Types
5. define contrato focado
6. gera GUID novo
7. aplica templates
8. valida arquitetura
9. revisa consistência
10. avalia Method Toxicity
11. avalia testes
12. avalia documentação
```

Ela não deve ser usada para editar uma interface existente e regenerar seu GUID.

---

## 35. Plano formal

O plano e as decisões consolidadas estão em:

```text
docs/ai/plans/interface-implementation.md
```

Esse documento registra inclusive por que nenhum novo Agent foi criado e por que `Types` continua opcional.
