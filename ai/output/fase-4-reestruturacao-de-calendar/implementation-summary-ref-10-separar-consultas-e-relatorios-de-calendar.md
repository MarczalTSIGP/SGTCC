# REF-10 — Separar consultas e relatórios de `Calendar`

## Resumo

Extraídas as duas responsabilidades de consulta/apresentação que ainda restavam em `Calendar`: a busca paginada por TCC, para `Calendars::ListQuery`, e a montagem de opções de select, para `Calendars::SelectOptions`. Os cinco pontos de consumo (três controllers, duas views) foram migrados para chamar os novos objetos diretamente — não foram mantidos delegadores em `Calendar`, seguindo o critério de aceite do roadmap de que `Calendar` "deixa de coordenar relatórios e estruturas destinadas à interface".

`orientations_report_by_status` e `by_first_year_and_tcc` foram removidos como código morto confirmado: nenhum consumidor foi encontrado em `app/`, `spec/` ou no restante do repositório, e o histórico do Git mostra que o último consumidor real (um gráfico de linha do dashboard) foi perdido na migração Vue → Hotwire (commit `60ebf5e1`).

## Arquivos alterados

| Arquivo | Mudança |
|---|---|
| `app/models/calendar.rb` | Removidos `search_by_tcc`, `search_by_tcc_one`, `search_by_tcc_two`, `select_data`, `select_for_orientation`, `by_first_year_and_tcc`, `orientations_report_by_status`. Nenhum delegador foi mantido — os cinco primeiros foram migrados, os dois últimos eram código morto. |
| `app/services/calendars/list_query.rb` | **Novo.** `Calendars::ListQuery.call(tcc:, page:, term:)`, reproduz exatamente a consulta antes em `search_by_tcc`. |
| `app/services/calendars/select_options.rb` | **Novo.** `Calendars::SelectOptions.for_tcc(tcc)` e `.for_orientation`, reproduzem exatamente `select_data`/`select_for_orientation`. |
| `app/controllers/responsible/calendars_controller.rb` | `#tcc_one`/`#tcc_two` migrados para `Calendars::ListQuery.call`. |
| `app/controllers/tcc_one_professors/calendars_controller.rb` | `#tcc_one` migrado para `Calendars::ListQuery.call`. |
| `app/views/responsible/activities/_activity_calendar_select.html.erb` | `collection` migrada para `Calendars::SelectOptions.for_tcc(@calendar.tcc)`. |
| `app/views/responsible/orientations/_form.html.erb` | `collection` migrada para `Calendars::SelectOptions.for_orientation`. |
| `spec/models/calendar/scope_calendar_spec.rb` | Removido o bloco `#search_by_tcc` (método não existe mais em `Calendar`); removidas as caracterizações de `select_data`/`select_for_orientation` escritas nesta task antes da extração (movidas para o novo spec). |
| `spec/services/calendars/list_query_spec.rb` | **Novo.** Cobertura de `Calendars::ListQuery.call` para `tcc: :one` e `tcc: :two`. |
| `spec/services/calendars/select_options_spec.rb` | **Novo.** Cobertura de `.for_tcc`/`.for_orientation`, escrita primeiro contra `Calendar.select_data`/`select_for_orientation` (caracterização, verde antes da extração) e depois adaptada para o objeto extraído. |

## Comportamento preservado

- **Busca paginada:** os dois casos de `spec/services/calendars/list_query_spec.rb` (encontrar por TCC I e por TCC II) passam, reproduzindo a mesma consulta (`where(tcc:).page(page).search(term).order(year: :desc, semester: :desc)`).
- **Selects:** `spec/services/calendars/select_options_spec.rb` cobre ordenação (ano desc, depois semestre/tcc) e o formato exato dos pares `[id, label]`, usando os mesmos formatadores `year_with_semester`/`year_with_semester_and_tcc` que o model já expunha. Esses testes foram escritos e rodados primeiro contra `Calendar.select_data`/`select_for_orientation` (caracterização, baseline verde com 18 examples) antes de qualquer extração — não havia teste direto para esses dois métodos antes desta task.
- **Consumidores:** os specs de feature `spec/features/responsible/calendars/`, `spec/features/tcc_one_professors/calendars/`, `spec/features/responsible/activities/activities_create_spec.rb` e `spec/features/responsible/orientations/orientations_create_spec.rb` passam sem alteração (18 examples), confirmando que as três actions e as duas views continuam funcionando de ponta a ponta.

## Achado: código morto confirmado

- `grep -rn "orientations_report_by_status\|by_first_year_and_tcc" .` (excluindo `.git/` e `ai/`) não encontrou nenhum consumidor além da própria definição em `calendar.rb`, antes da remoção.
- `git log --all -S"orientations_report_by_status" --oneline` mostra os commits `a92b8691` ("Add in progress, renewed, and canceled numbers to orientations line chart"), `ac825e73` ("Fix/fix the orientations status and all dashboard area") e `60ebf5e1` ("Major Refactor: Rails Upgrade, Hotwire Migration & Infrastructure Improvements"). Este último migrou os gráficos do dashboard de componentes Vue (`academics-report.vue`, `card-report-number.vue`) para ViewComponents Ruby (`app/components/charts/*`) e alterou `Responsible::CalendarsController` sem preservar a chamada ao método — ele ficou implementado e íntegro, mas sem consumidor, desde essa migração.
- Nenhum consumidor alternativo (chamada dinâmica, uso fora de `app/`/`spec/`) foi encontrado durante a implementação; a contingência descrita na task (extrair em vez de remover) não se aplicou.

## Validação

### Specs relacionadas

```
docker compose run --rm --name tests tests bundle exec rspec \
  spec/models/calendar/ spec/services/calendars/ \
  spec/features/responsible/calendars/ \
  spec/features/tcc_one_professors/calendars/ \
  spec/features/responsible/activities/activities_create_spec.rb \
  spec/features/responsible/orientations/orientations_create_spec.rb
```

**Resultado:** 60 + 18 examples, 0 failures (rodados em duas chamadas separadas durante a implementação).

### RuboCop — arquivos alterados

```
docker compose run --rm --name tests tests bundle exec rubocop \
  app/models/calendar.rb app/services/calendars/ \
  app/controllers/responsible/calendars_controller.rb \
  app/controllers/tcc_one_professors/calendars_controller.rb \
  spec/models/calendar/ spec/services/calendars/
```

**Resultado:** 15 files inspected, no offenses detected (duas violações corrigidas durante a implementação: `Layout/LineLength` em `list_query.rb` e `RSpec/MultipleExpectations` em `select_options_spec.rb`, resolvida separando os testes por asserção).

### Suíte completa

```
docker compose run --rm --name tests tests bundle exec rspec
```

**Resultado:** 1118 examples, 0 failures, 1 pending (WelcomeMailer — pendência pré-existente, não relacionada).

### RuboCop — projeto completo

```
docker compose run --rm --name tests tests bundle exec rubocop --parallel
```

**Resultado:** 808 files inspected, no offenses detected.

## Riscos e próximos passos

- `Calendars::ListQuery` e `Orientations::TccListQuery`/`ExaminationBoards::ListQuery` seguem o mesmo padrão de nome de entrada (`.call`) já estabelecido nas fases anteriores; não há duplicação de lógica entre eles — cada um encapsula uma consulta de domínio diferente.
- `Calendar` agora expõe apenas validações, associações, `set_dates`, `current?`, `orientation_by_academic`, os formatadores `year_with_semester`/`year_with_semester_and_tcc` e os três delegadores de navegação da REF-09. A Fase 4 do roadmap está concluída.
- Nenhuma duplicação remanescente identificada para a Fase 5 (Components e apresentação) a partir desta task.
