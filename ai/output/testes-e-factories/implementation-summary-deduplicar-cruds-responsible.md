# Implementation Summary

## General Summary

Foi feita uma deduplicação conservadora dos specs de CRUD da área `responsible`, centralizando padrões repetidos de validação de formulário, busca sem resultados e exclusão com sucesso.

Os cenários existentes foram preservados: os exemplos continuam cobrindo os mesmos fluxos de create, update, destroy e search, mantendo explícitos os campos, mensagens e diferenças específicas de cada recurso.

Comparação antes/depois:
- Grupo Pessoas (`academics`, `professors`, `external_members`): quantidade de exemplos preservada; cenários de validação, busca e exclusão mantidos.
- Grupo Cadastros auxiliares (`institutions`, `pages`, `attached_documents`): quantidade de exemplos preservada; validações e exclusões deduplicadas.
- Grupo Atividades e calendários (`base_activities`, `activities`, `calendars`): quantidade de exemplos preservada; validações, busca sem resultado e destroy deduplicados quando o padrão era claro.

## Changed Files

### spec/features/responsible/academics/academics_create_spec.rb

- Substituiu expectativas repetidas de formulário inválido por shared example de erros em branco.
- Necessário para reduzir duplicação sem alterar os campos validados.
- Mantidos os seletores específicos de acadêmico.

### spec/features/responsible/academics/academics_destroy_spec.rb

- Substituiu o fluxo repetido de exclusão com sucesso por shared example.
- Necessário para centralizar clique, confirmação, flash e ausência do registro.
- Mantida a mensagem masculina `destroy.m`.

### spec/features/responsible/academics/academics_search_spec.rb

- Substituiu o cenário repetido de busca sem resultado por shared example.
- Necessário para reutilizar a mesma expectativa de `no_results_message`.
- Mantido o termo de busca original.

### spec/features/responsible/academics/academics_update_spec.rb

- Substituiu limpeza de campos e expectativas de erro por shared example de update inválido.
- Necessário para reduzir repetição em validações de edição.
- Mantidos os campos `name`, `email` e `ra`.

### spec/features/responsible/professors/professors_create_spec.rb

- Centralizou as expectativas de campos obrigatórios em shared example.
- Necessário para reduzir duplicação no formulário de criação.
- Mantidos todos os campos específicos de professor.

### spec/features/responsible/professors/professors_destroy_spec.rb

- Centralizou o fluxo de destroy com sucesso.
- Necessário para reaproveitar o padrão comum de exclusão.
- Mantida a mensagem `destroy.m`.

### spec/features/responsible/professors/professors_search_spec.rb

- Centralizou o cenário de busca sem resultados.
- Necessário para reduzir repetição entre buscas administrativas.
- Mantido o termo inválido original.

### spec/features/responsible/professors/professors_update_spec.rb

- Centralizou o fluxo de update inválido.
- Necessário para reaproveitar preenchimento vazio e expectativas de erro.
- Mantidos os campos específicos de professor.

### spec/features/responsible/external_members/external_members_create_spec.rb

- Centralizou expectativas de validação obrigatória.
- Necessário para reduzir repetição no fluxo de criação inválida.
- Mantidos os campos específicos de membro externo.

### spec/features/responsible/external_members/external_members_destroy_spec.rb

- Centralizou o cenário de exclusão com sucesso.
- Necessário para reutilizar o fluxo comum de destroy.
- O cenário com associações foi mantido explícito.

### spec/features/responsible/external_members/external_members_search_spec.rb

- Centralizou a busca sem resultados.
- Necessário para reaproveitar o mesmo padrão de mensagem na tabela.
- Mantido o termo original.

### spec/features/responsible/external_members/external_members_update_spec.rb

- Centralizou validações de update inválido.
- Necessário para reduzir repetição de preenchimento vazio e mensagens.
- Mantidos `name` e `email`.

### spec/features/responsible/institutions/institutions_create_spec.rb

- Centralizou validações obrigatórias do formulário.
- Necessário para deduplicar o padrão de submit inválido.
- Mantida a diferença do campo `external_member`, que usa `required_error_message`.

### spec/features/responsible/institutions/institutions_destroy_spec.rb

- Centralizou exclusão com sucesso.
- Necessário para reaproveitar o fluxo comum de destroy.
- Mantida a mensagem feminina `destroy.f`.

### spec/features/responsible/institutions/institutions_search_spec.rb

- Centralizou busca sem resultados.
- Necessário para reduzir duplicação em search.
- Mantido o termo original.

### spec/features/responsible/institutions/institutions_update_spec.rb

- Centralizou update inválido.
- Necessário para reaproveitar limpeza de campos e mensagens.
- Mantidos os campos específicos de instituição.

### spec/features/responsible/pages/pages_create_spec.rb

- Centralizou validações de criação inválida.
- Necessário para reduzir repetição das mensagens de formulário.
- Mantidos os campos específicos de página.

### spec/features/responsible/pages/pages_destroy_spec.rb

- Centralizou o fluxo de exclusão.
- Necessário para reaproveitar destroy com flash e ausência do registro.
- Mantida a verificação por `menu_title`.

### spec/features/responsible/pages/pages_update_spec.rb

- Centralizou update inválido.
- Necessário para reduzir repetição de campos vazios e mensagens.
- Mantidos `menu_title` e `url`.

### spec/features/responsible/attached_documents/attached_documents_create_spec.rb

- Centralizou validações obrigatórias.
- Necessário para reduzir duplicação do submit inválido.
- Mantidos `name` e `file`.

### spec/features/responsible/attached_documents/attached_documents_destroy_spec.rb

- Centralizou exclusão com sucesso.
- Necessário para reaproveitar o fluxo comum de destroy.
- Mantida a mensagem `destroy.m`.

### spec/features/responsible/attached_documents/attached_documents_update_spec.rb

- Centralizou update inválido.
- Necessário para reduzir repetição de validação.
- Mantido o campo `attached_document_name`.

### spec/features/responsible/base_activities/base_activities_create_spec.rb

- Centralizou validações obrigatórias do formulário.
- Necessário para reduzir repetição mantendo mensagens diferentes por campo.
- Mantido `required_error_message` para tipo de atividade.

### spec/features/responsible/base_activities/base_activities_destroy_spec.rb

- Centralizou destroy com sucesso.
- Necessário para reutilizar o padrão de exclusão.
- Mantida a mensagem feminina `destroy.f`.

### spec/features/responsible/base_activities/base_activities_update_spec.rb

- Centralizou update inválido.
- Necessário para reduzir repetição.
- Mantido o campo `base_activity_name`.

### spec/features/responsible/activities/activities_create_spec.rb

- Centralizou validações obrigatórias de criação.
- Necessário para reduzir duplicação.
- Mantido `required_error_message` para `base_activity_type`.

### spec/features/responsible/activities/activities_show_spec.rb

- Substituiu expectativas repetidas de informações básicas e respostas por helpers/shared examples já usados para atividades.
- Necessário para reaproveitar comportamento comum de exibição.
- Mantidos os cenários de link quando enviado e ausência de link quando não enviado.

### spec/features/responsible/activities/activities_update_spec.rb

- Centralizou update inválido.
- Necessário para reduzir repetição de validação.
- Mantido o campo `activity_name`.

### spec/features/responsible/calendars/calendars_search_spec.rb

- Centralizou busca sem resultados.
- Necessário para reaproveitar o padrão de mensagem vazia.
- Mantido o termo original.

### spec/features/responsible/calendars/calendars_update_spec.rb

- Centralizou update inválido.
- Necessário para reduzir repetição.
- Mantida a descrição original do exemplo como `shows errors`.

### spec/support/responsible/

- Criado suporte específico para deduplicação dos CRUDs da área `responsible`.
- Inclui shared examples/helpers para formulário inválido, update inválido, busca sem resultados e destroy com sucesso.
- Necessário para evitar suporte global genérico demais e manter o escopo ligado à área `responsible`.

## Review Notes

- Revisar se os shared examples em `spec/support/responsible/` estão sendo carregados pelo setup atual sem exigir alteração em `rails_helper.rb` ou `spec_helper.rb`.
- Rodar os specs afetados e RuboCop nas pastas `spec/features/responsible/...` e `spec/support`.
- Conferir especialmente os fluxos com mensagens `destroy.m` e `destroy.f`, pois a diferença de gênero foi preservada por parâmetro.
- Não houve alteração intencional em código de produção, factories ou configuração global de testes.
- Não foi criado commit, push ou Pull Request.