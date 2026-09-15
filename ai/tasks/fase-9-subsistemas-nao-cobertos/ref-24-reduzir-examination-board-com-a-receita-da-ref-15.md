# Task

REF-24 — Aplicar a `ExaminationBoard` a mesma correção que a REF-15 aplicou a `Orientation`: deduplicar os scopes de período, que hoje fazem dele o corpo de classe mais complexo do projeto.

# Dependência

- REF-15 e REF-18, que produziram a receita e a medição.

# Contexto

Com a segunda rodada, `Orientation#none` caiu de 125,3 para 89,3 e **`ExaminationBoard` assumiu o topo da lista de complexidade com 97,7 pontos** de Flog no corpo da classe. São 178 linhas, 26 métodos e scopes, e 6 concerns incluídos.

A causa principal é a mesma que a REF-15 corrigiu, quase literalmente. `tcc_one_current_semester` e `tcc_two_current_semester` (`app/models/examination_board.rb:35-63`) são **14 linhas cada, idênticas exceto por dois pontos**:

```ruby
scope :tcc_one_current_semester, lambda {
  tcc_value = :one
  current = Calendar.current_by_tcc_one || Calendar.where(tcc: tcc_value)...
  return none if current.blank?
  joins(orientation: :calendars).where(calendars: { id: current.id }).where(tcc: tcc_value).distinct
}
```

A diferença entre os dois é `:one`/`:two` e `current_by_tcc_one`/`current_by_tcc_two`. Todo o resto — o fallback para o calendário mais recente, o `return none`, o `joins(orientation: :calendars)`, o `where` e o `distinct` — está escrito duas vezes.

# Objetivo

Ter uma única construção da consulta de período, preservando integralmente o comportamento e os nomes públicos.

# Escopo obrigatório

- Extrair a montagem comum de `tcc_one_current_semester` e `tcc_two_current_semester` para um único ponto, parametrizado pelo TCC.
- Manter os dois nomes públicos e o scope `current_semester`, que tem lógica diferente (filtra por intervalo de datas do calendário corrente, não por `id`) e **não** deve ser fundido com os outros dois.
- Preservar o fallback para o calendário mais recente por `year DESC, end_date DESC` quando não há calendário corrente, e o `return none` quando não há nenhum.
- Preservar `distinct` e o `joins(orientation: :calendars)`.

## Armadilha já conhecida, documentada pela REF-15

Métodos de apoio chamados de dentro de um `scope` **precisam ser públicos**. Dentro do bloco de um `scope`, `self` é a `ActiveRecord::Relation`, que só delega métodos de classe públicos; declarar o apoio como `private_class_method` levanta `NoMethodError`. Usar receptor explícito (`ExaminationBoard.metodo`) "resolve" o erro mas **descarta a relation corrente**, quebrando o encadeamento em silêncio.

## Comprovação obrigatória de equivalência

Repetir o método da REF-15, que funcionou:

- capturar `to_sql` dos scopes **antes e depois**, cobrindo: com calendário corrente, sem calendário corrente (fallback), e sem nenhum calendário (`none`);
- incluir ao menos dois casos de encadeamento a partir de uma relation, para garantir que as condições externas sobrevivem;
- o `diff` das duas capturas precisa ser vazio.

## Cobertura

Verificar se existe spec dedicado para esses scopes em `spec/models/examination_boards/examination_board_scopes_spec.rb`. Se a cobertura dos três casos acima não existir, criá-la — e validá-la por mutação, como foi feito na REF-15.

# Fora do escopo

- Não mexer nos seis concerns incluídos.
- Não alterar `current_semester`, `recent`, `with_relationships` nem `site_with_relationships`.
- Não tocar em `trigger_create_notifications` nem no `after_commit`.
- Não alterar `Calendar.current_by_tcc_one`/`current_by_tcc_two`.
- Não refatorar `Responsible::ExaminationBoardsController` (16 warnings, o pior controller do projeto) — registrar para task própria.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- A montagem da consulta de período aparece uma vez no model.
- `tcc_one_current_semester` e `tcc_two_current_semester` continuam existindo, com o mesmo comportamento nos três cenários.
- O `diff` das capturas de `to_sql` é vazio, e isso está no relatório.
- A complexidade do corpo da classe cai em relação aos 97,7 medidos pela REF-18; o número novo fica registrado.
- Suíte completa e RuboCop sem novas falhas ou offenses.

# Validação sugerida

```bash
docker compose exec -T tests bundle exec rspec \
  spec/models/examination_boards spec/services/examination_boards \
  spec/features/responsible/examination_boards spec/features/tcc_one_professors/examination_boards \
  spec/features/professors/examination_boards
docker compose exec -T tests bundle exec rspec
docker compose exec -T tests bundle exec rubocop --parallel
docker compose exec -T tests bundle exec flog -d app/models/examination_board.rb | head -5
```
