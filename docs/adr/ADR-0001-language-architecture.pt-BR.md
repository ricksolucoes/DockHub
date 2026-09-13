# ADR-0001 — Arquitetura de Idiomas do DockHub

[English — Official](./ADR-0001-language-architecture.md)

- **Status:** Aceito
- **Escopo:** `DockHub.Core.Language`
- **Tipo de decisão:** Arquitetura interna / infraestrutura de localização

## Contexto

O DockHub exige que textos destinados ao usuário sejam resolvidos por um componente centralizado de idioma, em vez de ficarem embutidos diretamente em Forms e código de apresentação. O idioma selecionado deve poder mudar em runtime, enquanto o português do Brasil permanece como idioma oficial/default e fallback obrigatório.

O projeto já utiliza no subsistema Theme um padrão estrutural baseado em `Types`, `Contracts` e `Impl`, consumo orientado a interfaces, `TInterfacedObject`, GUID explícito e método `New`. O módulo Language foi estruturado para permanecer coerente com esse padrão, sem introduzir catálogos externos ou um framework mais amplo antes de existir necessidade real.

## Decisão

As decisões abaixo ficam aceitas para a implementação atual.

### 1. Estrutura do módulo

Language fica em `src/core/language` e é separado em:

```text
Types
Contracts
Impl
Keys
Translations/<Language>
```

Cada idioma possui uma unit de tradução independente.

### 2. Tipo de idioma

Os idiomas suportados são representados por scoped enum:

```pascal
TDockHubLanguageType = (PtBR, EnUS);
```

`TDockHubLanguageHelper` concentra as conversões técnicas (`ToString`, `ToCultureCode`, `FromString`).

### 3. Tipo de chave

As chaves usam um tipo string semântico:

```pascal
TDockHubTranslationKey = type string;
```

As chaves são declaradas como constantes próximas do escopo do consumidor/módulo, e as constantes do projeto seguem a convenção de prefixo `_`.

Exemplo:

```pascal
_VIEW_MAIN_CAPTION = 'View.Main.Caption';
```

### 4. Contrato e implementação

Consumidores dependem de `IDockHubLanguage`. A implementação atual é `TDockHubLanguage = class sealed(TInterfacedObject, IDockHubLanguage)` e normalmente é criada por `TDockHubLanguage.New`.

GUID da interface:

```text
{7B6C1A0B-E84C-4EC0-93E1-F3C3C61873CD}
```

### 5. Idioma oficial e fallback

`PtBR` é o catálogo oficial/default.

Quando uma chave não existe em um idioma secundário suportado, a resolução utiliza `PtBR`. Se a chave também não existir em `PtBR`, é gerada `EDockHubTranslationNotFound`.

A ausência do idioma inteiro não é tratada como fallback. Um idioma não implementado gera `EDockHubLanguageNotSupported`.

### 6. Modelo de memória

A implementação mantém:

```text
FDefaultTranslations = PtBR, residente durante toda a vida do objeto
FCurrentTranslations = idioma secundário selecionado, ou nil para PtBR
```

Não são mantidos dictionaries para todos os idiomas simultaneamente.

### 7. Cache de fallback

Quando uma consulta em idioma secundário utiliza `PtBR` com sucesso, o valor resolvido é cacheado em `FCurrentTranslations`. A próxima consulta da mesma chave atinge primeiro o dictionary corrente.

O cache é descartado quando o idioma secundário muda ou quando o sistema retorna para `PtBR`.

### 8. Substituição transacional do idioma

O novo catálogo secundário é construído integralmente antes que o dictionary e o estado do idioma corrente sejam substituídos. Uma falha no carregamento preserva o estado válido anterior.

### 9. Validação central do registro

As units de idioma recebem um callback de registro em vez de acesso direto ao dictionary. `TDockHubLanguage.AddTranslation` centraliza validações de chave vazia, valor vazio e duplicidade.

### 10. Atualização da View

A UI atual utiliza `ApplyLanguage` explicitamente em cada View. `TPageMain` aplica o Caption chamando `Translate`.

Notificação automática por Observer/evento foi propositalmente adiada até que múltiplas janelas ou componentes independentes justifiquem essa necessidade.

## Consequências

### Positivas

- textos destinados ao usuário possuem um único caminho de resolução;
- comportamento público do Language permanece atrás de interface;
- fallback `pt-BR` é determinístico;
- somente um catálogo secundário opcional permanece em memória;
- conteúdo das traduções fica separado da lógica de resolução;
- novas traduções não transformam a Impl em um grande arquivo de textos;
- falha no carregamento de um novo idioma não destrói o estado válido atual;
- a solução pode evoluir para múltiplas Views preservando `ApplyLanguage`.

### Trade-offs

- a implementação possui um `case` explícito ligando o enum ao loader de idioma;
- adicionar idioma exige atualizar helper e `BuildTranslations`;
- entradas de fallback cacheadas não diferenciam internamente tradução nativa de texto herdado de `pt-BR`;
- `TPageMain` ainda possui sua própria instância de Language, portanto não existe contexto global compartilhado;
- não existe sincronização para mutações/cache concorrentes.

## Alternativas rejeitadas/adiadas

### Catálogos externos JSON

Adiado. O projeto atual não exige atualização/deployment independente das traduções, e introduzir essa infraestrutura agora não possui necessidade comprovada.

### Enum global para todas as chaves

Rejeitado para o desenho atual. Isso concentraria identidades textuais de todos os módulos em um único enum crescente e aumentaria acoplamento entre áreas independentes.

### Todos os idiomas permanentemente carregados

Rejeitado. A estratégia atual mantém `PtBR` e, no máximo, um catálogo secundário.

### Observer desde a primeira implementação

Adiado. O tamanho atual da UI não exige um barramento de notificação. No futuro, o Observer deve disparar os `ApplyLanguage` existentes, e não mover o mapeamento visual para o serviço de idioma.

### Textos finais dentro da View

Rejeitado. Textos finais destinados ao usuário pertencem aos catálogos de tradução, não ao código de apresentação ou recursos da Form.

## Gatilhos para reavaliar este ADR

Reavaliar quando ocorrer um ou mais dos seguintes pontos:

- múltiplas Forms precisarem reagir a uma única troca de idioma;
- for necessário um contexto global compartilhado de idioma;
- a preferência precisar ser persistida entre execuções;
- traduções precisarem ser atualizadas independentemente do executável;
- worker threads compartilharem e alterarem o Language;
- tamanho dos catálogos tornar consumo de memória/carga mensurável;
- for desejável enforcement automatizado da regra de não utilizar texto direto.

## Validação

A suíte DUnitX atual foi executada com 17 testes aprovados, 0 falhas, 0 erros e 0 leaks. Os testes atuais cobrem diretamente helpers, idioma default, troca em runtime, Caption da Main em `PtBR` e `EnUS` e exceções de chave ausente. A cobertura direta dos branches de fallback/cache permanece pendente até existir uma chave de produção adequada ou um seam específico de teste no futuro.
