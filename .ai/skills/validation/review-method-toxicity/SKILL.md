---
name: review-method-toxicity
description: Reusable DockHub workflow for validating Delphi Method Toxicity Metrics using real RAD Studio/CSV measurements when available and explicit static evaluation otherwise.
scope: DockHub Method Quality Validation
language: pt-BR
category: validation
status: ACTIVE
---

# Review Method Toxicity

## 1. Purpose

Executar de forma repetível a validação de Method Toxicity Metrics definida pelo `dockhub-delphi-coding` e pela governança do projeto.

A Skill não inventa fórmula nem score alternativo.

---

## 2. When to use

Use para código Delphi:

```text
novo
alterado
refatorado
reorganizado quando corpos de métodos forem afetados
produção
testes
```

---

## 3. When not to use

Não use para:

```text
inventar Toxicity sem RAD Studio/CSV
refatorar cosmeticamente
fragmentar métodos apenas para reduzir número
expandir escopo de código legado sem autorização
```

---

## 4. Inputs

```text
Current State Inspection
Target methods
Task scope
Project/environment thresholds when available
RAD Studio Method Toxicity report or CSV when available
```

---

## 5. Dependencies

```text
inspect-current-state
```

---

## 6. Procedure

### Step 1 — Confirmar escopo

Liste os métodos Delphi novos/alterados relevantes, inclusive em `tests/`.

### Step 2 — Confirmar hard thresholds obrigatórios

Para o DockHub, a configuração efetiva do RAD Studio é:

```text
Length                  <= 20
Parameters              <= 6
If Depth                <= 5
Cyclomatic Complexity   <= 6
Toxicity                 < 1
```

Esses valores são hard gates. Não trate os máximos atuais do projeto como novos thresholds e não compense uma violação de uma métrica por outra métrica menor.

### Step 3 — Verificar ferramenta real

Pergunte:

```text
Existe relatório Method Toxicity do RAD Studio ou CSV aplicável ao snapshot?
```

#### Se SIM

Use os valores reais:

```text
Length
Parameters
If Depth
Cyclomatic Complexity
Toxicity
```

Registre a origem da medição.

Não recalcule `Toxicity` manualmente.

#### Se NÃO

Faça avaliação estática diretamente no código quando possível.

Registre:

```text
Length: avaliação estática
Parameters: confirmado pela assinatura
If Depth: avaliação estática
Cyclomatic Complexity: avaliação estática quando possível
Toxicity: Não confirmado
```

Nunca diga que a ferramenta aprovou.

### Step 4 — Executar Hard Threshold Gate

Para cada método Delphi novo/modificado:

```text
Length > 20
→ FAIL

Parameters > 6
→ FAIL

If Depth > 5
→ FAIL

Cyclomatic Complexity > 6
→ FAIL

Toxicity >= 1
→ FAIL
```

Se houver medição real e qualquer limite for ultrapassado, a alteração não pode ser aprovada até a correção.

Sem medição real de `Toxicity`, registre essa parte do hard gate como **Não confirmado**; não declare aprovação real da métrica composta.

### Step 5 — Comparar com baseline medida

Quando existir CSV/relatório anterior comparável, execute também o Regression Baseline Gate.

A baseline medida deve ser descoberta no artefato RAD Studio/CSV correspondente ao snapshot em análise. Não reutilize valores hard-coded de snapshots anteriores.

Se não existir relatório comparável disponível, registre a baseline medida como **Não confirmado** e aplique apenas a avaliação estática possível e os hard limits como política.

Compare, quando tecnicamente relacionável ao mesmo snapshot/método:

```text
valor do método antes/depois
máximos globais antes/depois
```

Classificação:

```text
PASS
→ não houve degradação relevante

REVIEW
→ houve degradação mensurável, mas os hard limits continuam atendidos

NOT AVAILABLE
→ não existe baseline comparável para a alteração
```

`REVIEW` exige correção ou justificativa técnica explícita e auditável; não é aprovação automática.

### Step 6 — Revisão qualitativa complementar

Avalie, sem transformar em score alternativo:

```text
responsabilidade
coesão
acoplamento
side effects
exception flow
hidden control flow
nível de abstração
duplicação
testabilidade
```

Uma métrica baixa não autoriza design ruim.

### Step 7 — Determinar necessidade de correção

```text
hard threshold violado pela alteração
→ corrigir

regressão injustificada dentro dos hard limits
→ corrigir

regressão tecnicamente necessária dentro dos hard limits
→ justificar explicitamente
→ submeter à auditoria

violação legada fora do escopo e não agravada
→ registrar

refactor necessário para segurança da tarefa
→ propor menor mudança coerente
```

Dívida técnica existente não autoriza uma nova violação de hard threshold.

### Step 8 — Reavaliar depois do refactor

Se método foi alterado para reduzir toxicidade, execute novamente a medição real quando possível ou repita a avaliação estática.

Quando houver CSV anterior, repita também o Regression Baseline Gate.

---

## 7. Stop Conditions

Pare quando:

```text
método não estiver disponível integralmente
snapshot da métrica não puder ser relacionado ao código analisado
threshold específico do projeto estiver ambíguo e puder alterar aprovação
uma refatoração necessária exceder o escopo autorizado
```

Ao parar:

```text
não inventar
não extrapolar evidência
reportar
```

---

## 8. Output format

### Com métrica real

```text
Method Toxicity Review

Method:
- ...

Source:
- RAD Studio / CSV / ...

Length:
- ... / 20

Parameters:
- ... / 6

If Depth:
- ... / 5

Cyclomatic Complexity:
- ... / 6

Toxicity:
- ... / < 1

Hard Threshold Status:
- PASS / FAIL

Regression Baseline Status:
- PASS / REVIEW / NOT AVAILABLE

Qualitative findings:
- ...

Action:
- none / correction / justification / scoped refactor
```

### Sem ferramenta

```text
Method Toxicity Review

Method:
- ...

Measurement:
- static evaluation

Length:
- ... / 20

Parameters:
- ... / 6

If Depth:
- ... / 5

Cyclomatic Complexity:
- ... / 6

Toxicity:
- Não confirmado

Hard Threshold Status:
- PARTIAL / FAIL

Regression Baseline Status:
- PASS / REVIEW / NOT AVAILABLE

Qualitative findings:
- ...

Action:
- ...
```

`PARTIAL` significa que as métricas avaliáveis estaticamente não apresentaram violação confirmada, mas o gate completo não pode ser declarado aprovado porque `Toxicity` real não foi medida.

---

## 9. Quality Gate

```text
[ ] métodos afetados foram identificados
[ ] hard thresholds do DockHub foram aplicados: 20 / 6 / 5 / 6 / < 1
[ ] disponibilidade de RAD Studio/CSV foi verificada
[ ] valores reais foram usados quando disponíveis
[ ] Toxicity não foi calculada manualmente
[ ] ausência de ferramenta foi declarada quando aplicável
[ ] Length <= 20 foi validado
[ ] Parameters <= 6 foi validado
[ ] If Depth <= 5 foi validado
[ ] Cyclomatic Complexity <= 6 foi validado
[ ] Toxicity < 1 foi validada somente quando medida
[ ] nenhuma métrica foi usada para compensar violação de outra
[ ] código de teste foi incluído quando alterado
[ ] baseline anterior foi comparada quando disponível
[ ] regressões dentro dos hard limits foram identificadas
[ ] regressão injustificada foi corrigida ou reprovada
[ ] regressão tecnicamente necessária foi justificada e encaminhada à auditoria
[ ] nova violação de hard threshold não foi introduzida
[ ] toxicidade existente não foi agravada sem justificativa
[ ] refactor não fragmentou artificialmente o código
[ ] revisão qualitativa não foi confundida com score de Toxicity
[ ] escopo foi respeitado
```

---

## 10. Relationship with Agents

A interpretação arquitetural pertence ao:

```text
dockhub-delphi-coding
```

e ao Agent de domínio aplicável.

Para testes, coopera com:

```text
dockhub-tests
```

---

## 11. Final rule

```text
HARD THRESHOLDS ARE MANDATORY
COMPARE THE REGRESSION BASELINE WHEN AVAILABLE
REAL METRICS WHEN AVAILABLE
STATIC EVALUATION OTHERWISE
NEVER INVENT TOXICITY
```
