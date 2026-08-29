# REF-05 — Reestruturar controllers críticos

## Resumo

Foram extraídas consultas e fluxos repetidos dos controllers priorizados sem alterar rotas, templates, flashes, strong parameters ou regras acadêmicas.

- Listagens de bancas: `ExaminationBoards::ListQuery`.
- Dados de formulário de banca: `ExaminationBoards::FormContext`.
- Decisão de exclusão de banca: `ExaminationBoards::Destroy`.
- Listagens de orientações/supervisões por participante: `Orientations::ParticipantListQuery`.

Os controllers continuam responsáveis por autenticação/autorização existente, breadcrumbs, URLs, variáveis de apresentação, `render` e `redirect`.

## Inventário antes da alteração

| Controller/action | Consulta/regra anterior | Variáveis de view | Contrato HTTP preservado |
|---|---|---|---|
| `Responsible::ExaminationBoardsController#tcc_one_current_semester` | `ExaminationBoard.tcc_one_current_semester.search(params[:term]).page(params[:page]).order(date: :desc)` | `@examination_boards`, `@search_url`, `@new_url`, `@link_name` | `render :index` |
| `Responsible::ExaminationBoardsController#tcc_one` | `ExaminationBoard.tcc_one.search(params[:term]).page(params[:page]).order(date: :desc)` | mesmas variáveis | `render :index` |
| `Responsible::ExaminationBoardsController#tcc_two_current_semester` | `ExaminationBoard.tcc_two_current_semester.search(params[:term]).page(params[:page]).order(date: :desc)` | mesmas variáveis | `render :index` |
| `Responsible::ExaminationBoardsController#tcc_two` | `ExaminationBoard.tcc_two.search(params[:term]).page(params[:page]).order(date: :desc)` | mesmas variáveis | `render :index` |
| `TccOneProfessors::ExaminationBoardsController#tcc_one` | `ExaminationBoard.tcc_one.with_relationships.search(params[:term]).page(params[:page]).recent` | `@examination_boards`, `@search_url` | `render :index` |
| `TccOneProfessors::ExaminationBoardsController#tcc_two` | `ExaminationBoard.tcc_two.with_relationships.search(params[:term]).page(params[:page]).recent` | `@examination_boards`, `@search_url` | `render :index` |
| `Responsible::ExaminationBoardsController#new_to_tcc_one/#create_to_tcc_one` | `Orientation.current_tcc_one` e `Activity.human_tcc_one_identifiers` | `@examination_board`, `@orientations`, `@activities` | sucesso redireciona para TCC I; falha renderiza `:new_to_tcc_one` com `:unprocessable_content` |
| `Responsible::ExaminationBoardsController#new_to_tcc_two/#create_to_tcc_two` | `Orientation.current_tcc_two`, `Activity.human_tcc_two_identifiers`, default `identifier: :monograph` | mesmas variáveis | sucesso redireciona para TCC II; falha renderiza `:new_to_tcc_two` com `:unprocessable_content` |
| `Responsible::ExaminationBoardsController#edit/#update` | opções por `@examination_board.monograph?`; strong params limitados por `defense_minutes` | `@orientations`, `@activities`, `@disabled_field` | sucesso redireciona para show; falha renderiza `:edit` com `:unprocessable_content` |
| `TccOneProfessors::ExaminationBoardsController#new/#create/#edit/#update` | opções fixas de TCC I; strong params limitados por `defense_minutes`; bloqueio de edição/destruição de `monograph?` | `@examination_board`, `@orientations`, `@activities`, `@disabled_field` | mesmos renders, status e redirects |
| `Responsible::ExaminationBoardsController#destroy` | destrói se `defense_minutes.blank?`; bloqueia se ata existe | flash de sucesso ou alerta | redirect para índice ou show |
| `TccOneProfessors::ExaminationBoardsController#destroy` | mesma decisão, com destinos do namespace | flash de sucesso ou alerta | redirect para índice ou show |
| `Professors::OrientationsController#tcc_one/#tcc_two/#history` | relação autorizada `current_professor.orientations`, filtro opcional por status, TCC atual/histórico, `with_relationships`, `recent`, `search`, `page` | `@orientations`, `@search_url`, `@title` | `render :index` nas atuais; histórico mantém template padrão |
| `Professors::SupervisionsController#tcc_one/#tcc_two/#history` | relação autorizada `current_professor.supervisions`, filtro opcional por status, `with_relationships`, `recent`, TCC atual/histórico, `search`, `page` | mesmas variáveis | comportamento HTTP preservado |
| `ExternalMembers::SupervisionsController#tcc_one/#tcc_two/#history` | relação autorizada `current_external_member.supervisions`; atuais por `current_tcc_*`; histórico filtrava por `status` quando parâmetro existia; `search`, `page` | mesmas variáveis | comportamento HTTP preservado |

## Arquivos alterados

- `app/controllers/responsible/examination_boards_controller.rb`: actions de listagem, formulário e destroy agora delegam para objetos explícitos.
- `app/controllers/tcc_one_professors/examination_boards_controller.rb`: removido encadeamento de listagem e deduplicada preparação de formulário/destroy.
- `app/controllers/professors/orientations_controller.rb`: listagens usam query object a partir de `current_professor.orientations`.
- `app/controllers/professors/supervisions_controller.rb`: listagens usam query object a partir de `current_professor.supervisions`.
- `app/controllers/external_members/supervisions_controller.rb`: listagens usam query object a partir de `current_external_member.supervisions`; removido `send` para URL de busca.
- `app/services/examination_boards/list_query.rb`: composição fechada das listagens de bancas.
- `app/services/examination_boards/form_context.rb`: orientações, atividades, default de TCC II e estado de campos.
- `app/services/examination_boards/destroy.rb`: resultado explícito de exclusão ou bloqueio por ata.
- `app/services/orientations/participant_list_query.rb`: composição das listagens de orientações/supervisões a partir de relação autorizada.
- `spec/services/examination_boards/*`: cobertura isolada para listagem, formulário e exclusão de bancas.
- `spec/services/orientations/participant_list_query_spec.rb`: cobertura isolada para listagens por participante e isolamento por relação base.

## Contratos dos objetos extraídos

### `ExaminationBoards::ListQuery`

Entrada: `tcc: :one/:two`, `period: :current/:history`, `page:`, `term:`, `ordering: :responsible/:tcc_one_professor`.

Saída: relação paginada de `ExaminationBoard`.

Erros: `ArgumentError` para TCC, período ou ordenação não suportados.

Limites: usa mapa fechado de scopes; não recebe `params`, controller, rotas, flash ou helpers.

### `ExaminationBoards::FormContext`

Entrada: `for_new(tcc:)` ou `for_board(examination_board)`.

Saída: `examination_board`, `orientations`, `activities`, `disabled_field?`.

Regras preservadas: TCC II novo usa `identifier: :monograph`; banca `monograph?` usa opções de TCC II; demais usam TCC I; ata existente desabilita campos.

### `ExaminationBoards::Destroy`

Entrada: instância de `ExaminationBoard`.

Saída: `Result` com `destroyed?` e `blocked_by_defense_minutes?`.

Regras preservadas: ata presente bloqueia exclusão; sem ata chama `destroy` e retorna o estado `destroyed?`.

### `Orientations::ParticipantListQuery`

Entrada: `relation:` já autorizada, `segment: :tcc_one/:tcc_two/:history`, `profile: :professor_orientation/:professor_supervision/:external_member_supervision`, `status:`, `term:`, `page:`.

Saída: relação paginada de `Orientation`.

Erros: `ArgumentError` para segmento ou perfil inválido.

Limites: não busca usuário atual; não recebe `params`, sessão, controller, rotas, flash ou helpers; diferenças de preload/ordem entre perfis foram mantidas.

## Comportamento preservado

- Listagens do responsável continuam usando os mesmos scopes de TCC I/TCC II, atual/histórico, busca, paginação e `order(date: :desc)`.
- Listagens do professor de TCC I continuam usando `with_relationships`, busca, paginação e `recent`.
- Formulários continuam recebendo orientações atuais e identificadores corretos por TCC.
- Falhas de criação no responsável recarregam apenas opções, sem substituir a banca inválida e seus erros.
- Strong parameters continuam no controller e preservam a limitação para `document_available_until` quando há ata.
- Exclusão sem ata continua chamando `destroy`; exclusão com ata continua bloqueada com flashes e redirects próprios de cada namespace.
- `can_update_or_destroy?` do professor de TCC I foi preservado.
- Orientações/supervisões continuam partindo das associações do usuário autenticado, preservando isolamento por professor ou membro externo.
- Preloads, ordenações e diferença do histórico de membro externo quanto ao `status` foram mantidos.
- Nenhuma regra de `Orientation`, `ExaminationBoard`, `Document` ou `Signature` foi movida ou alterada.

## Métricas antes/depois

| Item | Antes | Depois |
|---|---:|---:|
| Linhas em `Responsible::ExaminationBoardsController` | 235 | 221 |
| Linhas em `TccOneProfessors::ExaminationBoardsController` | 141 | 143 |
| Linhas em `Professors::OrientationsController` | 126 | 127 |
| Linhas em `Professors::SupervisionsController` | 90 | 90 |
| Linhas em `ExternalMembers::SupervisionsController` | 98 | 112 |
| Flog total dos cinco controllers | 672.1 | 575.5 |
| Flog médio por método dos cinco controllers | 7.6 | 6.3 |
| Actions com composição direta de consulta nos alvos obrigatórios | 12 | 0 |
| Blocos de listagem de bancas removidos | 6 | 0 restantes nas actions |
| Blocos repetidos de formulário de banca centralizados | 4 | 1 contexto |
| Blocos repetidos de destroy por ata centralizados | 2 | 1 service |
| Objetos extraídos | 0 | 4 |
| RuboCop focado | 5 arquivos, 0 offenses em `Metrics/AbcSize` antes | 13 arquivos, 0 offenses |
| RuboCop global | não executado antes nesta task | 794 arquivos, 0 offenses |

Observação: a métrica ABC foi validada por RuboCop (`Metrics/AbcSize`) sem offenses nos controllers antes e nos arquivos alterados depois. O Flog foi usado como valor numérico de complexidade antes/depois.

## Validação

Comandos executados:

```bash
ruby -c app/services/examination_boards/list_query.rb \
  && ruby -c app/services/examination_boards/form_context.rb \
  && ruby -c app/services/examination_boards/destroy.rb \
  && ruby -c app/services/orientations/participant_list_query.rb \
  && ruby -c app/controllers/responsible/examination_boards_controller.rb \
  && ruby -c app/controllers/tcc_one_professors/examination_boards_controller.rb \
  && ruby -c app/controllers/professors/orientations_controller.rb \
  && ruby -c app/controllers/professors/supervisions_controller.rb \
  && ruby -c app/controllers/external_members/supervisions_controller.rb
```

Resultado: `Syntax OK` para todos os arquivos.

```bash
bundle exec rspec spec/services/examination_boards \
  spec/services/orientations/participant_list_query_spec.rb \
  spec/controllers/responsible/examination_boards_controller_spec.rb \
  spec/controllers/tcc_one_professors/examination_boards_controller_spec.rb
```

Resultado no ambiente Docker: `106 examples, 0 failures` para os services e feature specs dos cinco controllers priorizados.

```bash
bundle exec rspec
```

Resultado final após repetir a validação: `1074 examples, 0 failures, 1 pending`. O pending preexistente pertence a `WelcomeMailer`.

```bash
bundle exec rubocop --cache false --format simple <arquivos alterados>
```

Resultado: `13 files inspected, no offenses detected`.

```bash
bundle exec rubocop --cache false --parallel --format simple
```

Resultado: `794 files inspected, no offenses detected`. O RuboCop informou que `--parallel` foi ignorado por incompatibilidade com `--cache false`.

```bash
git diff --check
```

Resultado: sem problemas.

## Riscos e próximos passos

- A validação dinâmica foi executada no ambiente Docker; os testes focados e a suíte completa terminaram sem falhas.
- REF-06 continua sendo o lugar correto para reorganização interna de `Orientation`.
- REF-07 continua sendo o lugar correto para reorganização de `ExaminationBoard`, documentos, assinaturas, geração de atas e autenticidade documental.
- O arquivo não rastreado `ai/tasks/fase-2-controllers-e-consultas/ref-05-reestruturar-controllers-criticos.md` já estava fora do escopo desta implementação e não foi alterado.
