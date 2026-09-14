# Task

REF-22 — Resolver as 2013 offenses do ERB Lint, decidindo caso a caso entre alinhar a configuração e corrigir as views.

# Dependência

- REF-13D, que voltou a tornar o ERB Lint executável e registrou as offenses como estado atual.

# Contexto

O ERB Lint não rodava desde antes do baseline, por configuração obsoleta. A REF-13D corrigiu isso e a ferramenta passou a reportar **2013 offenses**, deliberadamente não corrigidas.

Distribuição atual:

| Tipo | Ocorrências | Natureza |
|---|---:|---|
| `Indent with spaces instead of tabs.` | 1018 | **conflito de configuração** |
| `Style/StringLiterals` | 377 | estilo, via RuboCop |
| `Layout/ArgumentAlignment` | 202 | formatação, via RuboCop |
| Múltiplas linhas em branco no fim do arquivo | 58 | formatação |
| Espaço em branco no fim da linha | 54 | formatação |
| `Layout/FirstArgumentIndentation` | 44 | formatação, via RuboCop |
| `Style/SingleArgumentDig` | 27 | estilo, via RuboCop |
| Falta de nova linha no fim do arquivo | 23 | formatação |
| `Rails/LinkToBlank` | 21 | **acessibilidade/segurança** |
| Demais tipos | ~189 | variados |

## O conflito de indentação

Metade das offenses vem de um único linter. O `.rubocop.yml` do projeto desliga explicitamente `Layout/IndentationStyle` (linha 120), aceitando tabulação no código Ruby. As views ERB seguem a mesma convenção.

Mas o linter que gera essas 1018 offenses **não é** o `Layout/IndentationStyle` do RuboCop: é o `space_indentation`, linter nativo do ERB Lint, que não é alcançado pelo `inherit_from: .rubocop.yml` do `.erb_lint.yml`. Ou seja, o projeto já decidiu aceitar tab, e a ferramenta está reclamando por um caminho que a decisão não cobriu.

**Reindentar 1018 pontos contrariaria uma convenção já adotada** e produziria um diff gigante sem ganho.

## `Rails/LinkToBlank`

As 21 ocorrências desse cop são as únicas com efeito além de estilo: `link_to` com `target: '_blank'` sem `rel="noopener"` expõe a página aberta ao `window.opener`. Merecem tratamento diferente do resto.

# Objetivo

Deixar o ERB Lint em um estado em que a saída signifique alguma coisa — sem ruído que ninguém vai corrigir e sem esconder o que importa.

# Escopo obrigatório

## 1. Alinhar a configuração com a convenção do projeto

- Desligar o linter `space_indentation` no `.erb_lint.yml`, deixando comentado o motivo: o projeto aceita tab e já desliga o cop equivalente no `.rubocop.yml`.
- Revisar se algum outro linter nativo do ERB Lint conflita com decisão já tomada no `.rubocop.yml` e tratá-lo do mesmo modo.

## 2. Corrigir o que tem efeito real

- Corrigir as 21 ocorrências de `Rails/LinkToBlank`, adicionando `rel` apropriado. **Verificar antes** se algum link depende de `window.opener` — se depender, documentar em vez de mudar.

## 3. Decidir sobre o restante, com critério explícito

- Para as offenses puramente de formatação (espaço no fim de linha, linhas em branco no fim do arquivo, falta de nova linha final, alinhamento de argumento), avaliar a correção automática (`erb_lint --autocorrect`) em um commit **separado** e exclusivamente mecânico.
- Se a correção automática alterar HTML renderizado em qualquer view, **reverter** essa view e tratá-la à mão. O critério é o de sempre: a saída visual não muda.
- `Style/StringLiterals` e `Style/SingleArgumentDig` podem ficar para depois — registrar a decisão em vez de corrigir por corrigir.

# Fora do escopo

- Não reindentar views.
- Não alterar comportamento, rotas ou regra de negócio.
- Não misturar correção automática com correção manual no mesmo commit.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- `bundle exec erb_lint --lint-all` roda e o total de offenses cai substancialmente, com o número novo registrado.
- Nenhuma view foi reindentada.
- As 21 ocorrências de `Rails/LinkToBlank` estão corrigidas ou justificadas uma a uma.
- As offenses que permanecem estão listadas por tipo, com a decisão de cada grupo registrada.
- Os feature specs das views alteradas passam, comprovando que o HTML não mudou.
- Suíte completa e RuboCop sem novas falhas ou offenses.

# Validação sugerida

```bash
docker compose exec -T tests bundle exec erb_lint --lint-all 2>&1 | tail -3
docker compose exec -T tests bundle exec erb_lint --lint-all --show-linter-names 2>&1 | head -20
git diff --stat
docker compose exec -T tests bundle exec rspec
docker compose exec -T tests bundle exec rubocop --parallel
```
