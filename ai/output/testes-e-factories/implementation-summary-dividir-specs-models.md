# Implementation Summary

## General Summary

Foram divididos os specs grandes de models em arquivos menores por responsabilidade dentro de `spec/models/`. Os arquivos monolíticos principais foram removidos e seus testes foram reorganizados em subpastas específicas por model, mantendo a intenção dos exemplos e sem alteração em código de produção.

## Changed Files

### spec/models/academic_spec.rb

- Arquivo removido após a migração dos testes para specs menores.
- A remoção foi necessária porque o conteúdo foi separado por responsabilidades em `spec/models/academics/`.
- Revisar se todos os cenários antigos foram preservados nos novos arquivos.

### spec/models/academics/

- Criada estrutura para specs menores do model `Academic`.
- A alteração foi necessária para separar validações, busca, documentos, termos e LDAP.
- Observação importante: confirmar os nomes dos arquivos criados dentro da pasta antes da PR.

### spec/models/activity_spec.rb

- Arquivo removido após a migração dos testes para specs menores.
- A remoção foi necessária porque o conteúdo foi separado por responsabilidades em `spec/models/activities/`.
- Revisar se callbacks de notificação e respostas acadêmicas continuam cobertos.

### spec/models/activities/

- Criada estrutura para specs menores do model `Activity`.
- A alteração foi necessária para separar validações, enums/formatação, prazos/status, respostas acadêmicas e notificações.
- Observação importante: confirmar os nomes dos arquivos criados dentro da pasta antes da PR.

### spec/models/document_spec.rb

- Arquivo removido após a migração dos testes para specs menores.
- A remoção foi necessária porque o spec concentrava muitas responsabilidades de `Document`.
- Revisar especialmente geração de TDO/TEP/TSO, assinaturas, callbacks, status e serialização.

### spec/models/documents/

- Criada estrutura para specs menores do model `Document`.
- A alteração foi necessária para organizar os testes por assinatura, geração, callbacks, status, revisão e serialização.
- Observação importante: confirmar os nomes dos arquivos criados dentro da pasta antes da PR.

### spec/models/examination_board_spec.rb

- Arquivo removido após a migração dos testes para specs menores.
- A remoção foi necessária porque o conteúdo foi distribuído em specs por responsabilidade.
- Nenhum código de produção deveria ter sido alterado.

### spec/models/examination_boards/appointments_spec.rb

- Foram movidos os testes de apontamentos de banca.
- A alteração foi necessária para isolar a regra de `appointments?`.
- Mantém os cenários com e sem arquivo/texto de apontamento.

### spec/models/examination_boards/callbacks_spec.rb

- Foram movidos os testes de callbacks de `ExaminationBoard`.
- A alteração foi necessária para isolar o comportamento de enfileiramento de notificações.
- Revisar se o matcher de job continua estável.

### spec/models/examination_boards/confirmation_spec.rb

- Foram movidos os testes do método `confirm!`.
- A alteração foi necessária para separar confirmação de banca das demais regras.
- Revisar o número esperado de notificações e destinatários.

### spec/models/examination_boards/evaluators_spec.rb

- Foram movidos os testes relacionados a avaliadores e notas.
- A alteração foi necessária para isolar regras de advisor, professor evaluator, external member evaluator e `all_evaluated?`.
- O bloco comentado sobre `can_create_defense_minutes?` foi preservado.

### spec/models/examination_boards/search_spec.rb

- Foram movidos os testes de busca de banca.
- A alteração foi necessária para separar comportamento de pesquisa.
- Cobre busca por título da orientação e local.

### spec/models/examination_boards/status_spec.rb

- Foram movidos os testes de status por data e distância da data.
- A alteração foi necessária para isolar regras temporais da banca.
- Revisar possíveis sensibilidades a data/hora atual.

### spec/models/examination_boards/validations_spec.rb

- Foram movidos os testes de validações, associações e helpers de identifiers.
- A alteração foi necessária para concentrar contrato básico do model.
- Mantém validações de presença e associações existentes.

### spec/models/external_member_spec.rb

- Arquivo removido após a migração dos testes para specs menores.
- A remoção foi necessária porque o conteúdo foi separado por responsabilidades em `spec/models/external_members/`.
- Revisar documentos, supervisões atuais e bancas atuais.

### spec/models/external_members/

- Criada estrutura para specs menores do model `ExternalMember`.
- A alteração foi necessária para separar validações, busca, documentos, supervisões e bancas.
- Observação importante: confirmar os nomes dos arquivos criados dentro da pasta antes da PR.

### spec/models/orientation_spec.rb

- Arquivo removido após a migração dos testes para specs menores.
- A remoção foi necessária porque já havia padrão de subpasta em `spec/models/orientations/`.
- A divisão seguiu o padrão existente.

### spec/models/orientations/academic_activities_spec.rb

- Foram movidos os testes de documentos de atividades acadêmicas da orientação.
- A alteração foi necessária para isolar proposal, project e monograph.
- Mantém cenários com calendários anteriores e atuais.

### spec/models/orientations/calendar_spec.rb

- Foram movidos os testes relacionados a calendário e filtros por TCC.
- A alteração foi necessária para separar regras de calendário, TCC atual e formatação do acadêmico com calendário.
- Revisar queries `by_tcc_one`, `by_tcc_two`, `by_current_tcc_one` e `by_current_tcc_two`.

### spec/models/orientations/cancellation_spec.rb

- Foram movidos os testes de cancelamento.
- A alteração foi necessária para isolar a regra de `cancel`.
- Mantém expectativa de status `cancelada`.

### spec/models/orientations/documents_spec.rb

- Foram movidos os testes de dados para documentos e serialização de tabela.
- A alteração foi necessária para separar supervisores, dados formatados e JSON.
- Inclui `document_tcc_one`.

### spec/models/orientations/migration_spec.rb

- Foram movidos os testes de migração de orientação.
- A alteração foi necessária para isolar regras de migração entre calendários e TCCs.
- Revisar com atenção por ser uma área sensível a datas.

### spec/models/orientations/ordering_spec.rb

- Foram movidos os testes de ranking e ordenação de bancas.
- A alteração foi necessária para separar regras de ordenação e escopo temporal.
- Inclui cenários de bancas futuras, passadas e calendários sobrepostos.

### spec/models/orientations/status_spec.rb

- Foram movidos os testes de status da orientação.
- A alteração foi necessária para isolar predicates e scopes de status.
- Mantém verificações de aprovado, cancelado, em andamento e cancelável.

### spec/models/orientations/validations_spec.rb

- Foram movidos os testes de validações, associações e métodos básicos.
- A alteração foi necessária para concentrar o contrato estrutural do model.
- Inclui `short_title` e `select_status_data`.

### spec/models/professor_spec.rb

- Arquivo removido após a migração dos testes para specs menores.
- A remoção foi necessária porque o conteúdo foi separado por responsabilidades em `spec/models/professors/`.
- Revisar documentos, roles, orientações, bancas e supervisões.

### spec/models/professors/documents_spec.rb

- Foram movidos os testes de documentos do professor.
- A alteração foi necessária para isolar documentos assinados, pendentes, em revisão e solicitados.
- Mantém consultas com `DISTINCT ON`.

### spec/models/professors/examination_boards_spec.rb

- Foram movidos os testes de bancas relacionadas ao professor.
- A alteração foi necessária para separar regras de bancas de orientação e participação.
- Revisar cenários de banca como orientador e como convidado.

### spec/models/professors/orientations_spec.rb

- Foram movidos os testes de orientações do professor.
- A alteração foi necessária para isolar filtros por TCC/status e dados para formulário.
- Revisar métodos de orientações aprovadas e em andamento.

### spec/models/professors/roles_spec.rb

- Foram movidos os testes de papéis/perfis do professor.
- A alteração foi necessária para separar `role?`, responsável, coordenador e tipos de professor.
- Revisar regras de `current_responsible` e `current_coordinator`.

### spec/models/professors/search_spec.rb

- Foram movidos os testes de busca de professor.
- A alteração foi necessária para isolar pesquisa por atributos, roles, acentos, case insensitive e ordenação.
- Mantém cobertura de busca por nome, email, username e role.

### spec/models/professors/validations_spec.rb

- Foram movidos os testes de validações, associações e métodos básicos.
- A alteração foi necessária para concentrar o contrato estrutural do model.
- Inclui validações de email, lattes e supervisor inválido.

### ai-runner.js

- Arquivo novo fora de `spec/models/`.
- Essa alteração está fora do escopo permitido da task.
- Deve ser revisada e provavelmente removida da PR se não for artefato intencional.

### ai/

- Diretório novo fora de `spec/models/`.
- Essa alteração está fora do escopo permitido da task.
- Deve ser revisada e provavelmente removida da PR se não for artefato intencional.

## Review Notes

Revisar se todos os arquivos fora de `spec/models/` devem ser removidos antes da PR, especialmente `ai-runner.js` e `ai/`.

Executar `bundle exec rspec spec/models` para confirmar que a reorganização não alterou o comportamento dos testes.
