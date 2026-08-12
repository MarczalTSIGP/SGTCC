# Inventário de Inconsistências e Responsabilidades — REF-01

**Data:** 2026-08-11
**Dependência:** REF-00 (`ai/output/fase-0-baseline/baseline/README.md`)
**Escopo:** leitura e análise — nenhum arquivo de produção foi alterado.

---

## Resumo

A inspeção confirmou os hotspots identificados pelo baseline. Foram encontradas três classes de problema comprovadas com evidências concretas no código:

1. **Enums `tcc` e `semester` usados de forma inconsistente** — o mesmo conceito aparece como inteiro literal (DB), string de chave I18n, símbolo e via API do enum, às vezes no mesmo arquivo.
2. **Regras de negócio e consultas SQL embutidas em controllers e services de dashboard** — os pontos mais críticos são `Responsible::OrientationsController#tcc_one/tcc_two` e os dois services `Dashboard::ResponsibleReport`/`Dashboard::ProfessorReport`, com TODOs e marcadores "CODE SMELL" explícitos.
3. **Código morto e extrações abandonadas** — dez locais com código comentado, TODOs sem implementação ou métodos marcados para remoção, incluindo o par `calendar_tcc_one?`/`calendar_tcc_two?` ainda em uso por `AcademicDocumentsInfo`.

Os concerns de `Orientation` são os mais numerosos (12) e carregam responsabilidades heterogêneas. `ExaminationBoard` concentra a maior complexidade Flog (115.0) justamente por misturar regras de domínio com geração de documentos e presença de ActionView.

RSpec e SimpleCov continuam indisponíveis no ambiente de coleta; os riscos decorrentes estão na seção final.

---

## Enum `tcc`

O enum está definido em `app/models/concerns/tcc.rb` como `{ one: 1, two: 2 }` (valores inteiros no banco). A API correta é `Calendar.tccs[:one]` (retorna `1`) ou predicados como `calendar.tcc_one?`. Os padrões encontrados:

| Arquivo | Linha(s) | Padrão usado | Observação |
|---|---|---|---|
| `app/controllers/responsible/orientations_controller.rb` | 22–23 | SQL literal `MIN(calendars.tcc) = 1` | Valor inteiro bruto em HAVING clause |
| `app/controllers/responsible/orientations_controller.rb` | 43 | `where(calendars: { tcc: 2 })` | Inteiro literal — contorna enum completamente |
| `app/services/populate/calendars.rb` | 21–22 | `tcc: 2` / `tcc: 1` | Inteiros no create! |
| `app/controllers/tcc_one_professors/examination_boards_controller.rb` | 54, 69 | `tcc: :one` | Símbolo correto na escrita |
| `app/controllers/responsible/examination_boards_controller.rb` | 90, 105 | `tcc: :one` / `tcc: :two` | Símbolo correto na escrita |
| `app/controllers/concerns/breadcrumb.rb` | 14, 21 | `@calendar.tcc == 'one'` | String chave I18n — comparação com string |
| `app/controllers/external_members/supervisions_controller.rb` | 88 | `@calendar.tcc == 'one'` | String chave I18n |
| `app/controllers/responsible/calendars_controller.rb` | 88 | `@calendar.tcc == 'one'` | String chave I18n |
| `app/controllers/responsible/base_activities_controller.rb` | 85 | `@base_activity.tcc == 'one'` | String chave I18n |
| `app/helpers/active_link_helper.rb` | 49 | `@calendar.tcc == tcc_type` | Variável recebe string 'one'/'two' |
| `app/models/orientation.rb` | 126 | `Calendar.where(tcc: 'one')` | String chave I18n em query |
| `app/models/orientation.rb` | 138, 143 | `current_calendar.tcc == 'one'` | String chave I18n (métodos marcados TODO) |
| `app/models/calendar.rb` | 81 | `calendar.tcc == 'two'` | String chave I18n |
| `app/models/examination_board.rb` | 34–35 | `where(tcc: Calendar.tccs[:one])` | **API correta** |
| `app/models/examination_board.rb` | 38, 53 | `Calendar.tccs[:one]` / `[:two]` | **API correta** |
| `app/models/concerns/orientation_join.rb` | 29, 33 | `Calendar.tccs[:one]` / `[:two]` | **API correta** |
| `app/models/concerns/current_calendar.rb` | 21, 25 | `current_by_tcc(:one)` / `(:two)` | **API correta** |
| `app/models/base_activity.rb` | 23, 27 | `tccs[:one]` / `tccs[:two]` | **API correta** |
| `app/models/calendar.rb` | 56, 60, 64, 87, 95, 99 | `tccs[calendar.tcc]` / `tccs[:two]` | **API correta** |
| `app/services/notifications/hooks/activity.rb` | 28 | `I18n.t("enums.tcc.#{activity.tcc}")` | Interpolação de chave — não é comparação |

**Consumidores que dependem do valor persistido inteiro:** `Responsible::OrientationsController#tcc_one` (SQL bruto), `Responsible::OrientationsController#tcc_two` (`where tcc: 2`), `Populate::Calendars` (`tcc: 1/2`). A REF-02 precisa garantir que nenhuma desses seja alterada de forma a modificar os inteiros `1`/`2` no banco.

**Padrão predominante correto:** `Calendar.tccs[:one]` — usado em 6 locais nos models/concerns centrais.

**Padrão a eliminar:** string literal `'one'`/`'two'` em comparações e inteiro `1`/`2` em queries.

---

## Enum `semester`

O enum está definido em `app/models/concerns/semester.rb` como `{ one: 1, two: 2 }`. A API correta é `Calendar.semesters[:one]` ou predicados `calendar.semester_one?`. Os padrões encontrados:

| Arquivo | Linha(s) | Padrão usado | Observação |
|---|---|---|---|
| `app/models/calendar.rb` | 35–36 | `s = semester.to_i; s == 1 ? 1 : 7` | Inteiro após conversão manual para set_dates |
| `app/models/calendar.rb` | 60, 64 | `find_by(semester: 1, ...)` / `find_by(semester: 2, ...)` | Inteiro literal em query |
| `app/models/calendar.rb` | 69, 75, 83 | `calendar.semester == 'two'` / `== 'one'` | String chave I18n em comparação |
| `app/models/calendar.rb` | 84, 87, 116, 119 | `find_by(semester: 'two', ...)` / `find_by(semester: 'one', ...)` | String em query |
| `app/services/calendars/clone_base_activities.rb` | 46 | `@calendar.semester == 'one'` | String chave I18n |
| `app/services/populate/calendars.rb` | 24–25 | `semester == 1` / `semester == 1 ? 2 : 1` | Inteiro literal puro |
| `app/services/dashboard/responsible_report.rb` | 132, 147 | `month <= 6 ? 1 : 2` | Recalcula semestre atual manualmente (ignora `Calendar.current_semester`) |

**Problema especial em `Calendar#set_dates`:** converte `semester.to_i` para usar `s == 1`, o que funciona porque `'one'.to_i == 0` e `'two'.to_i == 0` — a conversão está implicitamente errada se o valor armazenado for a string `'one'`. Na prática o valor persistido é `1` ou `2` (inteiro), então `to_i` funciona, mas o código é frágil.

**Problema especial em `Dashboard::ResponsibleReport`:** `current_tcc_one_orientations` e `current_tcc_two_orientations` recalculam `current_semester` com `month <= 6 ? 1 : 2` em vez de usar `Calendar.current_semester`. Isso duplica lógica que já existe centralizada e pode divergir se a regra for alterada em `CurrentCalendar`.

**Consumidores que dependem do valor persistido inteiro:** `Populate::Calendars` (`semester: 1/2`). A REF-03 não pode alterar a representação persistida.

---

## Controllers com Regra de Negócio / Consulta

### `Responsible::OrientationsController#tcc_one` — Flog 26.2, rating F

```
app/controllers/responsible/orientations_controller.rb, linhas 13–34
```

- Constrói SQL HAVING manualmente: `COUNT(DISTINCT calendars.tcc) = 1 AND MIN(calendars.tcc) = 1`.
- Aplica filtro de status, encadeia search e paginação diretamente na action.
- Marcado com `rubocop:disable`, "TEMPORARY SOLUCTION", "TODO: Refactor this method".
- Usa integer `1` para comparar TCC I no HAVING clause (padrão inconsistente).
- A query comentada (`# @orientations = Orientation.by_tcc_one(...)`) aponta para `OrientationFilter.by_tcc_one`, que **não é equivalente** (veja seção de extrações abandonadas).

### `Responsible::OrientationsController#tcc_two` — Flog 25.0, rating F

```
app/controllers/responsible/orientations_controller.rb, linhas 36–53
```

- Usa `where(calendars: { tcc: 2 })` — inteiro literal.
- A query comentada aponta para `OrientationFilter.by_tcc_two`, que usa `Orientation.tcc_two` — também não equivalente.

### `Responsible::OrientationsController#build_signatures_list` e `#format_signature_data`

```
app/controllers/responsible/orientations_controller.rb, linhas 127–144
```

- Lógica de apresentação (formatação de assinaturas) dentro do controller.
- Deveria estar em um presenter, ViewComponent ou helper.

### `Dashboard::ResponsibleReport#orientations_by_tcc_one` e `#orientations_by_tcc_two`

```
app/services/dashboard/responsible_report.rb, linhas 75–100
```

- Carrega todas as orientações TCC I/II em memória com `.select(&:tcc_one?)` (N+1 potencial).
- Compara status com strings portuguesas hardcoded: `o.status.eql?('em andamento')` etc.
- O enum `Orientation.status` retorna a chave traduzida (string portuguesa), portanto a comparação é tecnicamente válida, mas é frágil dependendo do locale ativo e da tradução.
- Marcado com `rubocop:disable`, "TODO: Refactor this method", "CODE SMELL: This method is horrible".

### `Dashboard::ProfessorReport#orientations_by_tcc_one` e `#orientations_by_tcc_two`

```
app/services/dashboard/professor_report.rb, linhas 23–49
```

- Mesmo padrão de `ResponsibleReport`: carga em memória, `select(&:tcc_one?)`, comparação com strings portuguesas.
- Código comentado (extração anterior abandonada, linhas 52–83) com implementação genérica que teria unificado os dois métodos.

### `Dashboard::ResponsibleReport#current_tcc_one_orientations` e `#current_tcc_two_orientations`

```
app/services/dashboard/responsible_report.rb, linhas 131–155
```

- Calcula semestre manualmente: `current_semester = Date.current.month <= 6 ? 1 : 2` em vez de `Calendar.current_semester`.
- `count_orientations` passa `tcc: tcc_type` com string `'one'`/`'two'` em vez de valor enum.
- `count_orientation_status` usa `Orientation.send("current_tcc_#{tcc_type}", status)` com metaprogramação em vez de chamada direta.

### `Dashboard::ResponsibleReport#orientations_count_by_calendars_and_status`

```
app/services/dashboard/responsible_report.rb, linhas 64–70
```

- Corpo do loop vazio: `# orientations += 0 # TODO: Implement this`.
- Sempre retorna 0 — método morto que serve de placeholder não funcional.

---

## Responsabilidades de `Orientation`, `Calendar`, `Document`, `Signature`, `ExaminationBoard`

### `Orientation` — 12 concerns incluídos

| Concern | Responsabilidade | Classificação |
|---|---|---|
| `Searchable` | Busca textual com unaccent | Consulta — estável |
| `OrientationStatus` | Enum status + predicados `approved?`, `canceled?` etc. | Status — bem coeso |
| `OrientationFilter` | Busca paginada por TCC/semestre (`by_tcc_one/two`, `by_current_*`) | Consulta — candidato a query object |
| `OrientationJoin` | Joins com calendários, filtragem por TCC/status | Consulta — candidato a query object |
| `OrientationOption` | Permissões `can_be_canceled?`, `can_be_edited?`, `can_be_destroyed?` | Regra de negócio — aceitável no model |
| `OrientationDocuments` | Acesso a TCO/TCAI, destruição de documento | Documentos — aceitável no model |
| `OrientationTcoTcai` | Callbacks criação e recriação de TCO e TCAI | Documentos/callbacks — sensível |
| `OrientationReport` | Ranking de professores (`professors_ranking`) | Relatório — candidato a service/query object |
| `OrientationValidation` | Validação de supervisores não serem o orientador | Validação — aceitável no model |
| `AcademicDocumentsInfo` | Seleciona documento de atividade por TCC; usa `calendar_tcc_one?` (deprecated) | Apresentação — acoplado a método marcado para remoção |
| `UsersToDocument` | Formata usuários em hash para JSON | Serialização — compartilhado com `ExaminationBoard` |

**No próprio model:** scopes (`tcc_one`, `tcc_two`, `current_tcc_one`, `current_tcc_two`, `to_migrate`, `with_relationships`, `recent`, `order_by_academic`), migrate, cancel, `tcc_one?`/`tcc_two?` (ativos), `calendar_tcc_one?`/`calendar_tcc_two?` (deprecated com TODO), `last_tcc_one_calendars`/`count_orientations_in_last_tcc_one_calendar` (sem consumidor externo identificado), `orientation_type`/`summary` (usa strings portuguesas como status), métodos de serialização JSON (`to_json_table`, `approved`, `approved_tcc_one` etc.).

**Problema de duplicação interna:** `calendar_tcc_one?` vs `tcc_one?` fazem a mesma coisa (ambos comparam `current_calendar.tcc == 'one'`). `AcademicDocumentsInfo` usa o deprecated `calendar_tcc_one?`, que precisa ser migrado para `tcc_one?` antes que o TODO seja concluído.

### `Calendar` — 4 concerns incluídos

| Concern | Responsabilidade | Classificação |
|---|---|---|
| `Searchable` | Busca textual por ano | Consulta — estável |
| `Tcc` | Enum `tcc` + `human_tccs` | Domínio — bem coeso |
| `Semester` | Enum `semester` + `human_semesters` | Domínio — bem coeso |
| `CurrentCalendar` | Calendário atual por TCC, ano/semestre corrente | Consulta temporal — candidato a service |

**No próprio model:** set_dates (callback de datas padrão), busca paginada (`search_by_tcc*`), navegação entre semestres (`previous_semester`, `next_semester`, `next_semester_tcc_two`), select_data para formulários, `orientations_report_by_status` (loop com estado mutável `years: []`, `total: []`), `by_first_year_and_tcc`. O model acumula responsabilidades de consulta, navegação temporal e relatório.

**Problema de `orientations_report_by_status`:** usa parâmetros acumuladores `years: []` e `total: []` com mutação via `push` dentro do loop. Em Ruby, defaults de keyword arguments são reavaliados a cada chamada (não há o problema de compartilhamento de Python), mas o estilo de mutação de parâmetro é um smell: a interface do método aceita injeção de arrays externos que serão mutados silenciosamente. A forma idiomática seria inicializar as variáveis no corpo do método.

### `Document` — 5 concerns incluídos

| Concern | Responsabilidade | Classificação |
|---|---|---|
| `TermJsonData` | Monta hash JSON do termo (orientação, orientador, aluno, instituição, banca) | Serialização — coeso |
| `SignatureMark` | Lista assinaturas formatadas para exibição | Apresentação — aceitável |
| `DocumentSigned` | Predicados `academic_signed?`, `professor_signed?` | Status — aceitável |
| `DocumentByType` | Factory methods `new_tdo`, `new_tep`, `new_tso` | Criação — candidato a service |
| `DocumentReview` | Predicados de review `tdo_for_review?`, `tep_for_review?`, `tso_for_review?` | Status — aceitável |

**No próprio model:** callbacks `generate_unique_code`, `create_signatures`, `save_to_json`, `trigger_create_notification`; lógica de assinatura (`save_judgment`, `update_requester_justification`); `by_user`, `status_table`, `filename`. Múltiplos callbacks e responsabilidades de criação.

### `Signature` — sem concerns

O model é enxuto: enum `user_type`, scopes, `sign`, `user_table`, `user`. O `user_table` usa comparação com string `user_type == 'academic'` e array `%w[external_member_supervisor ...]` — não usa enum predicados.

### `ExaminationBoard` — 6 concerns incluídos

| Concern | Responsabilidade | Classificação |
|---|---|---|
| `ExaminationBoardDefenseMinutes` | Criação e acesso à ata de defesa | Documentos — bem coeso |
| `UsersToDocument` | Formata usuários para JSON | Serialização — compartilhado com Orientation |
| `SituationEnum` | Enum `situation` | Domínio — bem coeso |
| `TccIdentifier` | Enum `identifier` + helpers de TCC | Domínio — bem coeso |
| `Searchable` | Busca textual | Consulta — estável |
| `Tcc` | Enum `tcc` + `human_tccs` | Domínio — bem coeso |

**No próprio model:** múltiplos scopes incluindo lógica complexa (`tcc_one_current_semester`, `tcc_two_current_semester`), `cs_asc_from_now_desc_ago` (método de ordenação composta que loda tudo em memória), `status`/`distance_of_date` (lógica de apresentação + `ActionView::Helpers::DateHelper`), `examination_board_data`, predicados de avaliadores, `touch_updated_at` (TODO para testes). A inclusão de `ActionView::Helpers::DateHelper` é o principal indicador de responsabilidade misturada.

---

## Extrações Abandonadas

| Local | Linhas | Descrição | Equivalente ao ativo? | Task |
|---|---|---|---|---|
| `app/controllers/responsible/orientations_controller.rb` | 19, 42 | Comentários `# @orientations = Orientation.by_tcc_one/two(...)` | **Não** — `by_tcc_one` usa scope `tcc_one` que traz todas as orientações com algum calendário TCC I; o ativo usa HAVING para garantir exclusividade (só TCC I) | **REF-04** |
| `app/models/orientation.rb` | 136–143 | `calendar_tcc_one?`/`calendar_tcc_two?` com `# TODO: Refactored and Remove` | Equivalente a `tcc_one?`/`tcc_two?` | **REF-06** |
| `app/models/orientation.rb` | 125–134 | `last_tcc_one_calendars`/`count_orientations_in_last_tcc_one_calendar` | Sem consumidor externo identificado — possível código morto | **REF-06** |
| `app/models/concerns/academic_documents_info.rb` | 16, 21 | Usa `calendar_tcc_one?` (deprecated) | Deveria usar `tcc_one?` | **REF-06** |
| `app/services/dashboard/responsible_report.rb` | 103–130 | Método `orientations_by_tcc` / `current_tcc_orientations` comentados — extração anterior abandonada | **Não** — usava `Orientation.send("tcc_#{tcc_type}", ...)` com scopes não equivalentes ao comportamento atual | **REF-06**, **REF-08** |
| `app/services/dashboard/professor_report.rb` | 52–83 | Método `calculate_orientations` comentado — extração anterior abandonada | **Não** — mesmo problema: usava scopes não equivalentes | **REF-06**, **REF-08** |
| `app/services/dashboard/responsible_report.rb` | 64–70 | `orientations_count_by_calendars_and_status` com loop vazio e `# TODO: Implement this` | N/A — método sempre retorna 0, nunca implementado | **REF-08** |
| `app/helpers/professors/active_link_helper.rb` | 4–6, 11–15 | Condições de active link baseadas em calendário comentadas | N/A — simplificou comportamento | **REF-08** |
| `app/helpers/external_members/active_link_helper.rb` | 23–25 | `# TODO: rubocop:disable` + corpo do método `supervisions_history_active_link?` comentado; retorna nil | N/A — método sem implementação, retorna nil | **REF-08** |
| `app/controllers/academics/calendars_controller.rb` | 12–13 | `# @orientations = orientations.page(params[:page])` + `# @calendars = ...` | N/A — paginação nunca implementada | **REF-05** |
| `app/models/academic.rb` | 15 | `# has_many :calendars, through: :orientations #TODO: test` | N/A — associação nunca implementada | **REF-06** |
| `app/models/examination_board.rb` | 215–219 | `# TODO: Tests for this method` sobre `touch_updated_at` | N/A — sem teste | **REF-07** |
| `app/models/academic_activity.rb` | 36–44 | `# TODO: Refactor and write tests for this method` sobre `clear_examination_boards_cache` | N/A — sem teste | **REF-07** |

**Confirmação do achado citado no roadmap:** a divergência entre `Orientation.tcc_one` (scope + `OrientationFilter.by_tcc_one`) e a query manual do controller **procede**. `Orientation.tcc_one('IN_PROGRESS')` retorna orientações que possuem *algum* calendário TCC I com status `IN_PROGRESS`, incluindo orientações que já migraram para TCC II. A query do controller garante exclusividade: `HAVING COUNT(DISTINCT calendars.tcc) = 1 AND MIN(calendars.tcc) = 1` exclui orientações com calendários de ambos os TCCs. A REF-04 deve partir do comportamento ativo do controller.

---

## Candidatos a Duplicação (Views / Controllers)

| Ranking Flay | Massa | Arquivos | Diferenças | Task |
|---|---|---|---|---|
| 1 | 264 | `external_members/examination_boards/_appointment_file_form.html.erb`<br>`professors/examination_boards/_appointment_file_form.html.erb` | Form id (`id: 'appoints_form'` só em professors), campo `external_member_id` vs `professor_id`, quebra de linha no botão | **REF-12** |
| 2 | 225 | `academics/documents/sign_form.html.erb`<br>`external_members/documents/sign_form.html.erb`<br>`professors/documents/sign_form.html.erb` | **Idênticos** — todos renderizam `Documents::SignFormComponent` com os mesmos 3 argumentos. As diferenças estão nos controllers (onde `@username`, `@confirm_url`, `@back_url` são definidos por namespace). | **REF-11** (as views podem ser consolidadas em shared/) |
| 3 | 216 | `academics/calendars/index.html.erb`<br>`academics/orientations/documents.html.erb`<br>`academics/tep_requests/index.html.erb` | Estrutura de tabela paginada similar, mas colunas diferentes. Duplicação provável de paginação e shell da tabela. | **REF-11** |

**Nota sobre o bloco 2:** as três views `sign_form.html.erb` são idênticas byte a byte (exceto uma linha em branco). Isso sugere que a consolidação em uma partial ou rota compartilhada eliminaria o bloco completamente sem criar abstração adicional.

**Duplicação em controllers:** `Responsible::ExaminationBoardsController` e `TccOneProfessors::ExaminationBoardsController` compartilham lógica de `examination_board_params`, `disabled_fields`, `set_orientations_and_activities` e fluxo destroy com defesa de ata. Candidatos à extração de concern ou concern HTTP na fase REF-05.

---

## Backlog Priorizado

A prioridade usa o binômio **impacto × complexidade** conforme o roadmap: alto impacto = afeta múltiplos módulos, risco de bug ou travamento de refatoração; alta complexidade = muitos consumidores, SQL manual, dependência cruzada.

| # | Achado | Impacto | Complexidade | Task | Por onde começar |
|---|---|---|---|---|---|
| 1 | SQL HAVING manual em `OrientationsController#tcc_one` com inteiro bruto; query comentada não equivalente | **Alto** — afeta listagem principal de TCC I | **Alta** — lógica de exclusividade de TCC I não trivial | REF-04 | Caracterizar comportamento esperado antes de extrair |
| 2 | `where(calendars: { tcc: 2 })` em `OrientationsController#tcc_two` | **Alto** — afeta listagem TCC II | **Média** — query mais simples | REF-04 | Parte da mesma extração do #1 |
| 3 | `Dashboard::ResponsibleReport#orientations_by_tcc_one/two` — carga em memória + strings portuguesas + CODE SMELL explícito | **Alto** — dashboard do responsável quebra silenciosamente se locale mudar | **Alta** — duplica lógica com professor_report | REF-06, REF-08 | Depois de REF-04 (usa os mesmos scopes/contexto) |
| 4 | `Dashboard::ProfessorReport#orientations_by_tcc_one/two` — mesmo padrão que #3 | **Alto** — mesmo risco de locale | **Média** — padrão idêntico ao #3 | REF-06, REF-08 | Junto com #3 |
| 5 | `calendar_tcc_one?`/`calendar_tcc_two?` marcados TODO ainda consumidos por `AcademicDocumentsInfo` | **Médio** — bloqueia remoção dos deprecated; `AcademicDocumentsInfo` usa método errado | **Baixa** — troca direta por `tcc_one?` | REF-06 | Simples: substituir referência em `AcademicDocumentsInfo` |
| 6 | Enum `tcc` com inteiro `1`/`2` em `Populate::Calendars` | **Médio** — seed de desenvolvimento | **Baixa** — usar símbolo `:one`/`:two` | REF-02 | Mudança mecânica simples |
| 7 | Enum `semester` misturado (`'one'`/`'two'`, `1`/`2`) em `Calendar` model | **Médio** — navegação temporal pode produzir resultados incorretos em edge cases | **Média** — várias consultas encadeadas | REF-03 | Padronizar antes de refatorar `Calendar` |
| 8 | `current_tcc_one/two_orientations` recalcula semestre manualmente; ignora `Calendar.current_semester` | **Médio** — pode divergir do semestre real em produção | **Baixa** — substituição simples | REF-03 | Parte da padronização de `semester` |
| 9 | `Responsible::ExaminationBoardsController` com lógica duplicada em relação a `TccOneProfessors::ExaminationBoardsController` | **Médio** — manutenção duplicada | **Média** — duas classes, shared concern | REF-05 | Após REF-04 |
| 10 | `ExaminationBoard` inclui `ActionView::Helpers::DateHelper` para `distance_of_time_in_words` | **Médio** — model com dependência de view | **Baixa** — mover para presenter/helper | REF-07 | Parte da reorganização de `ExaminationBoard` |
| 11 | `orientations_count_by_calendars_and_status` sempre retorna 0 — placeholder não implementado | **Médio** — dashboard exibe dados incorretos silenciosamente | **Baixa** — implementar ou remover | REF-08 | Verificar se afeta a UI antes de remover |
| 12 | Code morto comentado em `responsible_report.rb` / `professor_report.rb` (40+ linhas) | **Baixo** — não afeta comportamento | **Baixa** — remoção direta | REF-08 | Pode ser feito junto com #3/#4 |
| 13 | `sign_form.html.erb` idêntico em 3 namespaces | **Baixo** — duplicação visual sem risco de divergência | **Baixa** — mover para `shared/` | REF-11 | Simples mas envolve rotas |
| 14 | `_appointment_file_form.html.erb` quase idêntico em 2 namespaces | **Baixo** — risco de divergência se um for atualizado sem o outro | **Média** — `ViewComponent` com parâmetros | REF-12 | Após inventário REF-11 |
| 15 | `last_tcc_one_calendars`/`count_orientations_in_last_tcc_one_calendar` sem consumidor externo | **Baixo** — código morto no model | **Baixa** — remoção após confirmar ausência de uso | REF-06 | Confirmar com grep antes de remover |
| 16 | `Calendar.orientations_report_by_status` com parâmetros mutáveis `years: []` | **Baixo** — antipadrão Ruby, risco de estado compartilhado | **Baixa** — refatorar para retornar novo hash | REF-10 | Simples, seguro |

**Recomendação de ponto de partida da Fase 1:**

Iniciar por **REF-02** (enum `tcc`) porque:
1. As inconsistências de enum são pré-requisito para que a query extraída em REF-04 use API consistente.
2. Escopo cirúrgico: substituir inteiros e strings por `Calendar.tccs[:one]` / `tcc: :one` é uma mudança mecânica de baixo risco.
3. Não altera comportamento — o banco continua armazenando `1`/`2`.

Em paralelo ou imediatamente após: **REF-03** (enum `semester`), pelo mesmo motivo.

Após os dois enums padronizados: **REF-04** (extrair a busca de orientações do responsável), que é o item de maior impacto e desbloqueia REF-05 e REF-06.

---

## Riscos e Limitações

| Item | Risco | Impacto |
|---|---|---|
| RSpec indisponível no ambiente | Não foi possível confirmar se os scopes `tcc_one`/`tcc_two` e `by_tcc_one`/`by_tcc_two` produzem resultados distintos em banco real | **Alto** — a REF-04 deve começar com testes de caracterização antes de qualquer extração |
| SimpleCov desabilitado | Cobertura de testes desconhecida; não se sabe quais os métodos marcados TODO têm cobertura indireta | **Médio** — especialmente `clear_examination_boards_cache` e `touch_updated_at` |
| `orientation.status` retorna string traduzida | Depende do locale ativo no momento da geração do enum — se o locale não for `pt-BR`, os predicados `eql?('em andamento')` e `orientation_type` quebram silenciosamente | **Alto** — esse é o maior risco técnico do inventário; a REF-06 deve padronizar as comparações de status |
| `orientations_count_by_calendars_and_status` retorna 0 sempre | O método existe e é chamado em `calendar_orientations_by_status`, que alimenta o `calendar_report` do dashboard. Se este dado é exibido, ele sempre mostra 0 incorretamente | **Médio** — necessita verificação manual da UI |
| Métodos sem consumidor externo confirmados só por `grep` | `last_tcc_one_calendars` e `count_orientations_in_last_tcc_one_calendar` podem ser chamados dinamicamente ou por specs não carregáveis | **Baixo** — remover somente após confirmar com `grep -r` e ausência em specs |
