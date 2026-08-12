# Baseline de Qualidade do SGTCC — REF-00

## Resumo

**Data da coleta:** 2026-08-11  
**Ruby:** 3.4.7  
**Rails:** 8.1.3  

O SGTCC apresenta um estado misto: o código de produção está em conformidade total com o RuboCop (0 offenses) e sem alertas de segurança (Brakeman), mas acumula 690 code smells via Reek — predominantemente `IrresponsibleModule` (224) e `InstanceVariableAssumption` (136), típicos de classes grandes sem documentação. A análise de complexidade (Flog) indica acúmulo de responsabilidade nos models centrais (`ExaminationBoard`, `Orientation`). A duplicação (Flay) registra 119 blocos com código similar em views e controllers. O RubyCritic atribui nota **85.91/100**. Os testes RSpec não puderam ser executados neste ambiente por ausência do usuário PostgreSQL `nico`; a cobertura SimpleCov também não está coletável pois sua configuração está comentada em `spec/support/simplecov.rb`.

---

## Comandos e Versões

| Ferramenta   | Versão   | Comando de coleta                                          | Data       |
|--------------|----------|------------------------------------------------------------|------------|
| RuboCop      | 1.88.1   | `bundle exec rubocop --format json`                        | 2026-08-11 |
| Reek         | 6.5.0    | `bundle exec reek app/ 2>&1 \| tail -n 60`                | 2026-08-11 |
| Brakeman     | 8.0.5    | `bundle exec brakeman -q 2>&1 \| tail -n 40`              | 2026-08-11 |
| Flog         | 4.9.4    | `bundle exec flog app/ 2>&1 \| head -35`                  | 2026-08-11 |
| Flay         | 2.14.4   | `bundle exec flay app/ 2>&1 \| head -15`                  | 2026-08-11 |
| RubyCritic   | 5.0.0    | `bundle exec rubycritic app --no-browser -f console`       | 2026-08-11 |
| RSpec        | 3.13     | `bundle exec rspec 2>&1 \| tail -n 40`                    | 2026-08-11 |
| SimpleCov    | 0.22.0   | via RSpec (não coletável — config comentada)              | 2026-08-11 |

---

## Resultados

### RSpec

**Status: não executável neste ambiente.**

```
0 examples, 0 failures, 347 errors occurred outside of examples
Finished in 0.00004 seconds (files took 44.25 seconds to load)
```

**Causa:** todos os 347 arquivos de spec falharam ao carregar com `PG::ConnectionBad: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: FATAL: role "nico" does not exist`. O banco PostgreSQL de teste não está configurado no ambiente onde a coleta foi realizada.

| Métrica          | Valor               |
|------------------|---------------------|
| Exemplos         | 0 (não executáveis) |
| Falhas           | 0                   |
| Erros de carrega | 347                 |
| Arquivos de spec | 222 (`.rb` em spec/)|

---

### SimpleCov (cobertura)

**Status: não coletável.**

O arquivo `spec/support/simplecov.rb` tem todo o bloco de configuração do SimpleCov comentado. Por isso, nenhuma cobertura é gerada durante a execução do RSpec. Não existe `coverage/.last_run.json`.

| Métrica         | Valor       |
|-----------------|-------------|
| Cobertura total | N/A         |
| Motivo          | Config comentada em `spec/support/simplecov.rb` |

---

### RuboCop

**Status: 0 offenses — código em conformidade total.**

```
Total files inspected: 782
Total offenses: 0
```

O projeto mantém configuração rigorosa em `.rubocop.yml` (230 linhas), com `TargetRubyVersion: 3.4`, plugins rubocop-rails, rubocop-rspec, rubocop-rspec_rails, rubocop-capybara, rubocop-factory_bot. Vários cops estão desabilitados intencionalmente (`Metrics/ClassLength`, `Layout/IndentationStyle`, `Rails/ApplicationController` etc.) e algumas classes longas possuem exclusões pontuais (`Metrics/MethodLength`, `Metrics/AbcSize`).

| Métrica               | Valor |
|-----------------------|-------|
| Arquivos inspecionados| 782   |
| Total de offenses     | **0** |
| Cops desabilitados    | ~8 explícitos + exclusões pontuais |

---

### Reek

**Status: 690 warnings em 222 arquivos.**

```
690 total warnings
```

#### Smells por tipo

| Tipo de smell               | Ocorrências |
|-----------------------------|-------------|
| IrresponsibleModule         | 224         |
| InstanceVariableAssumption  | 136         |
| DuplicateMethodCall         | 77          |
| UtilityFunction             | 65          |
| TooManyStatements           | 41          |
| TooManyInstanceVariables    | 31          |
| FeatureEnvy                 | 30          |
| UncommunicativeVariableName | 17          |
| NilCheck                    | 14          |
| ControlParameter            | 10          |
| TooManyMethods              | 9           |
| LongParameterList           | 5           |
| DataClump                   | 3           |
| **Total**                   | **662***    |

*\*28 smells adicionais são warnings compostos (ex.: DuplicateCode referenciando múltiplos arquivos).*

#### Arquivos com mais smells (destaque)

| Arquivo                                          | Warnings |
|--------------------------------------------------|----------|
| `app/services/populate/orientations.rb`          | 28       |
| `app/services/populate/base_activities.rb`       | 11       |
| `app/controllers/responsible/examination_boards_controller.rb` | vários (TooManyMethods ≥24, TooManyInstanceVariables ≥11) |
| `app/controllers/responsible/orientations_controller.rb`       | vários (TooManyMethods ≥19, TooManyInstanceVariables ≥9) |

O smell mais frequente (`IrresponsibleModule`, 224) é ausência de comentário de classe — pode ser tratado como ruído em refatoração estrutural real. Os smells de domínio relevantes são `InstanceVariableAssumption`, `TooManyMethods`, `TooManyInstanceVariables` e `FeatureEnvy`, que indicam acúmulo de responsabilidades.

---

### Brakeman

**Status: 0 alertas de segurança.**

```
Controllers: 69
Models: 36
Templates: 401
Errors: 0
Security Warnings: 0
```

Há 2 entradas obsoletas no arquivo de ignore do Brakeman, mas nenhum alerta de segurança ativo.

| Métrica              | Valor |
|----------------------|-------|
| Security Warnings    | **0** |
| Erros de scan        | 0     |
| Controllers analisados | 69  |
| Models analisados    | 36    |
| Templates analisados | 401   |

---

### Flog (complexidade)

**Status: 8226.8 pontos totais, média de 5.8 por método.**

```
8226.8: flog total
   5.8: flog/method average
```

Flog mede complexidade ciclomática estendida. Quanto maior, mais complexo o método.

#### Top métodos por complexidade

| Método / Localização                                              | Score  |
|-------------------------------------------------------------------|--------|
| `ExaminationBoard#none` (body do model)                          | 115.0  |
| `Orientation#none` (body do model)                               | 99.9   |
| `Professor#none`                                                  | 41.4   |
| `ExaminationBoardNote#none`                                       | 37.7   |
| `Populate::BaseActivities#create_base_activities_for_tcc_one`    | 37.5   |
| `Document#none`                                                   | 32.6   |
| `Responsible::OrientationsController#tcc_one`                    | 26.2   |
| `Responsible::OrientationsController#tcc_two`                    | 25.0   |
| `Dashboard::ProfessorReport#orientations_by_tcc_one`             | 24.3   |
| `Dashboard::ResponsibleReport#orientations_by_tcc_one`           | 22.4   |

Os valores `#none` representam o body do arquivo fora de métodos explícitos (enums, scopes, validações inline). `ExaminationBoard` e `Orientation` são os models mais complexos.

| Métrica           | Valor   |
|-------------------|---------|
| Flog total        | 8226.8  |
| Flog/method avg   | 5.8     |
| Maior score único | 115.0 (`ExaminationBoard`) |

---

### Flay (duplicação)

**Status: 9098 pontos de duplicação, 119 blocos com código similar.**

```
Total score (lower is better) = 9098
```

Os blocos com maior massa de duplicação identificados:

| Ranking | Tipo        | Massa | Arquivos                                                                 |
|---------|-------------|-------|--------------------------------------------------------------------------|
| 1       | Bloco `:block` | 264 | `external_members/examination_boards/_appointment_file_form.html.erb`, `professors/examination_boards/_appointment_file_form.html.erb` |
| 2 (idêntico) | `:iter` | 225 | `academics/documents/sign_form.html.erb`, `external_members/documents/sign_form.html.erb`, `professors/documents/sign_form.html.erb` |
| 3       | `:iter`     | 216   | `academics/calendars/index.html.erb`, `academics/orientations/documents.html.erb`, `academics/tep_requests/index.html.erb` |

A duplicação concentra-se principalmente em **views** (`_appointment_file_form`, `sign_form`, listas de calendários, paginação) e **controllers** (ações similares em namespaces diferentes).

| Métrica            | Valor  |
|--------------------|--------|
| Score total        | 9098   |
| Blocos similares   | 119    |
| Bloco mais pesado  | 264 (identical views de appointment_file_form) |

---

### RubyCritic

**Status: nota 85.91 / 100.**

```
Score: 85.91
```

RubyCritic combina Flog, Flay e Reek com frequência de mudança (churn) para atribuir uma nota por arquivo (A-F) e uma nota global.

#### Arquivos com rating F (piores)

| Arquivo                                                          | Churn | Complexity | Smells |
|------------------------------------------------------------------|-------|------------|--------|
| `app/controllers/responsible/orientations_controller.rb`         | 66    | 167.1      | 19     |
| `app/controllers/responsible/examination_boards_controller.rb`   | alto  | alto       | vários |

#### Contexto

A nota 85.91 indica que o projeto está em estado intermediário — acima da média de projetos Rails legados, mas com hotspots claros de alta complexidade + alto churn que devem ser priorizados na refatoração.

| Métrica         | Valor  |
|-----------------|--------|
| Score global    | **85.91** |
| Escala          | 0–100 (maior = melhor) |
| Rating mínimo encontrado | F (em orientations_controller e examination_boards_controller) |

---

## Ferramentas adicionadas

As gems `rubycritic`, `flog` e `flay` não estavam presentes no `Gemfile`. Foram adicionadas ao grupo `:development` para tornar a coleta reproduzível:

```ruby
gem 'rubycritic', require: false
gem 'flog', require: false
gem 'flay', require: false
```

`bundle install` rodou sem erros — 252 gems instaladas (68 dependências diretas).

Versões instaladas: `rubycritic 5.0.0`, `flog 4.9.4`, `flay 2.14.4`.

O `.gitignore` foi atualizado para ignorar o relatório HTML do RubyCritic (`/tmp/rubycritic`), que é gerado por padrão mas não deve ser versionado.

---

## Limitações e falhas na coleta

| Ferramenta | Problema | Causa |
|------------|----------|-------|
| RSpec | Não executável | Banco PostgreSQL de teste indisponível — role `nico` não existe no servidor local (`/var/run/postgresql/.s.PGSQL.5432`) |
| SimpleCov  | Não coletável | Toda a configuração está comentada em `spec/support/simplecov.rb`; precisa ser descomentada para ativar |
| RuboCop `--format offenses` | Retorna vazio | O formato `offenses` com 0 violations produz output `0 Total in 0 files`; foi necessário usar `--format json` + script Python para confirmar |

Para reproduzir a coleta em ambiente com banco disponível:

```bash
# Clonar e configurar banco de teste
rails db:test:prepare

# RSpec com cobertura (requer descomentar spec/support/simplecov.rb)
bundle exec rspec 2>&1 | tail -n 40

# RuboCop
bundle exec rubocop --format json 2>&1 | python3 -c "import json,sys; d=json.load(sys.stdin); print('Offenses:', d['summary']['offense_count'])"

# Reek
bundle exec reek app/ 2>&1 | tail -n 10

# Brakeman
bundle exec brakeman -q 2>&1 | tail -n 40

# Flog
bundle exec flog app/ 2>&1 | head -15

# Flay
bundle exec flay app/ 2>&1 | head -5

# RubyCritic
bundle exec rubycritic app --no-browser -f console 2>&1 | grep 'Score:'
```

---

## Próximos passos

Este baseline está pronto para ser referenciado pelas tasks seguintes do roadmap:

- **REF-01** (inventário técnico): use os dados de Flog, Flay e Reek para identificar os arquivos prioritários de refatoração.
- **REF-14** (comparação as-is/to-be): compare os valores desta tabela com os coletados após a conclusão das fases 1–6 do roadmap.

### Tabela resumo consolidada

| Dimensão          | Ferramenta   | Resultado atual         | Meta referencial         |
|-------------------|--------------|-------------------------|--------------------------|
| Testes            | RSpec        | N/A (DB indisponível)  | Todos passando           |
| Cobertura         | SimpleCov    | N/A (config comentada) | ≥ 90%                    |
| Estilo            | RuboCop      | **0 offenses**          | 0 offenses (manter)      |
| Code smells       | Reek         | **690 warnings**        | Redução significativa     |
| Segurança         | Brakeman     | **0 warnings**          | 0 warnings (manter)      |
| Complexidade      | Flog total   | **8226.8**              | Redução nos hotspots      |
| Duplicação        | Flay score   | **9098**                | Redução nos blocos maiores|
| Nota geral        | RubyCritic   | **85.91 / 100**         | ≥ 90                     |
