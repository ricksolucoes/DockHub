# Delphi View.Page Template

Template oficial para materializar uma nova Page do DockHub **somente após** a arquitetura atual ter sido inspecionada e confirmada.

## Purpose

Fornecer a estrutura repetível de:

```text
Page Form
Page FMX resource
Page-specific Composition
```

O template não possui autoridade arquitetural.

## Consuming Skill

```text
create-view-page
```

## Responsible Agent

```text
dockhub-view-page
```

## When to use

Use quando a nova tela pertence ao modelo atual de `View.Page` e a inspeção confirmou:

```text
TForm host
TPageCompositionBase
runtime Composition
Theme/Language delegation
```

## When not to use

Não use para:

```text
TFrame ou outro host com arquitetura diferente
diálogo/modal que siga padrão distinto
Page cujo modelo arquitetural ainda não esteja definido
forçar interface específica sem contrato real
copiar conteúdo visual da Main para outra Page
```

## Files

```text
PAGE.template.pas
PAGE.template.fmx
COMPOSITION.template.pas
```

Não existem templates de `Types`, `Contracts` ou `Tests` neste diretório porque esses artefatos dependem de necessidade real do domínio/comportamento.

## Placeholders — Page

| Placeholder | Meaning |
| --- | --- |
| `{{PAGE_UNIT}}` | unit da Form, por exemplo `DockHub.View.Page.Settings` |
| `{{PAGE_CLASS}}` | classe da Form, por exemplo `TPageSettings` |
| `{{PAGE_VARIABLE}}` | variável FMX da Page quando o projeto utilizar uma |
| `{{COMPOSITION_REFERENCE_TYPE}}` | `IPageComposition` ou interface específica justificada |
| `{{PAGE_IMPLEMENTATION_USES}}` | units concretas necessárias na implementation |
| `{{COMPOSITION_CLASS}}` | classe concreta da Composition |
| `{{CLOSE_ACTION}}` | semântica real do fechamento da Page |
| `{{CONFIGURE_FORM_BODY}}` | configuração real do host |
| `{{CREATE_LANGUAGE_BODY}}` | construção/obtenção do Language atual |
| `{{CREATE_THEME_BODY}}` | construção/obtenção do Theme atual |

## Placeholders — FMX

```text
{{PAGE_VARIABLE}}
{{PAGE_CLASS}}
{{DESIGN_CLIENT_HEIGHT}}
{{DESIGN_CLIENT_WIDTH}}
{{FORM_FACTOR_WIDTH}}
{{FORM_FACTOR_HEIGHT}}
```

Os valores devem vir da decisão visual real da Page, não da Main por cópia.

## Placeholders — Composition

| Placeholder | Meaning |
| --- | --- |
| `{{COMPOSITION_UNIT}}` | unit `DockHub.View.Page.Impl.<Page>.Composition` |
| `{{COMPOSITION_CLASS}}` | classe concreta da Composition |
| `{{OPTIONAL_COMPOSITION_INTERFACE_SUFFIX}}` | vazio ou `, IPageComposition<Page>` quando justificado |
| `{{COMPOSITION_REFERENCE_TYPE}}` | contrato retornado por `New` |
| `{{COMPOSITION_PRIVATE_SECTION}}` | fields/helpers realmente necessários; vazio quando não houver |
| `{{COMPOSITION_IMPLEMENTATION_USES}}` | dependências concretas da implementation |
| `{{BUILD_BODY}}` | composição visual específica |
| `{{APPLY_LANGUAGE_BODY}}` | aplicação de Language específica |
| `{{APPLY_THEME_BODY}}` | aplicação de Theme específica |

## Architecture rules

```text
Page
→ coordena lifecycle, colaboradores e semântica

Composition
→ constrói/apresenta a UI runtime

Types
→ somente tipos estruturais/compartilhados reais

Contracts
→ somente contratos públicos reais
```

Não crie automaticamente `IPageCompositionX`, `Page.X.Types` ou novos tokens Theme.

## Stop Conditions

Pare quando:

```text
estrutura atual não foi inspecionada
host não segue o modelo TForm atual
responsabilidade da Page está indefinida
contrato específico não está justificado
lifetime/ownership exigiria mudança arquitetural
RickUIBuilder/Theme/Language não atendem ao comportamento e a decisão não foi aprovada
```

## Quality Gate

```text
[ ] Skill create-view-page foi aplicada
[ ] arquitetura atual foi confirmada
[ ] todos os placeholders foram substituídos
[ ] nenhum detalhe visual da Main foi copiado sem requisito
[ ] contrato específico está justificado quando usado
[ ] Types foram avaliados antes de criar tipo novo
[ ] lifecycle da base foi preservado
[ ] lifetime por interface foi preservado
[ ] testes foram avaliados
[ ] Method Toxicity foi revisada
[ ] documentação foi avaliada
```
