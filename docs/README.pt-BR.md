# Documentação do DockHub

[English — Official](./README.md)

Este diretório reúne a documentação dos componentes que já existem no código do DockHub e os Architecture Decision Records referentes a decisões que impactam diretamente sua manutenção futura.

## Documentação atual

| Documento | Finalidade |
| --- | --- |
| [Sistema de Desenvolvimento por IA](./ai/README.md) | Governança e workflows reutilizáveis de Agents, Skills e Templates, incluindo criação de `View.Page` e disciplina de validação de Method Toxicity. |
| [Módulo de Idiomas](./modules/language/README.pt-BR.md) | Arquitetura, contratos, comportamento em runtime, fallback, cache, exceções, integração com a View, manutenção e evolução do `Core.Language`. |
| [Módulo de Theme](./modules/theme/README.pt-BR.md) | Arquitetura, contrato, tokens semânticos, troca em runtime, gradiente, integração com a Main View, testes, manutenção e evolução prevista de `View.Theme`. |
| [Arquitetura de Pages da View](./modules/view/README.pt-BR.md) | Estrutura atual de `View.Page`, `Types / Contracts / Impl`, lifecycle da Composition, lifetime por interface, responsabilidades da Main, integração Theme/Language e regras de crescimento. |
| [RickUIBuilder — Referência de Integração do DockHub](./dependencies/rickuibuilder/README.pt-BR.md) | Snapshot upstream analisado, funcionamento de Factory/Fluent/Composition, ownership, eventos, handles, limitações e regras de integração com a Composition das Pages do DockHub. |
| [Identidade Visual](./modules/theme/VISUAL-IDENTITY.pt-BR.md) | Valores completos Delphi e CSS/Web das paletas Blue, Teal, Light e Dark, mantidos como referência visual reutilizável. |
| [ADR-0001 — Arquitetura de Idiomas](./adr/ADR-0001-language-architecture.pt-BR.md) | Registra por que a arquitetura atual foi escolhida e quais decisões foram propositalmente adiadas. |
| [ADR-0002 — Arquitetura de Theme](./adr/ADR-0002-theme-architecture.pt-BR.md) | Registra a arquitetura atual do Theme, suas fronteiras de responsabilidade e as decisões de propagação/estado compartilhado adiadas para avaliação futura. |
| [ADR-0003 — Arquitetura de Pages substituída](./adr/ADR-0003-view-page-architecture.pt-BR.md) | Preserva para histórico a decisão anterior baseada em diretório próprio por Page. |
| [ADR-0004 — Arquitetura de Composição das Pages da View](./adr/ADR-0004-view-page-composition-architecture.pt-BR.md) | Registra a estrutura vigente `Types / Contracts / Impl`, lifecycle abstrato da Composition, lifetime por interface e regras de compositions específicas. |
| [Testes Automatizados](./testing/README.pt-BR.md) | Estrutura do projeto DUnitX, inventário de testes no fonte, evidência de execução, evidência de Method Toxicity e lacunas conhecidas. |

## Regras da documentação

A documentação do projeto deve permanecer dentro de `docs/`. As únicas exceções documentais são `README.md` / `README.pt-BR.md` na raiz do repositório e arquivos `README.md` operacionais em `.ai/templates/**/`, usados exclusivamente para orientar Agents/Skills sobre o template local. Artefatos de governança da IA, como `.ai/AGENTS.md`, definições de Agents e arquivos `SKILL.md`, permanecem em `.ai` porque são instruções operacionais e não documentação técnica do projeto.

A documentação deste repositório segue estas regras:

- descrever somente comportamento implementado ou explicitamente identificado como futuro;
- separar comportamento implementado, comportamento testado e evidência histórica de execução;
- não apresentar reorganização arquitetural como funcionalidade para o usuário;
- manter contratos públicos, GUIDs, nomes de units e caminhos coerentes com o código;
- preservar ADRs substituídos em vez de reescrever o histórico arquitetural;
- registrar evoluções futuras como pontos de avaliação, e não como capacidades atuais;
- manter o inglês como documentação oficial do projeto e fornecer tradução em português do Brasil para os documentos principais.
