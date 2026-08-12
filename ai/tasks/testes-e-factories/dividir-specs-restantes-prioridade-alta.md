# Task

Dividir os próximos specs com responsabilidades misturadas em arquivos menores e mais escopados, focando nos models restantes de prioridade alta, no controller da API de orientações e nos feature specs de show de orientações/supervisões.

# Contexto

As refatorações anteriores foram concluídas:

- os 7 specs grandes iniciais de `spec/models/` foram divididos;
- os specs de orientações/supervisões de `professors` e `responsible` foram divididos;
- a refatoração planejada de bancas, atividades e documentos foi concluída.

O próximo grupo prioritário contém specs menores que ainda misturam responsabilidades diferentes no mesmo arquivo.

Prioridade alta:

- `spec/models/examination_board_note_spec.rb` — validações, associações, aprovação/reprovação e notificações;
- `spec/models/base_activity_spec.rb` — validações, busca, filtros por TCC e formatação;
- `spec/models/institution_spec.rb` — validações, CNPJ, busca e formatação;
- `spec/models/notification_spec.rb` — enums, callbacks, scopes, envio e falha;
- `spec/controllers/api/v1/orientations_controller_spec.rb` — orientações aprovadas, TCC I e propostas;
- `spec/features/external_members/supervisions/supervisions_show_spec.rb`;
- `spec/features/professors/supervisions/supervisions_show_spec.rb`;
- `spec/features/responsible/orientations/orientations_show_spec.rb`;
- `spec/features/professors/orientations/orientations_show_spec.rb`.

Depois deles, ainda existe:

- `spec/models/signature_spec.rb` — assinatura, resolução do usuário e tabela correspondente.

Os `documents_show_spec.rb` e `documents_sign_spec.rb` de `academics`, `professors` e `external_members` para `term_of_commitment` e `term_of_accept_institution` devem ficar para uma task futura, pois precisam principalmente de deduplicação, não de divisão por responsabilidade.

# Objetivo

Refatorar a organização dos próximos specs com responsabilidades misturadas, dividindo arquivos em specs menores por fluxo, regra ou cenário.

A task deve melhorar:

- legibilidade;
- localização dos cenários;
- manutenção futura;
- separação por responsabilidade;
- execução isolada de specs;
- clareza entre validações, associações, scopes, callbacks, notificações, fluxos de API e telas de show.

Esta task NÃO tem como objetivo deduplicar famílias de documentos/assinaturas.

Não crie shared examples.
Não crie helpers globais.
Não altere `spec/support`.
Não altere factories.

# Instrução crítica

Esta task deve alterar apenas arquivos de teste dentro dos escopos permitidos.

Não altere código de produção.

Não altere:

- `app/`;
- `config/`;
- `db/`;
- `lib/`;
- `spec/factories/`;
- `spec/support/`;
- specs fora do escopo permitido.

Não corrija bugs de produção.

Não mude regras de negócio.

Não mude rotas.

Não altere controllers, views, helpers, models ou services.

Não atualize dependências.

Não faça commit.

Não faça push.

Não abra Pull Request.

As alterações devem ficar apenas no working tree para revisão manual.

# Regra crítica contra correções oportunistas

Esta task deve apenas mover e reorganizar exemplos.

Não corrija expectativas.
Não corrija iteradores.
Não corrija matchers.
Não corrija cenários aparentemente incorretos.
Não altere lógica dos testes.
Não altere dados de setup para “melhorar” o teste.
Não transforme um teste frágil em outro teste diferente.

Se encontrar um teste aparentemente incorreto, frágil, duplicado, mal escrito ou com problema de matcher/iteração, registre no relatório final como pendência separada.

A prioridade é preservar o mesmo comportamento e a mesma cobertura, apenas reorganizando os exemplos.

# Escopo permitido

Você pode alterar, criar ou remover arquivos apenas nestes caminhos e subpastas relacionadas:

- `spec/models/examination_board_note_spec.rb`
- `spec/models/examination_board_notes/`
- `spec/models/base_activity_spec.rb`
- `spec/models/base_activities/`
- `spec/models/institution_spec.rb`
- `spec/models/institutions/`
- `spec/models/notification_spec.rb`
- `spec/models/notifications/`
- `spec/models/signature_spec.rb`
- `spec/models/signatures/`
- `spec/controllers/api/v1/orientations_controller_spec.rb`
- `spec/controllers/api/v1/orientations/`
- `spec/features/external_members/supervisions/supervisions_show_spec.rb`
- `spec/features/external_members/supervisions/`
- `spec/features/professors/supervisions/supervisions_show_spec.rb`
- `spec/features/professors/supervisions/`
- `spec/features/responsible/orientations/orientations_show_spec.rb`
- `spec/features/responsible/orientations/`
- `spec/features/professors/orientations/orientations_show_spec.rb`
- `spec/features/professors/orientations/`

# Escopo proibido

Não altere arquivos fora do escopo permitido.

Não altere:

- `spec/features/professors/documents/`;
- `spec/features/academics/documents/`;
- `spec/features/external_members/documents/`;
- `spec/factories/`;
- `spec/support/`;
- código de produção.

Se algum ajuste em `spec/support`, factories, shared examples ou helpers parecer útil, não faça nesta task. Apenas registre no relatório final como sugestão para uma task futura.

# Ordem de prioridade

Siga esta ordem:

1. `spec/models/examination_board_note_spec.rb`
2. `spec/models/base_activity_spec.rb`
3. `spec/models/institution_spec.rb`
4. `spec/models/notification_spec.rb`
5. `spec/controllers/api/v1/orientations_controller_spec.rb`
6. `spec/features/external_members/supervisions/supervisions_show_spec.rb`
7. `spec/features/professors/supervisions/supervisions_show_spec.rb`
8. `spec/features/responsible/orientations/orientations_show_spec.rb`
9. `spec/features/professors/orientations/orientations_show_spec.rb`
10. `spec/models/signature_spec.rb`

Se a task ficar grande demais, priorize os cinco primeiros arquivos e registre no relatório final o que ficou para depois.

# Regra de divisão

Cada spec prioritário deve ser dividido somente quando possuir responsabilidades realmente distintas.

Quando a divisão não se justificar, mantenha o arquivo original e explique no relatório final por que ele foi mantido.

Não force a criação de arquivos pequenos sem necessidade.

Não crie arquivos com apenas um cenário, a menos que esse cenário represente uma regra ou fluxo claramente separado.

Variações de contexto não são necessariamente responsabilidades diferentes.

Exemplos de variações que nem sempre justificam arquivo próprio:

- contexto válido vs inválido dentro da mesma validação;
- pequenas variações de atributos;
- cenários similares com estados próximos;
- branches simples de uma mesma regra;
- exemplos que compartilham o mesmo objetivo de teste.

Para `Institution`, `Notification` e `Signature`, tome cuidado especial para não dividir demais. Se o arquivo já puder ficar legível com poucos blocos bem organizados, prefira manter menos arquivos.

# Regra de comparação antes/depois

Antes de reorganizar cada arquivo, registre internamente:

- quantidade de exemplos existentes;
- nomes dos `describe`, `context`, `it` ou `scenario`;
- principais blocos de responsabilidade existentes.

Após a divisão, confirme que:

- a quantidade de exemplos foi preservada;
- os mesmos cenários continuam presentes;
- nenhum exemplo foi removido sem justificativa;
- nenhum exemplo teve sua intenção alterada;
- cada novo arquivo roda de forma isolada.

No relatório final, inclua um resumo da comparação antes/depois para cada arquivo mexido.

Exemplo esperado no relatório:

- `spec/models/base_activity_spec.rb`
  - Antes: X exemplos.
  - Depois: X exemplos distribuídos em Y arquivos.
  - Cenários preservados: sim.
  - Observações: nenhum cenário removido.

# Parte 1 — Dividir specs de models restantes

## `spec/models/examination_board_note_spec.rb`

Separar, se fizer sentido, por responsabilidades como:

- associações;
- validações;
- aprovação;
- reprovação;
- regras de nota;
- callbacks ou notificações.

Sugestão de nomes seguindo o padrão recente do projeto:

- `spec/models/examination_board_notes/examination_board_note_validations_spec.rb`
- `spec/models/examination_board_notes/examination_board_note_approval_spec.rb`
- `spec/models/examination_board_notes/examination_board_note_notifications_spec.rb`

Crie apenas os arquivos que fizerem sentido conforme os cenários reais.

## `spec/models/base_activity_spec.rb`

Separar, se fizer sentido, por responsabilidades como:

- associações;
- validações;
- busca;
- filtros por TCC;
- formatação;
- enums ou identificadores, se existirem.

Sugestão de nomes seguindo o padrão recente do projeto:

- `spec/models/base_activities/base_activity_validations_spec.rb`
- `spec/models/base_activities/base_activity_search_spec.rb`
- `spec/models/base_activities/base_activity_filters_spec.rb`
- `spec/models/base_activities/base_activity_formatting_spec.rb`

Crie apenas os arquivos que fizerem sentido conforme os cenários reais.

## `spec/models/institution_spec.rb`

Separar, se fizer sentido, por responsabilidades como:

- associações;
- validações;
- CNPJ;
- busca;
- formatação.

Sugestão de nomes seguindo o padrão recente do projeto:

- `spec/models/institutions/institution_validations_spec.rb`
- `spec/models/institutions/institution_cnpj_spec.rb`
- `spec/models/institutions/institution_search_spec.rb`
- `spec/models/institutions/institution_formatting_spec.rb`

Atenção: não divida este arquivo em muitos arquivos se os cenários forem pequenos ou apenas variações de contexto.

## `spec/models/notification_spec.rb`

Separar, se fizer sentido, por responsabilidades como:

- enums;
- associações e validações;
- callbacks;
- scopes;
- envio;
- falha;
- marcação como lida/não lida, se existir.

Sugestão de nomes seguindo o padrão recente do projeto:

- `spec/models/notifications/notification_enums_spec.rb`
- `spec/models/notifications/notification_validations_spec.rb`
- `spec/models/notifications/notification_callbacks_spec.rb`
- `spec/models/notifications/notification_scopes_spec.rb`
- `spec/models/notifications/notification_delivery_spec.rb`
- `spec/models/notifications/notification_failure_spec.rb`

Atenção: não divida este arquivo em muitos arquivos se os cenários forem apenas variações de uma mesma responsabilidade.

## `spec/models/signature_spec.rb`

Este arquivo é prioridade secundária nesta task. Só divida se os itens anteriores forem concluídos sem deixar a PR grande demais.

Separar, se fizer sentido, por responsabilidades como:

- associações e validações;
- assinatura;
- resolução do usuário;
- tabela correspondente;
- autenticação/senha, se existir;
- estados da assinatura, se existirem.

Sugestão de nomes seguindo o padrão recente do projeto:

- `spec/models/signatures/signature_validations_spec.rb`
- `spec/models/signatures/signature_signing_spec.rb`
- `spec/models/signatures/signature_user_resolution_spec.rb`
- `spec/models/signatures/signature_table_resolution_spec.rb`

Atenção: não divida este arquivo se a separação gerar arquivos pequenos demais ou apenas separar variações de contexto.

# Parte 2 — Dividir spec do controller da API

## `spec/controllers/api/v1/orientations_controller_spec.rb`

Separar, se fizer sentido, por cenário de API:

- orientações aprovadas;
- TCC I;
- propostas;
- filtros;
- formato JSON;
- casos vazios;
- status HTTP.

Sugestão de nomes seguindo padrão explícito e consistente:

- `spec/controllers/api/v1/orientations/orientations_controller_approved_orientations_spec.rb`
- `spec/controllers/api/v1/orientations/orientations_controller_tcc_one_spec.rb`
- `spec/controllers/api/v1/orientations/orientations_controller_proposals_spec.rb`
- `spec/controllers/api/v1/orientations/orientations_controller_json_response_spec.rb`

Se o projeto já possuir outro padrão para specs de controllers/API, siga o padrão existente.

# Parte 3 — Dividir feature specs de show restantes

Os feature specs de show abaixo misturam fluxos básicos, TCC I, TCC II, permissões, ações e detalhes da página.

Divida apenas quando houver responsabilidades distintas.

## `spec/features/external_members/supervisions/supervisions_show_spec.rb`

Separar, se fizer sentido, por:

- informações básicas;
- dados da supervisão;
- TCC I;
- TCC II;
- ações;
- permissões;
- documentos/atividades, se estiverem misturados no show.

Sugestão de nomes seguindo padrão explícito:

- `supervisions_show_basic_information_spec.rb`
- `supervisions_show_tcc_one_spec.rb`
- `supervisions_show_tcc_two_spec.rb`
- `supervisions_show_actions_spec.rb`

## `spec/features/professors/supervisions/supervisions_show_spec.rb`

Separar, se fizer sentido, por:

- informações básicas;
- dados da supervisão;
- TCC I;
- TCC II;
- ações;
- permissões;
- documentos/atividades, se estiverem misturados no show.

Sugestão de nomes seguindo padrão explícito:

- `supervisions_show_basic_information_spec.rb`
- `supervisions_show_tcc_one_spec.rb`
- `supervisions_show_tcc_two_spec.rb`
- `supervisions_show_actions_spec.rb`

## `spec/features/responsible/orientations/orientations_show_spec.rb`

Separar, se fizer sentido, por:

- informações básicas;
- dados da orientação;
- TCC I;
- TCC II;
- ações administrativas;
- permissões;
- documentos/atividades/reuniões, se estiverem misturados no show.

Sugestão de nomes seguindo padrão explícito:

- `orientations_show_basic_information_spec.rb`
- `orientations_show_tcc_one_spec.rb`
- `orientations_show_tcc_two_spec.rb`
- `orientations_show_actions_spec.rb`

## `spec/features/professors/orientations/orientations_show_spec.rb`

Separar, se fizer sentido, por:

- informações básicas;
- dados da orientação;
- TCC I;
- TCC II;
- ações;
- permissões;
- documentos/atividades/reuniões, se estiverem misturados no show.

Sugestão de nomes seguindo padrão explícito:

- `orientations_show_basic_information_spec.rb`
- `orientations_show_tcc_one_spec.rb`
- `orientations_show_tcc_two_spec.rb`
- `orientations_show_actions_spec.rb`

# Regra sobre nomes de arquivos

Os novos arquivos devem seguir o padrão de nomes já aceito pelo RuboCop do projeto.

Use nomes em `snake_case`, terminando com `_spec.rb`.

Para specs de model em subpastas, prefira o padrão recente com o nome do model no arquivo:

- `orientation_validations_spec.rb`;
- `base_activity_search_spec.rb`;
- `institution_validations_spec.rb`;
- `notification_scopes_spec.rb`;
- `signature_user_resolution_spec.rb`.

Evite nomes genéricos como:

- `validations_spec.rb`;
- `search_spec.rb`;
- `scopes_spec.rb`;
- `callbacks_spec.rb`.

Antes de criar nomes novos, observe os nomes já existentes na mesma pasta.

Se algum nome sugerido violar o padrão do projeto ou gerar problema no RuboCop, escolha um nome mais adequado e explique no relatório final.

# Regras de implementação

Preserve o comportamento dos testes existentes.

Não remova cenários sem justificativa clara.

Não simplifique expectativas se isso reduzir cobertura.

Não altere a intenção dos testes.

Não altere setup de dados sem necessidade.

Não altere factories.

Não tente deduplicar agressivamente nesta task.

Não extraia shared examples nesta task.

Não crie helpers nesta task.

Não altere `spec/support`.

Não introduza novas abstrações.

Duplicação moderada entre arquivos separados é aceitável nesta etapa, desde que cada spec fique claro e rode isoladamente.

Se o arquivo original ficar vazio após mover todos os cenários, remova o arquivo original.

Se o arquivo original ainda tiver cenários não migrados, mantenha-o com apenas os cenários restantes.

Ao mover cenários, garanta que cada novo arquivo tenha todos os `let`, `before`, `include`, `helper` ou setup necessário para rodar isoladamente.

Cada arquivo novo deve conseguir rodar individualmente com RSpec.

# Testes esperados

Após a divisão, rode os testes diretamente afetados usando o padrão do projeto.

Comando principal esperado:

```bash
./run rspec \
  spec/models/examination_board_note_spec.rb \
  spec/models/examination_board_notes \
  spec/models/base_activity_spec.rb \
  spec/models/base_activities \
  spec/models/institution_spec.rb \
  spec/models/institutions \
  spec/models/notification_spec.rb \
  spec/models/notifications \
  spec/controllers/api/v1/orientations_controller_spec.rb \
  spec/controllers/api/v1/orientations \
  spec/features/external_members/supervisions \
  spec/features/professors/supervisions \
  spec/features/responsible/orientations \
  spec/features/professors/orientations \
  spec/models/signature_spec.rb \
  spec/models/signatures
```

Também rode RuboCop nos arquivos/pastas afetados:

```bash
./run rubocop \
  spec/models/examination_board_note_spec.rb \
  spec/models/examination_board_notes \
  spec/models/base_activity_spec.rb \
  spec/models/base_activities \
  spec/models/institution_spec.rb \
  spec/models/institutions \
  spec/models/notification_spec.rb \
  spec/models/notifications \
  spec/controllers/api/v1/orientations_controller_spec.rb \
  spec/controllers/api/v1/orientations \
  spec/features/external_members/supervisions \
  spec/features/professors/supervisions \
  spec/features/responsible/orientations \
  spec/features/professors/orientations \
  spec/models/signature_spec.rb \
  spec/models/signatures
```

Se algum arquivo original for removido após a divisão, ajuste os comandos executados para não apontarem para arquivos inexistentes.

Se o comando completo de RSpec for muito demorado ou falhar por problema de ambiente, rode os arquivos/pastas menores afetados e explique no relatório final.

Se o RuboCop apontar apenas problemas nos arquivos alterados por esta task, corrija esses problemas.

Se o RuboCop apontar problemas antigos fora do escopo da task, não corrija nesta task. Apenas registre no relatório final.

Se algum teste falhar, investigue se a falha foi causada pela reorganização dos specs.

Corrija apenas problemas nos arquivos de spec alterados quando a correção for estritamente necessária para manter o mesmo comportamento após a movimentação.

Não corrija código de produção nesta task.

# Critérios de aceite

A task será considerada concluída se:

- cada spec prioritário tiver sido analisado;
- cada spec prioritário tiver comparação antes/depois de quantidade e nomes de exemplos;
- cada spec prioritário tiver sido dividido somente quando houver responsabilidades distintas;
- quando a divisão não se justificar, o arquivo original for mantido e isso for explicado no relatório final;
- variações de contexto não forem tratadas automaticamente como responsabilidades diferentes;
- a organização seguir o padrão existente do projeto;
- os novos arquivos seguirem nomes aceitos pelo RuboCop do projeto;
- nenhum código de produção for alterado;
- nenhum arquivo fora do escopo permitido for alterado;
- `spec/support` e `spec/factories` não forem alterados;
- os testes continuarem cobrindo os mesmos fluxos;
- arquivos antigos vazios forem removidos;
- arquivos antigos parcialmente migrados forem mantidos apenas com cenários restantes;
- cada novo arquivo de spec puder rodar individualmente;
- problemas encontrados em expectativas, iteradores, matchers ou cenários aparentemente incorretos forem registrados como pendência em vez de corrigidos oportunisticamente;
- o relatório final explicar claramente o que foi dividido;
- o relatório final listar o que ficou para uma próxima task, se nem tudo for concluído;
- os testes afetados forem executados ou a impossibilidade for explicada claramente;
- o RuboCop for executado nas pastas afetadas ou a impossibilidade for explicada claramente.

# Relatório final esperado

No relatório final, inclua:

## Resumo

Explique quais specs foram divididos e por quê.

## Comparação antes/depois

Para cada arquivo analisado, informe:

- quantidade de exemplos antes;
- quantidade de exemplos depois;
- nomes principais dos blocos/cenários preservados;
- se houve divisão ou manutenção do arquivo original;
- motivo da decisão.

## Arquivos criados

Liste os novos arquivos de spec criados.

## Arquivos removidos ou mantidos

Explique quais arquivos antigos foram removidos, quais foram mantidos parcialmente e quais não foram divididos por não justificarem separação.

## Pendências encontradas

Liste problemas encontrados que não foram corrigidos por estarem fora do escopo, especialmente:

- expectativas suspeitas;
- iteradores ou blocos `.each` problemáticos;
- matchers frágeis;
- cenários aparentemente incorretos;
- duplicações que exigiriam shared examples;
- necessidade futura de helper ou suporte global.

## O que ficou para depois

Liste arquivos, cenários ou duplicações que ainda precisam ser tratados em uma próxima task.

## Testes executados

Liste os comandos executados e o resultado.

Inclua o resultado do RSpec.

## RuboCop executado

Liste o comando executado e o resultado.

Se algum comando não foi executado, explique o motivo.

# Observação final

Esta task não deve criar commit automaticamente.

As alterações devem ficar apenas no working tree para revisão manual com:

```bash
git status
git diff
```
