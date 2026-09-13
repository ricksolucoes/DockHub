# Delphi Contract + Concrete Implementation Template

Este diretório contém o template oficial do DockHub para criação de um **contrato baseado em interface** e sua **implementação concreta**.

```text
IDockHubSomething
        ↓
TDockHubSomething
```

O template foi desenhado para preservar os padrões já definidos pelo `dockhub-delphi-coding`.

---

## 1. Quando usar

Use quando todos os pontos abaixo forem verdadeiros:

```text
- existe uma responsabilidade de componente clara
- há benefício real em expor contrato por interface
- consumidores não precisam depender da classe concreta
- o domínio atual é compatível com interface-based design
```

Não use apenas porque "toda classe precisa de interface".

---

## 2. Quando não usar

Não use automaticamente para:

```text
- records de dados
- helpers
- classes privadas de implementação
- objetos sem fronteira contratual real
- funções utilitárias
- tipos simples
```

YAGNI e KISS continuam valendo.

---

## 3. Arquivos

```text
CONTRACT.template.pas
IMPLEMENTATION.template.pas
```

O par representa:

```text
Contract
    ↓
Concrete Implementation
```

Um `Types` separado continua opcional e deve existir somente quando o domínio realmente precisar de enums, records, aliases, callbacks, exceptions compartilhadas ou outros tipos próprios.

---

## 4. Placeholders do Contract

### `{{CONTRACT_UNIT}}`

Nome completo da unit.

Exemplo ilustrativo:

```text
DockHub.Core.Example.Contracts
```

### `{{CONTRACT_INTERFACE_USES}}`

Bloco `uses` completo da seção `interface`, incluindo `uses` e `;`.

Se nenhum `uses` for necessário, substituir por vazio.

Exemplo:

```pascal
uses
  DockHub.Core.Example.Types;

```

### `{{CONTRACT_NAME}}`

Nome da interface.

Convenção:

```text
I + DockHub + Domain
```

Exemplo ilustrativo:

```text
IDockHubExample
```

### `{{INTERFACE_GUID}}`

GUID exclusivo da interface.

Formato:

```text
{XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}
```

Regras:

```text
nova interface
→ novo GUID

interface existente
→ preservar GUID existente
```

Nunca regenerar GUID de contrato existente.

### `{{CONTRACT_METHOD_DECLARATIONS}}`

Somente métodos públicos pertencentes ao contrato.

Devem chegar já formatados e indentados.

Não incluir:

- helpers internos;
- cache;
- validação privada;
- builders internos;
- detalhes de persistência;
- implementação concreta.

---

## 5. Placeholders da Implementation

### `{{IMPLEMENTATION_UNIT}}`

Nome completo da unit concreta.

Exemplo ilustrativo:

```text
DockHub.Core.Example.Impl
```

### `{{IMPLEMENTATION_INTERFACE_USES}}`

Bloco `uses` completo da seção `interface`.

Deve conter o Contract e apenas dependências necessárias para declarar a classe.

Exemplo:

```pascal
uses
  DockHub.Core.Example.Contracts;

```

### `{{IMPLEMENTATION_NAME}}`

Nome da classe concreta.

Exemplo:

```text
TDockHubExample
```

### `{{CONTRACT_NAME}}`

Mesmo contrato usado pelo template do Contract.

### `{{PRIVATE_SECTION}}`

Bloco privado completo.

Quando houver fields/helpers:

```pascal
  private
    FValue: string;

```

Quando não houver membros privados:

```text
substituir por vazio
```

Não deixar seção `private` vazia apenas para preencher o template.

### `{{INTERFACE_METHOD_DECLARATIONS}}`

Métodos que implementam o contrato.

O padrão do DockHub é mantê-los em `protected` quando a classe concreta não precisa expor API pública paralela.

### `{{IMPLEMENTATION_USES}}`

Bloco `uses` completo da seção `implementation`.

Coloque aqui dependências concretas que não são necessárias na API da unit.

Se não houver dependências:

```text
substituir por vazio
```

### `{{CONSTRUCTOR_BODY}}`

Inicialização específica.

Se não houver inicialização adicional, substituir por vazio.

O construtor continua chamando:

```pascal
inherited Create;
```

### `{{INTERFACE_METHOD_IMPLEMENTATIONS}}`

Implementações concretas dos métodos do contrato.

---

## 6. Regras de construção

O template usa:

```pascal
class function New: {{CONTRACT_NAME}}; static;
```

com:

```pascal
constructor Create;
```

em `protected`.

Objetivo:

```text
consumidor
→ recebe interface

implementação concreta
→ centraliza construção

Create
→ não é a API pública principal
```

Se o domínio atual já possuir outro padrão de construção, não force este template. Execute `validate-architecture` e siga o padrão vigente ou obtenha aprovação para a mudança.

---

## 7. `sealed`

O default é:

```pascal
class sealed
```

Use esse default quando a implementação não tiver sido projetada para herança.

Se herança fizer parte do design real:

```text
não remova sealed silenciosamente
```

A mudança deve ser justificada pela arquitetura.

---

## 8. `TInterfacedObject`

O default é:

```pascal
TInterfacedObject
```

Isso implica reference counting quando a instância é manipulada por interface.

Regra:

```text
não misturar reference counting
+
Free manual da mesma instância
```

sem análise explícita de lifetime.

---

## 9. Naming

Preserve:

| Elemento | Convenção |
|---|---|
| Interface | `I...` |
| Classe | `T...` |
| Exception | `E...` |
| Field | `F...` |
| Argumento | `A...` |
| Local | `L...` |
| Constante | `_...` |

---

## 10. Namespace

Siga o namespace do domínio atual.

Padrão conceitual:

```text
DockHub.<Layer>.<Domain>.Contracts
DockHub.<Layer>.<Domain>.Impl
```

Não invente nova layer apenas para utilizar o template.

---

## 11. `Types` opcional

Não crie automaticamente:

```text
DockHub.<Layer>.<Domain>.Types
```

Crie somente quando houver tipos próprios compartilhados.

Exemplos válidos:

- enum;
- record;
- alias;
- callback;
- exception de domínio compartilhada.

---

## 12. `uses`

### Contract

Deve conter o mínimo necessário para declarar a interface.

### Implementation / interface section

Deve conter apenas dependências necessárias para declarar a classe.

### Implementation / implementation section

Deve receber dependências concretas e detalhes internos sempre que possível.

Objetivo:

```text
menor acoplamento
+
menor propagação de dependências
```

---

## 13. Core e FMX

Quando o componente estiver em:

```text
DockHub.Core.*
```

dependência de FMX exige revisão.

Não introduza:

```text
FMX.Forms
FMX.Controls
```

no Core por conveniência.

---

## 14. Interface pequena e focada

A interface deve representar uma responsabilidade coerente.

Não transforme o Contract em God Interface.

Aplicar:

```text
SRP
ISP
KISS
YAGNI
```

---

## 15. Fluent Interface

Retornar a própria interface é permitido quando melhora composição.

Exemplo conceitual:

```pascal
function Value(
  const AValue: TSomethingType
): IDockHubSomething;
```

Não aplicar fluent API automaticamente.

---

## 16. Exceptions

O template não gera exception automaticamente.

Crie exception de domínio somente quando ela possuir semântica útil.

Não invente:

```text
EDockHubSomethingError
```

apenas porque um novo componente foi criado.

---

## 17. Fail Fast

Valide entrada inválida próximo da fronteira quando necessário.

Não adicione validações fictícias sem requisito.

---

## 18. Build-Then-Swap

Quando a implementação substituir estado cuja construção pode falhar:

```text
build
↓
validate
↓
swap
```

Não destrua estado válido antes de confirmar o novo estado.

O template não injeta esse padrão automaticamente; a implementação deve aplicá-lo quando necessário.

---

## 19. Method Toxicity

Métodos gerados ou materialmente alterados devem ser avaliados por:

```text
review-method-toxicity
```

O template não justifica:

- métodos grandes;
- múltiplas responsabilidades;
- nesting excessivo;
- side effects descontrolados.

---

## 20. O template não cria arquitetura adicional

Não gerar automaticamente:

```text
Singleton
Service Locator
DI Container
Observer
Event Bus
Repository
Builder
Abstract Factory
global mutable state
cache
persistence
thread synchronization
```

Esses elementos exigem requisito e análise próprios.

---

## 21. Testes

Depois de gerar o par:

```text
evaluate-test-impact
```

deve determinar a cobertura necessária.

Não assumir que todo par exige a mesma fixture.

---

## 22. Documentação

Depois de gerar o par:

```text
evaluate-documentation-impact
```

deve determinar se README, docs técnicas ou ADR precisam de atualização.

---

## 23. Skill oficial

O template é aplicado pela Skill:

```text
create-interface-implementation
```

Path:

```text
.ai/skills/implementation/create-interface-implementation/SKILL.md
```

A Skill decide como preencher o template dentro das regras do Agent.

---

## 24. Agent responsável

Não existe um Agent específico para "interface implementation".

Essa responsabilidade pertence a:

```text
dockhub-delphi-coding
```

e, quando houver regras próprias do domínio, ao Agent de domínio aplicável.

Criar um Agent apenas para esta operação violaria a separação definida entre:

```text
Agent
→ responsabilidade

Skill
→ procedimento
```

---

## 25. Generation Quality Gate

```text
CONTRACT
[ ] interface é realmente necessária
[ ] nome começa com I
[ ] GUID é novo para interface nova
[ ] GUID existente nunca foi regenerado
[ ] contrato é focado
[ ] contrato não expõe implementação
[ ] uses está mínimo

IMPLEMENTATION
[ ] classe começa com T
[ ] implementa contrato correto
[ ] sealed está apropriado
[ ] TInterfacedObject está apropriado
[ ] fields estão private
[ ] métodos da interface estão em visibilidade coerente
[ ] New retorna interface
[ ] Create está protegido
[ ] ownership está claro
[ ] lifetime está correto
[ ] implementation uses contém detalhes concretos

ARCHITECTURE
[ ] layer está correta
[ ] namespace está correto
[ ] Core não ganhou FMX indevido
[ ] nenhuma abstração especulativa foi criada
[ ] nenhuma mudança arquitetural foi assumida silenciosamente

QUALITY
[ ] SRP
[ ] ISP
[ ] KISS
[ ] YAGNI
[ ] Method Toxicity avaliada
[ ] testes avaliados
[ ] documentação avaliada
```

---

## 26. Stop Conditions

Pare antes de gerar quando:

```text
interface não estiver justificada
layer estiver indefinida
domínio estiver indefinido
responsabilidade estiver ambígua
contrato já existir
nome conflitar com tipo existente
mudança exigir arquitetura ainda não aprovada
template não representar o padrão vigente daquele domínio
```

---

## 27. Final rule

```text
TEMPLATE PROVIDES STRUCTURE

AGENT PROVIDES RULES

SKILL PROVIDES PROCEDURE

CURRENT CODE PROVIDES TRUTH
```
