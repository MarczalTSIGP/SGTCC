# Task

REF-02 — Padronizar o uso do enum `tcc` na camada de aplicação, preservando integralmente os valores persistidos e o comportamento atual.

# Contexto

A REF-01 (`ai/output/fase-0-baseline/inventario-ref-01.md`) confirmou que o mesmo conceito de TCC I/TCC II é representado no código como inteiro (`1`/`2`), string (`'one'`/`'two'`), símbolo (`:one`/`:two`) e chamada à API do enum (`Calendar.tccs[:one]`/`[:two]`).

O enum é compartilhado por meio de `app/models/concerns/tcc.rb` e está definido como:

```ruby
enum :tcc, { one: 1, two: 2 }, prefix: :tcc
```

Os inteiros `1` e `2` já existem no banco e são parte do contrato persistido. Esta task padroniza somente o modo como a aplicação consulta, compara e atribui esses valores; ela não altera o mapeamento do enum nem converte dados.

Os pontos de maior risco identificados são:

- `Responsible::OrientationsController#tcc_one`, cujo SQL manual usa `MIN(calendars.tcc) = 1`;
- `Responsible::OrientationsController#tcc_two`, cuja consulta usa `calendars: { tcc: 2 }`;
- `Populate::Calendars`, que cria calendários com `tcc: 1` e `tcc: 2`;
- consultas dos relatórios de dashboard que usam `tcc: 'one'`/`'two'`;
- comparações de instância com `tcc == 'one'`/`'two'` em models e controllers.

A extração da consulta de orientações do responsável pertence à REF-04. Nesta task, altere apenas a representação do valor do enum dentro da consulta existente, sem mover, reordenar ou reestruturar sua lógica.

# Dependências

- REF-01 — Inventariar inconsistências e responsabilidades.

# Objetivo

Adotar uma convenção única para o enum `tcc` em toda a camada de aplicação:

- usar os predicados prefixados `tcc_one?` e `tcc_two?` ao consultar o valor de uma instância que inclui `Tcc`;
- usar símbolos `:one` e `:two` em atribuições e consultas Active Record nas quais o enum é conhecido pelo model consultado;
- usar `Calendar.tccs.fetch(:one)` e `Calendar.tccs.fetch(:two)` somente quando o valor inteiro persistido for realmente necessário, como em um fragmento SQL manual;
- manter interpolação da chave retornada pelo enum apenas para tradução/apresentação, como `I18n.t("enums.tcc.#{record.tcc}")`.

# Instrução crítica

Não altere o mapeamento `{ one: 1, two: 2 }`, o tipo da coluna, migrations ou dados existentes.

Não transforme esta task na REF-04: preserve exatamente a semântica da consulta manual de `Responsible::OrientationsController#tcc_one`, inclusive a exclusividade de orientações que ainda não avançaram para TCC II (`COUNT(DISTINCT calendars.tcc) = 1` e `MIN(calendars.tcc)` correspondente a TCC I).

Não remova nesta task os scopes `Orientation.tcc_one`/`tcc_two`, os métodos `OrientationFilter.by_tcc_one`/`by_tcc_two`, os comentários de extração abandonada ou os blocos de RuboCop do controller. Essa remoção pertence à REF-04.

# Escopo permitido

- `app/models/concerns/tcc.rb`, somente para proteger/documentar o mapeamento existente caso um teste exija referência direta;
- models e concerns que consultam ou comparam `tcc`;
- controllers e controller concerns que consultam ou comparam `tcc`;
- services que consultam ou atribuem `tcc`, incluindo `Dashboard::*Report` e `Populate::Calendars`;
- helpers e components que contenham regra de comparação de `tcc`;
- testes e factories diretamente necessários para caracterizar e validar a padronização;
- relatório final em `ai/output/fase-1-dados-de-dominio/`.

# Escopo proibido

- Não altere o enum `semester`; ele pertence à REF-03.
- Não crie ou altere migrations e não execute atualização em massa de registros.
- Não extraia query objects, services ou presenters.
- Não refatore a estrutura das actions `tcc_one` e `tcc_two` além da substituição dos valores mágicos.
- Não altere rotas, parâmetros, paginação, ordenação, filtros, traduções ou respostas HTTP.
- Não substitua chaves usadas exclusivamente para tradução por valores inteiros do banco.
- Não faça commit, push ou criação de branch.

# Roteiro de implementação

## 1. Caracterizar o contrato persistido

- Adicionar ou ajustar um spec focado no concern/model que confirme `Calendar.tccs` igual a `{ 'one' => 1, 'two' => 2 }`.
- Confirmar que registros construídos com `tcc: :one` e `tcc: :two` continuam gravando respectivamente `1` e `2` na coluna, usando leitura sem conversão de tipo (por exemplo, `read_attribute_before_type_cast`).
- Confirmar que registros já persistidos com `1`/`2` continuam sendo lidos como `'one'`/`'two'` pela API do enum.

## 2. Eliminar inteiros mágicos de TCC

- Em `app/controllers/responsible/orientations_controller.rb`, parametrizar o `HAVING` com `Calendar.tccs.fetch(:one)` e substituir o `2` da consulta de TCC II por `:two` ou pela API explícita do enum.
- Em `app/services/populate/calendars.rb`, substituir `tcc: 1`/`2` por `tcc: :one`/`:two`, preservando a ordem de criação dos calendários.
- Buscar novamente por literais `1`/`2` usados semanticamente como TCC I/TCC II em `app/` e `lib/tasks/`, tratando todos os consumidores ativos encontrados.

## 3. Uniformizar consultas e atribuições

- Substituir `where`/`find_by` com `tcc: 'one'` ou `tcc: 'two'` por símbolos do enum quando a consulta Active Record conhece o atributo.
- Atualizar os relatórios de dashboard e demais services sem alterar os conjuntos retornados, a ordem ou o modo de agregação.
- Nos scopes de `Orientation`, passar símbolos em vez de strings quando o argumento representa uma chave do enum, desde que o método chamado mantenha o mesmo resultado SQL.

## 4. Uniformizar comparações de instância

- Substituir comparações como `calendar.tcc == 'one'` por `calendar.tcc_one?` e equivalentes para TCC II.
- Aplicar a mesma convenção a `BaseActivity` e a outros models que incluem `Tcc` e expõem os predicados prefixados.
- Em código que recebe dinamicamente uma chave de TCC, normalizar a fronteira para uma chave válida do enum sem introduzir `send` com entrada não validada. Preserve contratos públicos existentes quando o chamador ainda fornece string.
- Não alterar interpolação de tradução e exibição (`enums.tcc.#{...}`), pois nesses casos a string é a chave pública do enum, não uma comparação inconsistente.

## 5. Proteger o comportamento das consultas críticas

- Criar ou ajustar specs para `Responsible::OrientationsController#tcc_one` e `#tcc_two` cobrindo, no mínimo:
  - orientação que possui somente calendário de TCC I aparece apenas na listagem de TCC I;
  - orientação que avançou de TCC I para TCC II não aparece na listagem exclusiva de TCC I e aparece na listagem de TCC II;
  - filtro por status, termo, paginação e ordenação continuam inalterados, aproveitando os specs existentes quando já houver cobertura suficiente.
- Cobrir o comportamento de `Populate::Calendars` se ainda não existir teste que confirme a criação de ambos os tipos com os valores persistidos esperados.
- Manter os testes de apresentação que confirmam as traduções de TCC I/TCC II.

## 6. Verificação final

- Repetir a busca textual usada no inventário e confirmar que não restaram inteiros `1`/`2` expressando TCC I/TCC II fora da definição do enum, migrations históricas ou fixtures estritamente justificadas.
- Diferenciar ocorrências legítimas: semestre, datas, contadores, índices, identificadores de rota e valores esperados no teste do contrato persistido não são violações desta task.
- Registrar no relatório quaisquer ocorrências mantidas e a justificativa de cada uma.

# Critérios de aceite

- `Calendar.tccs` continua mapeando `one` para `1` e `two` para `2`.
- Nenhuma migration ou transformação de dados foi criada.
- Não há literal numérico `1`/`2` usado para representar TCC I/TCC II na camada de aplicação, exceto na definição central do enum e em testes explícitos do contrato persistido.
- Comparações de instância usam os predicados prefixados do enum; consultas e atribuições Active Record usam chaves simbólicas ou, quando necessário, a API explícita do enum.
- As listagens de orientações TCC I/TCC II retornam os mesmos registros, inclusive para uma orientação que migrou de TCC I para TCC II.
- Paginação, busca textual, filtro por status e ordenação das listagens permanecem idênticos.
- O serviço de população continua criando o mesmo número e a mesma sequência de calendários, gravando `1`/`2` no banco por meio do enum.
- Rotas, respostas HTTP, traduções e interfaces dos formulários não mudam.
- A suíte RSpec relacionada passa e o RuboCop não registra novas violações no escopo alterado.
- A consulta não foi extraída e o código morto reservado à REF-04 permanece para ser reconciliado naquela task.

# Validação sugerida

Execute primeiro os specs focados nos arquivos alterados e, depois, a suíte completa:

```bash
bundle exec rspec spec/models/calendar/ \
  spec/models/orientations/ \
  spec/features/responsible/orientations/ \
  spec/features/responsible/calendars/

bundle exec rspec
bundle exec rubocop app/ spec/
```

Se o projeto exigir o ambiente Docker, use os comandos equivalentes disponibilizados pelo script `./run`.

Se RSpec ou SimpleCov continuarem indisponíveis por problema de banco ou ambiente, não trate a ausência de execução como sucesso: registre o comando, a mensagem de erro e quais comportamentos ficaram validados apenas por inspeção estática.

# Métricas antes/depois

Registrar, para o escopo alterado:

- quantidade de ocorrências de inteiros mágicos usados como TCC;
- quantidade de comparações diretas com `'one'`/`'two'`;
- resultado dos specs focados (exemplos e falhas);
- offenses do RuboCop nos arquivos alterados.

O esperado é zerar os dois primeiros grupos na camada de aplicação, sem alteração funcional e sem aumento de offenses.

# Relatório final esperado

Criar `ai/output/fase-1-dados-de-dominio/implementation-summary-ref-02-padronizar-enum-tcc.md` com:

## Resumo

Descrição curta da convenção adotada e confirmação de que o mapeamento persistido foi preservado.

## Arquivos alterados

Lista de arquivos, explicando a inconsistência removida em cada um.

## Comportamento preservado

Evidências sobre leitura/escrita dos valores `1`/`2`, separação entre TCC I e TCC II, orientação migrada, população de calendários, filtros, busca, paginação, ordenação e traduções.

## Métricas antes/depois

Tabela com as ocorrências de valores mágicos e comparações diretas antes e depois.

## Validação

Comandos executados e respectivos resultados de RSpec e RuboCop. Falhas preexistentes ou limitações de ambiente devem aparecer separadas de regressões.

## Riscos e próximos passos

Listar limitações remanescentes e confirmar que a REF-04 ainda deve extrair as queries do controller e remover a extração abandonada.
