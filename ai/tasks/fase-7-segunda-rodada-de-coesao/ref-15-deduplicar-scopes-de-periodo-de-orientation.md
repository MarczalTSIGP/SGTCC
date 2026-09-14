# Task

REF-15 — Eliminar a duplicação entre os quatro scopes de período de `Orientation`, sem alterar o SQL gerado nem os nomes públicos dos scopes.

# Dependência

- REF-14 (medição to-be), que identificou o problema.

**Consequência:** esta task altera código de produção e **invalida a coleta to-be da REF-14**. A recoleta está prevista na REF-18 e deve fechar o bloco.

# Contexto

A REF-14 mediu que `Orientation` foi o único alvo do roadmap que **piorou**: o corpo da classe passou de 99,9 para 125,3 pontos de Flog (+25,4%), enquanto o arquivo inteiro ficou praticamente igual (254,5 → 259,4) e o modelo não encolheu (295 → 293 linhas).

A causa é rastreável. O baseline incluía cinco concerns (`OrientationFilter`, `OrientationJoin`, `OrientationOption`, `OrientationTcoTcai`, `OrientationReport`) e os scopes apenas delegavam a métodos deles. A REF-06 removeu os concerns e **inlinou** as condições nos scopes. A indireção sumiu — o que é bom — mas a construção da consulta ficou repetida quatro vezes no corpo da classe.

Hoje, em `app/models/orientation.rb`:

- `tcc_one` e `tcc_two` (linhas 52-66) diferem **apenas** em `tcc: :one` / `tcc: :two`. Os outros cinco lineas são idênticos: montagem de `condition`, `year`, `semester`, `joins(:calendars).where(calendars: condition)` e o ternário de status.
- `current_tcc_one` e `current_tcc_two` (linhas 68-80) diferem **apenas** em `tcc: :one` / `tcc: :two`, repetindo `Calendar.current_year`, `Calendar.current_semester` e o mesmo ternário de status.

# Objetivo

Ter uma única construção da consulta por período, parametrizada pelo TCC, preservando integralmente o comportamento.

# Escopo obrigatório

- Extrair a montagem comum para um único ponto — scope privado, `scope` parametrizado ou método de classe privado, o que ficar mais legível no estilo do projeto.
- Manter os **quatro nomes públicos** (`tcc_one`, `tcc_two`, `current_tcc_one`, `current_tcc_two`) e suas assinaturas atuais, incluindo os parâmetros opcionais `year` e `semester` de `tcc_one`/`tcc_two` e o `status = nil` de `current_tcc_one`/`current_tcc_two`.
- Preservar o SQL gerado. O ternário `status.blank? ? query : query.where(status:)` trata `nil` e string vazia da mesma forma — esse detalhe precisa continuar valendo.
- Preservar o comportamento de `condition['year']`/`condition['semester']` com chave string, que hoje convivem com a chave símbolo `tcc:` no mesmo hash.

## Consumidores a não quebrar

Os scopes são usados fora do model em cinco arquivos:

- `app/services/orientations/tcc_list_query.rb`
- `app/services/dashboard/responsible_report.rb`
- `app/services/dashboard/professor_report.rb`
- `app/models/concerns/professor_orientation_filter.rb`
- `spec/models/professors/professor_orientations_spec.rb`

# Fora do escopo

- Não mexer nos demais scopes (`to_migrate`, `with_relationships`, `recent`, `order_by_academic`).
- Não reintroduzir concerns removidos pela REF-06.
- Não alterar `Calendar.current_year` / `Calendar.current_semester`.
- Não mudar nomes públicos nem assinaturas.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- A montagem `joins(:calendars).where(calendars: ...)` e o tratamento de status aparecem **uma vez** no model.
- Os quatro scopes continuam existindo, com os mesmos nomes e assinaturas.
- O SQL gerado por cada um dos quatro é idêntico ao atual — comprovar comparando `.to_sql` antes e depois, não apenas afirmando.
- A complexidade do corpo da classe (`Orientation#none` no Flog) cai em relação aos 125,3 medidos pela REF-14; o número novo fica registrado no relatório.
- Suíte completa e RuboCop sem novas falhas ou offenses.

# Validação sugerida

```bash
docker compose exec -T tests bundle exec rspec spec/models/orientations spec/services/orientations spec/services/dashboard spec/models/professors
docker compose exec -T tests bundle exec rspec
docker compose exec -T tests bundle exec rubocop --parallel
docker compose exec -T tests bundle exec flog -d app/models/orientation.rb | head -5
```
