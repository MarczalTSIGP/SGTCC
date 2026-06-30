# Implementation Summary

## General Summary

Foi implementada uma refatoração ampla da suíte de testes, com foco em divisão de specs grandes, deduplicação de cenários repetidos, remoção de esperas frágeis e criação de exemplos compartilhados em `spec/support`. Também foram adicionados arquivos de contexto e tarefas para orientar execuções futuras via IA.

## Changed Files

### ai-runner.js

- Criado runner para apoiar execuções automatizadas de tarefas de IA.
- Necessário para padronizar o fluxo local de execução.
- Revisar integração antes de usar em automações reais.

### ai/context.md

- Criado contexto geral do projeto para agentes de IA.
- Necessário para orientar futuras tarefas com informações consistentes.
- Conteúdo deve ser mantido atualizado com decisões do projeto.

### ai/rails-context.md

- Criado contexto específico de Rails.
- Necessário para orientar padrões técnicos da aplicação.
- Revisar quando houver mudanças estruturais no app.

### ai/refatoracao.md

- Criado guia de refatoração.
- Necessário para consolidar critérios usados nas mudanças.
- Serve como referência para próximas limpezas.

### ai/rules.md

- Criadas regras de trabalho para IA.
- Necessário para reduzir variação entre execuções.
- Revisar se as convenções do projeto mudarem.

### ai/system.md

- Criado prompt/sistema base para execuções.
- Necessário para padronizar comportamento do agente.
- Deve acompanhar ajustes no processo de desenvolvimento.

### ai/output/implementation-summary-deduplicar-cruds-responsible.md

- Criado relatório da deduplicação dos CRUDs do responsável.
- Necessário para registrar o que foi alterado nessa etapa.
- Arquivo é documentação auxiliar.

### ai/output/implementation-summary-deduplicar-feature-specs-atividades-e-fluxos-restantes.md

- Criado relatório da deduplicação de specs de atividades e fluxos restantes.
- Necessário para rastrear a etapa de refatoração.
- Arquivo é documentação auxiliar.

### ai/output/implementation-summary-deduplicar-feature-specs-bancas.md

- Criado relatório da deduplicação de specs de bancas.
- Necessário para documentar a divisão e reutilização de exemplos.
- Arquivo é documentação auxiliar.

### ai/output/implementation-summary-deduplicar-feature-specs-documentos.md

- Criado relatório da deduplicação de specs de documentos.
- Necessário para registrar os exemplos compartilhados aplicados.
- Arquivo é documentação auxiliar.

### ai/output/implementation-summary-deduplicar-show-orientacoes-supervisoes.md

- Criado relatório da deduplicação de telas show de orientações/supervisões.
- Necessário para documentar a refatoração.
- Arquivo é documentação auxiliar.

### ai/output/implementation-summary-dividir-feature-specs-bancas-e-fluxos-restantes.md

- Criado relatório da divisão de specs de bancas e fluxos restantes.
- Necessário para registrar o escopo da etapa.
- Arquivo é documentação auxiliar.

### ai/output/implementation-summary-dividir-feature-specs-orientations.md

- Criado relatório da divisão de specs de orientações.
- Necessário para documentar a reorganização dos arquivos.
- Arquivo é documentação auxiliar.

### ai/output/implementation-summary-dividir-specs-models.md

- Criado relatório da divisão de specs de models.
- Necessário para registrar a decomposição das specs grandes.
- Arquivo é documentação auxiliar.

### ai/output/implementation-summary-remover-sleeps-dos-specs.md

- Criado relatório da remoção de sleeps.
- Necessário para documentar melhorias de estabilidade.
- Arquivo é documentação auxiliar.

### ai/output/implementation-summary-revisar-estabilidade-e-limpeza-dos-specs.md

- Criado relatório da revisão de estabilidade e limpeza.
- Necessário para registrar os ajustes finais.
- Arquivo é documentação auxiliar.

### ai/tasks/deduplicar-cruds-responsible.md

- Criada tarefa de deduplicação dos CRUDs do responsável.
- Necessária para orientar execução e rastreabilidade.
- Arquivo é documentação de trabalho.

### ai/tasks/deduplicar-feature-specs-atividades-e-fluxos-restantes.md

- Criada tarefa de deduplicação de atividades e fluxos restantes.
- Necessária para orientar a refatoração.
- Arquivo é documentação de trabalho.

### ai/tasks/deduplicar-feature-specs-bancas.md

- Criada tarefa de deduplicação de specs de bancas.
- Necessária para definir escopo e critérios.
- Arquivo é documentação de trabalho.

### ai/tasks/deduplicar-feature-specs-documentos.md

- Criada tarefa de deduplicação de specs de documentos.
- Necessária para orientar a extração de exemplos compartilhados.
- Arquivo é documentação de trabalho.

### ai/tasks/deduplicar-show-orientacoes-supervisoes.md

- Criada tarefa para deduplicar telas show de orientações e supervisões.
- Necessária para orientar a reorganização dos testes.
- Arquivo é documentação de trabalho.

### ai/tasks/dividir-feature-specs-bancas-e-fluxos-restantes.md

- Criada tarefa para divisão de specs de bancas e fluxos restantes.
- Necessária para quebrar specs extensas por responsabilidade.
- Arquivo é documentação de trabalho.

### ai/tasks/dividir-feature-specs-orientations.md

- Criada tarefa para divisão de specs de orientações.
- Necessária para organizar cenários por tela/ação.
- Arquivo é documentação de trabalho.

### ai/tasks/dividir-specs-models.md

- Criada tarefa para divisão de specs de models.
- Necessária para separar responsabilidades por comportamento.
- Arquivo é documentação de trabalho.

### ai/tasks/dividir-specs-restantes-prioridade-alta.md

- Criada tarefa para specs restantes de alta prioridade.
- Necessária para planejar próximas etapas.
- Arquivo é documentação de trabalho.

### ai/tasks/mapear-refatoracoes.md

- Criada tarefa de mapeamento das refatorações.
- Necessária para organizar o backlog técnico.
- Arquivo é documentação de trabalho.

### ai/tasks/refatorar-factory-calendars-com-traits.md

- Criada tarefa não rastreada para refatorar factory de calendars com traits.
- Necessária para registrar oportunidade futura de melhoria.
- Arquivo ainda aparece como não rastreado.

### ai/tasks/remover-sleeps-dos-specs.md

- Criada tarefa para remoção de sleeps dos specs.
- Necessária para melhorar estabilidade e velocidade dos testes.
- Arquivo é documentação de trabalho.

### ai/tasks/revisar-estabilidade-e-limpeza-dos-specs.md

- Criada tarefa de revisão final de estabilidade e limpeza.
- Necessária para consolidar ajustes após refatorações.
- Arquivo é documentação de trabalho.

### spec/controllers/api/v1/orientations/orientations_controller_approved_orientations_spec.rb

- Criado spec específico para orientações aprovadas.
- Necessário para substituir parte do controller spec monolítico.
- Revisar cobertura dos filtros e respostas esperadas.

### spec/controllers/api/v1/orientations/orientations_controller_approved_tcc_one_spec.rb

- Criado spec específico para TCC I aprovado.
- Necessário para isolar comportamento do endpoint.
- Revisar cenários de permissão e payload.

### spec/controllers/api/v1/orientations/orientations_controller_tcc_one_spec.rb

- Criado spec específico para orientações de TCC I.
- Necessário para dividir responsabilidades do controller spec.
- Revisar cenários de sucesso e erro.

### spec/controllers/api/v1/orientations_controller_spec.rb

- Removido spec antigo agregado.
- Necessário porque os cenários foram distribuídos em arquivos menores.
- Confirmar que não houve perda de cobertura.

### spec/features/academics/documents/term_of_accept_institution/documents_show_spec.rb

- Atualizado para usar fluxo compartilhado de exibição de documentos.
- Necessário para reduzir duplicação.
- Validar comportamento no perfil acadêmico.

### spec/features/academics/documents/term_of_accept_institution/documents_sign_spec.rb

- Atualizado para usar fluxo compartilhado de assinatura.
- Necessário para padronizar testes de documentos.
- Validar assinatura pelo acadêmico.

### spec/features/academics/documents/term_of_commitment/documents_show_spec.rb

- Atualizado para reutilizar exemplos de exibição.
- Necessário para remover repetição.
- Validar conteúdo exibido do termo.

### spec/features/academics/documents/term_of_commitment/documents_sign_spec.rb

- Atualizado para reutilizar exemplos de assinatura.
- Necessário para padronizar o teste.
- Validar estado após assinatura.

### spec/features/academics/examination_boards/examination_boards_show_academic_activity_spec.rb

- Criado spec para seção de atividade acadêmica da banca.
- Necessário para dividir o show de bancas.
- Revisar dados exibidos da atividade.

### spec/features/academics/examination_boards/examination_boards_show_appointments_spec.rb

- Criado spec para agendamentos da banca.
- Necessário para separar responsabilidade da tela.
- Revisar data, horário e local.

### spec/features/academics/examination_boards/examination_boards_show_basic_information_spec.rb

- Criado spec para informações básicas da banca.
- Necessário para substituir parte do spec antigo.
- Revisar campos principais exibidos.

### spec/features/academics/examination_boards/examination_boards_show_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão em specs menores.
- Confirmar equivalência da cobertura.

### spec/features/academics/orientations/orientations_activities_index_spec.rb

- Criado spec para listagem de atividades da orientação.
- Necessário para separar index e show.
- Revisar navegação e filtros.

### spec/features/academics/orientations/orientations_activities_show_spec.rb

- Criado spec para detalhe de atividade da orientação.
- Necessário para isolar cenário de exibição.
- Revisar conteúdo exibido.

### spec/features/academics/orientations/orientations_activities_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão por tela.
- Confirmar que index e show cobrem os cenários antigos.

### spec/features/academics/orientations/orientations_documents_index_spec.rb

- Criado spec para listagem de documentos da orientação.
- Necessário para separar responsabilidades.
- Revisar documentos listados.

### spec/features/academics/orientations/orientations_documents_show_spec.rb

- Criado spec para exibição de documento da orientação.
- Necessário para isolar o fluxo.
- Revisar permissões e conteúdo.

### spec/features/academics/orientations/orientations_documents_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão em index/show.
- Confirmar cobertura equivalente.

### spec/features/external_members/activities/activities_show_spec.rb

- Atualizado para usar exemplos compartilhados de atividade.
- Necessário para reduzir duplicação.
- Revisar comportamento para membro externo.

### spec/features/external_members/documents/term_of_accept_institution/documents_show_spec.rb

- Atualizado para reutilizar exemplo compartilhado de exibição.
- Necessário para padronizar specs de documentos.
- Validar acesso do membro externo.

### spec/features/external_members/documents/term_of_accept_institution/documents_sign_spec.rb

- Atualizado para reutilizar exemplo compartilhado de assinatura.
- Necessário para reduzir duplicação.
- Validar assinatura por membro externo.

### spec/features/external_members/documents/term_of_commitment/documents_show_spec.rb

- Atualizado para usar fluxo compartilhado.
- Necessário para padronizar cobertura.
- Revisar conteúdo exibido.

### spec/features/external_members/documents/term_of_commitment/documents_sign_spec.rb

- Atualizado para usar fluxo compartilhado.
- Necessário para reduzir repetição.
- Revisar estado do documento assinado.

### spec/features/external_members/examination_boards/examination_boards_show_appointments_spec.rb

- Criado spec para agendamentos de banca.
- Necessário para dividir o show.
- Revisar dados de agendamento.

### spec/features/external_members/examination_boards/examination_boards_show_basic_information_spec.rb

- Criado spec para informações básicas de banca.
- Necessário para substituir parte do spec antigo.
- Revisar campos visíveis ao membro externo.

### spec/features/external_members/examination_boards/examination_boards_show_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão do show.
- Confirmar cobertura equivalente.

### spec/features/external_members/supervisions/supervisions_activities_index_spec.rb

- Criado spec para listagem de atividades de supervisão.
- Necessário para separar index e show.
- Revisar navegação.

### spec/features/external_members/supervisions/supervisions_activities_show_spec.rb

- Criado spec para detalhe de atividade de supervisão.
- Necessário para isolar o cenário.
- Revisar conteúdo exibido.

### spec/features/external_members/supervisions/supervisions_activities_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/features/external_members/supervisions/supervisions_documents_index_spec.rb

- Criado spec para listagem de documentos de supervisão.
- Necessário para separar responsabilidades.
- Revisar documentos exibidos.

### spec/features/external_members/supervisions/supervisions_documents_show_spec.rb

- Criado spec para detalhe de documento de supervisão.
- Necessário para isolar o fluxo.
- Revisar acesso e conteúdo.

### spec/features/external_members/supervisions/supervisions_documents_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/features/external_members/supervisions/supervisions_show_basic_information_spec.rb

- Criado spec para informações básicas da supervisão.
- Necessário para dividir o show.
- Revisar campos principais.

### spec/features/external_members/supervisions/supervisions_show_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão por seções.
- Confirmar cobertura equivalente.

### spec/features/external_members/supervisions/supervisions_show_tcc_one_spec.rb

- Criado spec para supervisão de TCC I.
- Necessário para separar comportamentos por etapa.
- Revisar regras específicas de TCC I.

### spec/features/external_members/supervisions/supervisions_show_tcc_two_spec.rb

- Criado spec para supervisão de TCC II.
- Necessário para separar comportamentos por etapa.
- Revisar regras específicas de TCC II.

### spec/features/professors/activities/activities_show_spec.rb

- Atualizado para usar exemplo compartilhado de atividade.
- Necessário para reduzir duplicação.
- Revisar perfil professor.

### spec/features/professors/documents/term_of_accept_institution/documents_show_spec.rb

- Atualizado para reutilizar exemplo compartilhado.
- Necessário para padronizar documentos.
- Revisar conteúdo exibido.

### spec/features/professors/documents/term_of_accept_institution/documents_sign_spec.rb

- Atualizado para reutilizar exemplo compartilhado.
- Necessário para reduzir duplicação.
- Revisar assinatura pelo professor.

### spec/features/professors/documents/term_of_commitment/documents_show_spec.rb

- Atualizado para usar fluxo compartilhado.
- Necessário para padronizar specs.
- Revisar dados exibidos.

### spec/features/professors/documents/term_of_commitment/documents_sign_spec.rb

- Atualizado para usar fluxo compartilhado.
- Necessário para reduzir duplicação.
- Revisar estado assinado.

### spec/features/professors/examination_boards/examination_boards_show_academic_activity_spec.rb

- Criado spec para atividade acadêmica da banca.
- Necessário para dividir o show.
- Revisar dados exibidos.

### spec/features/professors/examination_boards/examination_boards_show_appointments_spec.rb

- Criado spec para agendamentos da banca.
- Necessário para isolar a seção.
- Revisar data, horário e local.

### spec/features/professors/examination_boards/examination_boards_show_basic_information_spec.rb

- Criado spec para informações básicas da banca.
- Necessário para substituir parte do spec antigo.
- Revisar campos principais.

### spec/features/professors/examination_boards/examination_boards_show_defense_minutes_spec.rb

- Criado spec para ata de defesa.
- Necessário para cobrir seção específica do professor.
- Revisar regras de disponibilidade da ata.

### spec/features/professors/examination_boards/examination_boards_show_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão por seções.
- Confirmar cobertura equivalente.

### spec/features/professors/orientations/orientations_activities_index_spec.rb

- Criado spec para listagem de atividades.
- Necessário para dividir fluxo de atividades.
- Revisar navegação.

### spec/features/professors/orientations/orientations_activities_show_spec.rb

- Criado spec para detalhe de atividade.
- Necessário para isolar cenário de show.
- Revisar conteúdo exibido.

### spec/features/professors/orientations/orientations_activities_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/features/professors/orientations/orientations_documents_index_spec.rb

- Criado spec para listagem de documentos.
- Necessário para separar index e show.
- Revisar documentos listados.

### spec/features/professors/orientations/orientations_documents_show_spec.rb

- Renomeado/ajustado para cobrir exibição de documentos.
- Necessário para refletir melhor o escopo.
- Confirmar que a cobertura antiga foi preservada.

### spec/features/professors/orientations/orientations_history_index_spec.rb

- Criado spec para histórico de orientações.
- Necessário para isolar fluxo de histórico.
- Revisar ordenação e dados exibidos.

### spec/features/professors/orientations/orientations_index_actions_spec.rb

- Criado spec para ações do index.
- Necessário para separar ações de listagens TCC I/TCC II.
- Revisar botões e permissões.

### spec/features/professors/orientations/orientations_index_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão do index.
- Confirmar cobertura equivalente.

### spec/features/professors/orientations/orientations_index_tcc_one_spec.rb

- Criado spec para index de TCC I.
- Necessário para isolar comportamento por etapa.
- Revisar listagem e filtros.

### spec/features/professors/orientations/orientations_index_tcc_two_spec.rb

- Criado spec para index de TCC II.
- Necessário para isolar comportamento por etapa.
- Revisar listagem e filtros.

### spec/features/professors/orientations/orientations_show_basic_information_spec.rb

- Criado spec para informações básicas da orientação.
- Necessário para dividir tela show.
- Revisar campos principais.

### spec/features/professors/orientations/orientations_show_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão por seções.
- Confirmar cobertura equivalente.

### spec/features/professors/orientations/orientations_show_tcc_one_spec.rb

- Criado spec para show de orientação TCC I.
- Necessário para separar regras por etapa.
- Revisar cenários específicos.

### spec/features/professors/orientations/orientations_show_tcc_two_spec.rb

- Criado spec para show de orientação TCC II.
- Necessário para separar regras por etapa.
- Revisar cenários específicos.

### spec/features/professors/supervisions/supervisions_activities_index_spec.rb

- Criado spec para listagem de atividades de supervisão.
- Necessário para dividir fluxo.
- Revisar navegação.

### spec/features/professors/supervisions/supervisions_activities_show_spec.rb

- Criado spec para detalhe de atividade de supervisão.
- Necessário para isolar show.
- Revisar conteúdo exibido.

### spec/features/professors/supervisions/supervisions_activities_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/features/professors/supervisions/supervisions_documents_index_spec.rb

- Renomeado/ajustado para listagem de documentos.
- Necessário para separar index e show.
- Revisar documentos listados.

### spec/features/professors/supervisions/supervisions_documents_show_spec.rb

- Criado spec para exibição de documentos.
- Necessário para cobrir detalhe separadamente.
- Revisar conteúdo e permissões.

### spec/features/professors/supervisions/supervisions_index_spec.rb

- Atualizado após reorganização das supervisões.
- Necessário para manter cobertura do index.
- Revisar cenários de listagem.

### spec/features/professors/supervisions/supervisions_show_basic_information_spec.rb

- Criado spec para informações básicas.
- Necessário para dividir tela show.
- Revisar campos principais.

### spec/features/professors/supervisions/supervisions_show_tcc_one_spec.rb

- Criado spec para show de supervisão TCC I.
- Necessário para isolar regras por etapa.
- Revisar comportamento específico.

### spec/features/professors/supervisions/supervisions_show_tcc_two_spec.rb

- Renomeado/ajustado para show de supervisão TCC II.
- Necessário para refletir o escopo do arquivo.
- Confirmar cobertura equivalente ao spec antigo.

### spec/features/responsible/academics/academics_create_spec.rb

- Atualizado para usar exemplo compartilhado de CRUD.
- Necessário para reduzir duplicação.
- Revisar fluxo de criação.

### spec/features/responsible/academics/academics_destroy_spec.rb

- Atualizado para usar exemplo compartilhado de CRUD.
- Necessário para padronizar destruição.
- Revisar exclusão e mensagens.

### spec/features/responsible/academics/academics_search_spec.rb

- Atualizado para usar padrões compartilhados.
- Necessário para reduzir repetição.
- Revisar busca por acadêmicos.

### spec/features/responsible/academics/academics_update_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para padronizar edição.
- Revisar atualização de campos.

### spec/features/responsible/activities/activities_create_spec.rb

- Atualizado para usar helper/exemplo compartilhado.
- Necessário para reduzir duplicação.
- Revisar criação de atividades.

### spec/features/responsible/activities/activities_index_spec.rb

- Atualizado para estabilizar listagem.
- Necessário para limpar duplicações e esperas frágeis.
- Revisar ordenação/listagem.

### spec/features/responsible/activities/activities_show_spec.rb

- Atualizado para usar exemplo compartilhado de show.
- Necessário para padronizar cobertura.
- Revisar conteúdo exibido.

### spec/features/responsible/activities/activities_update_spec.rb

- Atualizado para usar padrão compartilhado.
- Necessário para reduzir duplicação.
- Revisar edição de atividade.

### spec/features/responsible/attached_documents/attached_documents_create_spec.rb

- Atualizado para usar exemplo compartilhado de CRUD.
- Necessário para padronizar criação.
- Revisar upload/criação.

### spec/features/responsible/attached_documents/attached_documents_destroy_spec.rb

- Atualizado para usar exemplo compartilhado de CRUD.
- Necessário para padronizar remoção.
- Revisar exclusão.

### spec/features/responsible/attached_documents/attached_documents_update_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para reduzir repetição.
- Revisar atualização.

### spec/features/responsible/base_activities/base_activities_create_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para deduplicar CRUD.
- Revisar criação.

### spec/features/responsible/base_activities/base_activities_destroy_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para padronizar remoção.
- Revisar exclusão.

### spec/features/responsible/base_activities/base_activities_update_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para reduzir duplicação.
- Revisar edição.

### spec/features/responsible/calendars/calendars_search_spec.rb

- Atualizado para estabilizar/padronizar busca.
- Necessário para reduzir repetição.
- Revisar resultados de busca.

### spec/features/responsible/calendars/calendars_show_spec.rb

- Atualizado para limpar fluxo de show.
- Necessário para melhorar estabilidade.
- Revisar dados exibidos.

### spec/features/responsible/calendars/calendars_update_spec.rb

- Atualizado para padronizar edição.
- Necessário para reduzir duplicação.
- Revisar atualização.

### spec/features/responsible/documents/documents_review_spec.rb

- Atualizado para melhorar estabilidade do fluxo de revisão.
- Necessário para remover dependências frágeis.
- Revisar aprovação/reprovação.

### spec/features/responsible/examination_boards/examination_boards_create_tcc_one_spec.rb

- Atualizado para usar exemplos/contextos compartilhados.
- Necessário para reduzir duplicação.
- Revisar criação de banca TCC I.

### spec/features/responsible/examination_boards/examination_boards_create_tcc_two_spec.rb

- Atualizado para usar exemplos/contextos compartilhados.
- Necessário para reduzir duplicação.
- Revisar criação de banca TCC II.

### spec/features/responsible/examination_boards/examination_boards_show_academic_activity_spec.rb

- Criado spec para atividade acadêmica da banca.
- Necessário para dividir show.
- Revisar dados exibidos.

### spec/features/responsible/examination_boards/examination_boards_show_appointments_spec.rb

- Criado spec para agendamentos da banca.
- Necessário para isolar seção.
- Revisar data, horário e local.

### spec/features/responsible/examination_boards/examination_boards_show_basic_information_spec.rb

- Criado spec para informações básicas da banca.
- Necessário para substituir parte do spec antigo.
- Revisar campos principais.

### spec/features/responsible/examination_boards/examination_boards_show_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/features/responsible/external_members/external_members_create_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para deduplicar CRUD.
- Revisar criação.

### spec/features/responsible/external_members/external_members_destroy_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para padronizar exclusão.
- Revisar remoção.

### spec/features/responsible/external_members/external_members_search_spec.rb

- Atualizado para usar padrão compartilhado.
- Necessário para reduzir duplicação.
- Revisar busca.

### spec/features/responsible/external_members/external_members_update_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para padronizar edição.
- Revisar atualização.

### spec/features/responsible/institutions/institutions_create_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para deduplicar CRUD.
- Revisar criação.

### spec/features/responsible/institutions/institutions_destroy_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para padronizar exclusão.
- Revisar remoção.

### spec/features/responsible/institutions/institutions_search_spec.rb

- Atualizado para usar padrão compartilhado.
- Necessário para reduzir duplicação.
- Revisar busca.

### spec/features/responsible/institutions/institutions_update_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para padronizar edição.
- Revisar atualização.

### spec/features/responsible/orientations/orientations_activities_index_spec.rb

- Criado spec para listagem de atividades.
- Necessário para dividir spec agregado.
- Revisar navegação.

### spec/features/responsible/orientations/orientations_activities_show_spec.rb

- Criado spec para detalhe de atividade.
- Necessário para isolar show.
- Revisar conteúdo.

### spec/features/responsible/orientations/orientations_activities_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/features/responsible/orientations/orientations_documents_index_spec.rb

- Renomeado/ajustado para listagem de documentos.
- Necessário para separar index e show.
- Revisar documentos listados.

### spec/features/responsible/orientations/orientations_documents_show_spec.rb

- Criado spec para exibição de documentos.
- Necessário para cobrir detalhe separadamente.
- Revisar conteúdo e permissões.

### spec/features/responsible/orientations/orientations_index_actions_spec.rb

- Renomeado/ajustado para ações do index.
- Necessário para separar ações das listagens.
- Revisar botões e permissões.

### spec/features/responsible/orientations/orientations_index_tcc_one_spec.rb

- Criado spec para index TCC I.
- Necessário para separar comportamento por etapa.
- Revisar listagem.

### spec/features/responsible/orientations/orientations_index_tcc_two_spec.rb

- Criado spec para index TCC II.
- Necessário para separar comportamento por etapa.
- Revisar listagem.

### spec/features/responsible/orientations/orientations_search_spec.rb

- Atualizado para acompanhar reorganização dos specs.
- Necessário para manter busca consistente.
- Revisar filtros/resultados.

### spec/features/responsible/orientations/orientations_show_current_tcc_one_spec.rb

- Criado spec para orientação atual de TCC I.
- Necessário para isolar cenário específico.
- Revisar dados exibidos.

### spec/features/responsible/orientations/orientations_show_current_tcc_two_spec.rb

- Criado spec para orientação atual de TCC II.
- Necessário para isolar cenário específico.
- Revisar dados exibidos.

### spec/features/responsible/orientations/orientations_show_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão por seções/cenários.
- Confirmar cobertura equivalente.

### spec/features/responsible/orientations/orientations_show_tcc_one_spec.rb

- Criado spec para show de orientação TCC I.
- Necessário para separar comportamento por etapa.
- Revisar regras específicas.

### spec/features/responsible/pages/pages_create_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para deduplicar CRUD.
- Revisar criação.

### spec/features/responsible/pages/pages_destroy_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para padronizar remoção.
- Revisar exclusão.

### spec/features/responsible/pages/pages_update_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para padronizar edição.
- Revisar atualização.

### spec/features/responsible/professors/professors_create_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para deduplicar CRUD.
- Revisar criação.

### spec/features/responsible/professors/professors_destroy_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para padronizar exclusão.
- Revisar remoção.

### spec/features/responsible/professors/professors_search_spec.rb

- Atualizado para usar padrão compartilhado.
- Necessário para reduzir duplicação.
- Revisar busca.

### spec/features/responsible/professors/professors_update_spec.rb

- Atualizado para usar exemplo compartilhado.
- Necessário para padronizar edição.
- Revisar atualização.

### spec/features/tcc_one_professors/activities/activities_show_spec.rb

- Atualizado para usar exemplo compartilhado de atividade.
- Necessário para reduzir duplicação.
- Revisar perfil professor TCC I.

### spec/features/tcc_one_professors/calendars/calendars_index_spec.rb

- Atualizado para melhorar estabilidade da listagem.
- Necessário para limpar fluxo do spec.
- Revisar calendário exibido.

### spec/features/tcc_one_professors/examination_boards/examination_boards_create_spec.rb

- Atualizado para usar contexto/exemplo compartilhado.
- Necessário para reduzir duplicação.
- Revisar criação de banca.

### spec/features/tcc_one_professors/examination_boards/examination_boards_show_academic_activity_spec.rb

- Criado spec para atividade acadêmica da banca.
- Necessário para dividir show.
- Revisar dados exibidos.

### spec/features/tcc_one_professors/examination_boards/examination_boards_show_appointments_spec.rb

- Criado spec para agendamentos da banca.
- Necessário para isolar seção.
- Revisar agendamento.

### spec/features/tcc_one_professors/examination_boards/examination_boards_show_basic_information_spec.rb

- Criado spec para informações básicas da banca.
- Necessário para substituir parte do spec antigo.
- Revisar campos principais.

### spec/features/tcc_one_professors/examination_boards/examination_boards_show_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/features/tcc_one_professors/orientations/orientations_activities_index_spec.rb

- Criado spec para listagem de atividades.
- Necessário para dividir fluxo.
- Revisar navegação.

### spec/features/tcc_one_professors/orientations/orientations_activities_show_spec.rb

- Criado spec para detalhe de atividade.
- Necessário para isolar show.
- Revisar conteúdo.

### spec/features/tcc_one_professors/orientations/orientations_activities_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/features/tcc_one_professors/orientations/orientations_documents_index_spec.rb

- Criado spec para listagem de documentos.
- Necessário para separar index e show.
- Revisar documentos listados.

### spec/features/tcc_one_professors/orientations/orientations_documents_show_spec.rb

- Criado spec para exibição de documentos.
- Necessário para cobrir detalhe separadamente.
- Revisar conteúdo e acesso.

### spec/features/tcc_one_professors/orientations/orientations_documents_spec.rb

- Removido spec antigo agregado.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/features/tcc_one_professors/orientations/orientations_show_spec.rb

- Atualizado para acompanhar refatoração dos fluxos.
- Necessário para manter cobertura específica do perfil.
- Revisar cenários remanescentes.

### spec/models/academic_spec.rb

- Removido spec antigo agregado de Academic.
- Necessário após divisão por responsabilidade.
- Confirmar cobertura equivalente nos novos arquivos.

### spec/models/academics/academic_documents_spec.rb

- Criado spec para documentos do acadêmico.
- Necessário para isolar associações/comportamentos.
- Revisar cenários de documentos.

### spec/models/academics/academic_ldap_spec.rb

- Criado spec para integração/resolução LDAP do acadêmico.
- Necessário para separar regra específica.
- Revisar cenários com LDAP.

### spec/models/academics/academic_search_spec.rb

- Criado spec para busca de acadêmicos.
- Necessário para isolar escopo de pesquisa.
- Revisar filtros.

### spec/models/academics/academic_terms_spec.rb

- Criado spec para termos relacionados ao acadêmico.
- Necessário para separar comportamento.
- Revisar regras de termos.

### spec/models/academics/academic_validations_spec.rb

- Criado spec para validações de Academic.
- Necessário para dividir o model spec antigo.
- Revisar validações obrigatórias.

### spec/models/activity_spec.rb

- Removido spec antigo agregado de Activity.
- Necessário após divisão por comportamento.
- Confirmar cobertura equivalente.

### spec/models/activities/activity_academic_responses_spec.rb

- Criado spec para respostas acadêmicas de atividades.
- Necessário para isolar comportamento específico.
- Revisar regras de resposta.

### spec/models/activities/activity_deadlines_spec.rb

- Criado spec para prazos de atividades.
- Necessário para separar lógica temporal.
- Revisar cenários de deadline.

### spec/models/activities/activity_enums_spec.rb

- Criado spec para enums de Activity.
- Necessário para isolar contratos de valores.
- Revisar nomes e valores esperados.

### spec/models/activities/activity_notifications_spec.rb

- Criado spec para notificações de atividades.
- Necessário para separar callbacks/efeitos.
- Revisar envio esperado.

### spec/models/activities/activity_validations_spec.rb

- Criado spec para validações de Activity.
- Necessário para dividir spec antigo.
- Revisar validações obrigatórias.

### spec/models/base_activities/base_activity_filters_spec.rb

- Criado spec para filtros de BaseActivity.
- Necessário para separar comportamento de consulta.
- Revisar filtros disponíveis.

### spec/models/base_activities/base_activity_formatting_spec.rb

- Criado spec para formatações de BaseActivity.
- Necessário para isolar métodos de apresentação.
- Revisar strings formatadas.

### spec/models/base_activities/base_activity_search_spec.rb

- Renomeado/ajustado para busca de BaseActivity.
- Necessário para refletir escopo específico.
- Confirmar cobertura antiga preservada.

### spec/models/base_activities/base_activity_validations_spec.rb

- Criado spec para validações de BaseActivity.
- Necessário para dividir spec antigo.
- Revisar validações.

### spec/models/document_spec.rb

- Removido spec antigo agregado de Document.
- Necessário após divisão por responsabilidade.
- Confirmar cobertura equivalente.

### spec/models/documents/document_callbacks_spec.rb

- Criado spec para callbacks de Document.
- Necessário para isolar efeitos automáticos.
- Revisar efeitos colaterais esperados.

### spec/models/documents/document_generation_spec.rb

- Criado spec para geração de documentos.
- Necessário para separar lógica de criação.
- Revisar geração de arquivos/conteúdo.

### spec/models/documents/document_review_spec.rb

- Criado spec para revisão de documentos.
- Necessário para isolar regras de review.
- Revisar aprovação/reprovação.

### spec/models/documents/document_serialization_spec.rb

- Criado spec para serialização de documentos.
- Necessário para proteger formato de saída.
- Revisar campos serializados.

### spec/models/documents/document_signatures_spec.rb

- Criado spec para assinaturas de documentos.
- Necessário para separar associações/regras.
- Revisar fluxo de assinatura.

### spec/models/documents/document_status_spec.rb

- Criado spec para status de documentos.
- Necessário para isolar transições/estados.
- Revisar estados esperados.

### spec/models/documents/document_validations_spec.rb

- Criado spec para validações de Document.
- Necessário para dividir spec antigo.
- Revisar validações obrigatórias.

### spec/models/examination_board_notes/examination_board_note_approval_spec.rb

- Renomeado/ajustado para aprovação de nota de banca.
- Necessário para refletir escopo específico.
- Confirmar cobertura antiga preservada.

### spec/models/examination_board_notes/examination_board_note_notifications_spec.rb

- Criado spec para notificações de notas de banca.
- Necessário para isolar efeitos.
- Revisar notificações disparadas.

### spec/models/examination_board_notes/examination_board_note_validations_spec.rb

- Criado spec para validações de notas de banca.
- Necessário para separar responsabilidade.
- Revisar validações.

### spec/models/examination_board_spec.rb

- Removido spec antigo agregado de ExaminationBoard.
- Necessário após divisão por comportamento.
- Confirmar cobertura equivalente.

### spec/models/examination_boards/examination_board_appointments_spec.rb

- Criado spec para agendamentos de banca.
- Necessário para isolar regras de agenda.
- Revisar conflitos e campos.

### spec/models/examination_boards/examination_board_callbacks_spec.rb

- Criado spec para callbacks de banca.
- Necessário para separar efeitos automáticos.
- Revisar efeitos esperados.

### spec/models/examination_boards/examination_board_confirmation_spec.rb

- Criado spec para confirmação de banca.
- Necessário para isolar fluxo de confirmação.
- Revisar regras de confirmação.

### spec/models/examination_boards/examination_board_evaluators_spec.rb

- Criado spec para avaliadores da banca.
- Necessário para separar regras de membros.
- Revisar composição da banca.

### spec/models/examination_boards/examination_board_search_spec.rb

- Criado spec para busca de bancas.
- Necessário para isolar consultas.
- Revisar filtros.

### spec/models/examination_boards/examination_board_status_spec.rb

- Criado spec para status de banca.
- Necessário para separar estados/transições.
- Revisar estados esperados.

### spec/models/examination_boards/examination_board_validations_spec.rb

- Criado spec para validações de banca.
- Necessário para dividir spec antigo.
- Revisar validações.

### spec/models/external_member_spec.rb

- Removido spec antigo agregado de ExternalMember.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/models/external_members/external_member_documents_spec.rb

- Criado spec para documentos de membro externo.
- Necessário para isolar associações.
- Revisar documentos relacionados.

### spec/models/external_members/external_member_examination_boards_spec.rb

- Criado spec para bancas de membro externo.
- Necessário para separar comportamento.
- Revisar vínculos com bancas.

### spec/models/external_members/external_member_search_spec.rb

- Criado spec para busca de membros externos.
- Necessário para isolar consultas.
- Revisar filtros.

### spec/models/external_members/external_member_supervisions_spec.rb

- Criado spec para supervisões de membro externo.
- Necessário para separar associações.
- Revisar vínculos com supervisões.

### spec/models/external_members/external_member_validations_spec.rb

- Criado spec para validações de ExternalMember.
- Necessário para dividir spec antigo.
- Revisar validações.

### spec/models/institutions/institution_cnpj_spec.rb

- Criado spec para regras de CNPJ de Institution.
- Necessário para isolar validação/formatação.
- Revisar CNPJs válidos e inválidos.

### spec/models/institutions/institution_search_spec.rb

- Renomeado/ajustado para busca de instituições.
- Necessário para refletir escopo específico.
- Confirmar cobertura antiga preservada.

### spec/models/institutions/institution_validations_spec.rb

- Criado spec para validações de Institution.
- Necessário para dividir spec antigo.
- Revisar validações.

### spec/models/notification_spec.rb

- Removido spec antigo agregado de Notification.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/models/notifications/notification_callbacks_spec.rb

- Criado spec para callbacks de Notification.
- Necessário para isolar efeitos automáticos.
- Revisar callbacks esperados.

### spec/models/notifications/notification_definitions_spec.rb

- Criado spec para definições de notificações.
- Necessário para proteger contratos.
- Revisar tipos/definições.

### spec/models/notifications/notification_delivery_spec.rb

- Criado spec para entrega de notificações.
- Necessário para separar fluxo de envio.
- Revisar entrega esperada.

### spec/models/notifications/notification_failure_spec.rb

- Criado spec para falhas de notificação.
- Necessário para cobrir comportamento de erro.
- Revisar tratamento de falhas.

### spec/models/notifications/notification_scopes_spec.rb

- Criado spec para scopes de Notification.
- Necessário para isolar consultas.
- Revisar escopos.

### spec/models/orientation_spec.rb

- Removido spec antigo agregado de Orientation.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/models/orientations/orientation_academic_activities_spec.rb

- Criado spec para atividades acadêmicas da orientação.
- Necessário para separar comportamento.
- Revisar associações e regras.

### spec/models/orientations/orientation_calendar_spec.rb

- Criado spec para calendário da orientação.
- Necessário para isolar regras relacionadas.
- Revisar vínculos com calendário.

### spec/models/orientations/orientation_cancellation_spec.rb

- Criado spec para cancelamento de orientação.
- Necessário para separar fluxo específico.
- Revisar estados após cancelamento.

### spec/models/orientations/orientation_documents_spec.rb

- Criado spec para documentos da orientação.
- Necessário para isolar associações.
- Revisar documentos gerados/listados.

### spec/models/orientations/orientation_migration_spec.rb

- Criado spec para migração de orientação.
- Necessário para cobrir mudança entre etapas/estados.
- Revisar regras de migração.

### spec/models/orientations/orientation_ordering_spec.rb

- Criado spec para ordenação de orientações.
- Necessário para proteger comportamento de listagem.
- Revisar critérios de ordenação.

### spec/models/orientations/orientation_status_spec.rb

- Criado spec para status de orientação.
- Necessário para isolar estados/transições.
- Revisar estados esperados.

### spec/models/orientations/orientation_validations_spec.rb

- Criado spec para validações de Orientation.
- Necessário para dividir spec antigo.
- Revisar validações.

### spec/models/professor_spec.rb

- Removido spec antigo agregado de Professor.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/models/professors/professor_documents_spec.rb

- Criado spec para documentos do professor.
- Necessário para isolar associações.
- Revisar documentos relacionados.

### spec/models/professors/professor_examination_boards_spec.rb

- Criado spec para bancas do professor.
- Necessário para separar comportamento.
- Revisar vínculos com bancas.

### spec/models/professors/professor_orientations_spec.rb

- Criado spec para orientações do professor.
- Necessário para separar associações/regras.
- Revisar vínculos com orientações.

### spec/models/professors/professor_roles_spec.rb

- Criado spec para papéis do professor.
- Necessário para isolar permissões/funções.
- Revisar regras de role.

### spec/models/professors/professor_search_spec.rb

- Criado spec para busca de professores.
- Necessário para isolar consultas.
- Revisar filtros.

### spec/models/professors/professor_validations_spec.rb

- Criado spec para validações de Professor.
- Necessário para dividir spec antigo.
- Revisar validações.

### spec/models/signature_spec.rb

- Removido spec antigo agregado de Signature.
- Necessário após divisão.
- Confirmar cobertura equivalente.

### spec/models/signatures/signature_signing_spec.rb

- Criado spec para assinatura.
- Necessário para isolar fluxo principal.
- Revisar efeitos ao assinar.

### spec/models/signatures/signature_table_resolution_spec.rb

- Criado spec para resolução de tabela da assinatura.
- Necessário para proteger regra específica.
- Revisar tabelas resolvidas.

### spec/models/signatures/signature_user_resolution_spec.rb

- Criado spec para resolução de usuário da assinatura.
- Necessário para separar comportamento.
- Revisar usuários resolvidos.

### spec/models/signatures/signature_validations_spec.rb

- Criado spec para validações de Signature.
- Necessário para dividir spec antigo.
- Revisar validações.

### spec/support/activities/activity_show_examples.rb

- Criado exemplo compartilhado para exibição de atividades.
- Necessário para deduplicar specs de múltiplos perfis.
- Revisar se cobre variações de permissão.

### spec/support/documents/document_show_examples.rb

- Criado exemplo compartilhado para exibição de documentos.
- Necessário para reduzir repetição entre perfis.
- Revisar parâmetros usados pelos specs.

### spec/support/documents/document_sign_examples.rb

- Criado exemplo compartilhado para assinatura de documentos.
- Necessário para padronizar o fluxo.
- Revisar cenários de sucesso/erro.

### spec/support/examination_boards/examination_board_contexts.rb

- Criados contextos compartilhados de bancas.
- Necessário para reduzir setup duplicado.
- Revisar factories e dados comuns.

### spec/support/examination_boards/examination_board_create_examples.rb

- Criado exemplo compartilhado para criação de bancas.
- Necessário para deduplicar specs de criação.
- Revisar variações TCC I/TCC II.

### spec/support/examination_boards/examination_board_show_examples.rb

- Criado exemplo compartilhado para show de bancas.
- Necessário para padronizar seções exibidas.
- Revisar diferenças por perfil.

### spec/support/helpers/form.rb

- Atualizado helper de formulário.
- Necessário para apoiar specs refatorados.
- Revisar compatibilidade com usos existentes.

### spec/support/orientations/orientation_activity_show_examples.rb

- Criado exemplo compartilhado para show de atividades de orientação/supervisão.
- Necessário para reduzir duplicação.
- Revisar parâmetros por perfil.

### spec/support/orientations/orientation_document_show_examples.rb

- Criado exemplo compartilhado para documentos de orientação/supervisão.
- Necessário para padronizar fluxo.
- Revisar acesso e conteúdo.

### spec/support/orientations/orientation_index_examples.rb

- Criado exemplo compartilhado para index de orientações.
- Necessário para deduplicar listagens e ações.
- Revisar variações TCC I/TCC II.

### spec/support/orientations/orientation_show_examples.rb

- Criado exemplo compartilhado para show de orientações/supervisões.
- Necessário para reduzir repetição entre perfis.
- Revisar diferenças entre orientação e supervisão.

### spec/support/responsible/responsible_crud_examples.rb

- Criado exemplo compartilhado para CRUDs do responsável.
- Necessário para deduplicar specs de create/update/destroy/search.
- Revisar se todos os recursos cobertos passam os dados corretos.

## Review Notes

Revisar principalmente se a divisão dos specs preservou a cobertura dos arquivos removidos/renomeados e executar a suíte RSpec, com atenção especial aos fluxos de documentos, bancas, orientações, supervisões e CRUDs do responsável. O relatório foi gerado sem diff disponível, então as descrições acima se baseiam nos nomes e status dos arquivos.