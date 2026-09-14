# Task

REF-17 — Extrair de `Orientation` os acessores de documentos de atividade acadêmica, hoje repetidos em três variantes idênticas.

# Dependência

- REF-15 e REF-16, para não misturar deduplicação de scope, remoção de código morto e extração no mesmo diff.

**Consequência:** altera código de produção e invalida a coleta to-be da REF-14; a recoleta é a REF-18.

# Contexto

`Orientation` concentra oito métodos que existem só para buscar o documento de uma atividade acadêmica:

```ruby
def monograph(options = { final_version: false })
  conditions = { identifier: :monograph, final_version: options[:final_version] }
  find_academic_activity(conditions)
end

def final_monograph
  monograph(final_version: true)
end
```

O mesmo par se repete para `project`/`final_project` e `proposal`/`final_proposal` — três cópias com uma única diferença, o `identifier`. Somados ao privado `find_academic_activity`, são sete métodos; `orientation_type` e `summary` são os dois consumidores diretos.

`find_academic_activity` ainda monta uma consulta com `joins`, `includes`, `where` sobre três tabelas e `order`, o que é construção de consulta morando dentro do model junto com regra de domínio.

Este é o mesmo padrão que a REF-04 e a REF-05 já aplicaram nos controllers: a consulta sai para um objeto dedicado e o consumidor passa a pedir o que precisa.

# Objetivo

Ter uma única implementação da busca por atividade acadêmica, parametrizada pelo identificador, sem mudar o resultado de nenhum dos seis acessores públicos.

# Escopo obrigatório

- Criar um objeto dedicado — no estilo dos services/queries que o projeto já usa em `app/services/orientations/` — que receba a orientação e o identificador e devolva a atividade acadêmica correspondente.
- Preservar os seis nomes públicos (`monograph`, `final_monograph`, `project`, `final_project`, `proposal`, `final_proposal`) e suas assinaturas, incluindo o hash default `{ final_version: false }`.
- Preservar a consulta atual **exatamente**: `joins(:activity)`, `includes(activity: :calendar)`, o filtro por `identifier`, `final_version` e `calendar_id` vindo de `calendars.pluck(:id)`, a ordenação `calendars.year DESC, calendars.semester DESC` e o `.try(:first)`.
- `orientation_type` e `summary` continuam funcionando sem alteração de resultado — inclusive o detalhe de que `orientation_type` devolve `nil`, e não `:unknown`, quando o status casa mas o documento está ausente (comportamento preservado pela REF-13B).
- Cobrir o objeto novo com spec próprio, incluindo o caso sem atividade encontrada.

## Consumidores a verificar antes de mexer

`final_monograph`, `final_project` e `final_proposal` são usados fora do model — entre outros em `Orientation.to_json_table`, em `Orientation.approved`/`approved_tcc_one` e em views. Levantar a lista completa por `grep` antes de editar.

# Fora do escopo

- Não alterar `orientation_type` nem `summary` além do necessário para consumir o objeto novo.
- Não mexer em `AcademicActivity`, `Activity` nem em suas associações.
- Não corrigir o N+1 conhecido de `Orientation.approved` e `Orientation.approved_tcc_one`, que carregam todos os registros e filtram em Ruby com `reject { |o| o.final_monograph.nil? }`. **Registrado como achado**: é mudança de consulta com impacto em site público e API, e merece task própria com medição.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- A montagem da consulta de atividade acadêmica aparece **uma vez** no projeto.
- Os seis acessores públicos continuam existindo, com as mesmas assinaturas e os mesmos resultados.
- `Orientation` perde pelo menos os sete métodos hoje dedicados a isso.
- Há spec do objeto novo, com o caso de ausência coberto.
- A complexidade de `app/models/orientation.rb` cai em relação ao medido pela REF-14; o número novo fica registrado.
- Suíte completa e RuboCop sem novas falhas ou offenses.

# Validação sugerida

```bash
grep -rn "final_monograph\|final_project\|final_proposal\|\bmonograph\b\|\bproject\b\|\bproposal\b" app/ spec/ --include=*.rb --include=*.erb | head -40

docker compose exec -T tests bundle exec rspec spec/models/orientations spec/services/orientations spec/controllers/api spec/features/site
docker compose exec -T tests bundle exec rspec
docker compose exec -T tests bundle exec rubocop --parallel
docker compose exec -T tests bundle exec flog -d app/models/orientation.rb | head -5
```
