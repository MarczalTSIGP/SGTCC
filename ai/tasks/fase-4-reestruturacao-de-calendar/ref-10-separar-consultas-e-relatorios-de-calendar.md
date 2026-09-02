# Task

REF-10 — Extrair de `Calendar` a busca paginada por TCC e a montagem de opções para selects, migrando os consumidores para os objetos extraídos; remover `orientations_report_by_status`/`by_first_year_and_tcc` como código morto confirmado, sem alterar nenhum resultado observável.

# Contexto

Após a REF-09, `app/models/calendar.rb` ainda concentra, além de validações/associações/`set_dates` (fora de escopo), cinco métodos de classe voltados a consulta e apresentação:

```ruby
# app/models/calendar.rb

def self.search_by_tcc(tcc, page, term)                              # linha 67-69
def self.search_by_tcc_one(page, term)                                # linha 71-73
def self.search_by_tcc_two(page, term)                                # linha 75-77
def self.select_data(tcc)                                             # linha 79-83
def self.select_for_orientation                                       # linha 85-89
def self.by_first_year_and_tcc(tcc)                                   # linha 91-97
def self.orientations_report_by_status(status, years: [], total: [])  # linha 99-109
```

## Consumidores confirmados (busca paginada e selects)

| Método | Consumidor | Uso |
|---|---|---|
| `search_by_tcc_one` | `app/controllers/responsible/calendars_controller.rb:20` | `#tcc_one` — lista paginada de calendários de TCC I |
| `search_by_tcc_one` | `app/controllers/tcc_one_professors/calendars_controller.rb:6` | `#tcc_one` — mesma listagem, outro namespace |
| `search_by_tcc_two` | `app/controllers/responsible/calendars_controller.rb:27` | `#tcc_two` — lista paginada de calendários de TCC II |
| `select_data` | `app/views/responsible/activities/_activity_calendar_select.html.erb:6` | Monta as opções do select de calendário no formulário de atividades, filtrado pelo `tcc` do calendário atual |
| `select_for_orientation` | `app/views/responsible/orientations/_form.html.erb:10` | Monta as opções do select de calendário no formulário de orientação, todos os TCCs |

`search_by_tcc(tcc, page, term)` (a versão genérica com o parâmetro `tcc` explícito) não tem nenhum consumidor fora dos próprios `search_by_tcc_one`/`search_by_tcc_two` — confirmado por `grep -rn "\.search_by_tcc(" app/ spec/`.

Cobertura de testes hoje: `spec/models/calendar/scope_calendar_spec.rb` tem um bloco `#search_by_tcc` com um caso para `search_by_tcc_one` e um para `search_by_tcc_two`. **`select_data` e `select_for_orientation` não têm nenhum teste direto** — `grep -rn "select_data\|select_for_orientation" spec/` não encontra nada; a única proteção existente é indireta, via specs de feature que renderizam os formulários que os consomem (`spec/features/responsible/activities/activities_create_spec.rb` e `spec/features/responsible/orientations/orientations_create_spec.rb`).

## `orientations_report_by_status` e `by_first_year_and_tcc` — achado: código morto, não relatório a extrair

O roadmap descreve a REF-10 como incluindo a extração do "relatório por status" para um objeto específico. A investigação desta task mostra que isso não se aplica mais:

- `grep -rn "orientations_report_by_status\|by_first_year_and_tcc" .` (fora de `.git/`) não encontra **nenhum** consumidor além da própria definição em `calendar.rb` — nem em controllers, nem em views, nem em specs. `by_first_year_and_tcc` só é chamado internamente por `orientations_report_by_status`.
- `git log --all -S"orientations_report_by_status" --oneline` mostra que o método já teve consumidor: os commits `a92b8691` ("Add in progress, renewed, and canceled numbers to orientations line chart"), `ac825e73` ("Fix/fix the orientations status and all dashboard area") e, principalmente, `60ebf5e1` ("Major Refactor: Rails Upgrade, Hotwire Migration...") — este último migrou os gráficos do dashboard de Vue (`academics-report.vue`, `card-report-number.vue`) para ViewComponents (`app/components/charts/*`) e alterou `Responsible::CalendarsController` sem preservar a chamada a este método. O método ficou implementado, íntegro e sem cobertura de teste, mas órfão desde essa migração.
- Isso é o mesmo padrão de "extração/funcionalidade abandonada" já tratado nas REF-04, REF-06 e REF-08 (métodos comentados ou sem consumidor deixados no código durante refatorações anteriores). A diferença aqui é que o método nunca foi comentado — continua sendo código Ruby válido e executável, só deixou de ser chamado.

Esta task trata os dois métodos como código morto a remover, não como relatório a extrair. Se a implementação encontrar, na prática, um consumidor que o `grep` acima não capturou (por exemplo, chamada dinâmica via `send`/`public_send`, ou uso fora de `app/`/`spec/`), **não remova**: trate como um relatório real, extraia para um objeto dedicado corrigindo o smell dos parâmetros acumuladores mutáveis (`years: []`, `total: []` — o padrão idiomático é inicializar os arrays no corpo do método, não recebê-los como argumento) e documente o consumidor encontrado no relatório final.

# Dependências

- REF-09 — Extrair navegação entre períodos acadêmicos (concluída; `previous_semester`/`next_semester`/`next_semester_tcc_two` já são delegadores para `Calendars::PeriodNavigation` e não são afetados por esta task).

# Objetivo

- Extrair a busca paginada por TCC (`search_by_tcc`/`search_by_tcc_one`/`search_by_tcc_two`) para um query object dedicado.
- Extrair a montagem de opções para selects (`select_data`/`select_for_orientation`) para um objeto de apresentação dedicado.
- Migrar os cinco pontos de consumo (três em controllers, dois em views) para os objetos extraídos, removendo os cinco métodos correspondentes de `Calendar`.
- Adicionar caracterização para `select_data`/`select_for_orientation` antes de movê-los, já que hoje não têm teste direto.
- Remover `orientations_report_by_status` e `by_first_year_and_tcc` como código morto confirmado, após reconfirmar ausência de consumidores.
- `Calendar` deixa de coordenar qualquer estrutura destinada à interface (listas paginadas, arrays de opções) ou relatório; mantém apenas validações, associações, `set_dates`, `current?`, `orientation_by_academic` e os formatadores `year_with_semester`/`year_with_semester_and_tcc` (usados tanto pelo próprio `Calendar` quanto pelo novo objeto de select).

# Instruções críticas

Preserve integralmente:

- os resultados, a ordenação (`year: :desc, semester: :desc` para a busca; `year: :desc, semester: :asc` para `select_data`; `year: :desc, tcc:, semester:` para `select_for_orientation`) e a paginação hoje produzidos por `search_by_tcc_one`/`search_by_tcc_two`;
- o formato dos pares `[id, label]` retornados por `select_data` (`year_with_semester`) e `select_for_orientation` (`year_with_semester_and_tcc`), incluindo os rótulos traduzidos;
- o comportamento das três actions de controller (`Responsible::CalendarsController#tcc_one`/`#tcc_two`, `TccOneProfessors::CalendarsController#tcc_one`) e das duas views consumidoras, sem alterar HTML, rotas ou parâmetros aceitos.

Antes de remover `orientations_report_by_status`/`by_first_year_and_tcc`, reconfirme com `grep` (repita a busca da seção de contexto) que continuam sem consumidor. Se encontrar um, siga a instrução de contingência da seção de contexto em vez de remover.

# Escopo obrigatório

## 1. Extrair a busca paginada

Criar `app/services/calendars/list_query.rb` com `Calendars::ListQuery.call(tcc:, page:, term:)`, reproduzindo exatamente a consulta hoje em `search_by_tcc`. Migrar os três call sites (`Responsible::CalendarsController#tcc_one`/`#tcc_two`, `TccOneProfessors::CalendarsController#tcc_one`) para chamar `Calendars::ListQuery.call(tcc: :one/:two, page: params[:page], term: params[:term])`. Remover `search_by_tcc`, `search_by_tcc_one` e `search_by_tcc_two` de `Calendar`.

## 2. Extrair a montagem de opções para select

Criar `app/services/calendars/select_options.rb` com dois métodos de classe — um equivalente a `select_data(tcc)` e outro a `select_for_orientation` (nomes à sua escolha, desde que expressem a diferença: um filtra por TCC, o outro traz todos). Migrar `_activity_calendar_select.html.erb:6` e `_form.html.erb:10` para chamar o novo objeto. Remover `select_data` e `select_for_orientation` de `Calendar`.

## 3. Caracterizar antes de mover (select_data/select_for_orientation)

Adicionar specs diretas para os dois métodos (via `Calendar` ou já direto no novo objeto, à sua escolha de ordem de commits) cobrindo pelo menos: filtragem por `tcc`, ordenação, e o formato do label retornado — antes de considerar a extração validada.

## 4. Remover código morto confirmado

Excluir `orientations_report_by_status` e `by_first_year_and_tcc` de `Calendar`, após a reconfirmação pedida nas Instruções críticas.

# Escopo permitido

- `app/models/calendar.rb`, apenas nos sete métodos listados no contexto;
- `app/services/calendars/` (dois novos arquivos);
- `app/controllers/responsible/calendars_controller.rb`, `app/controllers/tcc_one_professors/calendars_controller.rb`, apenas nas actions `tcc_one`/`tcc_two`;
- `app/views/responsible/activities/_activity_calendar_select.html.erb`, `app/views/responsible/orientations/_form.html.erb`, apenas na linha que monta a `collection`;
- `spec/models/calendar/scope_calendar_spec.rb` (mover/remover o bloco `#search_by_tcc`) e novos specs em `spec/services/calendars/`;
- relatório final em `ai/output/fase-4-reestruturacao-de-calendar/`.

# Escopo proibido

- Não altere `set_dates`, callbacks de criação, validações, associações, `current?`, `orientation_by_academic`, `year_with_semester`, `year_with_semester_and_tcc` ou os delegadores de navegação (`previous_semester`/`next_semester`/`next_semester_tcc_two`) criados na REF-09.
- Não implemente um relatório novo, gráfico ou qualquer funcionalidade a partir de `orientations_report_by_status` — se não encontrar consumidor, remova; não "aproveite" o código morto para reativar o gráfico removido na migração Hotwire, isso é mudança funcional fora do escopo.
- Não altere `Dashboard::ResponsibleReport#orientations_count_by_calendars_and_status` (placeholder zerado documentado na REF-08) — é um método diferente, em outra classe, e continua fora do escopo desta task.
- Não altere rotas, parâmetros aceitos pelas actions ou HTML renderizado pelas duas views além da fonte da `collection`.
- Não faça commit, push ou criação de branch.

# Roteiro de implementação

## 1. Confirmar consumidores e ausência deles

- Reconfirmar os cinco call sites da busca/select e a ausência de consumidores de `orientations_report_by_status`/`by_first_year_and_tcc` com `grep -rn` em `app/`, `spec/` e na raiz do repositório (excluindo `.git/`).

## 2. Caracterizar select_data/select_for_orientation

- Escrever specs cobrindo o comportamento atual antes de qualquer extração, já que hoje não há teste direto.

## 3. Extrair e migrar a busca paginada

- Criar `Calendars::ListQuery`, migrar os três controllers, rodar os specs de feature/model relacionados, remover os três métodos de `Calendar`.

## 4. Extrair e migrar os selects

- Criar `Calendars::SelectOptions`, migrar as duas views, rodar os specs de feature relacionados, remover os dois métodos de `Calendar`.

## 5. Remover código morto

- Excluir `orientations_report_by_status` e `by_first_year_and_tcc` (ou seguir a instrução de contingência se um consumidor real for encontrado).

## 6. Verificação final

- Executar a suíte RSpec completa, via `docker compose run --rm --name tests tests bundle exec rspec` (o nome do container precisa ser exatamente `tests` para os specs de feature resolverem o host do Capybara/Selenium).
- Executar `bundle exec rubocop --parallel` no projeto completo.

# Critérios de aceite

- `Calendar` não expõe mais `search_by_tcc`, `search_by_tcc_one`, `search_by_tcc_two`, `select_data`, `select_for_orientation`, `by_first_year_and_tcc` nem `orientations_report_by_status`.
- As três actions de controller e as duas views consumidoras continuam funcionando sem alteração de rota, parâmetro ou HTML observável.
- `select_data`/`select_for_orientation` têm cobertura de teste direta pela primeira vez, escrita antes da extração.
- Nenhum resultado, ordenação ou rótulo mudou para os métodos migrados.
- A remoção de `orientations_report_by_status`/`by_first_year_and_tcc` está documentada no relatório com a evidência de ausência de consumidor (grep) e o achado histórico (git log) — ou, no caso de contingência, o objeto extraído correspondente está documentado.
- A suíte completa passa (`docker compose run --rm --name tests tests bundle exec rspec`); o RuboCop não registra novas violações no projeto (`bundle exec rubocop --parallel`).

# Validação sugerida

```bash
bundle exec rspec spec/models/calendar/ spec/services/calendars/ \
  spec/features/responsible/calendars/ \
  spec/features/tcc_one_professors/calendars/ \
  spec/features/responsible/activities/activities_create_spec.rb \
  spec/features/responsible/orientations/orientations_create_spec.rb

bundle exec rubocop app/models/calendar.rb app/services/calendars/ \
  app/controllers/responsible/calendars_controller.rb \
  app/controllers/tcc_one_professors/calendars_controller.rb
```

Depois, execute obrigatoriamente a suíte e o lint completos antes de declarar a task concluída:

```bash
docker compose up -d web
docker compose run --rm --name tests tests bundle exec rspec
docker compose run --rm --name tests tests bundle exec rubocop --parallel
```

O nome do container precisa ser exatamente `tests` (`TEST_APP_HOST=tests`), com `db`, `web` e `selenium` no ar. Falhas de ambiente não devem ser registradas como sucesso, e execuções parciais (por exemplo, excluindo `spec/features/**`, ou o RuboCop rodado só nos arquivos alterados) não satisfazem os critérios de aceite — documente comando e resultado reais.

# Relatório final esperado

Criar `ai/output/fase-4-reestruturacao-de-calendar/implementation-summary-ref-10-separar-consultas-e-relatorios-de-calendar.md` com:

## Resumo

Objetos extraídos, consumidores migrados e o que foi removido de `Calendar`, incluindo a decisão sobre `orientations_report_by_status`/`by_first_year_and_tcc`.

## Arquivos alterados

Lista dos arquivos e responsabilidade de cada mudança, separando controllers/views migrados de código novo.

## Comportamento preservado

Evidência de que as três actions e as duas views produzem o mesmo resultado observável de antes (resultado dos specs de feature/model relevantes).

## Achado: código morto confirmado

Evidência de ausência de consumidor de `orientations_report_by_status`/`by_first_year_and_tcc` (grep) e o histórico de quando/por que ficaram órfãos (git log), ou — em caso de contingência — o consumidor encontrado e o objeto extraído para ele.

## Validação

Comandos e resultados reais de RSpec (suíte completa) e RuboCop (projeto completo), separando regressões, falhas preexistentes e limitações ambientais.

## Riscos e próximos passos

Observações relevantes para as fases seguintes (Fase 5 — Components e apresentação), incluindo qualquer duplicação remanescente entre `Calendars::ListQuery`/`Calendars::SelectOptions` e outros query objects já existentes (`Orientations::TccListQuery`, `ExaminationBoards::ListQuery`).
