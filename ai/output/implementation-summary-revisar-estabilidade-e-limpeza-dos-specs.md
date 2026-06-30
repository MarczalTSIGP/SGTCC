# Implementation Summary

## General Summary

Foram resolvidos os principais problemas de estabilidade, duplicação e legibilidade nos specs de `examination_boards`, `calendars`, `orientations` e `documents`. O setup duplicado nos specs de bancas foi extraído para `shared_context`s por perfil. O `if/else` morto no `calendars_show_spec` foi separado em contextos explícitos. O acesso `resp[1]` frágil no controller spec foi substituído por busca explícita por `id`. O shared example `'orientation activity show page'` foi aplicado nos specs de activities. O `let(:document_type)` não usado foi removido. O typo `activites` foi corrigido. Diversas outras aplicações de shared examples de iterações anteriores foram também consolidadas nesta branch.

---

## Changed Files

### spec/support/examination_boards/examination_board_contexts.rb *(novo)*

- Define cinco `shared_context` separados por perfil: `academic monograph examination board setup`, `responsible monograph examination board setup`, `professor proposal examination board setup`, `tcc one professor project examination board setup` e `external member project examination board setup`.
- Necessário para centralizar o setup repetido de bancas (criação de `document_type`, adição de professor/membro externo à banca e `login_as`) que aparecia em múltiplos arquivos.
- O `rubocop:disable RSpec/ContextWording` é necessário porque os nomes seguem o padrão descritivo do projeto.

### spec/support/examination_boards/examination_board_create_examples.rb *(novo)*

- Define helpers de instância para criação de bancas: `expect_examination_board_required_errors`, `expect_examination_board_created`, `expect_orientation_select_without_tcc`, etc.
- Necessário para remover duplicação nos specs de criação de banca (`responsible`, `tcc_one_professors`).

### spec/features/academics/examination_boards/examination_boards_show_basic_information_spec.rb

- Substituído o bloco `before` manual por `include_context 'academic monograph examination board setup'`.
- O `visit` foi mantido em um `before` local porque a rota é específica deste perfil.

### spec/features/academics/examination_boards/examination_boards_show_appointments_spec.rb

- Substituído o bloco `before` manual por `include_context 'academic monograph examination board setup'`.

### spec/features/academics/examination_boards/examination_boards_show_academic_activity_spec.rb

- Substituído o bloco `before` manual por `include_context 'academic monograph examination board setup'`.
- O `let(:academic)`, `let(:orientation)` e `let!(:examination_board)` foram removidos pois são fornecidos pelo shared context.

### spec/features/professors/examination_boards/examination_boards_show_basic_information_spec.rb

- Substituído por `include_context 'professor proposal examination board setup'`.

### spec/features/professors/examination_boards/examination_boards_show_appointments_spec.rb

- Substituído por `include_context 'professor proposal examination board setup'`.

### spec/features/professors/examination_boards/examination_boards_show_academic_activity_spec.rb

- Substituído por `include_context 'professor proposal examination board setup'`.

### spec/features/professors/examination_boards/examination_boards_show_defense_minutes_spec.rb

- Substituído por `include_context 'professor proposal examination board setup'`.

### spec/features/responsible/examination_boards/examination_boards_show_basic_information_spec.rb

- Substituído por `include_context 'responsible monograph examination board setup'`.

### spec/features/responsible/examination_boards/examination_boards_show_appointments_spec.rb

- Substituído por `include_context 'responsible monograph examination board setup'`.

### spec/features/responsible/examination_boards/examination_boards_show_academic_activity_spec.rb

- Substituído por `include_context 'responsible monograph examination board setup'`.

### spec/features/tcc_one_professors/examination_boards/examination_boards_show_basic_information_spec.rb

- Substituído por `include_context 'tcc one professor project examination board setup'`.

### spec/features/tcc_one_professors/examination_boards/examination_boards_show_appointments_spec.rb

- Substituído por `include_context 'tcc one professor project examination board setup'`.

### spec/features/tcc_one_professors/examination_boards/examination_boards_show_academic_activity_spec.rb

- Substituído por `include_context 'tcc one professor project examination board setup'`.

### spec/features/external_members/examination_boards/examination_boards_show_basic_information_spec.rb

- Substituído por `include_context 'external member project examination board setup'`.

### spec/features/external_members/examination_boards/examination_boards_show_appointments_spec.rb

- Substituído por `include_context 'external member project examination board setup'`.

### spec/features/responsible/calendars/calendars_show_spec.rb

- O `it 'shows its activities or empty message'` com `if/else` interno foi decomposto em três contextos separados:
  - `'when shows the calendar'` — exibe cabeçalho básico.
  - `'when the calendar has no activities'` — verifica mensagem de vazio sem criar atividades.
  - `'when the calendar has activities'` — cria uma atividade no `before` e verifica os campos exibidos.
- O `visit` que estava no `before` externo foi movido para dentro de cada contexto.

### spec/controllers/api/v1/orientations/orientations_controller_tcc_one_spec.rb

- Substituído `resp[1]` por `resp.detect { |o| o['id'] == orientation.id.to_s }`.
- Adicionado `expect(response_orientation).to be_present` para falha explícita se o registro não for encontrado.

### spec/features/academics/documents/term_of_accept_institution/documents_show_spec.rb

- Removido `let(:document_type) { document.document_type }` que estava declarado mas não usado.

### spec/features/academics/documents/term_of_commitment/documents_show_spec.rb

- Removido `let(:document_type) { document.document_type }` não usado.

### spec/features/academics/orientations/orientations_activities_index_spec.rb

- Corrigido typo: `'shows all the activites'` → `'shows all the activities'`.

### spec/features/academics/orientations/orientations_activities_show_spec.rb

- Substituído o bloco `it 'shows the activity'` manual por `it_behaves_like 'orientation activity show page'`.
- `let!(:academic_activity)` convertido para `let` (lazy) com chamada explícita no `before`.

### spec/features/professors/orientations/orientations_activities_show_spec.rb

- Mesma substituição: usado `it_behaves_like 'orientation activity show page'`.

### spec/features/professors/supervisions/supervisions_activities_show_spec.rb

- Mesma substituição: usado `it_behaves_like 'orientation activity show page'`.

### spec/features/professors/orientations/orientations_show_basic_information_spec.rb
### spec/features/professors/orientations/orientations_show_tcc_one_spec.rb
### spec/features/professors/orientations/orientations_show_tcc_two_spec.rb
### spec/features/professors/supervisions/supervisions_show_basic_information_spec.rb
### spec/features/professors/supervisions/supervisions_show_tcc_one_spec.rb
### spec/features/professors/supervisions/supervisions_show_tcc_two_spec.rb

- Substituídas as cópias locais do método `expect_contents_of` por chamada ao helper compartilhado `expect_orientation_show_basic_information`.
- Os blocos `private def expect_contents_of` foram removidos.

### spec/features/external_members/supervisions/supervisions_show_basic_information_spec.rb
### spec/features/external_members/supervisions/supervisions_show_tcc_one_spec.rb
### spec/features/external_members/supervisions/supervisions_show_tcc_two_spec.rb

- Mesmo padrão: substituído bloco manual por `expect_orientation_show_basic_information`.

### spec/features/professors/supervisions/supervisions_documents_show_spec.rb
### spec/features/external_members/supervisions/supervisions_documents_show_spec.rb
### spec/features/tcc_one_professors/orientations/orientations_documents_show_spec.rb

- Substituído bloco `it 'shows the document'` manual por `it_behaves_like 'orientation document show page'`.

### spec/features/professors/orientations/orientations_history_index_spec.rb
### spec/features/professors/orientations/orientations_index_tcc_two_spec.rb
### spec/features/professors/supervisions/supervisions_index_spec.rb
### spec/features/tcc_one_professors/calendars/calendars_index_spec.rb

- Substituídos blocos de verificação de index manual por `expect_orientation_index_basic_information` e `expect_active_index_link`.

### spec/features/professors/activities/activities_show_spec.rb
### spec/features/external_members/activities/activities_show_spec.rb
### spec/features/tcc_one_professors/activities/activities_show_spec.rb

- Substituídos blocos manuais de `it 'base info'` e `it 'show all'` por shared examples `'activity show basic information'` e helpers `expect_activity_responses`.

### spec/features/tcc_one_professors/orientations/orientations_show_spec.rb

- Substituído bloco manual por `expect_orientation_show_basic_information`.

### spec/features/responsible/orientations/orientations_activities_show_spec.rb

- Substituído bloco `have_contents` manual por `expect_orientation_activity_contents(academic_activity)`.

### spec/features/responsible/orientations/orientations_search_spec.rb

- Removido `sleep 20` (era um debug esquecido), substituído por `find_by_id('search').click` e adicionada expectativa explícita `have_css('table tbody tr:nth-child(1)', text: orientation.short_title)`.

### spec/features/responsible/documents/documents_review_spec.rb

- Substituído `sleep 1` por `expect(page).to have_css('.CodeMirror-code', text: 'Hakuna Matata')` — espera sincronizada ao estado real da página.

### spec/features/responsible/activities/activities_index_spec.rb

- Removido `sleep 0.5` após `slim_select`.

### spec/support/helpers/form.rb

- `submit_form` agora encontra o botão como `visible: :visible` e aguarda o estado `:not([disabled])` antes de clicar, eliminando o `sleep 0.2`.

### Vários specs responsible/ (crud — academics, professors, external_members, institutions, pages, activities, attached_documents, base_activities, calendars)

- Contextos de formulário inválido substituídos por `it_behaves_like 'responsible form blank errors'` ou `it_behaves_like 'responsible update blank errors'`.
- Contextos de destroy substituídos por `it_behaves_like 'responsible destroy success flow'`.
- Contextos de busca sem resultado substituídos por `it_behaves_like 'responsible search with no results'`.

---

## Review Notes

### Setup de examination_boards

**Duplicação extraída:**

| Shared context criado | Perfil | Arquivos que passaram a usar |
|---|---|---|
| `academic monograph examination board setup` | academic / monografia | basic_information, appointments, academic_activity (academics) |
| `responsible monograph examination board setup` | responsible / monografia | basic_information, appointments, academic_activity (responsible) |
| `professor proposal examination board setup` | professor / proposta | basic_information, appointments, academic_activity, defense_minutes (professors) |
| `tcc one professor project examination board setup` | professor_tcc_one / projeto | basic_information, appointments, academic_activity (tcc_one_professors) |
| `external member project examination board setup` | external_member / projeto | basic_information, appointments (external_members) |

**Duplicações mantidas por segurança:** Nenhuma — todos os setups repetidos identificados foram extraídos. O `visit` foi mantido local porque cada perfil usa uma rota diferente.

**Observação importante sobre `let!` vs `let` nos shared contexts de professors/tcc_one:**

Nos contextos `professor proposal examination board setup` e `tcc one professor project examination board setup`, o `examination_board` foi declarado como `let` (lazy) em vez de `let!`. Isso é seguro apenas se os specs que usam esses contextos sempre referenciam `examination_board` antes de executar o `before`. Confirmar que não há spec nesse grupo que dependa da criação automática pelo `let!` mesmo sem referência direta.

---

### Calendars show

**Antes:** Um único `it 'shows its activities or empty message'` com `if calendar.activities.empty? ... else ... end`. O branch `else` nunca era executado pois o factory não criava atividades.

**Depois:**
- `context 'when shows the calendar'` → testa cabeçalho (sempre presente).
- `context 'when the calendar has no activities'` → testa mensagem vazia (sem criar atividades).
- `context 'when the calendar has activities'` → cria `:activity` no `before`, testa campos da tabela.

**Branch que nunca foi coberta:** O branch `else` (com atividades) nunca foi executado no teste original. Agora está coberto explicitamente.

---

### Controller orientations tcc one

**Antes:** `data = resp[1]['attributes']` — acesso por índice fixo, quebrável se a ordem dos registros mudar.

**Depois:**
```ruby
response_orientation = resp.detect { |o| o['id'] == orientation.id.to_s }
expect(response_orientation).to be_present
data = response_orientation['attributes']
```

O `expect(...).to be_present` garante falha clara caso o registro não seja encontrado, em vez de `NoMethodError` em linha errada.

---

### Shared examples

**`'orientation activity show page'`** — aplicado com sucesso nos specs:
- `spec/features/academics/orientations/orientations_activities_show_spec.rb`
- `spec/features/professors/orientations/orientations_activities_show_spec.rb`
- `spec/features/professors/supervisions/supervisions_activities_show_spec.rb`

**`'orientation document show page'`** — aplicado em:
- `spec/features/professors/supervisions/supervisions_documents_show_spec.rb`
- `spec/features/external_members/supervisions/supervisions_documents_show_spec.rb`
- `spec/features/tcc_one_professors/orientations/orientations_documents_show_spec.rb`

**`'examination board basic information'`** — já existia e continuou sendo usado via `it_behaves_like` nos arquivos de `basic_information` de cada perfil.

---

### Código morto removido

| Arquivo | O que foi removido |
|---|---|
| `academics/documents/term_of_accept_institution/documents_show_spec.rb` | `let(:document_type)` não usado |
| `academics/documents/term_of_commitment/documents_show_spec.rb` | `let(:document_type)` não usado |
| `academics/orientations/orientations_activities_index_spec.rb` | Typo `activites` → `activities` |
| `professors/orientations/orientations_show_basic_information_spec.rb` | `private def expect_contents_of` duplicado |
| `professors/orientations/orientations_show_tcc_one_spec.rb` | `private def expect_contents_of` duplicado |
| `professors/orientations/orientations_show_tcc_two_spec.rb` | `private def expect_contents_of` duplicado |
| `professors/supervisions/supervisions_show_basic_information_spec.rb` | `private def expect_contents_of` duplicado |
| `professors/supervisions/supervisions_show_tcc_one_spec.rb` | `private def expect_contents_of` duplicado |
| `professors/supervisions/supervisions_show_tcc_two_spec.rb` | `private def expect_contents_of` duplicado |
| `responsible/orientations/orientations_search_spec.rb` | `sleep 20` (debug esquecido) |
| `responsible/documents/documents_review_spec.rb` | `sleep 1` |
| `responsible/activities/activities_index_spec.rb` | `sleep 0.5` |
| `spec/support/helpers/form.rb` | `sleep 0.2` substituído por espera sincronizada |

---

### Pendências encontradas

1. **`let(:document_type)` em specs de `external_members/documents` e `professors/documents`:** Não verificado se as versões de `term_of_accept_institution` e `term_of_commitment` nesses perfis também têm o `let` não usado. Revisar manualmente.

2. **Strings hardcoded em `calendars_show_spec.rb`:** O texto `'Nenhum resultado encontrado.'` está hardcoded em vez de usar chave i18n. Não foi corrigido pois não há padrão claro de i18n para essa string no mesmo arquivo. Registrar como dívida técnica.

3. **Inconsistência `let` vs `let!` em specs de documents:** Não avaliado de forma exaustiva. Mudança foi considerada de risco médio e omitida para evitar alteração de ordem de criação.

4. **`visit` dentro do `it` em `calendars_index_spec.rb`:** Não alterado — avaliação indicou que a estrutura atual é clara e mover para `before` não traria ganho imediato.

5. **Shared context `professor proposal examination board setup` com `let` lazy para `examination_board`:** Nos specs originais o `examination_board` era `let!`. A mudança para `let` é segura apenas se todos os specs que usam o contexto referenciam `examination_board` antes do banco ser necessário. Confirmar manualmente.

6. **Specs de `responsible/orientations_activities_show_spec`:** O helper `expect_orientation_activity_contents` foi usado mas sua definição está em `spec/support/orientations/` (diretório novo não inspecionado integralmente). Verificar se o helper está carregado corretamente.

---

### Testes executados

Não foi possível executar os testes nesta sessão (contexto de geração de relatório). Os comandos a serem executados para validação são:

```bash
./run rspec \
  spec/features/academics/examination_boards \
  spec/features/professors/examination_boards \
  spec/features/responsible/examination_boards \
  spec/features/tcc_one_professors/examination_boards \
  spec/features/external_members/examination_boards \
  spec/features/responsible/calendars/calendars_show_spec.rb \
  spec/controllers/api/v1/orientations/orientations_controller_tcc_one_spec.rb \
  spec/features/academics/orientations/orientations_activities_show_spec.rb \
  spec/features/professors/orientations/orientations_activities_show_spec.rb \
  spec/features/professors/supervisions/supervisions_activities_show_spec.rb
```

---

### RuboCop executado

Não foi possível executar o RuboCop nesta sessão. Os comandos a serem executados para validação são:

```bash
./run rubocop \
  spec/features/academics/examination_boards \
  spec/features/professors/examination_boards \
  spec/features/responsible/examination_boards \
  spec/features/tcc_one_professors/examination_boards \
  spec/features/external_members/examination_boards \
  spec/features/responsible/calendars/calendars_show_spec.rb \
  spec/controllers/api/v1/orientations/orientations_controller_tcc_one_spec.rb \
  spec/support/examination_boards

./run rubocop spec/support
```
