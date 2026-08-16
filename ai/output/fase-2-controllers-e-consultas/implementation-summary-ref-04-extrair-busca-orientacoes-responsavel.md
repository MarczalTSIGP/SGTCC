# REF-04 — Extrair busca de orientações do responsável

## Resumo

Foi criado o objeto de consulta `Orientations::ResponsibleListQuery`, com entrada única por `.call(tcc:, page:, term:, status:)`.

O controller `Responsible::OrientationsController` deixou de compor SQL nas actions históricas `tcc_one` e `tcc_two`. As actions agora mantêm apenas breadcrumb, chamada explícita ao objeto de consulta, `@search_url` e renderização da view existente.

## Arquivos alterados

- `app/controllers/responsible/orientations_controller.rb`: substitui a composição manual das relations em `tcc_one` e `tcc_two` por `Orientations::ResponsibleListQuery.call(...)`; remove comentários temporários, chamadas antigas comentadas e desativações locais de `Metrics/AbcSize` dessas duas actions.
- `app/services/orientations/responsible_list_query.rb`: novo objeto de consulta para listagens históricas do responsável.
- `spec/services/orientations/responsible_list_query_spec.rb`: specs unitários da composição da relação para TCC I, TCC II, status, busca textual, ordenação, paginação, duplicatas e TCC inválido.

## Comportamento preservado

- TCC I continua usando agregação equivalente ao comportamento ativo anterior: `COUNT(DISTINCT calendars.tcc) = 1` e `MIN(calendars.tcc) = Calendar.tccs.fetch(:one)`. Assim, uma orientação que avançou para TCC II não entra na listagem de TCC I.
- TCC II continua retornando orientações com ao menos um calendário TCC II, incluindo orientações migradas de TCC I para TCC II. Uma subconsulta de IDs elimina duplicatas sem combinar `DISTINCT` e `ORDER BY` na relação externa, preservando também operações como `pluck(:id)` no PostgreSQL.
- A consulta aplica `status` somente quando presente.
- A busca textual continua delegada a `Orientation.search(term)`.
- A ordenação permanece `orientations.created_at DESC`.
- A paginação continua usando `page(page)` do Kaminari.
- Breadcrumbs, nomes de parâmetros (`page`, `term`, `status`), URLs de busca, template `:index` e variáveis de view (`@orientations`, `@search_url`) foram preservados.

## Extração abandonada

Os métodos `OrientationFilter.by_tcc_one` e `OrientationFilter.by_tcc_two` não foram removidos porque ainda possuem consumidores ativos fora das duas listagens desta task:

- `app/controllers/responsible/professors_controller.rb`
- `spec/models/orientations/orientation_calendar_spec.rb`

Os scopes genéricos `Orientation.tcc_one` e `Orientation.tcc_two` também foram preservados, conforme exigido. Consumidores ativos encontrados incluem:

- `app/models/concerns/professor_orientation_filter.rb`
- `app/services/dashboard/professor_report.rb`
- `app/services/dashboard/responsible_report.rb`
- `app/controllers/tcc_one_professors/orientations_controller.rb`
- `spec/models/professors/professor_orientations_spec.rb`

A reorganização desses scopes continua pertencendo à REF-06, e a limpeza de relatórios/services de dashboard continua pertencendo à REF-08.

## Métricas antes/depois

| Métrica | Antes | Depois |
| --- | ---: | ---: |
| `Metrics/AbcSize` local nas actions | desativado em `tcc_one` e `tcc_two` | sem desativação local; RuboCop não apontou offense |
| Chamadas de consulta dentro de `tcc_one` e `tcc_two` (`joins`, `includes`, `where`, `group`, `having`, `order`, `search`, `page`) | 13 | 0 |
| Comentários temporários e desativações RuboCop removidos | 8 | 0 remanescentes nas duas actions |
| Chamadas antigas comentadas removidas | 2 | 0 remanescentes nas duas actions |
| Métodos da extração abandonada removidos | 0 | 0, por consumidores ativos confirmados |
| RuboCop no escopo alterado | não aplicável | 10 arquivos inspecionados, 0 offenses |

## Validação

Comandos executados:

```bash
bundle exec ruby -c app/services/orientations/responsible_list_query.rb
bundle exec ruby -c spec/services/orientations/responsible_list_query_spec.rb
bundle exec ruby -c app/controllers/responsible/orientations_controller.rb
```

Resultado: `Syntax OK` nos três arquivos.

```bash
bundle exec rubocop --cache false app/services/orientations/ \
  app/controllers/responsible/orientations_controller.rb \
  app/models/concerns/orientation_filter.rb \
  spec/services/orientations/
```

Resultado: 10 arquivos inspecionados, 0 offenses.

```bash
bundle exec rubocop --cache false --only Metrics/AbcSize \
  app/controllers/responsible/orientations_controller.rb
```

Resultado: 1 arquivo inspecionado, 0 offenses.

RSpec focado executado:

```bash
bundle exec rspec spec/services/orientations/ \
  spec/features/responsible/orientations/orientations_index_tcc_one_spec.rb \
  spec/features/responsible/orientations/orientations_index_tcc_two_spec.rb \
  spec/features/responsible/orientations/orientations_search_spec.rb
```

Resultado após disponibilização do ambiente Docker: 16 exemplos, 0 falhas.

Suíte completa:

```bash
bundle exec rspec
```

Resultado: 1.059 exemplos, 0 falhas e 1 pending preexistente em `WelcomeMailer`.

## Riscos e próximos passos

- Os specs unitários e de integração foram executados contra PostgreSQL no ambiente Docker.
- `OrientationFilter.by_tcc_one` e `OrientationFilter.by_tcc_two` permanecem por consumidores ativos fora do escopo permitido; a limpeza deve ser retomada quando esses consumidores forem migrados.
- `Orientation.tcc_one` e `Orientation.tcc_two` permanecem inalterados; sua reorganização pertence à REF-06.
- A limpeza dos relatórios e services de dashboard permanece para a REF-08.
