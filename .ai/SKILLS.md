# DockHub AI Skills

Este arquivo é o **registro normativo, contrato comum e ponto de governança das Skills de IA** do projeto DockHub.

As Skills definem **procedimentos reutilizáveis**.

Elas não substituem Agents, não criam autoridade arquitetural própria e não podem sobrescrever regras estabelecidas em `.ai/AGENTS.md` ou nos Agents especializados.

---

## 1. Modelo de governança

A infraestrutura de IA do DockHub é dividida em:

```text
AGENTS.md
    ↓
governança de Agents

agents/
    ↓
responsabilidade, decisão e regras de domínio

SKILLS.md
    ↓
governança e registro de procedimentos

skills/
    ↓
procedimentos reutilizáveis
```

Regra conceitual:

```text
Agent
→ decide o que deve acontecer

Skill
→ define como executar um procedimento recorrente
```

---

## 2. Precedência

Quando houver conflito:

```text
1. código atual do repositório
2. solicitação explícita da tarefa
3. .ai/AGENTS.md
4. Agent especializado aplicável
5. .ai/SKILLS.md
6. SKILL.md utilizada
7. .ai/TEMPLATES.md
8. template utilizado
```

Uma Skill nunca pode usar seu procedimento para contornar uma regra de nível superior.

---

## 3. Estrutura oficial

```text
.ai/
├── AGENTS.md
├── SKILLS.md
├── TEMPLATES.md
│
├── agents/
│   ├── dockhub-delphi-coding.md
│   ├── dockhub-language-translator.md
│   ├── dockhub-theme.md
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
```

A documentação humana está em:

```text
docs/ai/README.md
```

---

## 4. Schema obrigatório

Todo arquivo:

```text
.ai/skills/**/SKILL.md
```

deve iniciar com front matter YAML contendo:

```yaml
---
name: <skill-name>
description: <description>
scope: <scope>
language: pt-BR
category: <category>
status: <status>
---
```

Campos obrigatórios:

```text
name
description
scope
language
category
status
```

---

## 5. Convenção de nomes

Skills devem preferir:

```text
<verb>-<object>
```

Exemplos:

```text
inspect-current-state
implement-change
validate-architecture
review-code-consistency
review-method-toxicity
evaluate-test-impact
evaluate-documentation-impact
```

Não prefixe Skills com `dockhub-` sem necessidade.

Elas já pertencem ao contexto do projeto.

---

## 6. Categorias

Categorias iniciais oficiais:

```text
foundation
implementation
validation
testing
documentation
```

### `foundation`

Procedimentos básicos reutilizados por outras Skills.

Não devem depender de Skills de nível superior.

### `implementation`

Procedimentos que coordenam mudanças no código.

Podem consumir Foundation e Validation, desde que o grafo permaneça acíclico.

### `validation`

Procedimentos de análise.

Não alteram produção por iniciativa própria.

### `testing`

Procedimentos relacionados à análise de impacto e fluxo de testes.

Não substituem `dockhub-tests`.

### `documentation`

Procedimentos relacionados à análise de impacto documental.

Não substituem `dockhub-documentation`.

Categorias de domínio podem ser introduzidas futuramente somente quando existirem Skills reais que justifiquem essa organização.

---

## 7. Lifecycle

Estados oficiais:

```text
PROPOSED
ACTIVE
DEPRECATED
```

Fluxo:

```text
PROPOSED
    ↓
ACTIVE
    ↓
DEPRECATED
```

### `PROPOSED`

Skill em elaboração, ainda não deve ser utilizada como procedimento oficial.

### `ACTIVE`

Skill registrada e disponível.

### `DEPRECATED`

Skill ainda mantida temporariamente para migração.

Uma Skill deprecated deve informar:

```text
replacement
migration guidance
```

quando houver substituta.

---

## 8. Regra de registro

Uma Skill só é oficial quando:

```text
1. existe em .ai/skills/
2. possui SKILL.md
3. possui front matter válido
4. possui name único
5. usa categoria oficial ou aprovada
6. está registrada neste SKILLS.md
7. possui dependências acíclicas
8. possui stop conditions
9. possui output format
10. possui Quality Gate
```

Criar a pasta sem atualizar este registro deixa a Skill incompleta.

---

## 9. Dependências entre Skills

O grafo de dependências deve permanecer **acíclico**.

Regra:

```text
Skill A pode utilizar Skill B
somente se B não depender direta ou indiretamente de A
```

Skills de Validation não devem iniciar `implement-change`.

Skills de Testing e Documentation não devem modificar produção por iniciativa própria.

---

## 10. Grafo oficial atual

```text
inspect-current-state
    │
    ├── validate-architecture
    ├── review-method-toxicity
    ├── evaluate-test-impact
    └── evaluate-documentation-impact

review-method-toxicity
    ↓
review-code-consistency
    ↑
inspect-current-state

implement-change
    ├── inspect-current-state
    ├── validate-architecture
    ├── review-code-consistency
    ├── evaluate-test-impact
    └── evaluate-documentation-impact

create-interface-implementation
    ├── inspect-current-state
    ├── validate-architecture
    ├── review-code-consistency
    ├── evaluate-test-impact
    └── evaluate-documentation-impact
```

`implement-change` é uma Skill de orquestração.

As Skills de análise não retornam para `implement-change`.

---

## 11. Skills registradas

### 11.1 `inspect-current-state`

```text
Category:
foundation

Path:
.ai/skills/foundation/inspect-current-state/SKILL.md

Status:
ACTIVE

Dependencies:
none
```

Propósito:

> Inspecionar o estado atual do repositório antes de implementação, revisão, testes ou documentação.

Principais consumidores:

```text
dockhub-delphi-coding
dockhub-language-translator
dockhub-theme
dockhub-tests
dockhub-documentation
```

---

### 11.2 `implement-change`

```text
Category:
implementation

Path:
.ai/skills/implementation/implement-change/SKILL.md

Status:
ACTIVE

Dependencies:
inspect-current-state
validate-architecture
review-code-consistency
evaluate-test-impact
evaluate-documentation-impact
```

Propósito:

> Coordenar uma alteração de código com inspeção, gate arquitetural, revisão, análise de testes e impacto documental.

Principais consumidores:

```text
dockhub-delphi-coding
dockhub-language-translator
dockhub-theme
future implementation agents
```

---

### 11.3 `create-interface-implementation`

```text
Category:
implementation

Path:
.ai/skills/implementation/create-interface-implementation/SKILL.md

Status:
ACTIVE

Dependencies:
inspect-current-state
validate-architecture
review-code-consistency
evaluate-test-impact
evaluate-documentation-impact
```

Propósito:

> Criar um novo Contract Delphi e sua Concrete Implementation usando os templates oficiais, somente quando a interface estiver justificada.

Agent responsável:

```text
dockhub-delphi-coding
```

Template:

```text
.ai/templates/delphi/interface-implementation/
```

Principais consumidores:

```text
dockhub-delphi-coding
dockhub-theme
future domain agents
```

---

### 11.4 `validate-architecture`

```text
Category:
validation

Path:
.ai/skills/validation/validate-architecture/SKILL.md

Status:
ACTIVE

Dependencies:
inspect-current-state
```

Propósito:

> Verificar layers, direção de dependências, contratos, lifetime, ownership e introdução de padrões arquiteturais.

Principais consumidores:

```text
dockhub-delphi-coding
dockhub-language-translator
dockhub-theme
dockhub-documentation
dockhub-tests, quando houver mudança de testabilidade em produção
```

---

### 11.5 `review-code-consistency`

```text
Category:
validation

Path:
.ai/skills/validation/review-code-consistency/SKILL.md

Status:
ACTIVE

Dependencies:
inspect-current-state
review-method-toxicity
```

Propósito:

> Revisar consistência estrutural, arquitetural, Delphi e de projeto.

Principais consumidores:

```text
dockhub-delphi-coding
dockhub-language-translator
dockhub-theme
dockhub-tests
```

---

### 11.6 `review-method-toxicity`

```text
Category:
validation

Path:
.ai/skills/validation/review-method-toxicity/SKILL.md

Status:
ACTIVE

Dependencies:
inspect-current-state
```

Propósito:

> Aplicar o procedimento de Method Toxicity definido pelo `dockhub-delphi-coding`.

Principais consumidores:

```text
dockhub-delphi-coding
dockhub-language-translator
dockhub-theme
review-code-consistency
```

---

### 11.7 `evaluate-test-impact`

```text
Category:
testing

Path:
.ai/skills/testing/evaluate-test-impact/SKILL.md

Status:
ACTIVE

Dependencies:
inspect-current-state
```

Propósito:

> Mapear uma alteração para testes existentes, novos testes e risco de regressão.

Principais consumidores:

```text
dockhub-delphi-coding
dockhub-language-translator
dockhub-theme
dockhub-tests
implement-change
```

---

### 11.8 `evaluate-documentation-impact`

```text
Category:
documentation

Path:
.ai/skills/documentation/evaluate-documentation-impact/SKILL.md

Status:
ACTIVE

Dependencies:
inspect-current-state
```

Propósito:

> Identificar quais documentos precisam ser atualizados sem escrever a documentação automaticamente.

Principais consumidores:

```text
dockhub-delphi-coding
dockhub-language-translator
dockhub-theme
dockhub-documentation
implement-change
```

---

## 12. Generic Skill versus Domain Skill

### Generic Skill

Procedimento reutilizável por mais de um Agent.

Exemplos atuais:

```text
inspect-current-state
validate-architecture
evaluate-test-impact
```

### Domain Skill

Procedimento recorrente específico de um domínio.

Estrutura futura permitida:

```text
.ai/skills/domains/<domain>/<skill-name>/SKILL.md
```

Exemplo conceitual futuro:

```text
.ai/skills/domains/language/add-translation-key/SKILL.md
```

Esse diretório não deve ser criado antes de existir uma Skill de domínio real.

---

## 13. Quando criar uma nova Skill

Crie quando pelo menos uma destas condições for relevante:

```text
- tarefa é repetida frequentemente
- tarefa precisa sempre da mesma sequência
- erro no procedimento gera risco
- mais de um Agent pode reutilizar a rotina
- existe um Quality Gate procedural que precisa ser consistente
```

Não crie Skill apenas para encapsular poucos comandos triviais.

---

## 14. Quando NÃO criar uma Skill

Não crie para:

```text
open-file
read-unit
save-file
rename-variable
```

Não crie para duplicar:

```text
regras arquiteturais do Agent
documentação teórica
regra específica que já pertence a um Agent
```

Uma Skill representa uma capacidade operacional significativa.

---

## 15. Template oficial

Novas Skills devem começar por:

```text
.ai/templates/skill/SKILL.template.md
```

Novos Agents devem começar por:

```text
.ai/templates/AGENT.template.md
```

Templates Delphi oficiais são registrados em:

```text
.ai/TEMPLATES.md
```

O template de Contract + Concrete Implementation está em:

```text
.ai/templates/delphi/interface-implementation/
```

Templates são scaffolding.

Eles não substituem os registros normativos.

---

## 16. Stop Conditions obrigatórias

Toda Skill deve saber quando interromper.

Exemplos:

```text
arquivo necessário não localizado
contrato não confirmado
fontes contraditórias
mudança arquitetural não aprovada
evidência de execução necessária indisponível
dependência não registrada
escopo insuficiente
```

Ao atingir Stop Condition:

```text
não inventar
não decidir silenciosamente
não ampliar escopo
reportar
```

---

## 17. Output obrigatório

Toda Skill deve definir saída estruturada.

A saída deve:

```text
- informar o que foi inspecionado
- distinguir fato de recomendação
- informar stop conditions encontradas
- informar pendências
- evitar afirmar execução não realizada
```

---

## 18. Quality Gate mínimo

Antes de registrar uma Skill:

```text
[ ] front matter está válido
[ ] name é único
[ ] category está definida
[ ] status está definido
[ ] purpose é procedural
[ ] não duplica um Agent
[ ] inputs estão definidos
[ ] dependências estão definidas
[ ] procedimento está definido
[ ] stop conditions estão definidas
[ ] output está definido
[ ] Quality Gate está definido
[ ] não existe ciclo
[ ] foi registrada em SKILLS.md
```

---

## 19. Criação de nova Skill

Workflow normativo:

```text
1. confirmar necessidade recorrente
2. verificar se Skill equivalente já existe
3. escolher categoria
4. escolher nome verb-object
5. copiar SKILL.template.md
6. definir front matter
7. definir inputs
8. definir dependências
9. definir procedimento
10. definir stop conditions
11. definir output
12. definir Quality Gate
13. verificar grafo acíclico
14. criar diretório
15. registrar neste SKILLS.md
16. atualizar Agents consumidores quando necessário
17. atualizar docs/ai/README.md somente se o modelo de governança mudou
```

---

## 20. Alteração de Skill

Ao alterar uma Skill existente:

```text
1. verificar consumidores
2. preservar compatibilidade procedural quando possível
3. verificar dependências
4. verificar ausência de ciclos
5. atualizar registro se categoria/status/path mudar
6. evitar duplicar regra já existente em Agent
```

---

## 21. Depreciação

Não remova imediatamente uma Skill utilizada.

Fluxo:

```text
ACTIVE
    ↓
DEPRECATED
    ↓
migrar consumidores
    ↓
remoção em alteração posterior
```

Uma Skill deprecated deve permanecer registrada durante a migração.

---

## 22. Agents consumidores

Agents podem declarar quais Skills normalmente utilizam.

Essa declaração serve para descoberta e consistência.

Ela não transforma Skill em regra superior ao Agent.

---

## 23. Relação com documentação

`docs/ai/README.md` explica o sistema para desenvolvedores.

Hierarquia:

```text
Normativo:
.ai/AGENTS.md
.ai/SKILLS.md
.ai/TEMPLATES.md
.ai/agents/*.md
.ai/skills/**/SKILL.md
.ai/templates/**

Explicativo:
docs/ai/README.md
```

Em caso de divergência, os arquivos normativos prevalecem.

---

## 24. Crescimento futuro

Quando a quantidade de Skills justificar, o projeto pode introduzir:

```text
domains/
references/
examples/
scripts/
```

dentro da infraestrutura de Skills.

Essas estruturas não devem ser criadas antecipadamente.

Cada expansão deve resolver um problema concreto.

---

## 25. Princípio final

Skills existem para reduzir variação procedural.

Elas não devem aumentar complexidade de governança.

Prioridade:

```text
REPEATABILITY
    >
TRACEABILITY
    >
SCOPE DISCIPLINE
    >
SIMPLE COMPOSITION
    >
GROWTH READINESS
```

Sempre moderada por:

```text
KISS
+
YAGNI
+
ACYCLIC DEPENDENCIES
+
NO SILENT ARCHITECTURAL DECISIONS
```
