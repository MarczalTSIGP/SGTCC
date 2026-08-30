# REF-07 — Reorganizar ExaminationBoard, Document e Signature

## Resumo

Extraídas quatro responsabilidades que estavam misturadas nos models:
- **Apresentação** (`status`/`distance_of_date`) → `ExaminationBoards::StatusPresenter`
- **Consulta do site público** (`cs_asc_from_now_desc_ago` e auxiliares) → `ExaminationBoards::SiteQuery`
- **Factory de documentos por tipo** (`DocumentByType`) → `Documents::TypeFactory`
- **Leitura de `user_type`** em `Signature#user_table` → predicados do enum (sem novo objeto)

Adicionalmente: `ExaminationBoard.touch_related_to` centraliza a lógica de cache de `AcademicActivity`.

Comportamento funcional preservado em todos os casos.

---

## Inventário antes da alteração

| Método / Concern | Local original | Consumidores | Ação |
|---|---|---|---|
| `status` | `ExaminationBoard` | `_tbody.html.erb`, `TableComponent` | Extraído para `StatusPresenter` |
| `distance_of_date` | `ExaminationBoard` | `_tbody.html.erb`, `TableComponent` | Extraído para `StatusPresenter` |
| `include ActionView::Helpers::DateHelper` | `ExaminationBoard` | Necessário para `distance_of_time_in_words` | Removido do model |
| `cs_asc_from_now_desc_ago` | `ExaminationBoard` (class method) | `SiteController` | Extraído para `SiteQuery` |
| `current_calendar_for_site` | `ExaminationBoard` (class method privado) | `cs_asc_from_now_desc_ago` | Extraído para `SiteQuery` |
| `base_scope_for_calendar` | `ExaminationBoard` (class method privado) | `upcoming_from_now`, `past_until_now` | Extraído para `SiteQuery` |
| `upcoming_from_now` | `ExaminationBoard` (class method privado) | `cs_asc_from_now_desc_ago` | Extraído para `SiteQuery` |
| `past_until_now` | `ExaminationBoard` (class method privado) | `cs_asc_from_now_desc_ago` | Extraído para `SiteQuery` |
| `DocumentByType` concern | `Document` (include) | `TsoRequestsController`, `TepRequestsController`, `Professors::RequestsController` | Extraído para `Documents::TypeFactory` |
| `user_table` | `Signature` | `user`, specs | Refatorado no mesmo método |
| `clear_examination_boards_cache` | `AcademicActivity` | `after_commit` callback | Delegado para `ExaminationBoard.touch_related_to` |

---

## Arquivos alterados

| Arquivo | Responsabilidade da mudança |
|---|---|
| `app/models/examination_board.rb` | Removidos: `require 'action_view'`, `include ActionView::Helpers::DateHelper`, `status`, `distance_of_date`, 5 class methods de consulta do site. Adicionado: `touch_related_to`. Removido `# TODO` de `touch_updated_at`. |
| `app/models/document.rb` | Removido `include DocumentByType` |
| `app/models/signature.rb` | `user_table` refatorado para usar predicados do enum |
| `app/models/academic_activity.rb` | `clear_examination_boards_cache` delega para `ExaminationBoard.touch_related_to` |
| `app/views/shared/examination_boards/_tbody.html.erb` | Usa `ExaminationBoards::StatusPresenter` |
| `app/components/examination_boards/table_component.rb` | `badge_html`/`badge_style` usam `StatusPresenter` |
| `app/controllers/site_controller.rb` | `examination_boards` usa `ExaminationBoards::SiteQuery.call` |
| `app/controllers/academics/tso_requests_controller.rb` | `Document.new_tso` → `Documents::TypeFactory.new_tso` |
| `app/controllers/academics/tep_requests_controller.rb` | `Document.new_tep` → `Documents::TypeFactory.new_tep` |
| `app/controllers/professors/requests_controller.rb` | `Document.new_tdo` → `Documents::TypeFactory.new_tdo` |
| `app/services/examination_boards/status_presenter.rb` | **Novo** — apresentação de status/distância de data |
| `app/services/examination_boards/site_query.rb` | **Novo** — consulta composta do site público |
| `app/services/documents/type_factory.rb` | **Novo** — factory de criação de documentos por tipo |
| `spec/models/examination_boards/examination_board_status_spec.rb` | Atualizado para testar `ExaminationBoards::StatusPresenter` |
| `spec/models/orientations/orientation_ordering_spec.rb` | Atualizado para testar `ExaminationBoards::SiteQuery.call` |
| `spec/models/documents/document_generation_spec.rb` | Atualizado para testar `Documents::TypeFactory` |

---

## Contratos dos objetos extraídos

### `ExaminationBoards::StatusPresenter`

- **Entrada**: instância de `ExaminationBoard` (com `date` preenchido)
- **`#status`**: retorna `'today'`, `'next'` ou `'occurred'` com base na comparação entre `Date.current` e `board.date`
- **`#distance_of_date`**: retorna string localizada via `I18n.t('views.tables.examination_board.*')` usando `distance_of_time_in_words`
- **Dependências**: `ActionView::Helpers::DateHelper` (incluído na classe, fora do model)
- **Consumidores**: `_tbody.html.erb`, `ExaminationBoards::TableComponent`

### `ExaminationBoards::SiteQuery`

- **Entrada**: `relation` (ActiveRecord::Relation de `ExaminationBoard`, default `ExaminationBoard.all`)
- **`.call(relation)`**: retorna `Array` de `ExaminationBoard` com `site_with_relationships` precarregados
- **Ordem**: bancas futuras em ASC de data, seguidas de bancas passadas em DESC de data, dentro do período do calendário atual
- **Calendário atual**: `Calendar.where('? BETWEEN start_date AND end_date', Date.current).first` com fallback para o mais recente
- **Retorna `[]`** quando não há calendário disponível

### `Documents::TypeFactory`

- **`.new_tdo(professor, params)`**: cria `Document` do tipo TDO com `request[:requester]` de tipo `'advisor'`
- **`.new_tep(academic, params)`**: cria `Document` do tipo TEP com `request[:requester]` de tipo `'academic'`; preenche `params[:orientation_id]` a partir de `academic.current_orientation`
- **`.new_tso(academic, params)`**: cria `Document` do tipo TSO com `request[:requester]` e `request[:new_orientation]`; aplica `.shift` em `professor_supervisor_ids` e `external_member_supervisor_ids` (efeito colateral preservado); preenche `orientation_id`
- Retorna instância de `Document` não persistida com `request` preenchido
- Contratos de chaves do `request` preservados integralmente

### `ExaminationBoard.touch_related_to`

- **`.touch_related_to(academic_activity, orientation)`**: itera as bancas da orientação e toca as que têm `academic_activity == academic_activity`
- Centraliza a lógica que antes estava espalhada em `AcademicActivity#clear_examination_boards_cache`

---

## Comportamento preservado

### Status/distância de data
- A view `_tbody.html.erb` continua fornecendo os data-attributes `status-value` e `label-value` ao controller Stimulus com os mesmos valores
- O `TableComponent` continua renderizando o badge correto para today/next/occurred
- A lógica de comparação de datas foi copiada sem alteração para o presenter

### Consulta do site público
- `SiteController#examination_boards` continua populando `@proposal_examination_boards`, `@project_examination_boards` e `@monograph_examination_boards`
- A resolução do calendário atual (por intervalo, com fallback para o mais recente) foi preservada integralmente em `SiteQuery#current_calendar_for_site`
- A ordenação (upcoming ASC + past DESC) e o carregamento em memória (`to_a`) foram preservados
- O filtro por tipo de banca (proposal/project/monograph) é passado como `relation` ao serviço

### Criação de documentos por tipo
- Os três controllers continuam chamando um método com a mesma assinatura (`TypeFactory.new_tdo(user, params)`)
- O efeito de `.shift` em `new_tso` é preservado
- As chaves de `request` (`requester`, `new_orientation`, `advisor`, `professorSupervisors`, `externalMemberSupervisors`) são idênticas

### Resolução de `user_type` em assinaturas
- `Signature#user_table` retorna `Academic`, `ExternalMember` ou `Professor` para os mesmos 10 valores do enum
- Nenhum valor persistido foi alterado
- Os predicados usados (`user_type_academic?`, `user_type_external_member_supervisor?`, `user_type_external_member_evaluator?`, `user_type_responsible_institution?`) são gerados automaticamente pelo enum com `prefix: :user_type`

---

## Achados sobre comportamento existente

### `DocumentByType` concern — arquivo permanece como código morto
O concern `app/models/concerns/document_by_type.rb` não é mais incluído em nenhuma classe após a remoção do `include DocumentByType` de `Document`. O arquivo permanece no repositório sem efeito. Recomenda-se removê-lo em uma tarefa de limpeza posterior.

### `save_judgment` / `update_requester_justification` (item 6 — não executado)
Esses métodos permanecem no model `Document`. A extração exigiria replicar o contrato truthy/falsy com `errors.add` e `update_attribute` (rubocop disable) em um serviço, o que não simplificaria nem o model nem os controllers consumidores. Decisão: manter no model, conforme orientação da task.

### `TableComponent` — consumidor não explicitado no escopo
O `app/components/examination_boards/table_component.rb` usa `examination_board.status` e `examination_board.distance_of_date`. Como a remoção desses métodos do model quebraria o componente, ele foi atualizado para usar `StatusPresenter`. A mudança foi mínima e localizada em `badge_html`/`badge_style`.

---

## Métricas antes/depois

| Arquivo | Linhas (antes) | Linhas (depois) | Métodos removidos |
|---|---|---|---|
| `examination_board.rb` | ~234 | 178 | 7 (status, distance_of_date, cs_asc_from_now_desc_ago, current_calendar_for_site, base_scope_for_calendar, upcoming_from_now, past_until_now) |
| `document.rb` | 143 | 142 | 0 (include removido, methods estavam no concern) |
| `signature.rb` | 43 | 41 | 0 (refatoração interna) |
| `academic_activity.rb` | 56 | 51 | 0 (delegação simplificada) |

**Objetos novos criados:** 3 (`StatusPresenter`, `SiteQuery`, `TypeFactory`)

---

## Validação

### Comandos sugeridos

```bash
bundle exec rspec spec/models/examination_boards/examination_board_status_spec.rb \
  spec/models/orientations/orientation_ordering_spec.rb \
  spec/models/documents/document_generation_spec.rb \
  spec/models/signatures/ \
  spec/services/examination_boards/ \
  spec/services/documents/ \
  spec/controllers/responsible/examination_boards_controller_spec.rb \
  spec/controllers/tcc_one_professors/examination_boards_controller_spec.rb \
  spec/features/site/examination_boards/

bundle exec rubocop app/models/examination_board.rb \
  app/models/document.rb \
  app/models/signature.rb \
  app/models/academic_activity.rb \
  app/services/examination_boards/ \
  app/services/documents/ \
  app/components/examination_boards/table_component.rb \
  app/controllers/site_controller.rb

bundle exec rspec
bundle exec rubocop --parallel
```

> Validação dinâmica não foi executada nesta sessão.

---

## Riscos e próximos passos

- **`app/models/concerns/document_by_type.rb`**: arquivo morto, pode ser removido em limpeza separada (REF-08 ou tarefa de housekeeping)
- **`save_judgment`/`update_requester_justification`**: mantidos no model por decisão explícita; extração futura requer análise do contrato de erro com os 4 controllers consumidores
- **REF-08**: revisão geral de services e código morto (inclui remoção do concern)
- **REF-09/REF-10**: `Calendar` e navegação entre períodos — não alterados nesta task
- A regra de `Orientation` não foi tocada; os services da REF-06 seguem funcionando
