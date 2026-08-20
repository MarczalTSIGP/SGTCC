# Implementation Summary

## General Summary

Foi implementada uma deduplicação conservadora em specs de feature, mantendo os cenários existentes e centralizando expectativas repetidas em helpers/shared examples específicos.

A refatoração cobriu principalmente:

- show de atividades entre perfis;
- show de atividades em orientações/supervisões;
- show de documentos em orientações/supervisões;
- criação de bancas;
- alguns índices/calendários com repetição simples.

Nenhum código de produção foi alterado.

## Changed Files

### spec/features/external_members/activities/activities_show_spec.rb

- Substituiu expectativas repetidas de dados básicos e respostas por shared example/helper.
- Necessário para deduplicar o fluxo comum de show de atividade.
- Cenários preservados: `base info` e listagem de respostas.

### spec/features/professors/activities/activities_show_spec.rb

- Aplicou a mesma extração usada para external members.
- Necessário para manter consistência entre perfis.
- Cenários preservados: dados básicos e respostas sem links.

### spec/features/responsible/activities/activities_show_spec.rb

- Centralizou expectativas de dados básicos, listagem de respostas e links de respostas enviadas/não enviadas.
- Necessário para reduzir duplicação mantendo permissões do perfil explícitas.
- Cenários preservados: 4 exemplos.

### spec/features/tcc_one_professors/activities/activities_show_spec.rb

- Centralizou expectativas comuns de atividade e respostas.
- Necessário para alinhar o spec ao padrão aplicado ao perfil responsible.
- Cenários preservados: 4 exemplos.

### spec/features/academics/orientations/orientations_activities_show_spec.rb

- Substituiu expectativas repetidas por helpers de conteúdo e links da atividade.
- Necessário para deduplicar show de atividade em orientação.
- Cenários preservados: 1 exemplo.

### spec/features/professors/orientations/orientations_activities_show_spec.rb

- Usou os mesmos helpers de conteúdo e links da atividade.
- Necessário para remover duplicação com acadêmico e supervisão.
- Cenários preservados.

### spec/features/professors/supervisions/supervisions_activities_show_spec.rb

- Centralizou expectativas comuns da atividade vinculada à supervisão.
- Necessário para reaproveitar o mesmo comportamento visual testado.
- Cenários preservados.

### spec/features/responsible/orientations/orientations_activities_show_spec.rb

- Centralizou expectativas de conteúdo da atividade.
- Necessário para reduzir repetição mantendo o teste de links específico separado.
- Cenários preservados.

### spec/features/external_members/supervisions/supervisions_documents_show_spec.rb

- Substituiu o bloco repetido por shared example de show de documento em orientação/supervisão.
- Necessário para deduplicar dados básicos, supervisores e link ativo.
- Cenário preservado.

### spec/features/professors/supervisions/supervisions_documents_show_spec.rb

- Aplicou o shared example comum de documento.
- Necessário para reduzir duplicação com external member e professor TCC I.
- Cenário preservado.

### spec/features/tcc_one_professors/orientations/orientations_documents_show_spec.rb

- Aplicou o shared example comum de documento.
- Necessário para manter expectativas comuns centralizadas.
- Cenário preservado.

### spec/features/responsible/examination_boards/examination_boards_create_tcc_one_spec.rb

- Centralizou validações, criação com sucesso e verificação do select de orientação.
- Necessário para reduzir repetição entre criação de bancas TCC I/TCC II.
- Cenários preservados: filtro do select, criação válida e erros obrigatórios.

### spec/features/responsible/examination_boards/examination_boards_create_tcc_two_spec.rb

- Aplicou helpers comuns de criação de banca.
- Necessário para remover duplicação com o fluxo TCC I.
- Cenários preservados.

### spec/features/tcc_one_professors/examination_boards/examination_boards_create_spec.rb

- Aplicou helpers comuns de criação de banca, mantendo diferença de rota e exibição da orientação.
- Necessário para compartilhar comportamento comum sem esconder diferença do perfil.
- Cenários preservados.

### spec/features/professors/orientations/orientations_history_index_spec.rb

- Centralizou expectativas básicas de orientação no índice e link ativo.
- Necessário para deduplicar repetição simples de índice.
- Cenário preservado.

### spec/features/professors/orientations/orientations_index_tcc_two_spec.rb

- Usou helpers comuns de índice de orientação.
- Necessário para reduzir duplicação com histórico/supervisões/calendário.
- Cenário preservado.

### spec/features/professors/supervisions/supervisions_index_spec.rb

- Centralizou expectativas básicas e link ativo no cenário TCC II.
- Necessário para reduzir repetição pontual sem alterar os demais fluxos.
- Cenário preservado.

### spec/features/tcc_one_professors/calendars/calendars_index_spec.rb

- Usou helpers comuns para dados básicos da orientação e link ativo.
- Necessário para deduplicar repetição simples de índice/calendário.
- Cenário preservado.

### spec/features/professors/orientations/orientations_show_basic_information_spec.rb

- Substituiu helper local por helper compartilhado de dados básicos da orientação.
- Necessário para remover duplicação entre show de orientações e supervisões.
- Cenário preservado.

### spec/features/professors/orientations/orientations_show_tcc_one_spec.rb

- Passou a usar helper compartilhado de dados básicos.
- Necessário para remover helper local duplicado.
- Cenário preservado.

### spec/features/professors/orientations/orientations_show_tcc_two_spec.rb

- Passou a usar helper compartilhado de dados básicos.
- Necessário para manter consistência entre TCC I e TCC II.
- Cenário preservado.

### spec/features/professors/supervisions/supervisions_show_basic_information_spec.rb

- Substituiu helper local por helper compartilhado.
- Necessário para reduzir duplicação em show de supervisões.
- Cenário preservado.

### spec/features/professors/supervisions/supervisions_show_tcc_one_spec.rb

- Usou helper compartilhado de dados básicos da orientação.
- Necessário para remover duplicação local.
- Cenário preservado.

### spec/features/professors/supervisions/supervisions_show_tcc_two_spec.rb

- Usou helper compartilhado de dados básicos da orientação.
- Necessário para remover duplicação local.
- Cenário preservado.

### spec/features/external_members/supervisions/supervisions_show_basic_information_spec.rb

- Aplicou helper compartilhado de dados básicos.
- Necessário para alinhar show de supervisão ao padrão comum.
- Cenário preservado.

### spec/features/external_members/supervisions/supervisions_show_tcc_one_spec.rb

- Aplicou helper compartilhado de dados básicos.
- Necessário para remover repetição.
- Cenário preservado.

### spec/features/external_members/supervisions/supervisions_show_tcc_two_spec.rb

- Aplicou helper compartilhado de dados básicos.
- Necessário para remover repetição.
- Cenário preservado.

### spec/features/tcc_one_professors/orientations/orientations_show_spec.rb

- Substituiu expectativas inline por helper compartilhado.
- Necessário para reduzir duplicação no show de orientação.
- Cenário preservado.

### spec/support/activities/activity_show_examples.rb

- Criou suporte específico para expectativas comuns do show de atividades.
- Necessário para centralizar dados básicos, respostas e links de resposta.
- Escopo mantido específico para specs de atividades.

### spec/support/orientations/orientation_activity_show_examples.rb

- Criou suporte para expectativas comuns de atividades em orientações/supervisões.
- Necessário para reaproveitar conteúdo e links comuns.
- Mantém as rotas e perfis explícitos nos specs.

### spec/support/orientations/orientation_document_show_examples.rb

- Criou shared example para show de documentos em orientação/supervisão.
- Necessário para centralizar dados do documento, participantes e link ativo.
- Não altera os specs de documentos por perfil/tipo já deduplicados antes.

### spec/support/orientations/orientation_show_examples.rb

- Criou helper comum para informações básicas de orientação/supervisão.
- Necessário para substituir helpers locais duplicados.
- Usado apenas nos specs afetados.

### spec/support/orientations/orientation_index_examples.rb

- Criou helpers para informações básicas de orientação em índices e link ativo.
- Necessário para deduplicação pontual de índices/calendários.
- Mantém a deduplicação limitada a padrões simples.

### spec/support/examination_boards/examination_board_create_examples.rb

- Criou helpers para criação de bancas, validações obrigatórias e filtro do select de orientação.
- Necessário para deduplicar fluxos de criação TCC I/TCC II e professor TCC I.
- Mantém diferenças de rota, perfil e exibição de orientação parametrizadas.

## Review Notes

- Comparação preservada:
  - `activities_show_spec.rb` entre perfis: antes 12 exemplos; depois 12 exemplos; cenários preservados; diferenças de links por perfil mantidas.
  - atividades em orientações/supervisões: cenários de show preservados; conteúdo comum centralizado; links específicos mantidos onde existiam.
  - documentos em orientações/supervisões: 3 exemplos preservados; expectativas comuns centralizadas.
  - criação de bancas: 9 exemplos preservados; diferenças TCC I/TCC II e responsible/TCC I professor mantidas.
  - índices/calendários: deduplicação limitada a expectativas claramente repetidas.

- Revisar se os arquivos de suporte em `spec/support/activities`, `spec/support/orientations` e `spec/support/examination_boards` estão sendo carregados automaticamente pelo projeto.

- Executar/confirmar:
  - `./run rspec` nas pastas afetadas.
  - `./run rubocop` nas pastas afetadas e em `spec/support`.

- Não foi feito commit, push ou Pull Request.

- O working tree deve ser revisado manualmente com:
  ```bash
  git status
  git diff
  ```