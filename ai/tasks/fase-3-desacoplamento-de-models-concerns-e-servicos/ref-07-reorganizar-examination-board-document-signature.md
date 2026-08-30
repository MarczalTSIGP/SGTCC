# Task

REF-07 — Reorganizar `ExaminationBoard`, `Document` e `Signature`, separando apresentação, consultas compostas, geração de documentos e regras de assinatura hoje concentradas nesses models, sem alterar comportamento funcional, rastreabilidade ou autenticidade documental.

# Contexto

A REF-01 (`ai/output/fase-0-baseline/inventario-ref-01.md`) já classificou os concerns dos três models. A REF-05 já extraiu parte da camada HTTP de `ExaminationBoard` para `app/services/examination_boards/` (`Destroy`, `FormContext`, `ListQuery`), e a REF-06 reorganizou `Orientation`. Nenhuma dessas tasks tocou a lógica que ainda reside dentro dos três models a seguir.

## `ExaminationBoard` — 6 concerns incluídos, maior Flog do baseline (115.0)

Concerns mantidos como estão (coesos, não são alvo de extração nesta task): `ExaminationBoardDefenseMinutes` (criação/acesso à ata de defesa), `SituationEnum` (enum `situation`), `TccIdentifier` (enum `identifier` + `human_tcc_identifiers`/`human_tcc_one_identifiers`/`human_tcc_two_identifiers`), `Tcc` (enum `tcc`), `Searchable` (busca textual).

Responsabilidades ainda no próprio model (`app/models/examination_board.rb`) e candidatas a extração:

1. **Apresentação misturada ao domínio.** O model inclui `ActionView::Helpers::DateHelper` só para `distance_of_date` funcionar (`distance_of_time_in_words`). `status` (retorna `'today'`/`'next'`/`'occurred'` comparando strings de data) e `distance_of_date` são usados apenas em `app/views/shared/examination_boards/_tbody.html.erb:3-4` via `examination_board.status` e `examination_board.distance_of_date`. Não há outro consumidor confirmado.
2. **Consulta composta para o site público.** `cs_asc_from_now_desc_ago`, `current_calendar_for_site` (`private_class_method`), `base_scope_for_calendar`, `upcoming_from_now` e `past_until_now` compõem a listagem "próximas bancas / bancas ocorridas" carregando os resultados em memória (`.to_a`) e concatenando dois arrays. Consumido por `app/controllers/site_controller.rb`. `current_calendar_for_site` já resolve corretamente o calendário pela data (`Calendar.where('? BETWEEN start_date AND end_date', ...)` com fallback para o mais recente) — não reescreva essa regra, apenas realoque-a.
3. **Serialização.** `UsersToDocument` (compartilhado com `Orientation`) e `examination_board_data` montam estruturas para exibição e para o JSON de documentos gerados (`Document::TermJsonData#examination_board_data` consome o hash retornado por este método via o `attr_accessor :examination_board` de `Document`). Preserve as mesmas chaves.
4. **Predicados de avaliador e nota.** `advisor?`, `professor_evaluator?`, `external_member_evaluator?`, `evaluators_number`, `all_evaluated?`, `find_note_by_professor`, `find_note_by_external_member` — regra de domínio sobre quem avalia a banca. Podem permanecer no model se continuarem simples; extraia apenas se a extração de `evaluators`/`Logics::ExaminationBoard::EvaluatorsResponses` (já existente) absorver parte deles sem duplicar.
5. **TODO pendente.** `touch_updated_at` carrega o comentário `# TODO: Tests for this method` sem teste correspondente.
6. **Acoplamento externo confirmado no inventário.** `app/models/academic_activity.rb#clear_examination_boards_cache` (linhas ~37-45) tem `# TODO: Refactor and write tests for this method` e itera `academic.current_orientation.examination_boards` chamando `examination_board.touch` diretamente — é `AcademicActivity` reagindo ao estado de `ExaminationBoard`, não o inverso. Avalie se cabe um método de classe/instância explícito em `ExaminationBoard` para este caso de uso, preservando o efeito (invalidar cache tocando o registro).

## `Document` — 5 concerns incluídos

Concerns mantidos como estão (coesos/aceitáveis, não são alvo de extração): `TermJsonData` (monta o hash do termo), `SignatureMark` (`mark`, lista assinaturas formatadas), `DocumentSigned` (`academic_signed?`/`professor_signed?`), `DocumentReview` (`signed_by_user?`/`tdo_for_review?`/`tep_for_review?`/`tso_for_review?`).

Responsabilidades candidatas a extração:

1. **`DocumentByType`** — métodos de classe `new_tdo`/`new_tep`/`new_tso`/`new_orientation_request`/`new_request`, cada um montando `document.request` com dados de requisitante e, no caso de `new_tso`, removendo o primeiro elemento de `professor_supervisor_ids`/`external_member_supervisor_ids` via `.shift` (efeito colateral sobre o array de parâmetros recebido). Consumido por `Academics::TsoRequestsController`, `Academics::TepRequestsController` e `Professors::RequestsController`. É uma factory de criação, não uma responsabilidade intrínseca do model — candidato natural a `app/services/documents/`, mantendo a mesma interface pública (`Document.new_tdo(professor, params)` etc.) enquanto os controllers não forem migrados, ou migrando os três controllers na mesma task.
2. **`save_judgment`/`update_requester_justification`** — direto no model, usam `update_attribute` (`rubocop:disable Rails/SkipsModelValidations`) e retornam `false` com `errors.add` em vez de levantar exceção. Consumidos por `Responsible::DocumentsController` e pelos três controllers de request. Extraia para um service com resultado explícito somente se isso não exigir mudar o contrato observável (retorno truthy/falsy e `errors` populado) consumido pelas views/controllers atuais.
3. **`filename`** — depende de `orientation.academic`/`orientation.current_calendar`; mantenha no model se permanecer uma formatação direta de atributos, sem nova consulta composta.

## `Signature` — sem concerns, model enxuto

`user_table` (linha ~26-34) compara `user_type == 'academic'` com string literal e usa um array `%w[external_member_supervisor external_member_evaluator responsible_institution]` para decidir entre `ExternalMember` e `Professor`, apesar do enum `user_type` já definir prefixos (`user_type_academic?` etc., via `enum :user_type, {...}, prefix: :user_type`). Isso é o mesmo tipo de inconsistência que a REF-02/REF-03 trataram para `tcc`/`semester`, mas ficou fora daquelas tasks porque `Signature` não foi ao escopo de padronização de enum — trate aqui a leitura via predicados do enum, sem alterar o mapeamento persistido (`'AD'`, `'AC'`, `'CC'`, etc.).

# Dependências

- REF-05 — Reestruturar os controllers mais críticos.
- REF-06 — Reorganizar responsabilidades de `Orientation`.

# Objetivo

Reduzir `ExaminationBoard`, `Document` e `Signature` às responsabilidades intrínsecas de entidade de domínio — associações, validações, enums e invariantes — movendo:

- apresentação de data/status de banca (`status`, `distance_of_date`, dependência de `ActionView::Helpers::DateHelper`) para um objeto de apresentação fora do model;
- a consulta composta do site público (`cs_asc_from_now_desc_ago` e o grupo de métodos que ela coordena) para um query object em `app/services/examination_boards/`;
- a criação de documentos por tipo (`DocumentByType`) para uma factory/service em `app/services/documents/`;
- a leitura de `user_type` em `Signature#user_table` para os predicados do enum já existente.

O model deve manter associações, validações, enums, scopes simples e os métodos que expressam invariantes da entidade.

# Instruções críticas

Preserve integralmente:

- o resultado observável de `status`/`distance_of_date` na tabela de bancas (`app/views/shared/examination_boards/_tbody.html.erb`);
- os resultados de `cs_asc_from_now_desc_ago` (ordem, agrupamento "próximas" vs. "ocorridas", resolução do calendário atual pela data) usados por `SiteController`;
- as chaves e valores retornados por `examination_board_data`/`evaluators_object`, consumidos por `Document::TermJsonData`;
- a criação de documentos via `Document.new_tdo`/`new_tep`/`new_tso`, incluindo o efeito de `.shift` em `new_tso` e a estrutura de `document.request` resultante;
- o comportamento de `save_judgment`/`update_requester_justification`, incluindo os casos de validação que retornam `false` com `errors.add`;
- o mapeamento persistido do enum `user_type` de `Signature` (`'AD'`, `'AC'`, `'CC'`, `'NAD'`, `'PR'`, `'PS'`, `'ES'`, `'PV'`, `'EMV'`, `'RI'`) e o resultado de `user_table`/`user` para cada valor;
- a rastreabilidade e autenticidade dos documentos: nenhuma mudança pode afetar `code`, `content` (JSON assinado) ou a relação `signatures` já persistida.

Não altere `Orientation` além do necessário para continuar consumindo os objetos extraídos; isso pertence à REF-06 (concluída). Não altere `Calendar` nem sua navegação entre períodos; isso pertence à REF-09/REF-10. Não altere os services já extraídos pela REF-05 (`ExaminationBoards::Destroy`, `FormContext`, `ListQuery`) além do necessário para continuar funcionando.

# Escopo obrigatório

## 1. Apresentação de status/distância de data

Extrair `status` e `distance_of_date` para um objeto de apresentação (por exemplo `ExaminationBoards::StatusPresenter` ou decorator equivalente) que receba a banca e não dependa de `ActionView::Helpers::DateHelper` incluído no model. Atualizar `app/views/shared/examination_boards/_tbody.html.erb` para usar o novo objeto. Remover o `include ActionView::Helpers::DateHelper` de `ExaminationBoard` após a migração.

## 2. Consulta composta do site público

Extrair `cs_asc_from_now_desc_ago`, `current_calendar_for_site`, `base_scope_for_calendar`, `upcoming_from_now` e `past_until_now` para um query object em `app/services/examination_boards/` (ou pasta equivalente coerente com `ListQuery`/`FormContext` já existentes). Substituir a chamada em `SiteController` pelo novo objeto. Preservar a resolução do calendário atual por intervalo de data com fallback para o mais recente, e o carregamento único em memória se os consumidores dependerem da concatenação ordenada dos dois grupos.

## 3. Factory de criação de documentos por tipo

Extrair `DocumentByType` (`new_tdo`, `new_tep`, `new_tso` e os dois métodos privados de composição de `request`) para `app/services/documents/`. Migrar `Academics::TsoRequestsController`, `Academics::TepRequestsController` e `Professors::RequestsController` para o novo objeto antes de remover os métodos de classe do model.

## 4. Predicados de `user_type` em `Signature`

Substituir a comparação `user_type == 'academic'` e o array `%w[...]` de `user_table` pelos predicados gerados pelo enum (`user_type_academic?`, `user_type_external_member_supervisor?` etc.) ou por uma estrutura equivalente que não compare strings cruas. Manter o resultado (`Academic`/`ExternalMember`/`Professor`) idêntico para os dez valores do enum.

## 5. Acoplamento `AcademicActivity` → `ExaminationBoard`

Revisar `AcademicActivity#clear_examination_boards_cache` e decidir, com justificativa registrada no relatório, entre: (a) expor um método explícito em `ExaminationBoard` para esse caso de uso, chamado a partir de `AcademicActivity`; ou (b) manter o acesso direto documentando por que a extração não reduz acoplamento real. Remover o `# TODO` apenas se a decisão for implementada.

## 6. `save_judgment`/`update_requester_justification` (opcional, avaliar primeiro)

Extrair para um service somente se isso não alterar o contrato observável atual (retorno truthy/falsy, `errors` populado, `update_attribute` sem validação). Se a extração introduzir risco de mudar esse contrato para os quatro controllers consumidores, mantenha no model e registre a decisão.

# Escopo permitido

- `app/models/examination_board.rb`, `app/models/document.rb`, `app/models/signature.rb` e os concerns listados na seção de contexto;
- novos objetos em `app/services/examination_boards/` e `app/services/documents/`;
- `app/models/academic_activity.rb` apenas no método `clear_examination_boards_cache`;
- ajustes mínimos nos consumidores diretamente afetados (`SiteController`, `app/views/shared/examination_boards/_tbody.html.erb`, `Academics::TsoRequestsController`, `Academics::TepRequestsController`, `Professors::RequestsController`, `Responsible::DocumentsController` se o item 6 for executado);
- specs unitários dos objetos extraídos e specs de model/feature dos fluxos diretamente afetados;
- relatório final em `ai/output/fase-3-desacoplamento-de-models-concerns-e-servicos/`.

# Escopo proibido

- Não altere migrations, schema ou dados persistidos.
- Não altere o mapeamento ou os valores dos enums `situation`, `identifier`, `tcc` (`ExaminationBoard`) ou `user_type` (`Signature`).
- Não altere `Orientation`, seus concerns ou os services extraídos pela REF-06.
- Não altere `Calendar` ou a navegação entre períodos; isso pertence à REF-09/REF-10.
- Não altere os services já extraídos pela REF-05 (`ExaminationBoards::Destroy`, `FormContext`, `ListQuery`) além do necessário para continuar funcionando com os objetos desta task.
- Não altere a lógica de `Documents::SaveSignatures`/`Documents::DefenseMinutes` já extraídas; apenas consuma-as se necessário.
- Não altere rotas, parâmetros, textos, traduções ou respostas HTTP dos controllers consumidores.
- Não corrija comportamentos aparentemente incorretos sem antes caracterizá-los e sem registrar a decisão no relatório; se a caracterização confirmar um bug real, documente a descoberta e mantenha o comportamento atual nesta task — a correção funcional é uma mudança separada.
- Não faça commit, push ou criação de branch.

# Roteiro de implementação

## 1. Medir e caracterizar antes da extração

- Registrar tamanho, ABC/Flog e offenses de `examination_board.rb`, `document.rb`, `signature.rb` e dos concerns listados.
- Mapear cada método candidato para seus consumidores atuais (controllers, views, services, specs).
- Adicionar testes de caracterização apenas onde houver lacuna, cobrindo pelo menos:
  - `status`/`distance_of_date` para banca de hoje, futura e passada;
  - `cs_asc_from_now_desc_ago` com bancas antes e depois de agora, e o caso sem calendário atual;
  - `Document.new_tdo`/`new_tep`/`new_tso` com os efeitos sobre `request` e sobre os arrays de supervisores em `new_tso`;
  - `Signature#user_table`/`#user` para os dez valores de `user_type`;
  - `touch_updated_at` (cobrindo o TODO pendente) e `clear_examination_boards_cache`.

## 2. Extrair apresentação de status/distância de data

- Criar o objeto de apresentação e migrar `_tbody.html.erb`.
- Remover `include ActionView::Helpers::DateHelper` do model após a migração.

## 3. Extrair consulta do site público

- Criar o query object a partir de `cs_asc_from_now_desc_ago` e os métodos que ela coordena.
- Migrar `SiteController` e remover os métodos de classe do model.

## 4. Extrair factory de documentos por tipo

- Criar o objeto em `app/services/documents/`.
- Migrar os três controllers consumidores antes de remover `DocumentByType` do model.

## 5. Corrigir leitura de `user_type` e revisar acoplamento com `AcademicActivity`

- Substituir a comparação de string em `Signature#user_table` pelos predicados do enum.
- Implementar a decisão registrada para `clear_examination_boards_cache`.

## 6. Verificação final

- Executar specs unitários dos objetos novos.
- Executar os specs de model de `ExaminationBoard`, `Document`, `Signature` e os specs de feature/controller dos consumidores diretamente afetados.
- Executar a suíte RSpec completa.
- Executar RuboCop nos arquivos alterados e, antes do merge, no projeto completo.
- Comparar métricas antes/depois.

# Critérios de aceite

- `ExaminationBoard`, `Document` e `Signature` mantêm apenas associações, validações, enums, scopes simples e invariantes da entidade.
- `ExaminationBoard` não depende mais de `ActionView::Helpers::DateHelper`.
- A consulta do site público não permanece como método de classe encadeado no model.
- A criação de documentos por tipo produz o mesmo `request`/atributos de antes para os três fluxos migrados.
- `Signature#user_table` não compara `user_type` com literais de string.
- Nenhuma regra de `Orientation` ou `Calendar` foi movida ou alterada.
- A suíte relacionada e a suíte completa passam; o RuboCop não registra novas violações.
- Métricas de complexidade e smells de `ExaminationBoard` melhoram em relação ao baseline da REF-00/REF-01 (Flog 115.0).

# Validação sugerida

```bash
bundle exec rspec spec/models/examination_boards/ \
  spec/models/examination_board_attendee_spec.rb \
  spec/models/examination_board_notes/ \
  spec/models/documents/ \
  spec/models/signatures/ \
  spec/models/professors/professor_examination_boards_spec.rb \
  spec/models/external_members/external_member_examination_boards_spec.rb \
  spec/services/examination_boards/ \
  spec/controllers/responsible/examination_boards_controller_spec.rb \
  spec/controllers/tcc_one_professors/examination_boards_controller_spec.rb \
  spec/features/site/examination_boards/ \
  spec/features/**/documents/

bundle exec rubocop app/models/examination_board.rb \
  app/models/document.rb \
  app/models/signature.rb \
  app/models/concerns/examination_board_*.rb \
  app/models/concerns/document_*.rb \
  app/models/concerns/term_json_data.rb \
  app/models/concerns/signature_mark.rb \
  app/models/academic_activity.rb \
  app/services/examination_boards/ app/services/documents/ \
  spec/services/examination_boards/ spec/services/documents/

bundle exec rspec
bundle exec rubocop --parallel
```

Se o projeto exigir Docker, use os comandos equivalentes fornecidos por `./run` (ou `docker compose run --rm --name tests tests <comando>`, garantindo que o container se chame exatamente `tests` para que os specs de feature resolvam o host da aplicação).

Falhas de ambiente não devem ser registradas como sucesso. Documente comando, mensagem e comportamentos não validados dinamicamente.

# Métricas antes/depois

Registrar, no mínimo:

- linhas e ABC/Flog de `examination_board.rb`, `document.rb`, `signature.rb` e de cada concern alterado;
- quantidade de métodos de apresentação/consulta/criação movidos;
- quantidade de services novos e seus contratos;
- resultado dos specs focados e da suíte completa;
- offenses do RuboCop nos arquivos alterados e no projeto completo.

# Relatório final esperado

Criar `ai/output/fase-3-desacoplamento-de-models-concerns-e-servicos/implementation-summary-ref-07-reorganizar-examination-board-document-signature.md` com:

## Resumo

Responsabilidades extraídas e concerns simplificados.

## Inventário antes da alteração

Tabela por método/concern com responsabilidade atual, consumidores e contrato preservado.

## Arquivos alterados

Lista dos arquivos e responsabilidade de cada mudança.

## Contratos dos objetos extraídos

Entradas, saída, erros e limites de cada objeto de apresentação/query object/factory.

## Comportamento preservado

Evidências sobre status/distância de data da banca, listagem do site público, criação de documentos por tipo e resolução de `user_type` em assinaturas.

## Achados sobre comportamento existente

Registrar qualquer inconsistência encontrada durante a caracterização, sem corrigi-la nesta task, indicando se merece uma task funcional separada.

## Métricas antes/depois

Tabela com linhas, ABC/Flog, métodos movidos e offenses.

## Validação

Comandos e resultados de RSpec e RuboCop, separando regressões, falhas preexistentes e limitações ambientais.

## Riscos e próximos passos

Registrar decisões deliberadamente adiadas (em especial o item 6, se não executado) e confirmar que `Calendar` pertence à REF-09/REF-10 e a revisão geral de services/código morto à REF-08.
