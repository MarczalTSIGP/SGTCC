# Task

REF-21 — Eliminar a dependência de ordem de execução que faz specs passarem na suíte completa e falharem isolados.

# Dependência

- REF-16 e REF-17, que encontraram e caracterizaram o problema sem corrigi-lo.

# Contexto

## Sintoma

`spec/features/site/activities/activities_index_spec.rb` **falha quando executado isolado** e **passa na suíte completa**:

```
ActiveRecord::RecordInvalid:
  A validação falhou: Ano já está em uso para o TCC e semestre selecionado
# ./spec/features/site/activities/activities_index_spec.rb:9
```

Verificações já feitas, que descartam as explicações fáceis:

- o banco de teste estava **vazio** no momento da falha (`Calendar.count == 0`), então não é resíduo de execução anterior;
- o arquivo foi executado contra o código de `HEAD`, sem nenhuma alteração pendente, e falhou igual — não é regressão de refatoração.

## Causa provável, já identificada

`Calendar.current_semester` (`app/models/concerns/current_calendar.rb:17`) **consulta a própria tabela**:

```ruby
def current_semester
  semester_from(current_range_calendar || latest_calendar) || default_semester
end
```

Com a base vazia ele cai em `default_semester`, derivado do mês corrente. Assim que o primeiro calendário é criado, passa a derivar **desse registro**. Qualquer spec que chame `Calendar.current_semester` mais de uma vez, intercalado com criação de calendário, obtém respostas diferentes na mesma execução — e o resultado muda conforme o que rodou antes.

Foi exatamente esse o mecanismo que quebrou um spec novo durante a REF-17: dois `let` calculando o período acabaram resolvendo para o **mesmo** calendário, violando a unicidade de `orientation_calendars`. Lá a correção foi capturar o período uma única vez, antes de qualquer criação.

## Achado adicional

`spec/support/database_cleaner.rb` decide a estratégia assim:

```ruby
driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test
```

Mas `spec/support/capybara.rb` define `Capybara.default_driver = :chrome`. **A condição nunca é verdadeira neste projeto** — o ramo `:rack_test` é código morto e a estratégia é sempre `:truncation` para specs de feature. Isso não explica a falha, mas precisa ser considerado na investigação em vez de tomado como proteção ativa.

# Objetivo

Fazer com que os specs afetados passem tanto isolados quanto na suíte completa, sem mascarar o problema com ordem fixa ou `sleep`.

# Escopo obrigatório

- Diagnosticar a falha de `spec/features/site/activities/activities_index_spec.rb` até a causa concreta, e corrigi-la no spec ou no suporte de teste.
- Corrigir a mesma fragilidade latente em `spec/models/orientations/orientation_academic_activities_spec.rb`, que calcula `Calendar.current_semester` em dois `let` separados e hoje passa por sorte da ordem de avaliação.
- Varrer os specs em busca do mesmo padrão — `Calendar.current_semester` ou `Calendar.current_year` chamados mais de uma vez em um mesmo grupo, intercalados com criação de calendário — e registrar a lista, corrigindo os que estiverem no caminho da falha.
- Decidir o que fazer com o ramo morto de `:rack_test`: remover ou documentar por que fica.

## Verificação obrigatória

Cada spec corrigido precisa passar nos **três** modos:

1. isolado (`rspec <arquivo>`);
2. junto com seu diretório;
3. na suíte completa.

# Fora do escopo

- Não alterar `CurrentCalendar` nem a semântica de `current_semester`/`current_year` — são regra de domínio usada em produção. Se a conclusão for que a regra precisa mudar, isso vira task funcional própria.
- Não fixar ordem de execução (`--order defined` já é o padrão do projeto) como forma de esconder a dependência.
- Não adicionar `sleep`.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- `spec/features/site/activities/activities_index_spec.rb` passa isolado, por diretório e na suíte completa.
- `orientation_academic_activities_spec.rb` não depende mais da ordem de avaliação dos `let`.
- Existe lista dos specs que usam o padrão frágil, mesmo os não corrigidos.
- A suíte completa continua em 0 falhas.
- Nenhuma alteração em código de produção.

# Validação sugerida

```bash
docker compose exec -T tests bundle exec rspec spec/features/site/activities/activities_index_spec.rb
docker compose exec -T tests bundle exec rspec spec/features/site
docker compose exec -T tests bundle exec rspec spec/models/orientations/orientation_academic_activities_spec.rb
docker compose exec -T tests bundle exec rspec

grep -rn "Calendar.current_semester\|Calendar.current_year" spec/ | wc -l
```
