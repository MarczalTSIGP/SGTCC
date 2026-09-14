# Task

REF-19 — Eliminar o N+1 de `Orientation.approved` e `Orientation.approved_tcc_one`, que carregam todos os registros do status e filtram em Ruby.

# Dependência

- REF-17, que registrou o achado sem corrigi-lo.

# Contexto

```ruby
def self.approved
  by_status('APPROVED').reject { |o| o.final_monograph.nil? }
end

def self.approved_tcc_one
  by_status('APPROVED_TCC_ONE').reject { |o| o.final_project.nil? }
end
```

`by_status` devolve uma relation com `includes` de sete associações e `order('examination_boards.date DESC')`. O `reject` força o carregamento de **todos** os registros daquele status e, para cada um, chama `final_monograph`/`final_project`, que dispara `Orientations::AcademicActivityFinder` — uma consulta por registro, mais o `calendars.pluck(:id)` de cada orientação.

Custo por chamada: 1 consulta da relation + N consultas de atividade + N consultas de calendário. Cresce linearmente com o número de orientações aprovadas, que só aumenta a cada semestre.

## Onde isso é servido

| Consumidor | Uso |
|---|---|
| `SiteController` | páginas públicas de orientações aprovadas, aprovadas em TCC 1 e em andamento |
| `Api::V1::OrientationsController` | os mesmos três recortes, via API |
| `Dashboard::ProfessorsRankingReport` | `Orientation.approved.group_by(&:advisor_id)` |

São caminhos públicos, sem autenticação no caso do site — o pior lugar possível para uma consulta que cresce com a base.

# Objetivo

Obter os mesmos registros, na mesma ordem, sem carregar e descartar em Ruby.

# Escopo obrigatório

- Substituir o `reject` por filtro no banco: a condição real é "existe uma atividade acadêmica do identificador correspondente, com `final_version: true`, em um dos calendários da orientação".
- Reaproveitar a definição de "atividade final" já centralizada em `Orientations::AcademicActivityFinder` (REF-17) em vez de reescrever a regra. Se for necessário expor uma forma relacional dela, fazê-lo no próprio finder ou em um query object irmão, não espalhando `joins` pelos consumidores.
- Preservar **exatamente**:
  - o conjunto de registros devolvido, incluindo orientações sem banca (hoje presentes, porque `includes` não filtra);
  - a ordenação `examination_boards.date DESC`, e o comportamento atual para orientações com mais de uma banca;
  - o tipo devolvido aos consumidores. Hoje `approved` e `approved_tcc_one` devolvem **Array** (efeito do `reject`) e `in_tcc_one` devolve **relation**. Se a correção passar a devolver relation nos três, verificar cada consumidor — `group_by`, serializers e views podem depender de método de Array.
- `in_tcc_one` não tem `reject` e não sofre do problema; só entra na task se a solução unificar os três.

## Medição obrigatória

Esta task só se justifica se o ganho for demonstrado:

- registrar, **antes e depois**, o número de consultas disparadas por `Orientation.approved` e por `Orientation.approved_tcc_one` com uma massa de dados representativa (por exemplo 50 orientações aprovadas), usando `ActiveSupport::Notifications` ou log de SQL;
- registrar a contagem de registros devolvida antes e depois, que deve ser idêntica.

# Fora do escopo

- Não alterar `by_status` para outros usos além dos necessários.
- Não mudar as rotas, os serializers nem o HTML das páginas públicas.
- Não introduzir cache.
- Não paginar as listagens públicas — seria mudança funcional.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- `Orientation.approved` e `Orientation.approved_tcc_one` não carregam registros para descartá-los em Ruby.
- O número de consultas deixou de crescer com a quantidade de orientações; há medição antes/depois no relatório.
- O conjunto e a ordem dos registros são os mesmos de antes, comprovados por spec.
- Os três consumidores (site, API e ranking de professores) continuam funcionando, com seus feature specs e specs de controller passando.
- Suíte completa e RuboCop sem novas falhas ou offenses.

# Validação sugerida

```bash
docker compose exec -T tests bundle exec rspec \
  spec/models/orientations spec/services/dashboard/professors_ranking_report_spec.rb \
  spec/controllers/api spec/features/site
docker compose exec -T tests bundle exec rspec
docker compose exec -T tests bundle exec rubocop --parallel
```
