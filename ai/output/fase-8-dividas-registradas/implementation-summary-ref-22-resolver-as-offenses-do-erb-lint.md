# REF-22 — Resumo de implementação

## Resumo

ERB Lint de **2006 para 758 offenses**, em dois commits separados, como a task
exige: um de configuração e correção manual, outro exclusivamente mecânico.

| Etapa | Offenses | O que saiu |
|---|---:|---|
| Estado inicial | 2006 | — |
| Parte 1 — configuração + `Rails/LinkToBlank` | 967 | 1018 + 21 |
| Parte 2 — autocorrect de formatação | 758 | 209 |

Nenhuma view foi reindentada. Suíte: 1177 exemplos, 0 falhas, 1 pendente.

O número inicial difere dos 2013 registrados na task porque a REF-20 eliminou
oito views duplicadas de TEP e TSO no commit anterior.

## Parte 1 — a metade do relatório que era conflito de configuração

`SpaceIndentation` desligado no `.erb_lint.yml`, com o motivo no arquivo: o
`.rubocop.yml` desliga `Layout/IndentationStyle` explicitamente, o projeto aceita
tabulação, e as views seguem a mesma convenção. O linter é nativo do ERB Lint e
não é alcançado pelo `inherit_from: .rubocop.yml`, então a decisão precisava ser
repetida. **1018 offenses**, metade do relatório, eram a ferramenta cobrando uma
convenção que o projeto já decidiu não seguir.

### A varredura pedida pela task

Dos 15 cops desligados no `.rubocop.yml`, **só `Layout/IndentationStyle` tem
equivalente nativo** no ERB Lint. Os demais são cops Ruby, cobertos pelo
`inherit_from`.

Vale registrar o que **não** é conflito, porque parece: o `.erb_lint.yml` já
desligava `Layout/TrailingEmptyLines`, `Layout/TrailingWhitespace` e
`Layout/InitialIndentation`. Isso não é decisão de convenção — é consequência de
como o linter `rubocop` funciona dentro do ERB: ele analisa o trecho Ruby de
dentro de cada tag como se fosse um arquivo, e nesse recorte esses três cops
disparam sempre, em qualquer projeto. Os linters nativos equivalentes
(`final_newline`, `trailing_whitespace`) olham o arquivo de verdade, continuam
ligados e apontavam problema real — corrigido na parte 2.

### `Rails/LinkToBlank` — as 21 com efeito real

Corrigidas com `rel: 'noopener'`, uma a uma. Antes de mexer, verificado que
nenhuma depende de `window.opener`: não há **uma única ocorrência** de
`window.opener` em `app/javascript`, `app/assets` ou `app/views`, e os 21 links
abrem PDF de atividade, arquivo complementar, arquivo de apontamentos, imagem do
site, documento anexado, Lattes ou página pessoal — todos saída de conteúdo, sem
interação de volta com a página que abriu.

| Área | Ocorrências |
|---|---:|
| `academics/activities` | 4 |
| `shared/examination_boards` | 4 |
| `site/` | 5 |
| `responsible/` | 6 |
| `shared/orientation_activities` | 2 |

Specs das 16 views alteradas: 88 exemplos, 0 falhas.

## Parte 2 — correção automática, e por que ela parou onde parou

`erb_lint --autocorrect` restrito a sete linters nativos de formatação:
`final_newline`, `trailing_whitespace`, `extra_newline`, `space_around_erb_tag`,
`space_in_html_tag`, `self_closing_tag`, `closing_erb_tag_indent`.

217 correções em 118 arquivos, +126/−214 linhas. O diff inteiro foi revisado:
com `git diff -w`, restam **78 linhas** alteradas, de dois tipos apenas.

- **Void elements**: `<hr />`, `<meta … />`, `<img … />`, `<input … />` perdem a
  barra. HTML5, DOM idêntico.
- **`>` de abertura de tag** que estava sozinho numa linha sobe para o fim da
  última linha de atributo. Espaço dentro de tag é insignificante.

Todo o resto é whitespace. Verificado que nenhuma view alterada tem conteúdo com
espaço significativo — o único arquivo com `pre` é `layouts/mailer.html.erb`,
onde são regras CSS dentro de `<style>`, não conteúdo.

### O linter `rubocop` foi avaliado e rejeitado

A task pede para avaliar a correção automática também para alinhamento de
argumento. Avaliei: rodei `--enable-linters rubocop --autocorrect`, medi, e
**descartei**. Dois motivos, os dois verificados no diff produzido.

**1. Ela reindentaria views, contra o critério de aceite e contra a decisão da
parte 1.** O RuboCop conta tabulação como uma coluna. Em views indentadas com
tab, ele mantém os tabs e completa com espaços:

```erb
-		       class: 'list-group-item list-group-item-action') do %>
+		                     class: 'list-group-item list-group-item-action') do %>
```

O resultado é indentação misturada, alinhada só para quem enxerga tab como um
caractere. **13 arquivos** ficariam assim — exatamente a convenção que a parte 1
decidiu respeitar ao desligar o `SpaceIndentation`.

**2. Ela não é mecânica.** Foram 892 correções em 169 arquivos, +994/−975, e
junto com o alinhamento vinham reescritas de código:

- `.map { |p| p['id'] }` → `.pluck('id')`;
- ternário multilinha → `if` dentro de atributo HTML;
- `presence ||`, `dig`, `&.`, `Model.all.order` → `Model.order`.

São 20 offenses de `Rails/*` e ~14 de `Style/*` que mudam código, não formatação.
Cada uma pode estar certa, mas nenhuma cabe num commit "exclusivamente mecânico",
e misturá-las com 202 alinhamentos é o oposto de revisável.

A árvore foi restaurada com `git checkout -- app/` depois da medição; nada dessa
avaliação foi commitado.

## As 758 que ficaram, e a decisão de cada grupo

| Grupo | Qtd | Decisão |
|---|---:|---|
| `Style/StringLiterals` | 373 | Adiado. Aspas do Ruby dentro das tags, zero efeito na saída. A task já autoriza adiar. Cabe um commit mecânico próprio. |
| Alinhamento (`Layout/*`, 14 cops) | 303 | **Rejeitado**, não adiado. Corrigir automático reindenta 13 views com mistura de tab e espaço; corrigir à mão são 303 pontos sem ganho. |
| `Style/SingleArgumentDig` | 27 | Adiado, junto com `StringLiterals`. A task autoriza. |
| `Rails/*` e `Lint/*` | 21 | Cada uma é uma mudança de código que pede julgamento individual: `RedundantActiveRecordAllMethod` (14), `Pluck` (2), `Presence` (2), `SafeNavigationWithBlank` (2), `RedundantSafeNavigation` (1). Fora do escopo de uma task de lint. |
| `ErbSafety` | 10 | **O grupo que merece uma task própria.** Ver abaixo. |
| Demais `Style/*` | 22 | Ternário aninhado, `rescue` modificador, parênteses — revisão manual, baixa prioridade. |
| `RequireInputAutocomplete` | 2 | Campos de busca. Acessibilidade; correção trivial, mas muda HTML e ficou fora do commit mecânico. |

### `ErbSafety` — registrado como achado, não corrigido

Dez interpolações que o linter considera inseguras:

- **5 em `app/views/kaminari/`** — `<%= raw(...) %>` nos templates de paginação.
  São overrides dos templates do próprio gem, copiados como vieram.
- **4 `<%= (...).html_safe %>`** — entre elas `responsible/professors/show.html.erb:30`
  e `site/professor.html.erb:24`, o `link_to(...).html_safe` do Lattes, onde o
  `.html_safe` é redundante: `link_to` já devolve string segura.
- **1 interpolação em atributo JavaScript** sem `to_json`.

Nenhuma foi corrigida aqui: `html_safe` e `raw` sobre conteúdo vindo do banco
exigem olhar o que chega em cada um, o que é uma análise de segurança, não de
estilo. Fica registrado como candidato a task própria.

## Validação

| Comando | Resultado |
|---|---|
| `erb_lint --lint-all` | 758 offenses (era 2006) |
| `rspec` | 1177 exemplos, 0 falhas, 1 pendente |
| `rubocop --parallel` | 819 arquivos, 0 offenses |
| Cobertura | 96,63%, inalterada |

Os specs das views alteradas passam, o que sustenta que o HTML não mudou de
forma observável: a parte 2 não tem uma única alteração fora de whitespace e
void element, e a parte 1 acrescenta um atributo `rel` — que é o objetivo.

## Limites preservados

- Nenhuma view reindentada.
- Nenhuma alteração de comportamento, rota ou regra de negócio.
- Correção automática e correção manual em commits separados.
