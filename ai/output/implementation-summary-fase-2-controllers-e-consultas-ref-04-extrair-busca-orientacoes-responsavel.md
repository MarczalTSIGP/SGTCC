# Implementation Summary

## General Summary

Foi extraída a composição das listagens históricas de orientações do responsável para `Orientations::ResponsibleListQuery`.

As actions `Responsible::OrientationsController#tcc_one` e `#tcc_two` deixaram de montar joins, filtros, busca, ordenação e paginação diretamente. Agora elas preservam apenas a coordenação HTTP da tela: breadcrumb, chamada ao objeto de consulta, definição de `@search_url` e renderização de `:index`.

A nova consulta mantém a separação de domínio exigida: TCC I retorna apenas orientações com calendários exclusivamente de TCC I, enquanto TCC II retorna orientações com ao menos um calendário de TCC II, inclusive orientações migradas de TCC I para TCC II.

## Changed Files

### app/controllers/responsible/orientations_controller.rb

- As actions `tcc_one` e `tcc_two` passaram a chamar `Orientations::ResponsibleListQuery.call` com `tcc`, `page`, `term` e `status`.
- A composição manual da query foi removida do controller.
- Foram removidos comentários temporários, chamadas antigas comentadas e desativações locais de RuboCop relacionadas a essas duas actions.
- A alteração foi necessária para reduzir a responsabilidade do controller e concentrar a regra de listagem em um objeto isolado.
- Breadcrumbs, `@search_url` e `render :index` foram preservados.

### app/services/orientations/responsible_list_query.rb

- Foi criado o objeto de consulta `Orientations::ResponsibleListQuery`.
- A classe expõe um único ponto público: `.call(tcc:, page:, term:, status: nil)`.
- A consulta valida explicitamente os valores aceitos de TCC (`:one` e `:two`).
- Para TCC I, usa `joins`, `group` e `having` para garantir orientações com calendários exclusivamente de TCC I.
- Para TCC II, busca orientações com calendário de TCC II e aplica `distinct` para evitar duplicatas por joins.
- Aplica status opcional, busca textual, ordenação por `orientations.created_at DESC` e paginação.
- A alteração foi necessária para preservar o comportamento ativo fora do controller sem depender de `params`, rotas, helpers ou renderização.

### spec/services/orientations/

- Foram adicionados specs unitários para o novo objeto de consulta.
- A cobertura esperada inclui exclusividade de TCC I, inclusão de orientação migrada em TCC II, orientação criada diretamente em TCC II, ausência de registros sem calendário da etapa consultada, filtro por status, busca textual, ordenação e paginação.
- Esses testes são necessários para caracterizar a semântica da consulta fora de specs de interface.

### ai/output/fase-2-controllers-e-consultas/

- Foi criado o diretório de saída do relatório da REF-04.
- O relatório final esperado deve documentar a extração, os arquivos alterados, comportamento preservado, validação, métricas e próximos passos.

## Review Notes

- Revisar os specs do novo objeto de consulta, especialmente o caso da orientação migrada de TCC I para TCC II.
- Confirmar se `OrientationFilter.by_tcc_one` e `OrientationFilter.by_tcc_two` foram removidos apenas após busca final por consumidores ativos.
- Executar os specs focados e RuboCop indicados na task para confirmar que não houve regressão.
- Verificar que `Orientation.tcc_one`, `Orientation.tcc_two` e os fluxos de calendário atual permaneceram inalterados.