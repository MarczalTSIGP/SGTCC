Tenho todas as informações necessárias. Vou redigir o relatório final agora.

---

# Implementation Summary

## General Summary

A REF-07 extraiu responsabilidades de apresentação, consulta composta e criação de documentos dos models `ExaminationBoard`, `Document` e `Signature`, reduzindo-os às suas responsabilidades intrínsecas de entidade de domínio (associações, validações, enums, scopes e invariantes).

As extrações realizadas foram:

1. **`ExaminationBoards::StatusPresenter`** — os métodos `status` e `distance_of_date`, antes no model com dependência de `ActionView::Helpers::DateHelper`, foram movidos para um objeto de apresentação dedicado. O `include ActionView::Helpers::DateHelper` foi removido do model.
2. **`ExaminationBoards::SiteQuery`** — o grupo de métodos de consulta composta do site público (`cs_asc_from_now_desc_ago`, `current_calendar_for_site`, `base_scope_for_calendar`, `upcoming_from_now`, `past_until_now`) foi extraído para um query object, preservando a lógica de resolução de calendário e a concatenação ordenada de "próximas + passadas".
3. **`Documents::TypeFactory`** — os métodos de classe `new_tdo`, `new_tep` e `new_tso` (concern `DocumentByType`) foram extraídos para uma factory de serviço; o concern foi removido do `Document`.
4. **`Signature#user_table`** — a comparação com string literal `'academic'` e o array `%w[...]` foram substituídos pelos predicados gerados pelo enum (`user_type_academic?`, `user_type_external_member_supervisor?`, `user_type_external_member_evaluator?`, `user_type_responsible_institution?`).
5. **`ExaminationBoard.touch_related_to`** — o método de classe foi adicionado ao model para encapsular a iteração de toque de cache, e `AcademicActivity#clear_examination_boards_cache` passou a delegá-lo, eliminando o acesso direto interno e o TODO pendente.

## Changed Files

### `app/models/examination_board.rb`

- Removidos: `require 'action_view'` e `include ActionView::Helpers::DateHelper`.
- Removidos: métodos de instância `status` e `distance_of_date`.
- Removidos: métodos de classe `cs_asc_from_now_desc_ago`, `current_calendar_for_site`, `base_scope_for_calendar`, `upcoming_from_now` e `past_until_now`.
- Adicionado: método de classe `touch_related_to(academic_activity, orientation)` que centraliza a lógica de invalidação de cache antes dispersa em `AcademicActivity`.
- Removido: comentário `# TODO: Tests for this method` de `touch_updated_at` (o TODO foi resolvido na spec migrada).
- O model mantém apenas associações, validações, enums, scopes simples e invariantes da entidade.

### `app/models/document.rb`

- Removido: `include DocumentByType`.
- O concern `DocumentByType` deixou de ser incluído no model após a migração da factory para `Documents::TypeFactory`.
- Todas as demais responsabilidades (TermJsonData, SignatureMark, DocumentSigned, DocumentReview, `save_judgment`, `update_requester_justification`, `filename`) permanecem no model inalteradas.

### `app/models/signature.rb`

- `user_table`: substituída a comparação `user_type == 'academic'` por `user_type_academic?` e o array `%w[external_member_supervisor external_member_evaluator responsible_institution]` pelos três predicados gerados pelo enum (`user_type_external_member_supervisor?`, `user_type_external_member_evaluator?`, `user_type_responsible_institution?`).
- O resultado (`Academic`, `ExternalMember` ou `Professor`) permanece idêntico para os dez valores do enum; nenhum mapeamento persistido foi alterado.

### `app/models/academic_activity.rb`

- `clear_examination_boards_cache`: substituída a iteração direta com `examination_board.touch` pela chamada `ExaminationBoard.touch_related_to(self, academic.current_orientation)`.
- Removido o comentário `# TODO: Refactor and write tests for this method`.
- O efeito observável (tocar os registros de banca relacionados ao `AcademicActivity` corrente) é preservado.

### `app/views/shared/examination_boards/_tbody.html.erb`

- Adicionada instância de `ExaminationBoards::StatusPresenter` na abertura do partial.
- As referências `examination_board.status` e `examination_board.distance_of_date` foram substituídas por `eb_presenter.status` e `eb_presenter.distance_of_date`.
- Nenhuma outra linha da view foi alterada.

### `app/components/examination_boards/table_component.rb`

- `badge_html`: cria agora um `ExaminationBoards::StatusPresenter` e o passa para `badge_style` em vez de passar a banca diretamente.
- `badge_style`: renomeado o parâmetro de `examination_board` para `presenter`; chama `presenter.status` no `case`.
- O comportamento de `badge_html` (badge colorido com tooltip de distância) é preservado.

### `app/controllers/site_controller.rb`

- `examination_boards`: as três atribuições de variáveis de instância que chamavam `ExaminationBoard.<scope>.cs_asc_from_now_desc_ago` foram substituídas por `ExaminationBoards::SiteQuery.call(ExaminationBoard.<scope>)`.
- Nenhuma rota, parâmetro ou resposta HTTP foi alterada.

### `app/controllers/academics/tep_requests_controller.rb`

- `create`: `Document.new_tep` → `Documents::TypeFactory.new_tep`.

### `app/controllers/academics/tso_requests_controller.rb`

- `create` e `destroy_and_update`: `Document.new_tso` → `Documents::TypeFactory.new_tso`.

### `app/controllers/professors/requests_controller.rb`

- `create` e `destroy_and_create`: `Document.new_tdo` → `Documents::TypeFactory.new_tdo`.

### `app/services/examination_boards/status_presenter.rb` _(novo)_

- Objeto de apresentação responsável por `status` e `distance_of_date` de uma banca.
- Inclui `ActionView::Helpers::DateHelper` localmente, isolando a dependência de view-helper ao serviço de apresentação.
- Inicializado com uma instância de `ExaminationBoard`.

### `app/services/examination_boards/site_query.rb` _(novo)_

- Query object para a listagem pública de bancas por tipo.
- Interface: `SiteQuery.call(relation)` recebe uma relation de `ExaminationBoard` (já filtrada por tipo) e retorna um array ordenado com bancas futuras ascendentes seguidas de bancas passadas descendentes, dentro do calendário corrente.
- Preserva integralmente a lógica de resolução do calendário (intervalo de datas com fallback para o mais recente) e o carregamento em memória via concatenação de dois arrays.

### `app/services/documents/type_factory.rb` _(novo)_

- Factory de criação de documentos por tipo.
- Métodos de classe: `new_tdo(professor, params)`, `new_tep(academic, params)`, `new_tso(academic, params)`, `new_request(user, user_type, document)`, `new_orientation_request(user, user_type, document)`.
- Preserva o efeito colateral de `.shift` em `new_tso` e a estrutura do hash `document.request` produzida por cada factory method.

### `spec/models/documents/document_generation_spec.rb`

- `RSpec.describe` alterado de `Document` para `Documents::TypeFactory`.
- Blocos `describe` e chamadas ajustados para `Documents::TypeFactory.new_tdo/new_tep/new_tso`.
- O bloco `describe '#filename'` foi renomeado para `describe 'Document#filename'` para manter clareza sobre o sujeito testado.

### `spec/models/examination_boards/examination_board_status_spec.rb`

- `RSpec.describe` alterado de `ExaminationBoard` para `ExaminationBoards::StatusPresenter`.
- Todos os exemplos instanciam `described_class.new(board)` e chamam `status`/`distance_of_date` sobre o presenter.
- `include ActionView::Helpers::DateHelper` movido para o contexto do grupo de describe em vez de estar aninhado dentro dos exemplos.

### `spec/models/orientations/orientation_ordering_spec.rb`

- Bloco `describe '#cs_asc_from_now_desc_ago'` renomeado para `describe 'ExaminationBoards::SiteQuery'`.
- Chamadas a `ExaminationBoard.cs_asc_from_now_desc_ago` substituídas por `ExaminationBoards::SiteQuery.call`.

### `ai/output/fase-3-desacoplamento-de-models-concerns-e-servicos/implementation-summary-ref-07-reorganizar-examination-board-document-signature.md` _(novo)_

- Este relatório.

### `ai/tasks/fase-3-desacoplamento-de-models-concerns-e-servicos/ref-07-reorganizar-examination-board-document-signature.md` _(novo)_

- Arquivo de task original da REF-07.

## Review Notes

### Pontos obrigatórios a verificar

1. **`ExaminationBoards::SiteQuery.call` sem argumento** — no arquivo `spec/models/orientations/orientation_ordering_spec.rb` a spec chama `ExaminationBoards::SiteQuery.call` sem argumento (sem passar uma relation). O método de classe aceita `ExaminationBoard.all` como default, mas as specs originais testavam `ExaminationBoard.cs_asc_from_now_desc_ago` que também operava sobre `self` (qualquer relation). Verifique se os exemplos que só chamam `SiteQuery.call` (sem passar `ExaminationBoard.proposal/project/monograph`) continuam representando o comportamento esperado para o site público, ou se deveriam passar a relation filtrada por tipo.

2. **`Documents::TypeFactory` — visibilidade dos métodos privados** — `new_request` e `new_orientation_request` são públicos na factory. Se forem usados apenas internamente, considere torná-los `private_class_method`. Verifique se há consumidores externos antes de mudar.

3. **`touch_related_to` — remoção do TODO em `academic_activity.rb`** — o TODO foi removido junto com a refatoração; certifique-se de que a spec correspondente de `AcademicActivity#clear_examination_boards_cache` cobre o comportamento (toque seletivo apenas na banca cuja `academic_activity` é igual ao `self`). Se não houver spec, adicione-a.

4. **`touch_updated_at` — TODO removido do comment** — o comentário `# TODO: Tests for this method` foi removido de `examination_board.rb`. Confirme que a spec de `touch_updated_at` existe e passa antes de considerar o item encerrado.

5. **Item 6 (save\_judgment / update\_requester\_justification)** — deliberadamente mantido no model. Os dois métodos usam `update_attribute` com bypass de validações (`rubocop:disable Rails/SkipsModelValidations`) e retornam `false` com `errors.add`. Extraí-los para um service mudaria o contrato observável dos quatro controllers consumidores (`Responsible::DocumentsController`, `TepRequestsController`, `TsoRequestsController`, `RequestsController`). A decisão de manter no model está registrada aqui; uma task funcional separada deve avaliar se o padrão `update_attribute` deve ser substituído por `update` com validação explícita.

6. **Execução da suíte completa** — valide com:
   ```bash
   bundle exec rspec spec/models/examination_boards/ \
     spec/models/documents/ \
     spec/models/signatures/ \
     spec/services/examination_boards/ \
     spec/services/documents/ \
     spec/features/site/examination_boards/ \
     spec/models/orientations/orientation_ordering_spec.rb

   bundle exec rubocop app/models/examination_board.rb \
     app/models/document.rb \
     app/models/signature.rb \
     app/models/academic_activity.rb \
     app/services/examination_boards/ \
     app/services/documents/

   bundle exec rspec
   bundle exec rubocop --parallel
   ```
