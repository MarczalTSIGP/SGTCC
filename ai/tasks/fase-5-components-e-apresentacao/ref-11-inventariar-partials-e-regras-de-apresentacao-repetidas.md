# Task

REF-11 — Inventariar partials e blocos de apresentação repetidos entre namespaces/views do SGTCC, priorizando um conjunto curto de candidatos reais a component para a REF-12.

# Contexto

O inventário da REF-01 (`ai/output/fase-0-baseline/inventario-ref-01.md`) já apontou, via Flay, três blocos de duplicação em views. Esta task reconfirma esses três e amplia a busca, porque o Flay só pontua blocos com estrutura de código quase idêntica — ele não captura padrões onde o *shell* HTML se repete mas o conteúdo (colunas, labels) muda, que é o caso mais comum encontrado nesta investigação.

## Candidatos já confirmados (herdados da REF-01, reconfirmados nesta investigação)

**1. `sign_form.html.erb` — `academics/documents/`, `external_members/documents/`, `professors/documents/`.** Reconfirmado: os três arquivos são **byte a byte idênticos** (uma differença de linha em branco entre um deles e os outros dois). Todos renderizam `Documents::SignFormComponent.new(username:, confirm_url:, back_url:)` — o componente já existe; é a *view* ao redor dele que está triplicada. As diferenças reais estão nos três controllers, que preenchem `@username`/`@confirm_url`/`@back_url` de formas diferentes por namespace.

**2. `_appointment_file_form.html.erb` — `professors/examination_boards/`, `external_members/examination_boards/`.** Reconfirmado: only três diferenças — `html: { id: 'appoints_form' }` presente só na versão de professors, o hidden field (`professor_id` vs `external_member_id`), e uma quebra de linha só de formatação no botão de submit. Ainda não existe um `ExaminationBoards::AppointmentFileFormComponent` ou equivalente.

## Novo achado: shell de tabela de listagem duplicado muito além dos 3 arquivos do Flay

O terceiro item da REF-01 (`academics/calendars/index.html.erb`, `academics/orientations/documents.html.erb`, `academics/tep_requests/index.html.erb`) é uma instância de um padrão bem mais amplo: `grep -rl "table card-table table-vcenter" app/views` encontra **29 arquivos**; `grep -rl "shared/no_results"` encontra **32**. O shell é sempre a mesma estrutura:

```erb
<div class="table-striped ... table-responsive w-100">
  <table class="table card-table table-vcenter text-nowrap">
    <thead>
      <tr><th>...</th>...</tr>
    </thead>
    <tbody>
      <tr><%= render('shared/no_results') if @collection.empty? %></tr>
      <% @collection.each do |item| %>
        <%= render 'namespace/resource/item', item: item %>
      <% end %>
    </tbody>
  </table>
</div>
<%= paginate @collection %> <!-- quando paginado -->
```

Isso já foi parcialmente resolvido duas vezes no projeto, e os dois casos são o precedente direto a seguir:

- **`Orientations::TableComponent`** (`app/components/orientations/table_component.rb`) — já é `ViewComponent`, com badge de status, dropdown de ações configurável (`action_partial`/`action_block`) e resolução de rota por namespace. Consumido por **10 views** (`professors/orientations/index`, `professors/supervisions/index`, `tcc_one_professors/orientations/index`, `responsible/orientations/index`, `external_members/supervisions/index`, entre outras).
- **`ExaminationBoards::TableComponent`** — consumido por **12 views**, mesmo padrão.

Fora desses dois domínios já componentizados, o shell continua duplicado em duas camadas:

1. **Sete partials `shared/*/_table.html.erb` já compartilhadas entre várias views de um mesmo domínio** (`shared/activities/_table.html.erb` — 4 consumidores; `shared/documents/_table.html.erb` — 3; `shared/meetings/_table.html.erb` — 4; `shared/orientation_activities/_table.html.erb` — 6; e mais `shared/examination_boards/_table.html.erb`, `shared/orientations/_table.html.erb`, `shared/supervision_examination_boards/_table.html.erb`). Cada uma reimplementa o mesmo shell de tabela de forma independente das outras seis.
2. **Views que ainda montam a tabela inline, sem nenhum partial compartilhado** — pelo menos `academics/calendars/index.html.erb`, `academics/orientations/documents.html.erb`, `academics/tep_requests/index.html.erb`, `academics/tso_requests/index.html.erb`, `academics/activities/index.html.erb`, `external_members/calendars/index.html.erb`, `professors/requests/index.html.erb`, `responsible/academics/index.html.erb`, `responsible/attached_documents/index.html.erb`, `responsible/base_activities/index.html.erb`, `responsible/calendars/index.html.erb`, `responsible/external_members/index.html.erb`, `responsible/institutions/index.html.erb`, `responsible/pages/index.html.erb`, `responsible/professors/index.html.erb`, `tcc_one_professors/calendars/index.html.erb` (lista obtida por `grep -rl "table card-table table-vcenter"`, não filtrada nem verificada arquivo a arquivo — é o ponto de partida da investigação desta task, não o inventário final).

## Achado relacionado, já resolvido — não é candidato

Badges de status (orientação, banca, documento) já foram extraídos: `Orientations::StatusBadgeComponent`, `Documents::StatusBadgeComponent`, `app/views/shared/orientations/_legend_status.erb`, `app/views/shared/examination_boards/_legend_status.html.erb`. Não repita esse trabalho — apenas confirme, se aparecer nos seus grep, que já está resolvido.

## Condicionais de domínio em views — baixo volume, provavelmente não vale a pena

`grep -rln "tcc_one?\|tcc_two?\|\.status ==\|semester_one?\|semester_two?" app/views` encontra só 3 arquivos (`layouts/academics/_sidebar.html.erb`, `responsible/activities/_form.html.erb`, `layouts/academics/_requests_menu.html.erb`). Volume baixo — investigue, mas não force um candidato aqui só para preencher a lista; o roadmap é explícito que partials simples e locais não devem virar component sem benefício mensurável.

# Dependências

- REF-05 — Reestruturar os controllers mais críticos (concluída).

# Objetivo

Produzir um inventário de duplicação de apresentação, baseado em inspeção real das views, que:

- reconfirme e detalhe os dois candidatos já apontados pela REF-01 (`sign_form`, `_appointment_file_form`);
- complete o levantamento do shell de tabela de listagem — quantas views/partials realmente repetem o mesmo shell, quais colunas/variantes cada uma tem, e quais (se houver) têm lógica própria demais para valer a extração;
- separe, dentro desse levantamento, o que já está parcialmente resolvido (as 7 partials `shared/*/_table.html.erb`) do que ainda está solto em cada view;
- produza uma lista curta e ordenada (não a lista completa dos ~29 arquivos) de candidatos reais a component para a REF-12, com a estimativa de quantos consumidores cada um beneficiaria.

# Instrução crítica

Esta task é somente de **leitura, análise e documentação**. Não crie components, não extraia partials, não altere nenhuma view, controller ou model. A única escrita permitida é o relatório de inventário descrito abaixo.

# Escopo permitido

- Ler e inspecionar qualquer arquivo em `app/views/`, `app/components/`, `app/controllers/` e `ai/`.
- Usar `grep`/busca textual para localizar partials repetidos, classes CSS repetidas e condicionais de domínio em views.
- Consultar `ai/output/fase-0-baseline/inventario-ref-01.md` como ponto de partida, validando cada achado contra o código atual.
- Criar o arquivo de relatório em `ai/output/fase-5-components-e-apresentacao/`.

# Escopo proibido

- Não altere nenhum arquivo em `app/`.
- Não crie components, partials novas ou branches.
- Não faça commit ou push.

# Roteiro de investigação

## 1. Reconfirmar os dois candidatos da REF-01

- `diff` os três `sign_form.html.erb` e os dois `_appointment_file_form.html.erb`; documentar exatamente as diferenças (já levantadas no contexto, mas confirme que continuam válidas).
- Identificar os controllers que preenchem `@username`/`@confirm_url`/`@back_url` (para `sign_form`) e o hidden field de autor (para `_appointment_file_form`), já que uma eventual consolidação da REF-12 provavelmente parte da view/rota, não só do HTML.

## 2. Mapear o shell de tabela de listagem

- Para cada um dos ~29 arquivos que usam `table card-table table-vcenter`, classificar em: (a) já usa `Orientations::TableComponent`/`ExaminationBoards::TableComponent` — fora de escopo, já resolvido; (b) usa uma das 7 partials `shared/*/_table.html.erb` — duplicação já reduzida ao nível do domínio, mas o shell entre partials continua repetido; (c) monta a tabela inline, sem nenhum partial compartilhado.
- Para os grupos (b) e (c), listar colunas, presença de paginação (`paginate`), presença de `page_entries_info`, e qualquer lógica condicional embutida na linha da tabela (ex.: badge, link condicional).
- Registrar quantos consumidores cada partial/view atende hoje — é o proxy de benefício esperado de uma eventual extração.

## 3. Levantar condicionais de domínio soltos em views

- Investigar os 3 arquivos encontrados (`_sidebar.html.erb`, `responsible/activities/_form.html.erb`, `_requests_menu.html.erb`) e registrar se a lógica é repetida em algum outro lugar (candidato real) ou é local e única (não é candidato).

## 4. Priorizar

- Aplicar o mesmo critério do roadmap (impacto × complexidade): priorize o shell de tabela pelo número de consumidores que se beneficiariam e pela uniformidade das colunas encontradas; não proponha uma abstração única para tabelas com estruturas muito diferentes entre si.

# Critérios de aceite

- O inventário registra, para cada candidato, ocorrências (arquivos e contagem), variantes (o que difere entre elas), dependências (controllers/helpers dos quais a view depende) e benefício esperado (nº de consumidores, redução de duplicação).
- Os dois candidatos herdados da REF-01 estão reconfirmados com evidência atual (diff), não apenas citados do inventário antigo.
- O levantamento do shell de tabela separa claramente o que já está resolvido (`Orientations::TableComponent`, `ExaminationBoards::TableComponent`), o que está parcialmente resolvido (partials `shared/*/_table.html.erb`) e o que ainda está solto por view.
- Existe uma lista curta (poucos itens, não os ~29 arquivos) e ordenada de candidatos reais a component, pronta para a REF-12 consumir diretamente.
- Nenhuma alteração de código foi feita.

# Relatório final esperado

Criar `ai/output/fase-5-components-e-apresentacao/inventario-ref-11.md` com:

## Resumo

Visão geral do que foi encontrado, em poucas linhas, incluindo a distinção entre os dois candidatos pequenos (sign_form, appointment_file_form) e o achado maior (shell de tabela).

## Candidato 1 — `sign_form.html.erb`

Diff reconfirmado, controllers envolvidos, proposta de direção (component, partial compartilhada, ou rota unificada) sem implementar.

## Candidato 2 — `_appointment_file_form.html.erb`

Mesma estrutura do candidato 1.

## Shell de tabela de listagem

Tabela com cada partial/view classificada em resolvido / parcialmente resolvido / não resolvido, colunas, paginação, nº de consumidores.

## Condicionais de domínio em views

O que foi encontrado nos 3 arquivos e se algum vira candidato.

## Lista priorizada de candidatos a component (para a REF-12)

Lista curta e ordenada, com nº de consumidores beneficiados e uma nota de risco/complexidade por item.
