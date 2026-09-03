# REF-11 — Inventário de partials e regras de apresentação repetidas

## Resumo

Os dois candidatos herdados da REF-01 (`sign_form.html.erb`, `_appointment_file_form.html.erb`) continuam válidos e foram reconfirmados com `diff` real. A investigação ampliada encontrou um terceiro candidato mais valioso que nenhum dos dois: **6 views de "documentos da orientação/supervisão" quase idênticas entre si**, que já poderiam reaproveitar um padrão de partial parametrizada que o próprio projeto já usa em `shared/documents/_table.html.erb` para outro caso de uso. Também apareceu um candidato pequeno (`tep_requests`/`tso_requests`) e um achado colateral fora do escopo de extração desta fase: **três partials `shared/*/_table.html.erb` sem nenhum consumidor** (`examination_boards`, `orientations`, `supervision_examination_boards`), aparentemente órfãs desde que `Orientations::TableComponent` e `ExaminationBoards::TableComponent` passaram a cobrir esses dois domínios. Um candidato foi investigado e **descartado**: a listagem de calendários varia demais entre namespaces para justificar um component único.

## Candidato 1 — `sign_form.html.erb`

**Ocorrências:** `app/views/academics/documents/sign_form.html.erb`, `app/views/external_members/documents/sign_form.html.erb`, `app/views/professors/documents/sign_form.html.erb`.

**Variantes:** nenhuma no HTML — os três arquivos são **byte a byte idênticos** (uma diferença de linha em branco entre `professors` e os outros dois). Todos renderizam `Documents::SignFormComponent.new(username: @username, confirm_url: @confirm_url, back_url: @back_url)`; o componente em si já existe e já está correto. A view ao redor dele é o que está triplicado.

**Dependências (controllers que preenchem as 3 ivars antes de renderizar a view):**

| Controller | `@username` | `@confirm_url` / `@back_url` |
|---|---|---|
| `Professors::DocumentsController#sign_form` | `Professor.human_attribute_name('username')` | `professors_document_sign_path` / `professors_document_path` |
| `ExternalMembers::DocumentsController#sign_form` | `ExternalMember.human_attribute_name('email')` | `external_members_document_sign_path` / `external_members_document_path` |
| `Academics::DocumentsController#sign_form` | `Academic.human_attribute_name('ra')` | `academics_document_sign_path` / `academics_document_path` |

**Benefício esperado:** elimina 3 arquivos idênticos por 1. Baixo risco — a view não tem lógica própria, só encaminha 3 variáveis já resolvidas pelo controller para o component existente. Uma consolidação plausível é um único template compartilhado (`shared/documents/sign_form.html.erb`) renderizado pelas três actions via `render template:`, já que as três já calculam as mesmas 3 variáveis — não é necessário mexer no `Documents::SignFormComponent`.

## Candidato 2 — `_appointment_file_form.html.erb`

**Ocorrências:** `app/views/professors/examination_boards/_appointment_file_form.html.erb`, `app/views/external_members/examination_boards/_appointment_file_form.html.erb`.

**Variantes (as 3 únicas diferenças, reconfirmadas):**
1. `html: { multipart: true, id: 'appoints_form' }` — o `id` só existe na versão de `professors`.
2. Hidden field do autor: `f.hidden_field :professor_id, value: current_professor.id` vs `f.hidden_field :external_member_id, value: current_external_member.id`.
3. Quebra de linha só de formatação na chamada de `f.button :submit` — sem diferença de comportamento.

**Dependências:** ambas dependem de `@examination_board_note`, `@examination_board`, `url` e de `current_professor`/`current_external_member` (Devise scope do namespace). Não há um component equivalente ao `Documents::SignFormComponent` para este caso ainda.

**Benefício esperado:** elimina 1 arquivo de 2, baixo risco. Como a única variação real é *qual* coluna de autor preencher (e um `id` de formulário cosmético, possivelmente removível), um partial único com um local `author_field:` (`:professor_id`/`:external_member_id`) resolve sem precisar de um `ViewComponent` — mas um component também é viável se a REF-12 preferir manter o padrão já usado em `SignFormComponent`.

## Candidato 3 (novo, não estava na REF-01) — listagem de "documentos da orientação/supervisão"

**Ocorrências (6):** `academics/orientations/documents.html.erb`, `external_members/supervisions/documents.html.erb`, `professors/orientations/documents.html.erb`, `professors/supervisions/documents.html.erb`, `responsible/orientations/documents.html.erb`, `tcc_one_professors/orientations/documents.html.erb`.

**Variantes:** as 6 têm entre 31 e 32 linhas e a mesma estrutura exata: `page_entries_info`, tabela com as colunas `Document.orientation`/`academic`/`document_type`/`created_at` (`academics` e `responsible` acrescentam `colspan="3"` para ações; os outros não), `shared/no_results` na ausência de itens, um loop `@documents.each` renderizando um partial de linha específico do namespace (`academics/documents/document_orientation`, `external_members/documents/document_supervision`, `professors/documents/document_orientation`/`document_supervision` etc.) e `paginate @documents` no fim.

**Achado relevante:** o projeto **já resolveu exatamente esse padrão** em `shared/documents/_table.html.erb`, usado por `shared/dashboard/_documents_table.html.erb`, `shared/documents/_pending.html.erb` e `shared/documents/_signed.html.erb` — inclusive já usa `render partial: "#{namespace}/documents/document", collection: @documents` para variar o partial de linha por namespace. As 6 views deste candidato fazem manualmente, com pequenas variações de indentação e de coluna `all_signed`, o que essa partial já faz de forma parametrizada.

**Benefício esperado:** o maior dos quatro candidatos por número de consumidores (6). Risco moderado — é preciso confirmar se a ausência da coluna `all_signed` nessas 6 views (presente em `shared/documents/_table.html.erb`) é intencional antes de reaproveitar a partial existente ou criar uma variante dela.

## Achado descartado — listagem de calendários

`academics/calendars/index.html.erb`, `external_members/calendars/index.html.erb`, `tcc_one_professors/calendars/index.html.erb` e `responsible/calendars/index.html.erb` compartilham o mesmo *shell* de tabela, mas as colunas divergem de verdade entre si: `academics` mostra título/orientador da orientação vinculada; `external_members` acrescenta `created_at`; `tcc_one_professors` mostra a contagem de orientações do calendário; `responsible` mostra `tcc`/`start_date`/`end_date`/`created_at` e uma coluna de ações (edit/destroy), além de renderizar uma partial `tabs` que as outras três não têm. Consolidar essas 4 exigiria um component com tantas opções configuráveis que a duplicação atual (shell idêntico, ~10 linhas cada) provavelmente é mais legível do que a abstração. **Não incluído na lista priorizada** — bate com o aviso do próprio roadmap contra converter partials sem benefício mensurável.

## Achado pequeno — `tep_requests` / `tso_requests`

`academics/tep_requests/index.html.erb` e `academics/tso_requests/index.html.erb` diferem em exatamente 3 pontos: a chave de tradução (`tep`/`tso`), a rota de criação (`new_academics_tep_request_path`/`new_academics_tso_request_path`) e o partial de linha (`academics/tep_requests/request`/`academics/tso_requests/request`). **Observação que extrapola o escopo de "partial de apresentação":** a duplicação não para na view — `edit.html.erb`, `_form.html.erb`, `new.html.erb`, `_request.html.erb` e `show.html.erb` existem em pares idênticos-ou-quase nos dois diretórios, o que sugere que `tep_requests`/`tso_requests` são o mesmo recurso duplicado em dois controllers/namespaces, não só duas views parecidas. Isso é maior do que a REF-12 (extração de component) resolve sozinha — registrado aqui para uma decisão futura (possível parametrização do recurso inteiro por tipo de solicitação), não incluído na lista priorizada desta fase.

## Achado colateral — partials de tabela órfãs (fora do escopo de extração da REF-12)

`shared/examination_boards/_table.html.erb`, `shared/orientations/_table.html.erb` e `shared/supervision_examination_boards/_table.html.erb` não têm **nenhum** consumidor: `grep -rn` pelo caminho relativo de cada uma (com e sem o prefixo `shared/`) não encontra nenhuma chamada de `render` em `app/views` ou `app/components`. A leitura mais provável é que essas três partials existiam antes de `Orientations::TableComponent` e `ExaminationBoards::TableComponent` (ambos `ViewComponent`, já cobrindo os mesmos domínios com 10 e 12 consumidores respectivamente) e ficaram para trás quando as views migraram para os components, sem serem removidas. Isso é código morto de apresentação, não um candidato a component — está fora do escopo de extração da REF-12, mas deveria ser removido em alguma task (mesmo padrão já tratado nas REF-08/REF-10 para código Ruby órfão).

## Shell de tabela de listagem — visão consolidada

| Status | Onde | Consumidores | Ação sugerida |
|---|---|---|---|
| **Resolvido** | `Orientations::TableComponent` | 10 views | Nenhuma — já é o padrão a seguir |
| **Resolvido** | `ExaminationBoards::TableComponent` | 12 views | Nenhuma — já é o padrão a seguir |
| **Parcialmente resolvido** | `shared/activities/_table.html.erb` | 4 | Baixa prioridade — já compartilhada, ganho marginal de ir além |
| **Parcialmente resolvido** | `shared/documents/_table.html.erb` | 3 (+ 6 candidatas no item 3 acima) | Ver Candidato 3 |
| **Parcialmente resolvido** | `shared/meetings/_table.html.erb` | 4 | Baixa prioridade |
| **Parcialmente resolvido** | `shared/orientation_activities/_table.html.erb` | 6 | Baixa prioridade |
| **Órfã (achado colateral)** | `shared/examination_boards/_table.html.erb` | 0 | Remover (fora do escopo da REF-12) |
| **Órfã (achado colateral)** | `shared/orientations/_table.html.erb` | 0 | Remover (fora do escopo da REF-12) |
| **Órfã (achado colateral)** | `shared/supervision_examination_boards/_table.html.erb` | 0 | Remover (fora do escopo da REF-12) |
| **Não resolvido, candidato real** | 6 views de "documentos da orientação/supervisão" | 6 (cada uma seu próprio consumidor) | Ver Candidato 3 |
| **Não resolvido, descartado** | 4 views de "índice de calendários" | 4 | Ver "Achado descartado" acima |
| **Não resolvido, achado à parte** | `tep_requests`/`tso_requests` index | 2 | Ver "Achado pequeno" acima — extrapola REF-12 |
| **Não resolvido, sem consolidação avaliada** | `shared/documents/_reviewing.html.erb`, `professors/requests/index.html.erb`, `responsible/academics/index.html.erb`, `responsible/attached_documents/index.html.erb`, `responsible/base_activities/index.html.erb`, `responsible/external_members/index.html.erb`, `responsible/institutions/index.html.erb`, `responsible/pages/index.html.erb`, `responsible/professors/index.html.erb` | 1 cada | Fora do escopo desta task — nenhuma delas se repetiu com outra durante a investigação; não entraram na lista priorizada por falta de um par/grupo claro. Se a REF-12 tiver tempo sobrando após os 3 candidatos abaixo, vale uma segunda passada específica nesse grupo. |

## Condicionais de domínio em views

Os 3 arquivos encontrados (`layouts/academics/_sidebar.html.erb:15,26`, `responsible/activities/_form.html.erb:42`, `layouts/academics/_requests_menu.html.erb:7`) usam `current_orientation&.tcc_one?`/`tcc_two?`/`@calendar.tcc_one?` para decidir links de menu e campos de formulário. Cada ocorrência é local e não se repete em nenhum outro arquivo — não há padrão duplicado entre eles, só o mesmo tipo de predicado usado em 3 contextos diferentes e não relacionados. **Não é candidato a component ou helper compartilhado.**

## Lista priorizada de candidatos a component (para a REF-12)

1. **Views de "documentos da orientação/supervisão"** (6 consumidores) — maior benefício, reaproveita o padrão já validado em `shared/documents/_table.html.erb`. Risco moderado: confirmar a divergência da coluna `all_signed` antes de unificar.
2. **`sign_form.html.erb`** (3 consumidores) — menor risco de todos (zero variação de HTML), o component de conteúdo já existe; a task é só consolidar a view/rota ao redor dele.
3. **`_appointment_file_form.html.erb`** (2 consumidores) — 3 diferenças pequenas e bem entendidas (form id, nome do hidden field, quebra de linha cosmética).

Fora da lista, mas registrados para decisão de outra task: a duplicação de recurso inteiro `tep_requests`/`tso_requests` (maior que um component resolve) e a remoção das 3 partials de tabela órfãs (código morto, não extração).
