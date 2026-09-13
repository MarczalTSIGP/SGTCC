# Task

REF-13B — Eliminar as comparações de status de orientação feitas contra strings traduzidas, usando a API de status que já existe no domínio.

# Dependência

- REF-06 (reorganização de `Orientation`), que introduziu `equal_status?` e os predicados de status.
- Deve ser concluída **antes da REF-14**.

# Contexto

Este é o **risco nº 1 do inventário da REF-01** ("maior risco técnico do inventário"), atribuído à REF-06 e **não resolvido** até aqui — a validação da REF-13 confirmou que os quatro pontos continuam no código.

O `enum :status` de `OrientationStatus` monta as **chaves** a partir de `I18n.t` no carregamento da classe:

```ruby
enum :status, {
  "#{I18n.t('enums.orientation.status.APPROVED_TCC_ONE')}": 'APPROVED_TCC_ONE',
  ...
}, prefix: :status
```

Ou seja, `orientation.status` devolve a string **traduzida** ("em andamento", "aprovada", "Aprovada em TCC 1"), não o valor persistido. Comparar esse retorno com literais em português acopla regra de negócio ao locale ativo no momento em que a classe foi carregada: se o locale mudar, as comparações passam a falhar **silenciosamente**, sem erro e sem teste vermelho.

O concern já expõe a API correta: `equal_status?(status_enum)` e os predicados `approved?`, `canceled?` etc., que traduzem o valor persistido antes de comparar.

# Objetivo

Trocar as comparações literais pela API de status, preservando exatamente o comportamento atual em `pt-BR`.

# Escopo obrigatório

Migrar os quatro pontos abaixo — são os únicos encontrados por `grep` em `app/`:

| Arquivo | Trecho atual |
|---|---|
| `app/models/orientation.rb:206-215` | `case status` com `when 'aprovada'`, `when 'Aprovada em TCC 1'`, `when 'em andamento'` em `#orientation_type` |
| `app/services/dashboard/responsible_report.rb:79` | `orientations.count { \|o\| o.status.eql?('em andamento') }` |
| `app/services/dashboard/professor_report.rb:28` | `orientations.count { \|o\| o.status.eql?('em andamento') }` |
| `app/components/orientations/status_badge_component.rb:18` | `return 'text-dark' if @status == 'em andamento'` |

Regras:

- Usar `equal_status?`/predicados do concern; onde o objeto disponível não for uma `Orientation` (caso do component, que recebe a string de status), resolver a comparação a partir de `Orientation.statuses`, nunca do literal traduzido.
- `#orientation_type` deve continuar devolvendo `:approved`, `:tcc_one`, `:in_tcc_one` e `:unknown` nas mesmas condições, incluindo as verificações de `final_monograph`, `final_project` e `final_proposal`.
- Se algum predicado necessário não existir no concern (ex.: "aprovada em TCC 1"), adicioná-lo ao concern em vez de espalhar `equal_status?` com literal do valor persistido pelas camadas externas.
- Adicionar ou ajustar cobertura que **falhe** se a comparação voltar a depender do locale — por exemplo, exercitar os quatro pontos com o locale trocado dentro do exemplo.

# Fora do escopo

- Não alterar a montagem do `enum :status` nem trocar as chaves traduzidas por símbolos — isso mudaria o valor de `orientation.status` em toda a aplicação (views, filtros, buscas, relatórios) e é uma refatoração maior, de task própria.
- Não mexer no mapeamento de classes CSS de badge (escopo da REF-13C).
- Não alterar traduções.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- Nenhum literal de status traduzido resta em `app/` (`grep` por `'em andamento'`, `'aprovada'`, `'Aprovada em TCC 1'` retorna vazio em código Ruby).
- `#orientation_type`, os dois relatórios de dashboard e o badge produzem exatamente os mesmos resultados de antes em `pt-BR`.
- Existe teste que quebra se a comparação voltar a depender do locale.
- Suíte completa e RuboCop sem novas falhas ou offenses.

# Validação sugerida

```bash
grep -rn "em andamento\|'aprovada'\|Aprovada em TCC 1" app/

docker compose exec -T tests bundle exec rspec \
  spec/models/orientations spec/services/dashboard spec/components \
  spec/features/responsible/dashboard spec/features/professors/dashboard
docker compose exec -T tests bundle exec rspec
docker compose exec -T tests bundle exec rubocop --parallel
```
