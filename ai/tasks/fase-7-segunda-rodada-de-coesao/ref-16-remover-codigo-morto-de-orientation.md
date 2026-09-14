# Task

REF-16 — Remover de `Orientation` os métodos de classe sem nenhum consumidor e resolver o comentário de correção temporária que não corresponde ao código.

# Dependência

- REF-14, que encontrou os achados durante a coleta.

**Consequência:** altera código de produção e invalida a coleta to-be da REF-14; a recoleta é a REF-18.

# Contexto

A varredura da REF-14 encontrou quatro métodos de classe de `Orientation` sem **nenhuma** referência em `app/`, `spec/`, `lib/` ou views — nem sequer um spec que os exercite:

| Método | Linhas | Consumidores |
|---|---|---:|
| `Orientation.last_tcc_one_calendars` | 147-151 | 0 |
| `Orientation.count_orientations_in_last_tcc_one_calendar` | 153-156 | 0 |
| `Orientation.reproved` | 249-251 | 0 |
| `Orientation.reproved_tcc_one` | 253-255 | 0 |

Cuidado ao conferir: `reproved?` e `reproved_tcc_one?` — os **predicados** de `OrientationStatus` — são usados e **não** fazem parte desta remoção. O que está morto são os métodos de classe homônimos sem interrogação.

Além disso, o model carrega este comentário (linha 51):

```ruby
# 🚨 CORREÇÃO TEMPORÁRIA PARA MIGRAÇÃO: Troca after_create_commit por after_create
after_create_commit { Orientations::TcoTcaiService.create(self) }
```

O comentário anuncia uma troca que **não está feita**: a linha seguinte continua usando `after_create_commit`. Ou a correção foi revertida e o comentário ficou, ou nunca foi aplicada. Do jeito que está, ele descreve o código errado.

# Objetivo

Remover o que não tem consumidor e deixar o comentário consistente com o que o código faz.

# Escopo obrigatório

## Métodos mortos

- Reconfirmar por `grep`, um a um, que nenhum dos quatro tem consumidor — incluindo chamadas em relation (`@professor.orientations.reproved`), views e serializers.
- Remover os quatro.
- `by_status` é `private_class_method` e continua sendo usado por `approved`, `approved_tcc_one` e `in_tcc_one`, que **permanecem**. Não removê-lo.

## Comentário de correção temporária

- Descobrir, pelo histórico do arquivo, se a troca `after_create_commit` → `after_create` chegou a ser aplicada e revertida.
- Se o `after_create_commit` atual é o comportamento correto, remover o comentário enganoso.
- Se havia motivo real para `after_create`, **não** mudar o callback nesta task: registrar o achado com o contexto encontrado no histórico e deixar a decisão para uma task funcional própria. Callback de criação de documento é área sensível.

# Fora do escopo

- Não remover `approved`, `approved_tcc_one`, `in_tcc_one` nem `by_status`.
- Não alterar o callback `after_create_commit` nem `after_update`.
- Não tocar nos predicados de status.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- Os quatro métodos não existem mais e `grep` não encontra nenhuma referência remanescente.
- `approved`, `approved_tcc_one`, `in_tcc_one` e `by_status` continuam funcionando, com seus consumidores atuais (site, API e `Dashboard::ProfessorsRankingReport`) intactos.
- O comentário da linha 51 ou descreve o código corretamente, ou não existe mais.
- Se o callback ficou como está, existe registro de por quê.
- Suíte completa e RuboCop sem novas falhas ou offenses.

# Validação sugerida

```bash
grep -rn "last_tcc_one_calendars\|count_orientations_in_last_tcc_one_calendar" app/ spec/ lib/
grep -rnE "\.(reproved|reproved_tcc_one)\b[^?]" app/ spec/ lib/

git log -p --follow app/models/orientation.rb | grep -n "after_create" | head

docker compose exec -T tests bundle exec rspec spec/models/orientations spec/services/dashboard spec/controllers/api
docker compose exec -T tests bundle exec rspec
docker compose exec -T tests bundle exec rubocop --parallel
```
