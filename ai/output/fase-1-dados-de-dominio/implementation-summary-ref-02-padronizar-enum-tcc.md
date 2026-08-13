## Resumo

A camada de aplicação foi padronizada para usar `:one` e `:two` em consultas e atribuições Active Record de enums conhecidos, `tcc_one?` e `tcc_two?` em comparações de instância, e `Calendar.tccs.fetch(:one)` apenas no `HAVING` manual que precisa do valor inteiro persistido.

O mapeamento persistido foi preservado: `Calendar.tccs` continua sendo `{ 'one' => 1, 'two' => 2 }`. Não foram criadas migrations nem transformações de dados.

## Arquivos alterados

| Arquivo | Alteração |
| --- | --- |
| `app/controllers/responsible/orientations_controller.rb` | Substituído o inteiro bruto do `HAVING` por `Calendar.tccs.fetch(:one)` e o filtro de TCC II por `tcc: :two`, preservando a query manual e os blocos/comentários existentes. |
| `app/services/populate/calendars.rb` | Criação de calendários passou de `tcc: 2`/`tcc: 1` para `tcc: :two`/`tcc: :one`, mantendo a ordem de criação. |
| `app/models/calendar.rb` | Consultas internas passaram a usar símbolos do enum; comparação de instância em `next_semester_tcc_two` passou para `tcc_two?`. |
| `app/models/orientation.rb` | Scopes e consulta de calendários TCC I passaram a usar símbolos; métodos de instância passaram a delegar a verificação aos predicados do calendário atual. |
| `app/models/examination_board.rb` | Scopes e consultas de enum conhecido passaram a usar símbolos em vez da conversão manual por `Calendar.tccs`. |
| `app/models/base_activity.rb` | Scopes de TCC passaram a chamar `by_tcc` com símbolos. |
| `app/models/concerns/current_calendar.rb` | Consulta do calendário corrente por TCC passou a usar a chave simbólica recebida. |
| `app/models/concerns/orientation_join.rb` | Joins de calendário corrente passaram a usar `:one`/`:two`. |
| `app/services/calendars/clone_base_activities.rb` | A fronteira dinâmica entre `Calendar#tcc` e `BaseActivity.where` agora normaliza a chave para símbolo. |
| `app/services/dashboard/professor_report.rb` | Consultas dos relatórios passaram de strings para símbolos. |
| `app/services/dashboard/responsible_report.rb` | Consultas dos relatórios passaram de strings para símbolos; contador dinâmico normaliza a chave para símbolo. |
| `app/controllers/concerns/breadcrumb.rb` | Comparações com TCC I passaram para `tcc_one?`. |
| `app/controllers/responsible/calendars_controller.rb` | Redirecionamento por TCC passou para `tcc_one?`. |
| `app/controllers/responsible/base_activities_controller.rb` | Redirecionamento por TCC passou para `tcc_one?`. |
| `app/controllers/external_members/supervisions_controller.rb` | Redirecionamento por TCC passou para `tcc_one?`. |
| `app/helpers/active_link_helper.rb` | Comparação dinâmica preservada com normalização para string pública do enum. |
| `spec/models/calendar/validations_calendar_spec.rb` | Adicionado contrato do enum, escrita simbólica gravando `1`/`2` e leitura de valores inteiros persistidos. |
| `spec/services/populate/calendars_spec.rb` | Adicionado teste da sequência `[2, 1]` repetida pelo serviço de população. |
| `spec/features/responsible/orientations/orientations_index_tcc_one_spec.rb` | Cobertura da exclusividade da listagem TCC I para orientação não migrada. |
| `spec/features/responsible/orientations/orientations_index_tcc_two_spec.rb` | Cobertura de orientação migrada aparecendo na listagem TCC II. |
| `spec/features/responsible/orientations/orientations_index_to_migration_spec.rb` | Uso de símbolos em consultas/criações diretamente relacionadas ao escopo. |

## Comportamento preservado

- `Calendar.tccs` permanece `{ 'one' => 1, 'two' => 2 }`.
- Calendários criados com `tcc: :one` e `tcc: :two` continuam gravando `1` e `2`.
- Registros com valores inteiros `1` e `2` continuam sendo lidos pela API do enum como `'one'` e `'two'`.
- `Responsible::OrientationsController#tcc_one` mantém a exclusividade de TCC I com `COUNT(DISTINCT calendars.tcc) = 1` e `MIN(calendars.tcc)` igual ao valor persistido de TCC I.
- `Responsible::OrientationsController#tcc_two` mantém a seleção por calendários TCC II, agora via chave simbólica do enum.
- Busca, filtro por status, paginação e ordenação das listagens não foram alterados.
- Traduções e interpolação de chaves públicas do enum foram preservadas.
- A REF-04 continua responsável por extrair as queries do controller e reconciliar os comentários/código morto.

## Métricas antes/depois

| Métrica no escopo alterado | Antes | Depois |
| --- | ---: | ---: |
| Inteiros mágicos `1`/`2` representando TCC I/TCC II na camada de aplicação | 4 | 0 |
| Comparações diretas de instância com `'one'`/`'two'` | 11 | 0 |
| Consultas Active Record com `tcc: 'one'`/`tcc: 'two'` em consumidores ativos alterados | 6 | 0 |

Busca final executada no `app/` e `lib/tasks/`:

```bash
rg -n "tcc == ['\"](?:one|two)['\"]|tcc\.eql\?\(['\"](?:one|two)['\"]\)|tcc: ['\"](?:one|two)['\"]|tcc: [12]\b|Calendar\.tccs\[|tccs\[:|MIN\(calendars\.tcc\) = [12]" app lib/tasks
```

Resultado: nenhuma ocorrência.

## Validação

Comando RSpec executado:

```bash
bundle exec rspec spec/models/calendar/validations_calendar_spec.rb spec/services/populate/calendars_spec.rb spec/features/responsible/orientations/orientations_index_tcc_one_spec.rb spec/features/responsible/orientations/orientations_index_tcc_two_spec.rb spec/features/responsible/orientations/orientations_index_to_migration_spec.rb
```

Resultado: os exemplos não carregaram por limitação do sandbox. O suporte de Capybara tentou abrir socket em `0.0.0.0` porta `0` e falhou com:

```text
Errno::EPERM: Operation not permitted - socket(2) for "0.0.0.0" port 0
```

Também foi tentado validar diretamente `Calendar.tccs.fetch(:one)` via `rails runner`, mas a aplicação não inicializou neste ambiente por falha de credenciais criptografadas:

```text
ActiveSupport::MessageEncryptor::InvalidMessage
```

Comando RuboCop executado:

```bash
bundle exec rubocop --cache false app/controllers/responsible/orientations_controller.rb app/controllers/concerns/breadcrumb.rb app/controllers/responsible/calendars_controller.rb app/controllers/responsible/base_activities_controller.rb app/controllers/external_members/supervisions_controller.rb app/helpers/active_link_helper.rb app/models/calendar.rb app/models/orientation.rb app/models/examination_board.rb app/models/base_activity.rb app/models/concerns/orientation_join.rb app/models/concerns/current_calendar.rb app/services/calendars/clone_base_activities.rb app/services/dashboard/professor_report.rb app/services/dashboard/responsible_report.rb app/services/populate/calendars.rb spec/models/calendar/validations_calendar_spec.rb spec/services/populate/calendars_spec.rb spec/features/responsible/orientations/orientations_index_tcc_one_spec.rb spec/features/responsible/orientations/orientations_index_tcc_two_spec.rb spec/features/responsible/orientations/orientations_index_to_migration_spec.rb
```

Resultado:

```text
21 files inspected, no offenses detected
```

## Riscos e próximos passos

- Os specs focados foram adicionados, mas não puderam ser executados neste sandbox por bloqueio de socket do Capybara.
- A busca estática não encontrou restos dos padrões proibidos em `app/` ou `lib/tasks/`.
- A REF-04 ainda deve extrair as queries do controller, remover/reconciliar a extração abandonada e decidir o destino dos scopes e métodos legados indicados no roadmap.
