# Task

REF-13A — Remover o código morto de apresentação e de roteamento identificado pelo inventário da REF-11 e pela validação da REF-13, sem alterar nenhum comportamento observável.

# Dependência

- REF-11 (inventário de partials), REF-13 (validação de regressão).
- Deve ser concluída **antes da REF-14**: qualquer remoção feita depois invalida a medição to-be e obriga a remedir.

# Contexto

A REF-11 registrou três partials de tabela sem nenhum consumidor, deixadas para trás quando `Orientations::TableComponent` e `ExaminationBoards::TableComponent` assumiram esses domínios. A REF-12 não as removeu por estar limitada a extração de components.

A validação da REF-13 encontrou um segundo grupo de artefatos mortos, no fluxo de "desistência da orientação": existe rota, existe predicado e existem chaves de tradução, mas **não existe a ação no controller nem qualquer consumidor**.

# Objetivo

Remover artefatos comprovadamente sem consumidor, mantendo a suíte verde e sem mudar nenhuma tela, rota utilizada ou regra de domínio.

# Escopo obrigatório

## Partials de tabela órfãs

Remover, após reconfirmar com `grep` que não há `render` para nenhuma delas (com e sem o prefixo `shared/`, em `app/views`, `app/components` e `app/helpers`):

- `app/views/shared/examination_boards/_table.html.erb`
- `app/views/shared/orientations/_table.html.erb`
- `app/views/shared/supervision_examination_boards/_table.html.erb`

Cuidados:

- `app/views/shared/supervision_examination_boards/` fica vazio após a remoção — remover o diretório também.
- Os `_tbody.html.erb` de `shared/examination_boards` e `shared/orientations` **continuam em uso** por outras views e **não** devem ser tocados.
- A partial órfã de `supervision_examination_boards` renderiza `#{resource}/supervision_examination_boards/examination_board`; confirmar se esse partial de linha continua tendo outro consumidor antes de decidir sobre ele. Se ficar órfão em cascata, registrar o achado, mas **não** remover nesta task sem a mesma confirmação por `grep`.

## Fluxo de desistência nunca implementado

Verificado nesta análise:

- `config/routes.rb:357` declara `post 'orientations/(:id)/abandon' => 'orientations#abandon'` dentro de `namespace :professors`;
- `Professors::OrientationsController#abandon` **não existe** — a rota responde com erro se acionada;
- o path helper `professors_orientations_abandon_path` não aparece em `app/`, `spec/` nem `lib/`;
- `OrientationStatus#abandoned?` chama `equal_status?('ABANDONED')`, mas `ABANDONED` **não está** no `enum :status`; `Orientation.statuses.key('ABANDONED')` retorna `nil`, então o predicado **sempre retorna `false`**;
- `Orientation#active?` (`app/models/orientation.rb:125-126`) faz `!canceled? && !abandoned?`; como `abandoned?` é sempre `false`, `!abandoned?` é sempre `true` e o termo não influencia o resultado. `active?` é consumido apenas por `can_be_canceled?`.

Remover, nesta ordem e com commits separados:

1. a rota `professors/orientations/(:id)/abandon`;
2. o predicado `abandoned?` e o termo `&& !abandoned?` de `active?`.

A remoção do termo em `active?` é **comprovadamente neutra** — demonstrar isso no relatório, não apenas afirmar.

# Fora do escopo

- **Não remover** as chaves de locale `enums.orientation.status.ABANDONED`, `orientation.abandon` e `orientations.abandon.success`. Antes de qualquer decisão sobre elas é preciso confirmar que nenhuma linha da base de produção tem `status = 'ABANDONED'`; registrar isso como pendência de verificação de dados.
- Não implementar o fluxo de desistência — se ele for desejado, é mudança funcional e precisa de task própria.
- Não adicionar `ABANDONED` ao `enum :status`.
- Não mexer em outros components, partials ou rotas.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- As três partials órfãs e o diretório vazio não existem mais.
- A rota `abandon` e o predicado `abandoned?` não existem mais, e `active?` mantém o mesmo resultado para todos os status do enum.
- `grep` confirma zero referências remanescentes a cada artefato removido.
- Chaves de locale preservadas, com a pendência de verificação de dados registrada.
- Suíte completa e RuboCop sem novas falhas ou offenses.

# Validação sugerida

```bash
grep -rn "shared/examination_boards/table\|shared/orientations/table\|shared/supervision_examination_boards" app/ spec/
grep -rn "abandoned?\|orientations_abandon" app/ spec/ lib/

docker compose exec -T tests bundle exec rspec spec/models/orientations spec/features/professors/orientations spec/features/professors/supervisions spec/features/responsible/orientations
docker compose exec -T tests bundle exec rspec
docker compose exec -T tests bundle exec rubocop --parallel
```
