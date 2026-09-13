# REF-13C — Resumo de implementação

## Resumo

O mapeamento status → classe CSS de badge, antes declarado duas vezes, passou a existir em um único lugar. O HTML gerado pelos dois components é idêntico ao anterior.

## Alterações

### `Orientations::StatusBadge` (novo)

`app/components/orientations/status_badge.rb` — módulo com:

- `MAPPINGS`, congelado, com as seis entradas do enum;
- `DEFAULT_CLASS` (`badge-secondary`), o fallback que os dois components já aplicavam;
- `key_for(status)`, que traduz o rótulo exibido para o valor persistido;
- `class_for(status_key)`, que resolve a classe com fallback.

### Consumidores

- `Orientations::StatusBadgeComponent`: `status_key` e `status_badge_class` passaram a delegar ao módulo; `status_mappings` removido.
- `Orientations::TableComponent`: `badge_for_status` passou a delegar; `status_badge_class` e `status_mappings` removidos.

Os dois components **não** foram unificados: um renderiza badge com label visível e classe de cor de texto, o outro um `span` com `&nbsp;`, `data-controller="ui--tooltip"` e `title`.

## Cobertura

`spec/components/orientations/status_badge_spec.rb`:

- as seis entradas do mapeamento, uma por exemplo;
- fallback para status não mapeado e para `nil`;
- `key_for` com status válido e com status inexistente;
- um exemplo que compara as chaves de `MAPPINGS` com `Orientation.statuses.values` — falha se um status novo entrar no enum sem entrar no mapeamento.

## Validação

- `spec/components`: **14 exemplos, 0 falhas**.
- Suíte completa: **1137 exemplos, 0 falhas, 1 pendente** (+11 exemplos novos).
- RuboCop: **813 arquivos, 0 offenses**.
- `grep` por `badge-approved-tcc-1` em `app/`: uma ocorrência em código Ruby (o módulo), mais o CSS e a legenda em view, que são apresentação e não mapeamento.

## Preservado

Classes CSS, folhas de estilo e o visual não mudaram. `Documents::StatusBadgeComponent` não foi tocado — é outro domínio e não há evidência de duplicação com estes.
