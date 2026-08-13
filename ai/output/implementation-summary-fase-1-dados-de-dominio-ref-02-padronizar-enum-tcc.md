# Implementation Summary

## General Summary

Foi implementada a padronização do enum `tcc` na camada de aplicação sem alterar o contrato persistido `{ one: 1, two: 2 }`. As consultas Active Record e atribuições passaram a usar símbolos `:one`/`:two`, comparações de instância passaram a usar os predicados prefixados `tcc_one?`/`tcc_two?`, e o único uso de valor inteiro em lógica de aplicação ficou restrito ao SQL manual que exige o valor persistido via `Calendar.tccs.fetch(:one)`.

Também foram adicionadas coberturas para o contrato de persistência do enum e para as listagens críticas de orientações TCC I/TCC II, preservando o comportamento de orientação exclusiva de TCC I e orientação migrada para TCC II.

## Changed Files

### app/controllers/concerns/breadcrumb.rb

- Substituiu comparações diretas com `@calendar.tcc == 'one'` por `@calendar.tcc_one?`.
- Necessário para padronizar leitura de instância via predicado prefixado.
- Mantém os mesmos destinos de breadcrumb.

### app/controllers/external_members/supervisions_controller.rb

- Substituiu comparação direta de TCC por `@calendar.tcc_one?`.
- Necessário para remover comparação por string na decisão de rota.
- Não altera URLs nem fluxo do controller.

### app/controllers/responsible/base_activities_controller.rb

- Substituiu `@base_activity.tcc == 'one'` por `@base_activity.tcc_one?`.
- Necessário para seguir a convenção do concern `Tcc`.
- Mantém a mesma escolha de rota.

### app/controllers/responsible/calendars_controller.rb

- Substituiu comparação direta com string por `@calendar.tcc_one?`.
- Necessário para uniformizar leitura de enum em instâncias.
- Não altera rotas, parâmetros ou respostas.

### app/controllers/responsible/orientations_controller.rb

- Parametrizou o SQL manual de TCC I com `Calendar.tccs.fetch(:one)`.
- Substituiu `calendars: { tcc: 2 }` por `calendars: { tcc: :two }`.
- Necessário para remover inteiros mágicos preservando a semântica da query manual, incluindo `COUNT(DISTINCT calendars.tcc) = 1` e `MIN(calendars.tcc)` para TCC I.
- A consulta não foi extraída nem reestruturada.

### app/helpers/active_link_helper.rb

- Normalizou `tcc_type` para símbolo e passou a comparar com `tcc_one?`/`tcc_two?`.
- Necessário porque o método recebe chave dinâmica de TCC.
- Entradas inválidas retornam `false` sem uso de `send`.

### app/models/base_activity.rb

- Alterou chamadas internas de `by_tcc` para receber `:one`/`:two`.
- Necessário para usar chaves simbólicas em consultas Active Record conhecidas pelo model.
- Preserva os scopes/métodos existentes.

### app/models/calendar.rb

- Substituiu usos de `tccs[...]` em consultas Active Record por símbolos.
- Substituiu comparação `calendar.tcc == 'two'` por `calendar.tcc_two?`.
- Necessário para padronizar consultas, buscas por semestre e navegação TCC II.
- Não altera o enum nem o enum `semester`.

### app/models/concerns/current_calendar.rb

- Substituiu `where(tcc: tccs[tcc_key])` por `where(tcc: tcc_key)`.
- Necessário para consultar pelo enum usando a chave simbólica.
- Mantém a lógica de calendário corrente e fallback por `end_date`.

### app/models/concerns/orientation_join.rb

- Substituiu `Calendar.tccs[:one]`/`[:two]` por `:one`/`:two`.
- Necessário para remover uso desnecessário do valor persistido em joins Active Record.
- Mantém os métodos existentes.

### app/models/examination_board.rb

- Atualizou scopes de TCC para usar `where(tcc: :one)` e `where(tcc: :two)`.
- Ajustou valores auxiliares usados para localizar calendário corrente.
- Necessário para remover chamadas ao valor inteiro persistido em consultas Active Record.
- Sem alteração de semântica dos scopes.

### app/models/orientation.rb

- Atualizou scopes `tcc_one`/`tcc_two` para passar símbolos.
- Substituiu `Calendar.where(tcc: 'one')` por `Calendar.where(tcc: :one)`.
- Substituiu comparações de calendário corrente por `tcc_one?`/`tcc_two?`.
- Necessário para preservar os métodos existentes usando a convenção nova.
- Comentários e métodos reservados para REF-04 foram mantidos.

### app/services/calendars/clone_base_activities.rb

- Alterou consulta de atividades base para usar `@calendar.tcc.to_sym`.
- Necessário porque `@calendar.tcc` retorna string pela API do enum, enquanto a consulta agora usa símbolo.
- Mantém o conjunto clonado.

### app/services/dashboard/professor_report.rb

- Substituiu consultas com `tcc: 'one'`/`'two'` por `tcc: :one`/`:two`.
- Manteve os filtros em memória com `tcc_one?`/`tcc_two?`.
- Necessário para padronizar os relatórios sem alterar agregações.

### app/services/dashboard/responsible_report.rb

- Substituiu consultas com strings por símbolos.
- Normalizou `tcc_type` dinâmico com `to_sym` em `count_orientations`.
- Necessário para manter o contrato público aceitando string, mas consultar via símbolo.
- Não altera totais, agrupamentos ou filtros.

### app/services/populate/calendars.rb

- Substituiu criação com `tcc: 2`/`tcc: 1` por `tcc: :two`/`:one`.
- Necessário para remover inteiros mágicos em atribuição.
- A ordem de criação foi preservada: TCC II antes de TCC I em cada iteração.

### spec/features/responsible/orientations/orientations_index_tcc_one_spec.rb

- Adicionou cenário de orientação que avançou para TCC II.
- Necessário para garantir que ela não aparece na listagem exclusiva de TCC I.
- Protege a semântica crítica da query manual.

### spec/features/responsible/orientations/orientations_index_tcc_two_spec.rb

- Adicionou cenário de orientação migrada de TCC I para TCC II.
- Necessário para garantir que ela aparece na listagem de TCC II.
- Complementa a cobertura da separação TCC I/TCC II.

### spec/features/responsible/orientations/orientations_index_to_migration_spec.rb

- Substituiu consultas/criações com `Calendar.tccs[...]` por símbolos.
- Necessário para alinhar os testes à convenção de consulta Active Record.
- Mantém o comportamento esperado da tela de migração.

### spec/models/calendar/validations_calendar_spec.rb

- Adicionou specs do contrato persistido do enum.
- Confirma `Calendar.tccs == { 'one' => 1, 'two' => 2 }`.
- Confirma escrita simbólica persistindo `1`/`2` e leitura de inteiros já gravados como `'one'`/`'two'`.

### spec/services/populate/

- Diretório novo para specs de serviço de população.
- Deve conter a cobertura direta de `Populate::Calendars`, especialmente a criação dos calendários com valores persistidos esperados.
- O conteúdo do arquivo não foi incluído no diff apresentado.

### ai/output/fase-1-dados-de-dominio/

- Diretório novo para saída do relatório da fase.
- Necessário para registrar o resumo final esperado da REF-02.
- O arquivo específico não foi exibido no diff apresentado.

### ai/tasks/fase-1-dados-de-dominio/

- Diretório novo relacionado à documentação/tarefas da fase.
- Não há conteúdo disponível no preview informado.
- Revisar se deve permanecer no escopo do commit da REF-02.

## Review Notes

Revisar especialmente a listagem de orientações TCC I/TCC II, a tela de migração, os relatórios de dashboard e o serviço `Populate::Calendars`. Também conferir o conteúdo dos diretórios novos não rastreados antes de decidir o que entra no commit.