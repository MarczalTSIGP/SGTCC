# Task

REF-09 — Extrair de `Calendar` a navegação entre períodos acadêmicos (semestre anterior, próximo semestre e transição de TCC I para TCC II) para um objeto dedicado, mantendo `Calendar` como ponto de entrada compatível para os consumidores existentes, sem alterar nenhum resultado observável.

# Contexto

`app/models/calendar.rb` concentra hoje, junto com validações, callbacks, consultas e relatório, três métodos de classe que resolvem navegação temporal entre calendários:

```ruby
# app/models/calendar.rb

def self.search_by_semester(calendar, semester)                    # linha 55-57
def self.search_by_first_semester_next_year(calendar)               # linha 59-61
def self.search_by_second_semester_previous_year(calendar)          # linha 63-65
def self.previous_semester(calendar)                                # linha 67-72
def self.next_semester(calendar)                                    # linha 74-78
def self.next_semester_tcc_two(calendar)                            # linha 80-86
```

`search_by_semester`, `search_by_first_semester_next_year` e `search_by_second_semester_previous_year` são auxiliares internos: `grep -rn` em `app/` confirma que não têm nenhum consumidor fora de `calendar.rb`. `previous_semester`, `next_semester` e `next_semester_tcc_two` têm consumidores externos reais:

| Método | Consumidor | Uso |
|---|---|---|
| `previous_semester` | `app/views/responsible/activities/_header.html.erb:5-6` | Condição de exibição + `link_to` para o link "semestre anterior" (chamado duas vezes na view) |
| `next_semester` | `app/views/responsible/activities/_header.html.erb:19-20` | Condição de exibição + `link_to` para o link "próximo semestre" (chamado duas vezes na view); também chamado internamente por `next_semester_tcc_two` |
| `next_semester_tcc_two` | `app/services/orientations/migration_service.rb:16` | Determina o calendário de TCC II para onde a orientação migra ao ser aprovada em TCC I |

A cobertura de caracterização já existe e é completa: `spec/models/calendar/scope_calendar_spec.rb` testa os três casos relevantes de `previous_semester` (mesmo ano 2º→1º, virada de ano 1º→2º do ano anterior, ausência retorna `nil`), os três casos de `next_semester` (mesmo ano 1º→2º, virada de ano 2º→1º do ano seguinte, ausência retorna `nil`) e os quatro casos de `next_semester_tcc_two` (TCC I 1º sem.→TCC II mesmo ano, TCC I 2º sem.→TCC II ano seguinte, já em TCC II usa navegação regular, ausência retorna `nil`). Não é necessário escrever novos testes de caracterização antes de extrair — a suíte existente já protege o comportamento atual; ela deve apenas ser adaptada para exercitar o novo objeto (diretamente ou via `Calendar`, conforme a decisão de interface tomada).

`set_dates` (callback `before_validation`) e os métodos de consulta/relatório (`search_by_tcc*`, `select_data`, `select_for_orientation`, `by_first_year_and_tcc`, `orientations_report_by_status`) **não fazem parte desta task** — pertencem, respectivamente, à responsabilidade de criação do registro e à REF-10.

Já existe um precedente de service extraído de `Calendar` para o namespace `Calendars::`: `app/services/calendars/clone_base_activities.rb`, com `private_class_method :new` e ponto de entrada de classe (`.to(calendar)`). Não é obrigatório seguir esse mesmo nome de método de entrada — REF-08 já registrou que este projeto não força um único padrão de chamada entre os services —, mas o namespace `Calendars::` e a convenção de `private_class_method :new` quando o objeto não precisa ser instanciado pelo consumidor são um precedente direto a considerar.

# Dependências

- REF-03 — Padronizar o enum `semester` (já concluída; `Calendar` já usa `semester_one?`/`semester_two?`/símbolos consistentemente nos métodos-alvo desta task).

# Objetivo

- Isolar em um único objeto as regras de "semestre anterior", "próximo semestre" e "transição de TCC I para TCC II", hoje implementadas em `Calendar`.
- Eliminar a possibilidade de duas implementações divergentes da mesma regra de navegação.
- Tornar explícitos, no novo objeto, os casos de ausência de calendário seguinte/anterior e de virada de ano.
- Avaliar se separar o cálculo do período-alvo (ano/semestre/tcc) da consulta ao banco (`find_by`) simplifica o contrato do objeto; não é obrigatório dividir em duas classes se a separação não reduzir complexidade real.
- Preservar `Calendar.previous_semester`, `Calendar.next_semester` e `Calendar.next_semester_tcc_two` como delegadores finos para os consumidores atuais (view e `Orientations::MigrationService`) não precisarem ser alterados nesta task.

# Instruções críticas

Preserve integralmente:

- os três resultados por caso já cobertos em `spec/models/calendar/scope_calendar_spec.rb` (`previous_semester`, `next_semester`, `next_semester_tcc_two`), incluindo os casos de `nil` quando o calendário de destino não existe;
- o comportamento de `Orientations::MigrationService#call`, que depende de `Calendar.next_semester_tcc_two` retornar `nil` quando não há próximo calendário de TCC II (`reason: :no_next_calendar`);
- os dois links condicionais de `_header.html.erb` (aparecem apenas quando existe calendário anterior/próximo) e a URL para a qual apontam.

Não migre os consumidores (view e `MigrationService`) para chamar o novo objeto diretamente nesta task — mantenha-os chamando `Calendar.previous_semester`/`next_semester`/`next_semester_tcc_two`, que passam a delegar internamente. Migrar os consumidores é opcional e de baixo risco, mas só faça se não aumentar o escopo revisado da task; se optar por migrar, documente a decisão no relatório.

# Escopo obrigatório

## 1. Criar o objeto de navegação

Criar `app/services/calendars/period_navigation.rb` (ou nome equivalente que deixe explícita a responsabilidade — registre a escolha no relatório) contendo a lógica hoje em `previous_semester`, `next_semester`, `next_semester_tcc_two`, `search_by_semester`, `search_by_first_semester_next_year` e `search_by_second_semester_previous_year`. Os três últimos deixam de existir como métodos públicos de `Calendar` — não têm consumidor externo — e podem virar métodos privados do novo objeto ou ser reescritos, desde que o comportamento observável de `previous_semester`/`next_semester`/`next_semester_tcc_two` não mude.

## 2. Delegar a partir de `Calendar`

Substituir os corpos de `Calendar.previous_semester`, `Calendar.next_semester` e `Calendar.next_semester_tcc_two` por uma chamada ao novo objeto (`delegate` de classe ou chamada explícita de uma linha). Remover `search_by_semester`, `search_by_first_semester_next_year` e `search_by_second_semester_previous_year` de `Calendar` após confirmar novamente, por `grep`, que não há consumidor além do próprio arquivo.

## 3. Cobrir o novo objeto com teste

Mover ou duplicar a cobertura de `scope_calendar_spec.rb` para exercitar o novo objeto (diretamente, se a interface for pública o suficiente para isso, ou por meio de `Calendar` se a decisão de design for manter os métodos do objeto como implementação interna). Não é necessário inventar novos cenários: os casos já existentes (mesmo ano, virada de ano, ausência de calendário, TCC I→TCC II nas duas variações de semestre) já cobrem a regra.

# Escopo permitido

- `app/models/calendar.rb`, apenas nos seis métodos listados no contexto;
- `app/services/calendars/` (novo arquivo);
- `spec/models/calendar/scope_calendar_spec.rb` e/ou novo arquivo de spec do objeto extraído em `spec/services/calendars/`;
- relatório final em `ai/output/fase-4-reestruturacao-de-calendar/`.

# Escopo proibido

- Não altere `set_dates`, callbacks de criação, validações ou associações de `Calendar` — fora do escopo desta task.
- Não altere `search_by_tcc`, `search_by_tcc_one`, `search_by_tcc_two`, `select_data`, `select_for_orientation`, `by_first_year_and_tcc` ou `orientations_report_by_status` — pertencem à REF-10.
- Não altere `CurrentCalendar`, `Tcc` ou `Semester` (concerns) além de eventuais chamadas de leitura já existentes (`semester_one?`, `tcc_two?` etc.) reaproveitadas pelo novo objeto.
- Não migre `app/views/responsible/activities/_header.html.erb` nem `app/services/orientations/migration_service.rb` para chamar o novo objeto diretamente, a menos que opcionalmente decida fazê-lo sem custo adicional relevante (ver Instruções críticas).
- Não altere rotas, HTML renderizado ou o texto dos links da view.
- Não faça commit, push ou criação de branch.

# Roteiro de implementação

## 1. Confirmar ausência de outros consumidores

- `grep -rn "search_by_semester\|search_by_first_semester_next_year\|search_by_second_semester_previous_year\|previous_semester\|next_semester" app/ spec/` para reconfirmar a lista de consumidores antes de mover código.

## 2. Extrair o objeto

- Criar `Calendars::PeriodNavigation` (ou nome equivalente) com a lógica atual, preservando exatamente as mesmas condições (`semester_two?`, `tcc_two?`, `semester_one?`) e chamadas `find_by`.
- Decidir e registrar se cálculo do período-alvo e consulta ao banco ficam separados internamente.

## 3. Delegar em `Calendar`

- Substituir os três métodos públicos por delegação de uma linha cada.
- Remover os três métodos auxiliares sem consumidor externo.

## 4. Ajustar/mover os testes

- Rodar `bundle exec rspec spec/models/calendar/scope_calendar_spec.rb` antes de qualquer alteração para confirmar baseline verde.
- Mover ou duplicar a cobertura para o novo objeto; manter (ou adaptar) a cobertura via `Calendar` para os três métodos delegadores.

## 5. Verificação final

- Executar a suíte relacionada e, na sequência, a suíte completa.
- Executar RuboCop no projeto completo.

# Critérios de aceite

- `Calendar.previous_semester`, `Calendar.next_semester` e `Calendar.next_semester_tcc_two` continuam publicamente disponíveis e retornam exatamente os mesmos valores de antes para os casos cobertos em `scope_calendar_spec.rb`.
- A regra de navegação (semestre anterior, próximo semestre, transição TCC I→TCC II) tem uma única implementação, fora de `Calendar`.
- `search_by_semester`, `search_by_first_semester_next_year` e `search_by_second_semester_previous_year` não existem mais como métodos públicos de `Calendar`.
- `_header.html.erb` e `Orientations::MigrationService` continuam funcionando sem alteração (ou, se migrados para o novo objeto, com evidência de resultado idêntico no relatório).
- A suíte completa passa; o RuboCop não registra novas violações no projeto.

# Validação sugerida

```bash
bundle exec rspec spec/models/calendar/ spec/services/calendars/ spec/services/orientations/migration_service_spec.rb spec/features/responsible/

bundle exec rubocop app/models/calendar.rb app/services/calendars/

bundle exec rspec
bundle exec rubocop --parallel
```

Se o projeto exigir Docker, use `docker compose run --rm --name tests tests <comando>`, garantindo que o container se chame exatamente `tests` para que os specs de feature resolvam o host da aplicação (`TEST_APP_HOST=tests`), com `db`, `web` e `selenium` no ar (`docker compose up -d web`).

Falhas de ambiente não devem ser registradas como sucesso. Documente comando, mensagem e comportamentos não validados dinamicamente. **Execute a suíte de verdade antes de declarar a task concluída** — nas REF-06 e REF-07, "validação dinâmica não executada" mascarou regressões reais que só apareceram quando a suíte foi de fato rodada.

# Relatório final esperado

Criar `ai/output/fase-4-reestruturacao-de-calendar/implementation-summary-ref-09-extrair-navegacao-entre-periodos-academicos.md` com:

## Resumo

Objeto extraído, decisão de interface (delegação simples vs. separação entre cálculo e consulta) e o que foi removido de `Calendar`.

## Arquivos alterados

Lista dos arquivos e responsabilidade de cada mudança.

## Comportamento preservado

Evidência de que os casos cobertos em `scope_calendar_spec.rb` continuam passando pelos métodos delegadores, e de que `_header.html.erb`/`MigrationService` não mudaram de comportamento.

## Decisões de design

Nome e localização do objeto, se os três métodos auxiliares sem consumidor foram mantidos como privados ou reescritos, e se cálculo temporal e acesso ao banco foram separados (com justificativa).

## Validação

Comandos e resultados de RSpec e RuboCop, execução real, separando regressões, falhas preexistentes e limitações ambientais.

## Riscos e próximos passos

Observações relevantes para a REF-10 (consultas e relatórios remanescentes em `Calendar`: `search_by_tcc*`, `select_data`, `select_for_orientation`, `by_first_year_and_tcc`, `orientations_report_by_status`), incluindo a constatação de que `orientations_report_by_status` e `by_first_year_and_tcc` não têm nenhum consumidor em `app/` fora de `calendar.rb` (achado a confirmar/registrar formalmente na REF-10).
