# REF-21 — Resumo de implementação

## Resumo

A causa da falha era um `before(:suite)` que criava calendários **depois** da truncação do DatabaseCleaner. Removido, o spec afetado passa nos três modos de execução. O padrão frágil do `Calendar.current_semester` foi corrigido onde era pior, e o ramo morto do DatabaseCleaner foi eliminado.

## Diagnóstico

A task trazia duas hipóteses. **As duas estavam erradas**, e a instrumentação mostrou a causa real.

### O que eu verifiquei e descartei

1. **"O banco está sujo de execução anterior."** Semeei um calendário conflitante, rodei o spec isolado, e ele falhou — mas a instrumentação mostrou que o `before(:suite)` **truncava corretamente**: `count=1` antes, `count=0` depois, mesma conexão, sem transação aberta.
2. **"É a estratégia do DatabaseCleaner escolhida pelo `Capybara.current_driver`."** Também não: a truncação por exemplo funcionava, tanto que do segundo exemplo em diante o banco estava vazio.

### A causa real

Instrumentando o `before(:suite)` e o primeiro exemplo na mesma execução:

```
DEBUG suite: count=1 → truncate → count=0
DEBUG exemplo: count=4  [2026/two/one, 2026/two/two, 2027/one/one, 2027/one/two]
```

Quatro calendários **aparecem** entre a truncação e o primeiro exemplo. Não eram restaurados — eram criados, por `spec/support/default_calendars.rb`:

```ruby
config.before(:suite) do
  FactoryBot.create(:calendar, :current, :tcc_one) unless Calendar.exists?(...)
  ...
end
```

Dois `before(:suite)` em ordem de registro: o do DatabaseCleaner trunca, o de `default_calendars` cria quatro calendários logo em seguida.

O efeito é perverso: esses calendários existem **apenas durante o primeiro exemplo da execução**, porque o `append_after` do DatabaseCleaner os trunca junto com os dados do exemplo. Do segundo em diante, nunca mais existem.

Ou seja, o arquivo não cumpre o que promete — não são "calendários padrão", são calendários que só o primeiro exemplo enxerga. E quebram qualquer spec que rode primeiro e crie um calendário corrente, que é exatamente o caso de `activities_index_spec.rb`. Na suíte completa o primeiro exemplo é outro, que não cria calendário corrente, e por isso ninguém percebia.

## Alterações

### `spec/support/default_calendars.rb` — removido

Fixture de suíte inócua por construção: só vale para um exemplo e depois some. Verificado que a suíte completa continua em 0 falhas sem ele, e que `spec/models/calendar` — os únicos specs que usam `current_by_tcc_one`/`current_by_tcc_two` — seguem passando.

### `spec/support/database_cleaner.rb` — ramo morto removido

A condição `Capybara.current_driver == :rack_test`, que manteria a estratégia `:transaction` para drivers que compartilham conexão, **nunca era verdadeira**: `spec/support/capybara.rb` define `Capybara.default_driver = :chrome`. Era código morto com aparência de proteção ativa.

Substituído pela atribuição direta de `:truncation`, com comentário registrando o motivo e o que precisa voltar caso um driver `:rack_test` seja adotado no futuro.

### `orientation_academic_activities_spec.rb` — padrão frágil corrigido

O arquivo chamava `Calendar.current_year`/`current_semester` em **12 pontos**, dois por `let`, em três grupos. Como `current_semester` consulta a própria tabela, criar o primeiro calendário mudava a resposta para o segundo, e os dois podiam resolver para o mesmo registro.

Agora o período é capturado **uma vez por exemplo**, num helper memoizado — método, e não `let`, para não estourar o `RSpec/MultipleMemoizedHelpers`. Restaram 2 ocorrências, ambas nesse helper.

### `professors_pagination_spec.rb` — dependência de sequence

Encontrado ao rodar a suíte em ordem aleatória. O spec fazia `Professor.order(:name).last`, e os nomes vêm de uma sequence global da factory (`"Professor #{n}"`), cujo valor depende de quantos professores os exemplos anteriores criaram. O spec passa a criar explicitamente um professor com nome que ordena por último.

## Varredura do padrão frágil

Arquivos que chamam `Calendar.current_semester`/`current_year`, por número de ocorrências:

| Arquivo | Ocorrências |
|---|---:|
| `spec/models/orientations/orientation_academic_activities_spec.rb` | 12 → **2** |
| `spec/models/orientations/orientation_current_calendar_spec.rb` | 8 |
| `spec/factories/calendars.rb` | 7 |
| `spec/services/populate/calendars_spec.rb` | 4 |
| `spec/services/calendars/list_query_spec.rb` | 4 |
| `spec/features/professors/requests/requests_create_spec.rb` | 4 |
| 7 arquivos com 2 ocorrências cada | 14 |

Corrigido o pior caso. Os demais não estavam no caminho da falha e ficam registrados — vários são legítimos (a factory precisa consultar o período; o spec de `Populate::Calendars` testa justamente isso).

## Validação

Cada spec afetado passa nos três modos exigidos:

| Modo | `activities_index_spec` | `orientation_academic_activities_spec` |
|---|---|---|
| Isolado | 5 exemplos, 0 falhas | 6 exemplos, 0 falhas |
| Por diretório | 20 exemplos, 0 falhas | 128 exemplos, 0 falhas |
| Suíte completa | 1177 exemplos, 0 falhas, 1 pendente | idem |

RuboCop: **818 arquivos, 0 offenses**. Cobertura: 96,55%.

## O que esta task NÃO resolveu

Como verificação extra, rodei a suíte com `--order random`. **Ela não passa.** Com a seed 6155 falham dois specs, por causas diferentes das tratadas aqui:

- `spec/features/external_members/examination_board_files/examination_board_files_create_spec.rb:38`;
- `spec/features/responsible/professors/professors_pagination_spec.rb`, que continua falhando mesmo depois da correção de sequence — a causa restante não foi diagnosticada.

Confirmei que a falha em ordem aleatória **é preexistente**: rodando a mesma seed contra o estado anterior às minhas alterações, ela aparece igual.

Os critérios de aceite desta task são isolado, por diretório e suíte completa em **ordem definida**, que é o padrão do projeto — e esses estão cumpridos. Tornar a suíte segura em ordem aleatória é um trabalho próprio, de tamanho diferente, e fica registrado como tal.

## Limites preservados

- `CurrentCalendar` e a semântica de `current_semester`/`current_year` não foram tocados.
- Nenhuma ordem de execução foi fixada para esconder dependência.
- Nenhum `sleep` adicionado.
- Nenhuma alteração em código de produção.
- Nenhum commit, push ou branch criado.
