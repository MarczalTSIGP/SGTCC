# Task

Dividir specs grandes da pasta `spec/models/` em arquivos menores, organizados por responsabilidade, começando pelos models mais críticos.

# Contexto

Foi feita uma análise inicial da pasta `spec/` e os maiores problemas encontrados nos testes de models foram:

- specs muito grandes e misturadas;
- muitos contextos diferentes dentro do mesmo arquivo;
- responsabilidades de domínio diferentes testadas no mesmo spec;
- dificuldade de localizar testes específicos;
- manutenção difícil quando uma regra de negócio muda;
- oportunidade de dividir arquivos grandes por tema sem alterar o comportamento dos testes.

Os principais arquivos identificados foram:

- `spec/models/document_spec.rb` — aproximadamente 641 linhas;
- `spec/models/orientation_spec.rb` — aproximadamente 619 linhas;
- `spec/models/examination_board_spec.rb` — aproximadamente 406 linhas;
- `spec/models/professor_spec.rb` — aproximadamente 371 linhas;
- `spec/models/activity_spec.rb` — aproximadamente 252 linhas;
- `spec/models/academic_spec.rb` — aproximadamente 181 linhas;
- `spec/models/external_member_spec.rb` — aproximadamente 189 linhas.

Nesta primeira task, o foco deve ser **somente a pasta \*\***`spec/models/`\*\*.

# Objetivo

Refatorar a organização dos testes de models, dividindo arquivos grandes em arquivos menores por responsabilidade, sem alterar a lógica testada e sem alterar código de produção.

O objetivo é melhorar:

- legibilidade;
- manutenção;
- localização dos testes;
- isolamento por responsabilidade;
- clareza dos contextos;
- preparação para futuras refatorações no domínio.

# Instrução crítica

Esta task deve alterar apenas arquivos de teste dentro de `spec/models/`.

Não altere código de produção.

Não altere models, controllers, services, concerns, helpers, views, rotas, migrations ou arquivos de configuração.

Não corrija bugs de produção.

Não mude regras de negócio.

Não altere factories, exceto se for estritamente necessário para manter os testes funcionando, e nesse caso explique no relatório final.

Não reescreva testes de forma ampla.

A prioridade é mover, reorganizar e dividir specs existentes mantendo o mesmo comportamento.

# Estratégia obrigatória

Faça a refatoração de forma incremental e segura.

Antes de dividir tudo, inspecione a estrutura atual dos specs em `spec/models/`.

Identifique quais arquivos já possuem subpastas específicas, como `spec/models/orientations/`, para seguir o padrão existente do projeto.

Quando possível, aproveite padrões já usados no repositório.

Não crie uma estrutura completamente diferente se já houver um padrão iniciado.

# Escopo permitido

Você pode alterar, criar ou remover arquivos apenas dentro de:

- `spec/models/`

Você pode criar subpastas dentro de `spec/models/` quando fizer sentido.

Exemplos possíveis:

- `spec/models/documents/`
- `spec/models/orientations/`
- `spec/models/examination_boards/`
- `spec/models/professors/`
- `spec/models/activities/`
- `spec/models/academics/`
- `spec/models/external_members/`

Mas antes de criar novas pastas, verifique se o projeto já possui um padrão existente.

# Escopo proibido

Não altere arquivos fora de `spec/models/`.

Não altere:

- `app/models/`;
- `app/controllers/`;
- `app/services/`;
- `app/concerns/`;
- `app/helpers/`;
- `app/views/`;
- `config/routes.rb`;
- `db/migrate/`;
- `db/schema.rb`;
- `spec/factories/`, exceto se for indispensável;
- `spec/features/`;
- `spec/requests/`;
- `spec/support/`, exceto se for indispensável e claramente justificado.

# Ordem de prioridade

Comece pelos arquivos mais críticos e grandes.

A ordem recomendada é:

1. `spec/models/document_spec.rb`
2. `spec/models/orientation_spec.rb`
3. `spec/models/examination_board_spec.rb`
4. `spec/models/professor_spec.rb`
5. `spec/models/activity_spec.rb`
6. `spec/models/academic_spec.rb`
7. `spec/models/external_member_spec.rb`

Se a task ficar grande demais, priorize os primeiros arquivos e registre no relatório final o que ficou para uma próxima PR.

# Divisão recomendada por arquivo

## `spec/models/document_spec.rb`

Separar por responsabilidades como:

- associações e validações;
- callbacks;
- geração de documentos;
- documentos TDO, TEP e TSO;
- assinaturas;
- permissões de assinatura;
- status e métodos de marcação;
- JSON/serialização, se existir;
- revisão ou fluxos específicos, se existirem.

Sugestão de estrutura, se fizer sentido:

- `spec/models/documents/validations_spec.rb`
- `spec/models/documents/callbacks_spec.rb`
- `spec/models/documents/signatures_spec.rb`
- `spec/models/documents/generation_spec.rb`
- `spec/models/documents/status_spec.rb`
- `spec/models/documents/serialization_spec.rb`

## `spec/models/orientation_spec.rb`

Já existem specs menores em `spec/models/orientations/`, então continue esse padrão se ele existir no projeto.

Separar por responsabilidades como:

- associações e validações;
- status e scopes;
- migração de TCC;
- cancelamento;
- documentos;
- atividades acadêmicas;
- ordenação;
- regras relacionadas a calendário;
- regras relacionadas a banca, se estiverem no arquivo atual.

Sugestão de estrutura, se fizer sentido:

- `spec/models/orientations/validations_spec.rb`
- `spec/models/orientations/status_spec.rb`
- `spec/models/orientations/scopes_spec.rb`
- `spec/models/orientations/migration_spec.rb`
- `spec/models/orientations/cancellation_spec.rb`
- `spec/models/orientations/documents_spec.rb`
- `spec/models/orientations/academic_activities_spec.rb`
- `spec/models/orientations/ordering_spec.rb`

## `spec/models/examination_board_spec.rb`

Separar por responsabilidades como:

- associações e validações;
- busca;
- status por data;
- avaliadores;
- apontamentos;
- confirmação;
- callbacks;
- atas/defense minutes, se estiverem no spec.

Sugestão de estrutura:

- `spec/models/examination_boards/validations_spec.rb`
- `spec/models/examination_boards/search_spec.rb`
- `spec/models/examination_boards/status_spec.rb`
- `spec/models/examination_boards/evaluators_spec.rb`
- `spec/models/examination_boards/appointments_spec.rb`
- `spec/models/examination_boards/confirmation_spec.rb`
- `spec/models/examination_boards/callbacks_spec.rb`

## `spec/models/professor_spec.rb`

Separar por responsabilidades como:

- associações e validações;
- busca;
- documentos;
- roles/perfis;
- orientações por TCC/status;
- bancas;
- supervisões.

Sugestão de estrutura:

- `spec/models/professors/validations_spec.rb`
- `spec/models/professors/search_spec.rb`
- `spec/models/professors/documents_spec.rb`
- `spec/models/professors/roles_spec.rb`
- `spec/models/professors/orientations_spec.rb`
- `spec/models/professors/examination_boards_spec.rb`
- `spec/models/professors/supervisions_spec.rb`

## `spec/models/activity_spec.rb`

Separar por responsabilidades como:

- associações e validações;
- formatos/enums;
- prazos e status;
- respostas acadêmicas;
- callbacks de notificação.

Sugestão de estrutura:

- `spec/models/activities/validations_spec.rb`
- `spec/models/activities/enums_spec.rb`
- `spec/models/activities/deadlines_spec.rb`
- `spec/models/activities/academic_responses_spec.rb`
- `spec/models/activities/notifications_spec.rb`

## `spec/models/academic_spec.rb`

Separar por responsabilidades como:

- associações e validações;
- busca;
- documentos;
- TEP/TSO;
- LDAP, se esse comportamento estiver no spec atual.

Sugestão de estrutura:

- `spec/models/academics/validations_spec.rb`
- `spec/models/academics/search_spec.rb`
- `spec/models/academics/documents_spec.rb`
- `spec/models/academics/terms_spec.rb`
- `spec/models/academics/ldap_spec.rb`

## `spec/models/external_member_spec.rb`

Separar por responsabilidades como:

- associações e validações;
- busca;
- supervisões atuais;
- documentos;
- bancas atuais.

Sugestão de estrutura:

- `spec/models/external_members/validations_spec.rb`
- `spec/models/external_members/search_spec.rb`
- `spec/models/external_members/supervisions_spec.rb`
- `spec/models/external_members/documents_spec.rb`
- `spec/models/external_members/examination_boards_spec.rb`

# Regras de implementação

Preserve o comportamento dos testes existentes.

Não remova exemplos sem justificativa.

Não simplifique expectativas se isso reduzir cobertura.

Não altere descrições de testes de forma que percam significado.

Pode melhorar nomes de `describe`, `context` e `it` quando isso ajudar na organização, mas sem mudar a intenção do teste.

Evite criar muitos arquivos pequenos demais com apenas um teste, a menos que seja necessário para seguir uma divisão clara.

Evite duplicação desnecessária de setup.

Se houver muitos `let`, `before` ou factories repetidos após a divisão, avalie manter o setup local em cada arquivo ou extrair apenas se já existir padrão no projeto.

Não crie shared examples nesta task, exceto se for extremamente simples e claramente benéfico. O foco principal é dividir os arquivos grandes, não criar abstrações novas.

Se algum arquivo ficar vazio após mover os testes, remova o arquivo antigo.

Se o arquivo antigo ainda contiver testes que não foram migrados, mantenha-o.

# Testes esperados

Após a divisão, rode ou indique no relatório final o resultado de:

```bash
bundle exec rspec spec/models
```

Se a execução completa de `spec/models` for muito demorada ou falhar por problema de ambiente, rode os arquivos/pastas diretamente afetados, por exemplo:

```bash
bundle exec rspec spec/models/documents spec/models/orientations spec/models/examination_boards
```

Se algum teste falhar, investigue se a falha foi causada pela reorganização dos specs.

Corrija apenas problemas nos arquivos de spec alterados.

Não corrija código de produção nesta task.

# Critérios de aceite

A task será considerada concluída se:

- os maiores specs de models forem divididos em arquivos menores por responsabilidade;
- a organização seguir padrões já existentes no projeto;
- nenhum código de produção for alterado;
- os testes continuarem representando as mesmas regras de negócio;
- arquivos antigos vazios forem removidos;
- o relatório final explicar quais arquivos foram divididos;
- o relatório final listar arquivos que ficaram para uma próxima task, se houver;
- os testes de models forem executados ou, se não for possível, isso for explicado claramente.

# Relatório final esperado

No relatório final, inclua:

## Resumo

Explique quais specs foram divididos e por quê.

## Arquivos criados

Liste os novos arquivos de spec criados.

## Arquivos removidos ou mantidos

Explique se arquivos antigos foram removidos ou mantidos parcialmente.

## O que ficou para depois

Liste specs de models que ainda precisam ser divididos, se nem todos forem concluídos.

## Testes executados

Liste os comandos executados e o resultado.

Se algum comando não foi executado, explique o motivo.Revisei a pasta spec sem alterar arquivos. Eu separaria em duas frentes: arquivos grandes/misturados e famílias com código repetido que pedem helper/shared examples.

Arquivos Para Dividir

Prioridade alta:

spec/models/document_spec.rb

Muito grande: 641 linhas. Dá para dividir por responsabilidades: assinaturas, callbacks, geração de TDO/TEP/TSO, JSON, status/mark, revisão e permissões de assinatura.

spec/models/orientation_spec.rb

619 linhas. Já existem specs menores em spec/models/orientations/, então esse é um ótimo candidato para continuar a migração. Separaria: validações/associações, status/scopes, migração, cancelamento, documentos, atividades acadêmicas e ordenação.

spec/models/examination_board_spec.rb

406 linhas. Separaria: validações/associações, busca, status por data, avaliadores, apontamentos, confirmação, callbacks.

spec/models/professor_spec.rb

371 linhas. Separaria: validações, busca, documentos, roles, orientações por TCC/status, bancas e supervisões.

spec/models/activity_spec.rb

252 linhas. Separaria: validações/associações, formatos/enums, prazo/status, respostas acadêmicas e callbacks de notificação.

spec/models/academic_spec.rb

181 linhas. Separaria: validações/associações, busca, documentos, TEP/TSO, LDAP.

spec/models/external_member_spec.rb

189 linhas. Separaria: validações, busca, supervisões atuais, documentos e bancas atuais.

spec/features/professors/orientations/orientations_index_spec.rb

Bom primeiro alvo da sua refatoração. Separaria em:

orientations_index_tcc_one_spec.rb

orientations_index_tcc_two_spec.rb

orientations_history_index_spec.rb

possivelmente orientations_index_actions_spec.rb para links de detalhes, atividades, documentos, reuniões e edição.

spec/features/responsible/orientations/orientations_index_spec.rb

Mesmo problema: mistura listagem TCC 1, TCC 2 e ações da linha/dropdown.

spec/features/responsible/orientations/orientations_activities_spec.rb

Mistura index e show. Separaria em orientations_activities_index_spec.rb e orientations_activities_show_spec.rb.

spec/features/\*/examination_boards/examination_boards_show_spec.rb

Os show specs de banca têm contextos diferentes no mesmo arquivo: dados básicos, atividade acadêmica, avaliadores, apontamentos, ata/defense minutes. Bons candidatos para arquivos menores por cenário.

Arquivos Com Código Repetido

Famílias com repetição clara:

Specs de documentos por tipo e perfil:

spec/features/professors/documents/term_of_commitment/documents_show_spec.rb

spec/features/professors/documents/term_of_accept_institution/documents_show_spec.rb

equivalentes em academics e external_members

Repetem setup de orientação/documento, login, conteúdo esperado, assinatura, documento pendente/assinado e redirect de autorização.

Specs de assinatura de documentos:

spec/features/professors/documents/term_of_commitment/documents_sign_spec.rb

spec/features/professors/documents/term_of_accept_institution/documents_sign_spec.rb

equivalentes em academics e external_members

Repetem click_button(signature_button), preenchimento de usuário/senha, sucesso e senha inválida. Dá para extrair helper ou shared examples.

Specs de atividades de orientação/supervisão:

spec/features/academics/orientations/orientations_activities_spec.rb

spec/features/professors/orientations/orientations_activities_spec.rb

spec/features/professors/supervisions/supervisions_activities_spec.rb

spec/features/responsible/orientations/orientations_activities_spec.rb

spec/features/tcc_one_professors/orientations/orientations_activities_spec.rb

Mesma lógica de index/show, mudando rotas e usuário autenticado.

Specs de documentos de orientação/supervisão:

orientations_documents_spec.rbRevisei a pasta spec sem alterar arquivos. Eu separaria em duas frentes: arquivos grandes/misturados e famílias com código repetido que pedem helper/shared examples.

Arquivos Para Dividir

Prioridade alta:

spec/models/document_spec.rb
Muito grande: 641 linhas. Dá para dividir por responsabilidades: assinaturas, callbacks, geração de TDO/TEP/TSO, JSON, status/mark, revisão e permissões de assinatura.

spec/models/orientation_spec.rb
619 linhas. Já existem specs menores em spec/models/orientations/, então esse é um ótimo candidato para continuar a migração. Separaria: validações/associações, status/scopes, migração, cancelamento, documentos, atividades acadêmicas e ordenação.

spec/models/examination_board_spec.rb
406 linhas. Separaria: validações/associações, busca, status por data, avaliadores, apontamentos, confirmação, callbacks.

spec/models/professor_spec.rb
371 linhas. Separaria: validações, busca, documentos, roles, orientações por TCC/status, bancas e supervisões.

spec/models/activity_spec.rb
252 linhas. Separaria: validações/associações, formatos/enums, prazo/status, respostas acadêmicas e callbacks de notificação.

spec/models/academic_spec.rb
181 linhas. Separaria: validações/associações, busca, documentos, TEP/TSO, LDAP.

spec/models/external_member_spec.rb
189 linhas. Separaria: validações, busca, supervisões atuais, documentos e bancas atuais.

spec/features/professors/orientations/orientations_index_spec.rb
Bom primeiro alvo da sua refatoração. Separaria em:

orientations_index_tcc_one_spec.rb
orientations_index_tcc_two_spec.rb
orientations_history_index_spec.rb
possivelmente orientations_index_actions_spec.rb para links de detalhes, atividades, documentos, reuniões e edição.
spec/features/responsible/orientations/orientations_index_spec.rb
Mesmo problema: mistura listagem TCC 1, TCC 2 e ações da linha/dropdown.

spec/features/responsible/orientations/orientations_activities_spec.rb
Mistura index e show. Separaria em orientations_activities_index_spec.rb e orientations_activities_show_spec.rb.

spec/features/\*/examination_boards/examination_boards_show_spec.rb
Os show specs de banca têm contextos diferentes no mesmo arquivo: dados básicos, atividade acadêmica, avaliadores, apontamentos, ata/defense minutes. Bons candidatos para arquivos menores por cenário.

Arquivos Com Código Repetido

Famílias com repetição clara:

Specs de documentos por tipo e perfil:

spec/features/professors/documents/term_of_commitment/documents_show_spec.rb
spec/features/professors/documents/term_of_accept_institution/documents_show_spec.rb
equivalentes em academics e external_members
Repetem setup de orientação/documento, login, conteúdo esperado, assinatura, documento pendente/assinado e redirect de autorização.

Specs de assinatura de documentos:

spec/features/professors/documents/term_of_commitment/documents_sign_spec.rb
spec/features/professors/documents/term_of_accept_institution/documents_sign_spec.rb
equivalentes em academics e external_members
Repetem click_button(signature_button), preenchimento de usuário/senha, sucesso e senha inválida. Dá para extrair helper ou shared examples.

Specs de atividades de orientação/supervisão:

spec/features/academics/orientations/orientations_activities_spec.rb
spec/features/professors/orientations/orientations_activities_spec.rb
spec/features/professors/supervisions/supervisions_activities_spec.rb
spec/features/responsible/orientations/orientations_activities_spec.rb
spec/features/tcc_one_professors/orientations/orientations_activities_spec.rb
Mesma lógica de index/show, mudando rotas e usuário autenticado.

Specs de documentos de orientação/supervisão:

orientations_documents_spec.rb
supervisions_documents_spec.rb
Repetem listagem de documentos, link por orientação, dados do acadêmico e página de show.

Specs de show de bancas:

academics/examination_boards/examination_boards_show_spec.rb
professors/examination_boards/examination_boards_show_spec.rb
responsible/examination_boards/examination_boards_show_spec.rb
tcc_one_professors/examination_boards/examination_boards_show_spec.rb
external_members/examination_boards/examination_boards_show_spec.rb
Mesma estrutura com variações de rota/perfil/permissões.

Specs de busca de modelos:

spec/models/academic_spec.rb
spec/models/professor_spec.rb
spec/models/external_member_spec.rb
Repetem testes de busca por atributos, acentos, case insensitive e ordenação por nome.

CRUD feature specs de responsible:

academics, professors, external_members, institutions, pages, activities, base_activities, attached_documents
Repetem fluxo: login como responsável, visit, preencher formulário, submit_form, sucesso, erro, search, pagination, destroy.

Login/logout specs:

academics_login/logout
professor_login
responsible_login/log

supervisions_documents_spec.rb

Repetem listagem de documentos, link por orientação, dados do acadêmico e página de show.

Specs de show de bancas:

academics/examination_boards/examination_boards_show_spec.rb

professors/examination_boards/examination_boards_show_spec.rb

responsible/examination_boards/examination_boards_show_spec.rb

tcc_one_professors/examination_boards/examination_boards_show_spec.rb

external_members/examination_boards/examination_boards_show_spec.rb

Mesma estrutura com variações de rota/perfil/permissões.

Specs de busca de modelos:

spec/models/academic_spec.rb

spec/models/professor_spec.rb

spec/models/external_member_spec.rb

Repetem testes de busca por atributos, acentos, case insensitive e ordenação por nome.

CRUD feature specs de responsible:

academics, professors, external_members, institutions, pages, activities, base_activities, attached_documents

Repetem fluxo: login como responsável, visit, preencher formulário, submit_form, sucesso, erro, search, pagination, destroy.

Login/logout specs:

academics_login/logout

professor_login

responsible_login/logout

external_members_login/logout

Repetem mensagens, fluxo de credenciais válidas/inválidas e redirect quando não autenticado.

Eu começaria pela sua área aberta agora: spec/features/professors/orientations/orientations_index_spec.rb, depois faria o par responsible/orientations/orientations_index_spec.rb. Esses dois dão uma primeira PR bem focada e já estabelecem o padrão para dividir o restante.
