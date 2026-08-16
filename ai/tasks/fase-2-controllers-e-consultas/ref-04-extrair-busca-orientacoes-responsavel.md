# Task

REF-04 — Extrair a busca de orientações do responsável para um objeto de consulta, preservando a separação entre TCC I exclusivo e TCC II.

# Contexto

As actions `Responsible::OrientationsController#tcc_one` e `#tcc_two` ainda concentram composição de consulta, filtro por status, busca textual, ordenação e paginação. Além de aumentar a complexidade do controller, essa lógica está protegida por desativações locais do RuboCop e comentários que registram a solução como temporária.

A REF-01 (`ai/output/fase-0-baseline/inventario-ref-01.md`) confirmou que existe uma tentativa anterior de extração em `OrientationFilter.by_tcc_one` e `OrientationFilter.by_tcc_two`, referenciada por chamadas comentadas no controller. Essa implementação não reproduz integralmente o comportamento ativo:

- a listagem de TCC I usa `GROUP BY` e `HAVING` para retornar somente orientações cujos calendários pertencem exclusivamente ao TCC I;
- o scope `Orientation.tcc_one` retorna orientações que possuem algum calendário de TCC I, inclusive aquelas que já avançaram para TCC II;
- a listagem de TCC II retorna orientações que possuem calendário de TCC II, incluindo as que vieram do TCC I.

A REF-02 já substituiu os valores mágicos dessas consultas pela API do enum. Esta task deve partir da consulta atualmente ativa, e não da extração antiga.

Há uma ressalva de escopo: os scopes `Orientation.tcc_one` e `Orientation.tcc_two` ainda possuem consumidores ativos fora dessas duas listagens, como controllers de professores, relatórios de dashboard e specs de model. Eles não devem ser removidos nesta task. A remoção ou redefinição desses scopes pertence à reorganização de `Orientation` na REF-06 e à revisão dos relatórios/services na REF-08. Apenas os métodos de fachada `OrientationFilter.by_tcc_one` e `OrientationFilter.by_tcc_two`, substituídos pelo novo objeto e sem consumidor ativo após a mudança, fazem parte da limpeza desta task.

# Dependências

- REF-02 — Padronizar o enum `tcc`.

# Objetivo

Criar um objeto de consulta dedicado às listagens históricas de orientações do responsável, com uma interface explícita para:

- etapa de TCC (`:one` ou `:two`);
- página;
- termo de busca;
- status opcional.

O objeto deve retornar uma `ActiveRecord::Relation` paginada e ordenada, sem conhecer `params`, rotas, breadcrumbs, renderização ou qualquer outro detalhe HTTP.

Ao final, as actions devem apenas configurar a apresentação, chamar o objeto de consulta e renderizar a view existente.

# Instrução crítica

Preserve exatamente a diferença de domínio entre as duas listagens:

- TCC I contém somente orientações que possuem calendários de TCC I e ainda não possuem calendário de TCC II;
- TCC II contém toda orientação que possui ao menos um calendário de TCC II, mesmo que também possua calendários de TCC I.

Não implemente TCC I como um simples `where(calendars: { tcc: :one })`. Isso incluiria orientações que já avançaram para TCC II e alteraria o comportamento observado.

Não reutilize `OrientationFilter.by_tcc_one` ou `Orientation.tcc_one` como base da nova consulta de TCC I. A implementação nova deve reproduzir a semântica do `HAVING` ativo e possuir teste isolado para a orientação migrada.

# Interface esperada

Adote uma única classe no namespace de orientações, por exemplo:

```ruby
Orientations::ResponsibleListQuery.call(
  tcc: :one,
  page: params[:page],
  term: params[:term],
  status: params[:status]
)
```

O nome pode ser ajustado ao padrão encontrado no projeto, mas a classe deve:

- expor um único ponto de entrada público;
- validar ou tratar explicitamente as chaves de TCC aceitas;
- receber valores simples, e não o objeto `params`;
- não acessar variáveis de controller;
- não montar URLs nem decidir templates;
- manter a composição como `ActiveRecord::Relation` até a paginação, sem filtrar registros em memória.

# Escopo permitido

- `app/controllers/responsible/orientations_controller.rb`, limitado às actions `tcc_one` e `tcc_two` e aos comentários/desativações resolvidos por elas;
- novo objeto em `app/services/orientations/` ou diretório equivalente já adotado pelo projeto;
- `app/models/concerns/orientation_filter.rb`, somente para remover `by_tcc_one` e `by_tcc_two` depois de confirmar ausência de consumidores ativos;
- specs unitários do novo objeto de consulta;
- specs de request/feature das listagens e busca de orientações do responsável diretamente relacionados ao comportamento extraído;
- factories e helpers de spec estritamente necessários aos cenários de caracterização;
- relatório final em `ai/output/fase-2-controllers-e-consultas/`.

# Escopo proibido

- Não altere os mapeamentos dos enums `tcc`, `semester` ou `status`.
- Não altere migrations, schema ou dados persistidos.
- Não remova nem redefina os scopes `Orientation.tcc_one` e `Orientation.tcc_two`, pois ainda existem consumidores ativos fora desta task.
- Não altere `by_current_tcc_one`, `by_current_tcc_two`, `current_tcc_one` ou `current_tcc_two`.
- Não refatore outras actions de `Responsible::OrientationsController`.
- Não mova breadcrumbs, formatação de assinaturas, regras de edição, cancelamento, destruição ou documentos.
- Não altere rotas, nomes de parâmetros, URLs de busca, templates, textos, traduções ou respostas HTTP.
- Não modifique a quantidade por página nem substitua a biblioteca de paginação.
- Não faça commit, push ou criação de branch.

# Roteiro de implementação

## 1. Caracterizar o comportamento ativo

Antes da extração, adicionar ou ajustar testes que cubram diretamente:

- uma orientação com somente calendário TCC I aparece em TCC I e não aparece em TCC II;
- uma orientação com calendários TCC I e TCC II não aparece em TCC I e aparece em TCC II;
- uma orientação com somente calendário TCC II aparece em TCC II;
- orientações sem calendário da etapa consultada não aparecem;
- o filtro por status continua opcional e restringe o resultado quando informado;
- a busca textual continua funcionando para os campos já suportados por `Searchable`;
- a ordem permanece `orientations.created_at DESC`;
- a paginação preserva o número e a ordem dos registros por página.

Reaproveite os feature specs existentes para o contrato visível, mas cubra a composição da relação em specs unitários do objeto novo. Não dependa apenas de Capybara/JavaScript para validar a semântica da consulta.

## 2. Criar o objeto de consulta

- Criar uma classe com responsabilidade exclusiva de compor a listagem histórica do responsável.
- Começar por `Orientation` e aplicar a seleção correspondente ao TCC solicitado.
- Para TCC I, preservar a condição equivalente a `COUNT(DISTINCT calendars.tcc) = 1` e `MIN(calendars.tcc) = Calendar.tccs.fetch(:one)`, ou outra formulação relacional comprovadamente equivalente.
- Para TCC II, selecionar orientações associadas a calendário `tcc: :two`.
- Aplicar o status somente quando presente.
- Aplicar `search(term)`, ordenação decrescente por criação e `page(page)` na mesma sequência observável da implementação atual.
- Evitar SQL interpolado; valores dinâmicos devem ser parametrizados ou representados pela API do enum.
- Garantir que joins com múltiplos calendários não produzam orientações duplicadas na listagem.

## 3. Simplificar as actions

- Manter em cada action o breadcrumb existente.
- Substituir a montagem manual da relação por uma chamada ao novo objeto com parâmetros explícitos.
- Preservar `@orientations`, `@search_url` e o `render :index` esperados pelas views.
- Remover os comentários de solução temporária, as chamadas antigas comentadas e os blocos `rubocop:disable/enable Metrics/AbcSize` que deixarem de ser necessários.
- Não introduzir um método privado genérico no controller se ele apenas duplicar a interface do objeto de consulta.

## 4. Reconciliar a extração abandonada

- Buscar consumidores de `Orientation.by_tcc_one` e `Orientation.by_tcc_two` em toda a aplicação e nos testes.
- Remover `OrientationFilter.by_tcc_one` e `OrientationFilter.by_tcc_two` somente depois de confirmar que as listagens do responsável eram seus únicos consumidores pretendidos e que não resta chamada ativa.
- Preservar `OrientationFilter.by_tcc`, pois continua sendo usado pelas consultas de calendário atual, salvo se uma remoção estritamente local e comprovada for possível.
- Preservar os scopes `Orientation.tcc_one` e `Orientation.tcc_two` e registrar seus consumidores remanescentes no relatório final.
- Não limpar o código comentado dos relatórios de dashboard; essa reconciliação pertence à REF-08.

## 5. Verificar contratos HTTP e de apresentação

- Confirmar que as mesmas rotas continuam atendendo listagem e busca de TCC I/TCC II.
- Confirmar que os mesmos parâmetros `page`, `term` e `status` são aceitos.
- Confirmar que as views continuam recebendo os campos e associações necessários sem consultas adicionais evitáveis.
- Comparar o SQL ou o conjunto de IDs antes/depois para os cenários caracterizados, especialmente a orientação migrada.
- Verificar que a ordem e a paginação são determinísticas nos testes; em caso de empate relevante, caracterizar o comportamento atual antes de adicionar qualquer critério secundário.

## 6. Verificação final

- Repetir a busca por `TODO: Refactor this method`, `TEMPORARY SOLUCTION` e pelos blocos de RuboCop nas duas actions e confirmar que os marcadores resolvidos foram removidos.
- Confirmar que `Responsible::OrientationsController#tcc_one` e `#tcc_two` não contêm `joins`, `includes`, `where`, `group`, `having`, `order`, `search` ou `page`.
- Confirmar que o objeto novo não referencia `params`, helpers, rotas ou métodos de renderização.
- Executar specs focados, RuboCop nos arquivos alterados e, quando o ambiente permitir, a suíte completa.

# Critérios de aceite

- As actions `tcc_one` e `tcc_two` não compõem SQL nem encadeiam filtros, busca, ordenação ou paginação.
- Existe um objeto de consulta isolado, com parâmetros explícitos e cobertura própria.
- Uma orientação exclusiva de TCC I aparece somente na listagem de TCC I.
- Uma orientação que avançou de TCC I para TCC II é excluída da listagem de TCC I e incluída na listagem de TCC II.
- Uma orientação criada diretamente em TCC II continua aparecendo na listagem de TCC II.
- Status, termo, paginação e ordem produzem os mesmos resultados observáveis de antes.
- A consulta não materializa todos os registros para filtrá-los em Ruby e não gera duplicatas por causa dos joins.
- Breadcrumbs, URLs de busca, rotas, templates e respostas HTTP permanecem inalterados.
- Os comentários da extração antiga e as desativações locais do RuboCop resolvidas pela task não existem mais nas duas actions.
- `OrientationFilter.by_tcc_one` e `OrientationFilter.by_tcc_two` não existem mais, desde que a busca final confirme ausência de consumidor ativo.
- `Orientation.tcc_one`, `Orientation.tcc_two` e os fluxos de calendário atual permanecem disponíveis e inalterados.
- A suíte RSpec relacionada passa e o RuboCop não registra novas violações no escopo alterado.

# Validação sugerida

Execute primeiro os specs do objeto novo e os fluxos diretamente afetados:

```bash
bundle exec rspec spec/services/orientations/ \
  spec/features/responsible/orientations/orientations_index_tcc_one_spec.rb \
  spec/features/responsible/orientations/orientations_index_tcc_two_spec.rb \
  spec/features/responsible/orientations/orientations_search_spec.rb

bundle exec rubocop app/services/orientations/ \
  app/controllers/responsible/orientations_controller.rb \
  app/models/concerns/orientation_filter.rb \
  spec/services/orientations/

bundle exec rspec
```

Se o projeto exigir Docker, use os comandos equivalentes disponibilizados pelo script `./run`.

Se RSpec, Capybara ou o banco continuarem indisponíveis por limitação do ambiente, não registre a ausência de execução como sucesso. Documente o comando, a mensagem de erro e quais garantias ficaram limitadas à inspeção estática.

# Métricas antes/depois

Registrar, para o escopo alterado:

- complexidade Flog ou ABC das actions `tcc_one` e `tcc_two`;
- quantidade de chamadas de consulta (`joins`, `where`, `group`, `having`, `order`, `search`, `page`) dentro das duas actions;
- quantidade de comentários temporários e desativações do RuboCop removidos;
- quantidade de métodos da extração abandonada removidos;
- resultado dos specs focados, com exemplos e falhas;
- offenses do RuboCop nos arquivos alterados.

O esperado é reduzir as actions a coordenação HTTP, zerar nelas a composição da consulta e manter idênticos os conjuntos e a ordem de IDs nos cenários caracterizados.

# Relatório final esperado

Criar `ai/output/fase-2-controllers-e-consultas/implementation-summary-ref-04-extrair-busca-orientacoes-responsavel.md` com:

## Resumo

Descrição da interface do objeto criado e da responsabilidade retirada do controller.

## Arquivos alterados

Lista dos arquivos, explicando o papel de cada alteração.

## Comportamento preservado

Evidências sobre exclusividade de TCC I, inclusão da orientação migrada em TCC II, filtro por status, busca textual, paginação, ordenação, rotas e renderização.

## Extração abandonada

Registrar os métodos removidos, a busca por consumidores e os scopes genéricos preservados com seus consumidores ativos.

## Métricas antes/depois

Tabela com complexidade das actions, chamadas de consulta no controller, comentários temporários, métodos mortos e offenses de estilo.

## Validação

Comandos executados e resultados de RSpec e RuboCop, separando limitações do ambiente e falhas preexistentes de regressões introduzidas.

## Riscos e próximos passos

Listar limitações remanescentes e confirmar que a reorganização dos scopes de `Orientation` pertence à REF-06, enquanto a limpeza dos relatórios e services de dashboard pertence à REF-08.
