# DockHub AI Agents

Este arquivo é o **registro central, contrato comum e ponto de governança** dos agentes de IA do projeto DockHub.

Ele define:

- regras transversais obrigatórias;
- estrutura oficial de agentes;
- schema mínimo de metadata;
- agentes atualmente registrados;
- responsabilidades;
- cooperação entre agentes;
- precedência de instruções;
- processo para criação de novos agentes.

Os agentes especializados ficam em:

```text
.ai/agents/
```

---

## 1. Estrutura oficial

A estrutura atual é:

```text
.ai/
├── AGENTS.md
├── SKILLS.md
├── TEMPLATES.md
├── agents/
│   ├── dockhub-delphi-coding.md
│   ├── dockhub-language-translator.md
│   ├── dockhub-tests.md
│   └── dockhub-documentation.md
├── skills/
│   ├── foundation/
│   ├── implementation/
│   ├── validation/
│   ├── testing/
│   └── documentation/
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

`AGENTS.md` não é um agente especializado.

Ele é o arquivo central de regras e registro.

Os arquivos dentro de:

```text
.ai/agents/
```

são agentes especializados e devem seguir o padrão definido neste documento.

---

## 2. Schema obrigatório dos agentes especializados

Todo arquivo:

```text
.ai/agents/*.md
```

deve iniciar com front matter YAML válido.

Schema mínimo obrigatório:

```yaml
---
name: <agent-name>
description: <agent-description>
scope: <agent-scope>
language: <agent-language>
category: <transversal|domain>
status: <PROPOSED|ACTIVE|DEPRECATED>
---
```

Campos obrigatórios:

### `name`

Identificador único do agente.

Regras:

```text
- lowercase
- kebab-case
- prefixo "dockhub-" recomendado
- não duplicar outro agente existente
```

Exemplo:

```yaml
name: dockhub-tests
```

### `description`

Descrição curta e objetiva da responsabilidade do agente.

Deve informar:

- o que o agente faz;
- o domínio principal;
- restrições relevantes quando necessário.

Não deve ser um texto promocional.

### `scope`

Escopo funcional principal.

Exemplo:

```yaml
scope: DockHub Automated Tests / Regression / Validation
```

### `language`

Idioma principal das instruções do agente.

Padrão atual:

```yaml
language: pt-BR
```

### `category`

Classificação do Agent.

Valores atuais:

```text
transversal
domain
```

### `status`

Lifecycle do Agent:

```text
PROPOSED
ACTIVE
DEPRECATED
```

---

## 3. Regra de registro

Um agente só é considerado oficialmente disponível no DockHub quando:

1. existe em `.ai/agents/`;
2. possui front matter válido;
3. possui `name` único;
4. está listado na seção **Agentes registrados** deste `AGENTS.md`;
5. sua responsabilidade não conflita silenciosamente com outro agente;
6. suas regras especializadas são compatíveis com este arquivo.

Criar um arquivo em `.ai/agents/` sem atualizar este registro deixa o agente em estado incompleto.

---

## 4. Agentes registrados

### 4.1 `dockhub-language-translator`

Arquivo:

```text
.ai/agents/dockhub-language-translator.md
```

Metadata:

```yaml
---
name: dockhub-language-translator
description: Specialized AI agent for implementing, reviewing, and evolving the DockHub language/translation module while preserving its current Delphi architecture, contracts, tests, and documentation discipline.
scope: DockHub Language / Translation subsystem
language: pt-BR
category: domain
status: ACTIVE
---
```

Responsabilidade principal:

- implementação e manutenção do subsistema de idiomas/traduções;
- chaves;
- catálogos;
- fallback;
- cache;
- troca de idioma;
- integração com Views;
- regras arquiteturais específicas de Language.

Não substitui o agente de testes nem o agente de documentação.

---

### 4.2 `dockhub-tests`

Arquivo:

```text
.ai/agents/dockhub-tests.md
```

Metadata:

```yaml
---
name: dockhub-tests
description: Specialized AI agent for creating, reviewing, executing, and auditing DockHub automated tests while preserving reliability, deterministic behavior, traceability, regression safety, and execution-evidence discipline.
scope: DockHub Automated Tests / Regression / Validation
language: pt-BR
category: transversal
status: ACTIVE
---
```

Responsabilidade principal:

- testes automatizados;
- DUnitX;
- regressão;
- validação;
- fixtures;
- runner;
- evidência de execução;
- análise de XML de resultados;
- separação entre comportamento implementado e comportamento efetivamente testado.

É um agente transversal e pode atuar sobre qualquer módulo do DockHub.

---

### 4.3 `dockhub-documentation`

Arquivo:

```text
.ai/agents/dockhub-documentation.md
```

Metadata:

```yaml
---
name: dockhub-documentation
description: Specialized AI agent for creating, reviewing, and auditing DockHub technical and architectural documentation while preserving strict consistency with source code, tests, execution evidence, and bilingual documentation rules.
scope: DockHub Technical Documentation / Architecture / README / ADR / Audit
language: pt-BR
category: transversal
status: ACTIVE
---
```

Responsabilidade principal:

- documentação técnica;
- documentação arquitetural;
- README;
- ADR;
- documentação de testes;
- auditoria documental;
- paridade EN / pt-BR;
- coerência entre código, testes, evidências e documentação.

É um agente transversal e pode documentar qualquer módulo do DockHub.

---


### 4.4 `dockhub-delphi-coding`

Arquivo:

```text
.ai/agents/dockhub-delphi-coding.md
```

Metadata:

```yaml
---
name: dockhub-delphi-coding
description: Specialized AI agent for explaining, reviewing, and enforcing the DockHub Delphi coding conventions, architectural structure, design principles, Method Toxicity controls, and implementation patterns based on the current source code.
scope: DockHub Delphi Coding Standards / Architecture / Method Toxicity / Code Review
language: pt-BR
category: transversal
status: ACTIVE
---
```

Responsabilidade principal:

- explicar como o código Delphi deve ser estruturado;
- revisar convenções de codificação;
- preservar padrões arquiteturais existentes;
- aplicar SOLID de forma pragmática;
- aplicar KISS, YAGNI e DRY com cautela;
- orientar ownership, lifetime e visibilidade;
- avaliar Method Toxicity;
- governar o padrão Delphi de Contract + Concrete Implementation;
- atuar em modos `EXPLAIN`, `REVIEW` e `IMPLEMENT`.

É um agente transversal.

Ele define **como codificar**, enquanto os agentes de domínio definem regras específicas de cada subsistema.


## 5. Fonte da verdade

O **código atual do repositório** é sempre a fonte normativa da implementação.

Nenhum agente pode assumir que:

- uma arquitetura continua igual porque aparece em uma instrução antiga;
- uma funcionalidade está implementada porque aparece em documentação ou roadmap;
- um teste passou porque existe um teste no repositório;
- uma mudança futura está autorizada porque foi mencionada como possibilidade;
- uma informação de conversa anterior substitui a inspeção do estado atual;
- uma documentação anterior substitui a leitura do código atual;
- um resultado antigo de teste representa automaticamente o snapshot atual.

Antes de alterar qualquer área, o agente deve ler os arquivos atuais relevantes.

---

## 6. Regra de evidência

Afirmações devem ser sustentadas por evidência compatível com o tipo de afirmação.

Use:

- código atual para comportamento implementado;
- configuração atual para comportamento de build/teste;
- resultados reais de execução para afirmar que algo foi executado;
- documentação atual como material a revisar, não como verdade automática;
- roadmap apenas para intenção futura.

Não use como prova:

- suposição;
- memória de conversa;
- resultado antigo sem relação verificável com o snapshot atual;
- documentação desatualizada;
- comentário sem correspondência no código.

---

## 7. Regra de escopo

Implemente ou altere somente:

```text
solicitação
+
dependências tecnicamente necessárias
```

Não transforme uma tarefa localizada em redesign geral.

---

## 8. Mudança arquitetural

Se uma tarefa exigir:

- quebra de contrato público;
- novo padrão arquitetural;
- alteração de lifetime;
- mudança de ownership;
- nova dependência transversal;
- novo mecanismo global;
- mudança de persistência;
- mudança de concorrência;
- alteração relevante de estrutura;

o agente deve:

1. identificar o impacto;
2. explicar a necessidade;
3. propor a menor mudança coerente;
4. pedir aprovação quando a mudança não estiver explicitamente autorizada.

---

## 9. Não inventar APIs

Nunca apresente como existente algo que não foi confirmado no código atual.

Isso inclui:

- units;
- namespaces;
- classes;
- interfaces;
- GUIDs;
- métodos;
- propriedades;
- exceptions;
- constantes;
- paths;
- configurações.

Quando algo novo precisar ser criado, apresente-o explicitamente como novo.

---

## 10. Testes

Nunca:

- remover teste para fazer uma alteração passar;
- enfraquecer assertion sem justificativa;
- ignorar teste silenciosamente;
- afirmar cobertura sem evidência;
- afirmar execução sem execução real;
- afirmar ausência de leak sem evidência específica.

Quando não houver ambiente disponível, use linguagem explícita:

```text
Validação estática realizada.
Compilação/testes não executados neste ambiente.
```

---

## 11. Documentação

Toda alteração deve verificar impacto em documentação.

A documentação deve distinguir claramente:

```text
implementado
testado
limitação atual
decisão arquitetural
visão de projeto
evolução futura
```

Não apresente roadmap como implementação atual.

---

## 12. Evoluções futuras

Possibilidades futuras podem ser propostas, mas não implementadas automaticamente.

Exemplos:

- Observer;
- Event Bus;
- Service Locator;
- DI Container;
- singleton global;
- persistência;
- hot reload;
- sincronização entre threads;
- carregamento remoto;
- externalização de configuração.

---

## 13. Cooperação entre agentes

Quando uma tarefa envolver múltiplos domínios, utilize o agente responsável por cada etapa.

Fluxo recomendado:

```text
Agente de implementação
        ↓
Agente de testes
        ↓
Agente de documentação
```

No caso atual de Language:

```text
dockhub-delphi-coding
        +
dockhub-language-translator
        ↓
implementação
        ↓
dockhub-tests
        ↓
dockhub-documentation
```

O `dockhub-delphi-coding` define os padrões transversais de implementação.

O agente de domínio complementa esses padrões com regras específicas do subsistema.

Cada agente deve limitar-se à sua responsabilidade principal.

### Regra

O agente de coding:

- explica e revisa padrões Delphi;
- avalia arquitetura e Method Toxicity;
- não substitui regras específicas de domínio;
- não executa refatoração fora de escopo.

O agente de implementação:

- implementa comportamento;
- identifica testes necessários;
- identifica documentação afetada.

O agente de testes:

- valida o comportamento;
- cria/revisa testes;
- registra evidência;
- não redesenha produção silenciosamente.

O agente de documentação:

- registra o estado real;
- utiliza evidências disponíveis;
- não inventa comportamento;
- não modifica produção no modo de auditoria.

---

## 14. Handoff entre agentes

Quando agentes atuarem em sequência, a saída deve ser objetiva.

### Implementação → Testes

Formato recomendado:

```text
IMPLEMENTATION-EVIDENCE

Files changed:
- ...

Behavior implemented:
- ...

Contracts affected:
- ...

Known limitations:
- ...

Tests expected:
- ...
```

### Testes → Documentação

Formato recomendado:

```text
TEST-EVIDENCE

Source snapshot:
- ...

Fixtures:
- ...

Cases:
- ...

Execution result:
- ...

Limitations:
- ...
```

### Documentação

Deve revalidar esses handoffs contra os arquivos reais antes de utilizá-los como fonte documental.

---

## 15. Formato antes da implementação

Antes de editar:

```text
Arquivos inspecionados:
- ...

Comportamento atual confirmado:
- ...

Alteração solicitada:
- ...

Arquivos que precisam mudar:
- ...

Impacto arquitetural:
- ...

Testes afetados:
- ...

Documentação afetada:
- ...
```

---

## 16. Formato depois da implementação

Ao concluir:

```text
Arquivos alterados:
- ...

Comportamento implementado:
- ...

Testes adicionados/alterados:
- ...

Validação executada:
- ...

Limitações restantes:
- ...

Documentação afetada:
- ...
```

Nunca use:

```text
compilado
testado
validado
```

sem evidência real.

---

## 17. Processo para criação de novo agente

Antes de criar novo agente, verifique se a responsabilidade já pertence a um agente existente.

Crie um novo agente somente quando existir um domínio suficientemente específico e recorrente.

Workflow:

```text
1. identificar domínio
2. confirmar que não há agente equivalente
3. definir missão
4. definir scope
5. definir fronteiras
6. definir arquivos que deve inspecionar
7. definir workflows
8. definir proibições
9. definir quality gate
10. criar front matter
11. adicionar arquivo em .ai/agents/
12. registrar neste AGENTS.md
13. verificar conflitos com agentes existentes
```

---

## 18. Convenção de nomes para novos agentes

Preferência:

```text
dockhub-<domain>.md
```

Exemplos possíveis:

```text
dockhub-theme.md
dockhub-rest.md
dockhub-database.md
dockhub-architecture-review.md
```

Esses nomes são apenas exemplos.

Eles não representam agentes atualmente registrados.

---

## 19. Quality Gate para novo agente

Antes de registrar um novo agente:

```text
[ ] arquivo está em .ai/agents/
[ ] front matter YAML está presente
[ ] name é único
[ ] description é objetiva
[ ] scope é claro
[ ] language está definido
[ ] category está definida
[ ] status está definido
[ ] missão está definida
[ ] fonte da verdade está definida
[ ] fronteiras estão definidas
[ ] workflows estão definidos
[ ] mudanças proibidas estão definidas
[ ] quality gate está definido
[ ] não duplica responsabilidade de outro agente
[ ] foi registrado neste AGENTS.md
```

---

## 20. Regra de conflito

Em caso de conflito:

1. o código atual define o estado real;
2. a solicitação explícita define o objetivo;
3. este `AGENTS.md` define o processo comum;
4. o agente especializado define regras do domínio.

Se ainda houver ambiguidade com impacto arquitetural, o agente deve interromper e pedir decisão em vez de escolher silenciosamente.

---

## Skills reutilizáveis

Procedimentos reutilizáveis ficam em:

```text
.ai/skills/
```

O registro normativo das Skills é:

```text
.ai/SKILLS.md
```

Agents podem utilizar Skills registradas para executar workflows consistentes.

Skills:

- não substituem Agents;
- não possuem autoridade arquitetural própria;
- não podem sobrescrever regras deste arquivo;
- devem respeitar o Agent especializado aplicável;
- devem manter dependências acíclicas.

Precedência completa:

```text
1. código atual
2. solicitação explícita
3. AGENTS.md
4. Agent especializado
5. SKILLS.md
6. SKILL.md utilizada
7. TEMPLATES.md
8. template utilizado
```

Templates oficiais:

```text
.ai/templates/AGENT.template.md
.ai/templates/skill/SKILL.template.md
```

Guia humano:

```text
docs/ai/README.md
```

O README é explicativo.

Os registros em `.ai/` permanecem normativos.

---

## Templates reutilizáveis

Estruturas reutilizáveis ficam em:

```text
.ai/templates/
```

O registro normativo é:

```text
.ai/TEMPLATES.md
```

Templates fornecem estrutura e ficam abaixo de Agents e Skills na precedência.

O padrão oficial de Contract + Concrete Implementation está em:

```text
.ai/templates/delphi/interface-implementation/
```

e é aplicado pela Skill:

```text
create-interface-implementation
```

Não existe Agent específico para essa operação; a autoridade permanece no `dockhub-delphi-coding`.

---

## 21. Estado atual do registro

Agentes oficialmente registrados:

```text
1. dockhub-delphi-coding
2. dockhub-language-translator
3. dockhub-tests
4. dockhub-documentation
```

Qualquer novo agente deve ser adicionado a esta lista e às seções de registro correspondentes antes de ser considerado parte oficial da estrutura de agentes do DockHub.
