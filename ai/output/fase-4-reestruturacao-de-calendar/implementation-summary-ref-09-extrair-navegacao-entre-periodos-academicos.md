# REF-09 — Extrair navegação entre períodos acadêmicos de `Calendar`

## Resumo

Extraída a lógica de navegação temporal entre calendários (`previous_semester`, `next_semester`, `next_semester_tcc_two`) para o objeto `Calendars::PeriodNavigation`. Os três métodos auxiliares sem consumidor externo (`search_by_semester`, `search_by_first_semester_next_year`, `search_by_second_semester_previous_year`) foram movidos como métodos privados do novo objeto. `Calendar` mantém os três métodos públicos como delegadores de uma linha, preservando compatibilidade total com os consumidores existentes (view `_header.html.erb` e `Orientations::MigrationService`).

**Decisão de interface:** delegação simples — `Calendar.previous_semester(c)` chama `Calendars::PeriodNavigation.previous_semester(c)`. Cálculo do período-alvo e consulta ao banco não foram separados em classes distintas porque a separação não reduziria complexidade real: cada método já é trivialmente pequeno e há exatamente uma consulta `find_by` por caminho.

## Arquivos alterados

| Arquivo | Mudança |
|---|---|
| `app/models/calendar.rb` | Removidos 6 métodos (3 públicos + 3 auxiliares). Adicionados 3 delegadores finos. |
| `app/services/calendars/period_navigation.rb` | **Novo.** Contém toda a lógica de navegação extraída de `Calendar`. |
| `spec/services/calendars/period_navigation_spec.rb` | **Novo.** Cobertura direta de `Calendars::PeriodNavigation` com os 10 cenários dos testes existentes + caso `nil` de argumento. |

`spec/models/calendar/scope_calendar_spec.rb` foi mantido sem alteração: os testes continuam passando via delegação, o que valida também os delegadores.

## Comportamento preservado

- **`scope_calendar_spec.rb` (10 casos via `Calendar`):** todos passam.
- **`period_navigation_spec.rb` (11 casos via `Calendars::PeriodNavigation`):** todos passam.
- **`Orientations::MigrationService`** não foi alterado; continua chamando `Calendar.next_semester_tcc_two` que delega ao novo objeto.
- **`_header.html.erb`** não foi alterado; os links condicionais ainda chamam `Calendar.previous_semester` e `Calendar.next_semester` com comportamento idêntico.
- **`orientations_report_by_status`** em `Calendar` chama `next_semester` internamente — passa pelo mesmo delegador, sem impacto.

## Decisões de design

### Nome e localização

`Calendars::PeriodNavigation` em `app/services/calendars/period_navigation.rb`, seguindo o namespace já estabelecido por `Calendars::CloneBaseActivities`. O nome é explícito sobre a responsabilidade (navegação entre períodos acadêmicos).

### Estrutura interna

O objeto usa apenas métodos de classe e `private_class_method :new`, idêntico ao precedente de `CloneBaseActivities`. Os três auxiliares (`search_by_semester`, `search_by_first_semester_next_year`, `search_by_second_semester_previous_year`) tornaram-se privados via `private_class_method def self.`, padrão já usado em outros services do projeto (ex.: `Notifications::Hooks::Activity`), eliminando-os como interface pública de qualquer classe.

### Cálculo vs. consulta

Não foram separados em camadas distintas. Cada método já é uma única expressão lógica com uma única chamada `find_by`; qualquer separação adicional seria abstração prematura sem ganho concreto de clareza ou testabilidade.

### Consumidores — decisão de não migrar

View e `MigrationService` não foram migrados para chamar `Calendars::PeriodNavigation` diretamente. O custo de migração é baixo, mas manter os delegadores em `Calendar` preserva a surface pública de `Calendar` para futuros consumidores e não aumenta o escopo revisado desta task.

## Validação

### RSpec — specs relacionadas

```
bundle exec rspec spec/models/calendar/scope_calendar_spec.rb \
                   spec/services/calendars/period_navigation_spec.rb \
                   spec/services/orientations/migration_service_spec.rb
```

**Resultado:** 32 examples, 0 failures

### Suíte completa, incluindo features (via `docker compose run --rm --name tests tests ...`)

```
bundle exec rspec
```

**Resultado:** 1111 examples, 0 failures, 1 pending (WelcomeMailer — pendente pré-existente)

### RuboCop — projeto completo

```
bundle exec rubocop --parallel
```

**Resultado:** 804 files inspected, no offenses detected

> Nota: uma violação de `Style/IfUnlessModifier` + `Layout/LineLength` foi detectada e corrigida durante a implementação, ao converter o modificador `if` de linha longa em bloco `if/else` no método `next_semester_tcc_two`.
>
> A primeira rodada de validação desta task havia excluído `spec/features/**` "por tempo" e rodado o RuboCop apenas nos dois arquivos alterados. Essa validação foi refeita depois com a suíte completa e o RuboCop no projeto inteiro, usando o nome de container `tests` exigido para a resolução do host do Capybara/Selenium — ambos passaram sem falhas.

## Riscos e próximos passos

### REF-10 — consultas e relatórios remanescentes em `Calendar`

Os seguintes métodos permanecem em `Calendar` e são alvo da REF-10:

- `search_by_tcc` / `search_by_tcc_one` / `search_by_tcc_two` — têm consumidores em controllers/views.
- `select_data` / `select_for_orientation` — usados em formulários de seleção.
- `by_first_year_and_tcc` — usado internamente por `orientations_report_by_status`.
- `orientations_report_by_status` — a ser confirmado na REF-10: `grep -rn "orientations_report_by_status" app/` não encontrou consumidor fora de `calendar.rb`; o mesmo para `by_first_year_and_tcc`. Ambos devem ser investigados e registrados formalmente na REF-10.

### Sem regressões identificadas

Todos os consumidores conhecidos (`_header.html.erb`, `MigrationService`, `orientations_report_by_status`) continuam funcionando via delegadores ou chamadas internas preservadas.
