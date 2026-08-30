# REF-06 — Reorganizar Orientation

## Resumo

`Orientation` foi reduzido às responsabilidades intrínsecas de entidade de domínio: associações, validações, enum de status, predicados de status e invariantes (`active?`, `can_be_canceled?`, `short_title`, `supervisors`). Cinco concerns foram extraídos para services dedicados. A duplicação `calendar_tcc_one?`/`tcc_one?` foi consolidada. As quatro ações de controller que usavam `OrientationFilter` foram migradas para `Orientations::TccListQuery`.

---

## Inventário antes da alteração

| Concern / Área | Responsabilidade | Consumidores confirmados | Destino |
|---|---|---|---|
| `OrientationJoin` | Helpers `join_with_status_by_tcc`, `join_current_calendar_*` | Scopes `tcc_one`, `tcc_two`, `current_tcc_one`, `current_tcc_two` | Inlineado diretamente nas lambdas dos scopes (eliminado) |
| `OrientationFilter` | Queries paginadas `by_tcc_one`, `by_tcc_two`, `by_current_tcc_one`, `by_current_tcc_two` | `Responsible::ProfessorsController`, `Responsible::OrientationsController`, `TccOneProfessors::OrientationsController` | → `Orientations::TccListQuery` |
| `OrientationOption` | `can_be_edited?`, `can_be_destroyed?`, `can_be_canceled?` | Controllers concerns `OrientationEdit`, `OrientationDestroy`; services de links | `can_be_edited?`/`can_be_destroyed?` → `Orientations::EditabilityPolicy`; `can_be_canceled?` → mantido no model |
| `OrientationTcoTcai` | Callbacks `after_create_commit`/`after_update`, `create_tco`, `create_tcai` | Disparado pelos callbacks; `Populate::Orientations` via modelo | → `Orientations::TcoTcaiService` |
| `OrientationReport` | `professors_ranking`, `professors_ranking_data` | `Dashboard::ResponsibleReport` | → `Dashboard::ProfessorsRankingReport` |
| `orientation.rb` direto | `migrate`, `can_be_migrated?`, `tcc_one?`, `tcc_two?`, `calendar_tcc_one?`, `calendar_tcc_two?` | Controllers de migração, `AcademicDocumentsInfo`, `Populate::Orientations` | `migrate` → delega a `Orientations::MigrationService`; duplicação `calendar_tcc_*?` consolidada em `tcc_*?` via `delegate` |

---

## Arquivos alterados

| Arquivo | Tipo de mudança |
|---|---|
| `app/models/orientation.rb` | Remove 5 includes; callbacks agora disparam services; `migrate` delega a `MigrationService`; `tcc_one?`/`tcc_two?` via `delegate`; scopes inlineados sem helpers externos; `calendar_tcc_one?`/`calendar_tcc_two?` removidos |
| `app/models/concerns/academic_documents_info.rb` | `calendar_tcc_one?` → `tcc_one?` |
| `app/models/concerns/orientation_join.rb` | **Deletado** |
| `app/models/concerns/orientation_filter.rb` | **Deletado** |
| `app/models/concerns/orientation_option.rb` | **Deletado** |
| `app/models/concerns/orientation_tco_tcai.rb` | **Deletado** |
| `app/models/concerns/orientation_report.rb` | **Deletado** |
| `app/services/orientations/tcc_list_query.rb` | **Criado** |
| `app/services/orientations/editability_policy.rb` | **Criado** |
| `app/services/orientations/tco_tcai_service.rb` | **Criado** |
| `app/services/orientations/migration_service.rb` | **Criado** |
| `app/services/dashboard/professors_ranking_report.rb` | **Criado** |
| `app/controllers/responsible/professors_controller.rb` | `by_tcc_one`/`by_tcc_two` → `TccListQuery` |
| `app/controllers/tcc_one_professors/orientations_controller.rb` | `by_tcc_one` → `TccListQuery` |
| `app/controllers/responsible/orientations_controller.rb` | `by_current_tcc_one`/`by_current_tcc_two` → `TccListQuery` via helper privado |
| `app/services/dashboard/responsible_report.rb` | `Orientation.professors_ranking` → `Dashboard::ProfessorsRankingReport.call` |
| `spec/models/orientations/orientation_calendar_spec.rb` | Removidos testes de `calendar_tcc_one?`/`by_tcc_*` (migrados); adicionados testes de `tcc_one?`/`tcc_two?` |
| `spec/models/orientations/orientation_ordering_spec.rb` | `Orientation.professors_ranking` → `Dashboard::ProfessorsRankingReport.call` |
| `spec/services/orientations/tcc_list_query_spec.rb` | **Criado** |
| `spec/services/orientations/editability_policy_spec.rb` | **Criado** |
| `spec/services/orientations/tco_tcai_service_spec.rb` | **Criado** |
| `spec/services/orientations/migration_service_spec.rb` | **Criado** |
| `spec/services/dashboard/professors_ranking_report_spec.rb` | **Criado** |

---

## Contratos dos objetos extraídos

### `Orientations::TccListQuery`

```ruby
Orientations::TccListQuery.call(
  relation:,      # ActiveRecord::Relation base (e.g. professor.orientations, Orientation.all)
  tcc:,           # :one | :two
  page:,          # valor de paginação Kaminari (nil = página 1)
  term:,          # string de busca (nil/blank = sem filtro)
  status: nil,    # valor de status Orientation (nil/blank = todos)
  period: nil     # :current = filtra pelo semestre atual; nil = todos os períodos
)
# → ActiveRecord::Relation (paginada, com includes de apresentação, ordenada por .recent)
```

**Garantias de segurança:** sem `send` com entrada aberta; sem filtragem em memória; toda filtragem delega aos scopes do model.

### `Orientations::EditabilityPolicy`

```ruby
policy = Orientations::EditabilityPolicy.new(orientation)
policy.editable?    # → Boolean; false se existem documentos adpp/adpj/admg associados
policy.destroyable? # → Boolean; alias de editable?
```

### `Orientations::TcoTcaiService`

```ruby
Orientations::TcoTcaiService.create(orientation)
# Cria TCO; cria TCAI apenas se orientation.institution presente.

Orientations::TcoTcaiService.recreate(orientation)
# Recria TCO e TCAI somente se tcc_one? && can_be_edited?; caso contrário, no-op.
```

**Nota sobre o comentário `🚨 CORREÇÃO TEMPORÁRIA PARA MIGRAÇÃO`:** o callback `after_create_commit` (em vez de `after_create`) foi preservado intencionalmente. O comentário foi mantido no `orientation.rb`. A revisão dessa decisão pertence a uma task funcional separada.

### `Orientations::MigrationService`

```ruby
result = Orientations::MigrationService.call(orientation)
result.migrated  # → Boolean
result.reason    # → nil | :wrong_status | :no_next_calendar
```

O model mantém `def migrate = Orientations::MigrationService.call(self).migrated` para compatibilidade com todos os consumidores (`Responsible::OrientationsMigrationController`, `Populate::Orientations`).

### `Dashboard::ProfessorsRankingReport`

```ruby
Dashboard::ProfessorsRankingReport.call
# → Array de [name_with_scholarity, count], ordenado por count decrescente
# Inclui apenas orientações com final_monograph (reusa Orientation.approved)
```

---

## Comportamento preservado

| Comportamento | Evidência |
|---|---|
| Scopes `tcc_one`, `tcc_two`, `current_tcc_one`, `current_tcc_two` | Continuam no model; lambdas reescritas inline sem dependências externas; testados por `TccListQuery` spec e `ParticipantListQuery` spec |
| `can_be_edited?`/`can_be_destroyed?` | Delegam para `EditabilityPolicy`; specs de model passam sem alteração |
| Criação TCO/TCAI ao criar orientação | Callback `after_create_commit` preservado; spec `orientation_after_create_spec.rb` passa |
| Recriação TCO/TCAI ao atualizar | Guard `tcc_one? && can_be_edited?` preservado no service; spec `orientation_after_update_spec.rb` passa |
| Migração TCC I → TCC II | `migrate` retorna boolean; spec `orientation_migration_spec.rb` passa |
| `professors_ranking` | `Dashboard::ProfessorsRankingReport.call` retorna mesma estrutura; spec atualizado passa |
| `tcc_one?`/`tcc_two?` (via `delegate`) | Comportamento idêntico ao anterior; `AcademicDocumentsInfo` atualizado |

---

## Achados sobre comportamento existente

### `TccOneProfessors::OrientationsController#by_calendar` — mapeamento de parâmetros invertido

A chamada original `@calendar.orientations.by_tcc_one(params[:status], params[:term]).recent` passava `params[:status]` onde deveria estar `page` e `params[:term]` onde deveria estar `term`. Isso resultava em: nenhum filtro de status, paginação ignorada (Kaminari retorna página 1 para valor não numérico).

O comportamento foi **preservado intencionalmente** na refatoração (`page: params[:status], term: params[:term]`). Correção funcional é uma task separada fora do escopo de refatoração estrutural.

### `orientation_type` — comparação com literais de status traduzidos

O método `orientation_type` compara `status` com literais em português (`'aprovada'`, `'Aprovada em TCC 1'`, `'em andamento'`), que são os valores retornados pelo enum traduzido via `I18n.t`. Esse comportamento foi **mantido sem alteração** — a consistência depende da tradução ativa. Merece uma task funcional separada para avaliar se a comparação deveria ser feita contra as chaves internas (`'APPROVED'`, `'APPROVED_TCC_ONE'`, `'IN_PROGRESS'`).

---

## Métricas antes/depois

| Métrica | Antes | Depois |
|---|---|---|
| Linhas de `orientation.rb` | 297 | ~250 (−47) |
| Linhas de concerns somados | 148 (5 concerns) | 0 (5 deletados) |
| Concerns incluídos | 8 | 3 (`OrientationStatus`, `OrientationDocuments`, `OrientationValidation`) |
| Services novos | 0 | 5 (`TccListQuery`, `EditabilityPolicy`, `TcoTcaiService`, `MigrationService`, `ProfessorsRankingReport`) |
| Consultas paginadas encadeadas no model | 4 (`by_tcc_one`, `by_tcc_two`, `by_current_tcc_one`, `by_current_tcc_two`) | 0 |
| Duplicações removidas | — | `calendar_tcc_one?`/`tcc_one?` (par consolidado via `delegate`) |
| Specs de services novos | 0 | 5 arquivos, ~50 exemplos |

---

## Validação

### Specs focadas

```
./run rspec spec/models/orientations/ spec/services/orientations/ spec/services/dashboard/professors_ranking_report_spec.rb spec/features/responsible/orientations/ spec/features/tcc_one_professors/orientations/
```

**Resultado:** 189 exemplos, 0 falhas.

### RuboCop nos arquivos alterados

**Resultado:** 19 arquivos inspecionados, 0 offenses.

### Falhas preexistentes (não introduzidas por esta task)

15 falhas em `spec/models/calendar/`, `spec/models/documents/document_callbacks_spec.rb`, `spec/models/external_members/`, `spec/models/professors/`, `spec/models/site_spec.rb`, `spec/controllers/tcc_one_professors/examination_boards_controller_spec.rb`, `spec/services/populate/calendars_spec.rb`. Todas em áreas não modificadas por esta task.

---

## Riscos e próximos passos

- **`skip_documents_callbacks`** em `tmp/local_migrations/`: o accessor e o guard no callback foram preservados. Migrations locais não foram alteradas (proibido pelo escopo).
- **`orientation_type` com literais de status**: registrado como achado; correção funcional pertence a task separada.
- **Mapeamento de params em `TccOneProfessors::OrientationsController#by_calendar`**: bug preservado; correção pertence a task funcional.
- **`ExaminationBoard`, `Document`, `Signature`**: não tocados; pertencem à REF-07.
- **`Calendar` e navegação entre períodos**: não tocados; pertencem às REF-09/REF-10.
- **`ProfessorOrientationFilter`**: não alterado; continua consumindo os scopes `tcc_one`, `tcc_two`, `current_tcc_one`, `current_tcc_two` que permanecem no model.
