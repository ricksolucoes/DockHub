# Documentação do DockHub

[English — Official](./README.md)

Este diretório reúne a documentação dos componentes que já existem no código do DockHub e os Architecture Decision Records referentes a decisões que impactam diretamente sua manutenção futura.

## Documentação atual

| Documento | Finalidade |
| --- | --- |
| [Módulo de Idiomas](./modules/language/README.pt-BR.md) | Arquitetura, contratos, comportamento em runtime, fallback, cache, exceções, integração com a View, manutenção e evolução do `Core.Language`. |
| [ADR-0001 — Arquitetura de Idiomas](./adr/ADR-0001-language-architecture.pt-BR.md) | Registra por que a arquitetura atual foi escolhida e quais decisões foram propositalmente adiadas. |
| [Testes Automatizados](../tests/README.pt-BR.md) | Estrutura do projeto DUnitX, execução, inventário atual dos testes, resultados e lacunas de cobertura conhecidas. |

## Regras da documentação

A documentação deste repositório segue estas regras:

- descrever somente comportamento implementado ou explicitamente identificado como futuro;
- separar comportamento implementado de comportamento efetivamente coberto por testes;
- não apresentar reorganização arquitetural como funcionalidade para o usuário;
- manter contratos públicos, GUIDs, nomes de units e caminhos coerentes com o código;
- registrar evoluções futuras como pontos de avaliação, e não como capacidades atuais;
- manter o inglês como documentação oficial do projeto e fornecer tradução em português do Brasil para os documentos principais.
