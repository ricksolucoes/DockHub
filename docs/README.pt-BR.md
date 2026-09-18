# Documentação do DockHub

[English — Official](./README.md)

Este diretório reúne a documentação dos componentes que já existem no código do DockHub e os Architecture Decision Records referentes a decisões que impactam diretamente sua manutenção futura.

## Documentação atual

| Documento | Finalidade |
| --- | --- |
| [Módulo de Idiomas](./modules/language/README.pt-BR.md) | Arquitetura, contratos, comportamento em runtime, fallback, cache, exceções, integração com a View, manutenção e evolução do `Core.Language`. |
| [Módulo de Theme](./modules/theme/README.pt-BR.md) | Arquitetura, contrato, tokens semânticos, troca em runtime, gradiente, integração com a Main View, testes, manutenção e evolução prevista de `View.Theme`. |
| [Arquitetura de Pages da View](./modules/view/README.pt-BR.md) | Organização de `View.Page`, boundary físico por Page, responsabilidade de `Composition`, eventos, integração com Theme/Language e regras de crescimento. |
| [RickUIBuilder — Referência de Integração do DockHub](./dependencies/rickuibuilder/README.pt-BR.md) | Snapshot upstream analisado, funcionamento de Factory/Fluent/Composition, ownership, eventos, handles, limitações e regras de integração com Theme/Language do DockHub. |
| [Identidade Visual](./modules/theme/VISUAL-IDENTITY.pt-BR.md) | Valores completos Delphi e CSS/Web das paletas Blue, Teal, Light e Dark, mantidos como referência visual reutilizável. |
| [ADR-0001 — Arquitetura de Idiomas](./adr/ADR-0001-language-architecture.pt-BR.md) | Registra por que a arquitetura atual foi escolhida e quais decisões foram propositalmente adiadas. |
| [ADR-0002 — Arquitetura de Theme](./adr/ADR-0002-theme-architecture.pt-BR.md) | Registra a arquitetura atual do Theme, suas fronteiras de responsabilidade e as decisões de propagação/estado compartilhado adiadas para avaliação futura. |
| [ADR-0003 — Arquitetura de Pages e Composição Runtime da View](./adr/ADR-0003-view-page-architecture.pt-BR.md) | Registra a organização por Page e a separação entre ciclo de vida/comportamento da Page e composição visual runtime. |
| [Testes Automatizados](../tests/README.pt-BR.md) | Estrutura do projeto DUnitX, execução, inventário atual dos testes, resultados e lacunas de cobertura conhecidas. |

## Regras da documentação

A documentação deste repositório segue estas regras:

- descrever somente comportamento implementado ou explicitamente identificado como futuro;
- separar comportamento implementado de comportamento efetivamente coberto por testes;
- não apresentar reorganização arquitetural como funcionalidade para o usuário;
- manter contratos públicos, GUIDs, nomes de units e caminhos coerentes com o código;
- registrar evoluções futuras como pontos de avaliação, e não como capacidades atuais;
- manter o inglês como documentação oficial do projeto e fornecer tradução em português do Brasil para os documentos principais.
