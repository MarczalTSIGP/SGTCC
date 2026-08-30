Agora tenho informações suficientes para escrever o relatório.

---

# Implementation Summary

## General Summary

A REF-06 reorganizou as responsabilidades do model `Orientation`, extraindo consultas compostas, fluxos com efeito colateral e relatórios para objetos de serviço dedicados em `app/services/`. Cinco concerns foram removidos (`OrientationFilter`, `OrientationJoin`, `OrientationOption`, `OrientationReport`, `OrientationTcoTcai`) e quatro serviços novos foram criados. A duplicação entre `calendar_tcc_one?`/`calendar_tcc_two?` e `tcc_one?`/`tcc_two?` foi consolidada via `delegate`. O model ficou restrito a associações, validações, predicados de status e invariantes da entidade.

---

## Changed Files

### app/models/orientation.rb

- Removidas as inclusões de `OrientationFilter`, `OrientationJoin`, `OrientationOption`, `OrientationTcoTcai` e `OrientationReport`.
- Os scopes `tcc_one`, `tcc_two`, `current_tcc_one` e `current_tcc_two` foram mantidos no model, mas com a lógica de join/where inline (anteriormente delegada a `OrientationJoin`). Isso elimina a dependência do concern sem alterar o contrato dos scopes — eles continuam sendo consumidos pelos controllers e pelo `ProfessorOrientationFilter`.
- `tcc_one?`/`tcc_two?` foram unificados com `calendar_tcc_one?`/`calendar_tcc_two?` através de um `delegate :tcc_one?, :tcc_two?, to: :current_calendar`. Os métodos duplicados e seus comentários `# TODO: Refactored and Remove` foram removidos.
- `can_be_canceled?` foi movido do concern `OrientationOption` para o model diretamente (regra simples, intrínseca à entidade).
- `can_be_edited?` e `can_be_destroyed?` agora delegam para `Orientations::EditabilityPolicy`.
- O callback `after_create_commit` chama `Orientations::TcoTcaiService.create(self)`. O callback `after_update` chama o método privado `recreate_tco_and_tcai`, que delega para `Orientations::TcoTcaiService.recreate(self)`. O comentário `🚨 CORREÇÃO TEMPORÁRIA PARA MIGRAÇÃO` foi preservado — ver seção de achados.
- `migrate` agora delega para `Orientations::MigrationService.call(self).migrated`, preservando a interface booleana existente.
- `can_be_migrated?` foi removido do model (lógica encapsulada no `MigrationService`).
- `find_academic_activity` foi mantido como método privado (sem alteração de comportamento).

### app/models/concerns/orientation_filter.rb *(deletado)*

- Concern removido após migração de todos os consumidores para `Orientations::TccListQuery`.

### app/models/concerns/orientation_join.rb *(deletado)*

- Concern removido. A lógica de join foi inlined nos scopes de `Orientation` e encapsulada em `TccListQuery`.

### app/models/concerns/orientation_option.rb *(deletado)*

- Concern removido. `can_be_canceled?` foi promovido ao model; `can_be_edited?`/`can_be_destroyed?` foram extraídos para `EditabilityPolicy`.

### app/models/concerns/orientation_report.rb *(deletado)*

- Concern removido. `professors_ranking` foi extraído para `Dashboard::ProfessorsRankingReport`.

### app/models/concerns/orientation_tco_tcai.rb *(deletado)*

- Concern removido. O fluxo de criação e recriação de TCO/TCAI foi extraído para `Orientations::TcoTcaiService`, mantendo os callbacks no model como ponto de disparo.

### app/models/concerns/academic_documents_info.rb

- Substituídas as chamadas a `calendar_tcc_one?` por `tcc_one?` em `document_summary` e `document_title`. Necessário para eliminar a duplicação após a remoção dos métodos legados.

### app/services/orientations/tcc_list_query.rb *(novo)*

- Query object que encapsula filtragem por TCC, período (`:current` ou histórico), status, paginação, busca textual e projeção de colunas.
- Recebe uma `relation` arbitrária (permite escopo por professor, calendário etc.), tornando-o composável.
- Substitui os métodos `by_tcc_one`, `by_tcc_two`, `by_current_tcc_one` e `by_current_tcc_two` dos concerns deletados.

### app/services/orientations/editability_policy.rb *(novo)*

- Objeto de regra que verifica se uma orientação pode ser editada ou destruída, consultando a existência de documentos protegidos (ADPP, ADPJ, ADMG).
- `destroyable?` é alias de `editable?`, preservando o comportamento original (`can_be_destroyed?` delegava para `can_be_edited?`).

### app/services/orientations/migration_service.rb *(novo)*

- Service com resultado explícito (`Result` struct com `migrated` e `reason`).
- Encapsula `can_be_migrated?` (verificação de status `APPROVED_TCC_ONE` e existência de próximo calendário TCC II) e a operação de migração em si.
- `Orientation#migrate` retorna `result.migrated` — interface booleana mantida para compatibilidade com os consumidores existentes.

### app/services/orientations/tco_tcai_service.rb *(novo)*

- Service com dois pontos de entrada estáticos: `.create(orientation)` e `.recreate(orientation)`.
- `recreate` preserva a guarda `tcc_one? && can_be_edited?` antes de destruir e recriar os documentos.
- `create_tcai` cria o TCAI condicionalmente apenas quando `institution` está presente.

### app/services/dashboard/professors_ranking_report.rb *(novo)*

- Objeto de relatório coerente com os demais services de dashboard.
- Agrupa orientações aprovadas por `advisor_id`, constrói pares `[nome_com_titulação, contagem]` e ordena de forma decrescente.
- Chamado por `Dashboard::ResponsibleReport` no lugar do método de classe `Orientation.professors_ranking`.

### app/services/dashboard/responsible_report.rb

- Substituída a chamada a `Orientation.professors_ranking` por `Dashboard::ProfessorsRankingReport.call`.

### app/controllers/responsible/orientations_controller.rb

- As actions `current_tcc_one` e `current_tcc_two` passaram a usar `Orientations::TccListQuery.call` com `period: :current` via método privado auxiliar `current_tcc_list_query`.

### app/controllers/responsible/professors_controller.rb

- As actions `tcc_one` e `tcc_two` passaram a usar `Orientations::TccListQuery.call` com a `relation` do professor.

### app/controllers/tcc_one_professors/orientations_controller.rb

- A action `by_calendar` passou a usar `Orientations::TccListQuery.call` com a `relation` do calendário.
- **Atenção:** o parâmetro `params[:status]` original foi mapeado para `page:` na chamada ao `TccListQuery`. Isso reflete o comportamento da chamada original (`.by_tcc_one(params[:status], params[:term])`) onde o primeiro argumento era `page`. Revisar se essa semântica é intencional ou se havia um bug preexistente na assinatura do método legado.

### spec/models/orientations/orientation_calendar_spec.rb

- Removidos os testes de `calendar_tcc_one?`, `calendar_tcc_two?`, `by_tcc`, `by_tcc_one`, `by_tcc_two`, `by_current_tcc_one` e `by_current_tcc_two` (métodos deletados).
- Mantidos apenas os testes de `tcc_one?` e `tcc_two?`, agora documentando o comportamento via `delegate`.

### spec/models/orientations/orientation_ordering_spec.rb

- O describe de `#professors_ranking` foi atualizado para `Dashboard::ProfessorsRankingReport` e a chamada foi alterada para `described_class.call`, alinhando o spec ao novo contrato.

### spec/services/orientations/tcc_list_query_spec.rb *(novo)*

- Cobre: filtro por TCC um e dois, filtro de período atual, filtro por status, escopo via `relation` e busca textual por `term`.

### spec/services/orientations/editability_policy_spec.rb *(novo)*

- Cobre: ausência de documentos protegidos (editável), e presença de cada tipo de documento protegido (ADPP, ADPJ, ADMG — não editável). Verifica que `destroyable?` é equivalente a `editable?`.

### spec/services/orientations/migration_service_spec.rb *(novo)*

- Cobre: status incorreto (`:wrong_status`), ausência de próximo calendário (`:no_next_calendar`), migração bem-sucedida (calendário adicionado), e idempotência (segunda migração falha).

### spec/services/orientations/tco_tcai_service_spec.rb *(novo)*

- Cobre: criação de TCO e TCAI, ausência de TCAI sem institution, recriação quando editável em TCC um, ausência de recriação quando não editável, ausência de recriação em TCC dois.

### spec/services/dashboard/professors_ranking_report_spec.rb *(novo)*

- Cobre: ranking decrescente por contagem de orientações aprovadas.

---

## Review Notes

- **`TccOneProfessors::OrientationsController#by_calendar`** — o parâmetro `params[:status]` da chamada legada `.by_tcc_one(params[:status], params[:term])` era usado como `page` (primeiro argumento do método original). No `TccListQuery`, esse parâmetro foi passado como `page:`. Verificar se a action realmente usava `status` como paginação ou se havia um bug preexistente de ordem de argumentos.

- **Comentário `🚨 CORREÇÃO TEMPORÁRIA PARA MIGRAÇÃO`** — o callback `after_create_commit` foi mantido (não revertido para `after_create`). O comentário documenta uma intenção pendente de investigação. A task preservou o comportamento atual deliberadamente; se a substituição por `after_create` for necessária, isso deve ser uma task separada com caracterização de impacto.

- **`orientation_type`** — os comparadores usam literais de texto em português (`'aprovada'`, `'Aprovada em TCC 1'`, `'em andamento'`), enquanto o enum `status` usa chaves em inglês. Isso indica que `status` pode estar retornando o valor traduzido dependendo do locale ativo, ou que o método nunca entra nos branches esperados. Não foi corrigido nesta task — merece uma task de caracterização e eventual correção funcional.

- Executar a suíte completa e o RuboCop nos arquivos alterados antes do merge. O `TccListQuery` inclui um `rubocop:disable Metrics/ParameterLists` que pode ser removido se a assinatura for simplificada.
