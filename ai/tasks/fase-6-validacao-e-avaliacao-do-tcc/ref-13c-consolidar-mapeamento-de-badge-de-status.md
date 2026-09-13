# Task

REF-13C — Consolidar o mapeamento de badge de status de orientação duplicado entre dois components.

# Dependência

- REF-13B (desacoplamento do locale), para não misturar a correção de risco com a deduplicação.

# Contexto

A REF-11 inventariou duplicação em **partials**, então não enxergou repetição dentro de `app/components`. A validação da REF-13 encontrou o mesmo mapeamento de status para classe CSS declarado duas vezes, literalmente idêntico:

- `app/components/orientations/status_badge_component.rb` — `status_badge_class` + `status_mappings`;
- `app/components/orientations/table_component.rb:83-93` — `status_badge_class` + `status_mappings`.

As seis entradas (`APPROVED_TCC_ONE`, `APPROVED`, `IN_PROGRESS`, `CANCELED`, `REPROVED_TCC_ONE`, `REPROVED`) e o `fetch(..., 'badge-secondary')` são iguais nos dois. Uma classe CSS nova ou renomeada hoje precisa ser alterada em dois lugares, sem nada que force a consistência.

# Objetivo

Ter uma única fonte do mapeamento status → classe de badge, consumida pelos dois components, sem mudar o HTML gerado.

# Escopo obrigatório

- Extrair o mapeamento e a resolução da classe para um único ponto (por exemplo, um component base, um módulo compartilhado em `app/components/concerns` ou um objeto de apresentação — seguir o padrão que o projeto já usa para components).
- Os dois components passam a consumir essa fonte única.
- Preservar o fallback `badge-secondary` para status não mapeado.
- Preservar exatamente o HTML de cada consumidor: `Orientations::StatusBadgeComponent` monta `badge badge-pill <classe> <cor de texto>` com label visível; `Orientations::TableComponent` monta um `span` com `&nbsp;`, `data-controller="ui--tooltip"` e `title`. **Não** unificar os dois components entre si — eles renderizam coisas diferentes.
- Cobrir a fonte única com spec próprio, incluindo o caso de fallback.

# Fora do escopo

- Não alterar classes CSS, folhas de estilo nem o visual.
- Não unificar `Orientations::StatusBadgeComponent` com `Orientations::TableComponent`.
- Não mexer no mapeamento equivalente de outros domínios (`Documents::StatusBadgeComponent`) sem evidência de duplicação real.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- O mapeamento das seis entradas aparece **uma única vez** em `app/`.
- Os dois components renderizam o mesmo HTML de antes, verificado por spec.
- Há spec da fonte única cobrindo os seis status e o fallback.
- Suíte completa e RuboCop sem novas falhas ou offenses.

# Validação sugerida

```bash
grep -rn "badge-approved-tcc-1" app/

docker compose exec -T tests bundle exec rspec spec/components spec/features/responsible/orientations spec/features/professors/orientations
docker compose exec -T tests bundle exec rspec
docker compose exec -T tests bundle exec rubocop --parallel
```
