# Task

Deduplicar os specs restantes de feature com duplicação clara, começando pelos `activities_show_spec.rb` entre perfis e avançando para os fluxos de atividades/documentos dentro de orientações/supervisões e criação de bancas.

# Contexto

As etapas anteriores de refatoração e deduplicação já foram concluídas para:

- specs grandes de models;
- specs grandes/misturados de features;
- specs de documentos por perfil/tipo;
- specs de show de bancas;
- specs de show de orientações/supervisões.

Agora restam alguns grupos principais de duplicação em specs de feature.

O próximo grupo mais seguro e bem delimitado é o de `activities_show_spec.rb` entre perfis.

Depois dele, há duplicações em:

- show de atividades dentro de orientações/supervisões;
- show de documentos dentro de orientações/supervisões;
- create de bancas;
- alguns índices/calendários com repetição parecida.

Os CRUDs do `responsible` devem ficar para uma task futura separada, porque representam uma deduplicação mais ampla e arriscada.

# Objetivo

Reduzir duplicação entre specs de feature restantes, mantendo os mesmos cenários, expectativas e comportamento testado.

A task deve melhorar:

- manutenção dos specs;
- consistência entre perfis;
- clareza dos cenários;
- reaproveitamento de expectativas comuns;
- redução de setup repetido;
- facilidade para evoluir telas de atividades, documentos e criação de bancas.

Esta task NÃO deve alterar comportamento dos testes.

Esta task NÃO deve alterar código de produção.

# Instrução crítica

Esta task deve apenas deduplicar e reorganizar testes existentes.

Não altere código de produção.

Não altere:

- `app/`;
- `config/`;
- `db/`;
- `lib/`;
- `spec/models/`;
- `spec/controllers/`;
- `spec/requests/`;
- `spec/factories/`;
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

Esta task deve apenas deduplicar e reorganizar exemplos.

Não corrija expectativas.
Não corrija iteradores.
Não corrija matchers.
Não corrija cenários aparentemente incorretos.
Não altere lógica dos testes.
Não altere dados de setup para “melhorar” o teste.
Não transforme um teste frágil em outro teste diferente.
Não remova expectativas para facilitar a deduplicação.

Se encontrar um teste aparentemente incorreto, frágil, duplicado, mal escrito ou com problema de matcher/iteração, registre no relatório final como pendência separada.

A prioridade é preservar o mesmo comportamento e a mesma cobertura, apenas reduzindo duplicação.

# Escopo permitido

Você pode alterar arquivos apenas dentro destas pastas:

- `spec/features/external_members/activities/`
- `spec/features/professors/activities/`
- `spec/features/responsible/activities/`
- `spec/features/tcc_one_professors/activities/`
- `spec/features/academics/orientations/`
- `spec/features/professors/orientations/`
- `spec/features/professors/supervisions/`
- `spec/features/responsible/orientations/`
- `spec/features/external_members/supervisions/`
- `spec/features/tcc_one_professors/orientations/`
- `spec/features/responsible/examination_boards/`
- `spec/features/tcc_one_professors/examination_boards/`
- `spec/features/tcc_one_professors/calendars/`

Você também pode criar ou alterar arquivos de suporte somente se forem específicos para deduplicação destes specs.

Antes de criar suporte novo, verifique se o projeto já possui convenção em:

- `spec/support/`
- `spec/support/shared_examples/`
- `spec/features/support/`, se existir;
- outros arquivos de shared examples já existentes.

Se o projeto já tiver padrão de shared examples, siga esse padrão.

Se `spec/support/**/*.rb` não for carregado automaticamente pelo projeto, não altere `rails_helper.rb` ou `spec_helper.rb` nesta task. Nesse caso, prefira deduplicação local nos próprios specs afetados e registre no relatório final que a extração global ficou para uma task posterior.

# Escopo proibido

Não altere:

- `spec/factories/`;
- `rails_helper.rb`;
- `spec_helper.rb`;
- código de produção;
- specs fora dos diretórios permitidos;
- CRUDs amplos do `responsible`;
- shared examples não relacionados a atividades, documentos internos, criação de bancas ou índices/calendários desta task;
- suporte global genérico demais.

Não altere arquivos globais de configuração de teste.

Não mexa nos diretórios abaixo nesta task:

- `spec/features/responsible/academics/`
- `spec/features/responsible/professors/`
- `spec/features/responsible/external_members/`
- `spec/features/responsible/institutions/`
- `spec/features/responsible/pages/`
- `spec/features/responsible/attached_documents/`
- `spec/features/responsible/base_activities/`
- `spec/features/responsible/calendars/`

Os CRUDs do `responsible` devem ficar para uma task futura específica.

# Ordem de prioridade

Siga esta ordem:

1. Deduplicar `activities_show_spec.rb` entre perfis.
2. Deduplicar show de atividades dentro de orientações/supervisões.
3. Deduplicar show de documentos dentro de orientações/supervisões.
4. Deduplicar create de bancas.
5. Analisar índices/calendários com repetição parecida apenas se a task ainda estiver pequena.
6. Registrar o restante como pendência.

Se a task ficar grande demais, priorize somente o grupo 1, `activities_show_spec.rb` entre perfis, e registre no relatório final o que ficou para depois.

# Grupo 1 — Show de atividades entre perfis

Arquivos prioritários:

- `spec/features/external_members/activities/activities_show_spec.rb`
- `spec/features/professors/activities/activities_show_spec.rb`
- `spec/features/responsible/activities/activities_show_spec.rb`
- `spec/features/tcc_one_professors/activities/activities_show_spec.rb`

Esses specs podem repetir:

- criação de atividade;
- usuário/perfil autenticado;
- visita à tela de show;
- dados básicos da atividade;
- descrição;
- título;
- prazo;
- status;
- links e ações disponíveis;
- permissões por perfil;
- mensagens ou seções comuns.

Deduplicate apenas o que for realmente comum.

Mantenha explícito no spec:

- perfil autenticado;
- rota usada;
- permissão esperada;
- diferenças de visualização entre perfis;
- ações específicas de cada perfil.

# Grupo 2 — Show de atividades dentro de orientações/supervisões

Arquivos:

- `spec/features/academics/orientations/orientations_activities_show_spec.rb`
- `spec/features/professors/orientations/orientations_activities_show_spec.rb`
- `spec/features/professors/supervisions/supervisions_activities_show_spec.rb`
- `spec/features/responsible/orientations/orientations_activities_show_spec.rb`

Esses specs podem repetir:

- criação de orientação ou supervisão;
- criação da atividade vinculada;
- login do perfil correto;
- visita à tela da atividade;
- dados básicos da atividade;
- dados da orientação/supervisão;
- status da atividade;
- arquivos/respostas, se existirem;
- permissões por perfil.

Deduplicate apenas padrões claros.

Mantenha explícito:

- se o fluxo é de orientação ou supervisão;
- quem acessa;
- rota usada;
- expectativa específica do perfil;
- diferenças entre acadêmico, professor e responsável.

# Grupo 3 — Show de documentos dentro de orientações/supervisões

Arquivos:

- `spec/features/external_members/supervisions/supervisions_documents_show_spec.rb`
- `spec/features/professors/supervisions/supervisions_documents_show_spec.rb`
- `spec/features/tcc_one_professors/orientations/orientations_documents_show_spec.rb`

Esses specs NÃO são os specs de documentos por perfil/tipo já deduplicados anteriormente.

Eles representam documentos acessados dentro do contexto de orientação/supervisão.

Podem repetir:

- criação de orientação ou supervisão;
- criação de documento vinculado;
- login do perfil correto;
- visita à tela do documento;
- dados básicos do documento;
- status do documento;
- links;
- permissões por perfil;
- mensagens ou seções comuns.

Deduplicate apenas o que for realmente comum.

Mantenha explícito:

- se o documento pertence a orientação ou supervisão;
- perfil autenticado;
- rota usada;
- permissões específicas;
- diferenças de visualização.

# Grupo 4 — Create de bancas

Arquivos:

- `spec/features/responsible/examination_boards/examination_boards_create_tcc_one_spec.rb`
- `spec/features/responsible/examination_boards/examination_boards_create_tcc_two_spec.rb`
- `spec/features/tcc_one_professors/examination_boards/examination_boards_create_spec.rb`

Esses specs podem repetir:

- criação de orientação;
- criação de calendário;
- login;
- visita à tela de criação;
- preenchimento de formulário;
- seleção de avaliadores;
- criação com sucesso;
- validações de campos obrigatórios;
- mensagens de erro;
- diferenças entre TCC I e TCC II;
- diferenças entre responsável e professor de TCC I.

Deduplicate apenas padrões claros e seguros.

Mantenha explícito:

- quem cria a banca;
- se é TCC I ou TCC II;
- rota usada;
- permissões;
- campos específicos do formulário;
- diferenças entre perfis.

# Grupo 5 — Índices/calendários com repetição parecida

Este grupo é prioridade menor.

Analise somente se os grupos anteriores forem concluídos sem aumentar demais o escopo.

Arquivos:

- `spec/features/professors/orientations/orientations_history_index_spec.rb`
- `spec/features/professors/orientations/orientations_index_tcc_two_spec.rb`
- `spec/features/professors/supervisions/supervisions_index_spec.rb`
- `spec/features/tcc_one_professors/calendars/calendars_index_spec.rb`

Se a duplicação não for semanticamente óbvia, não altere.

Registre no relatório final que esse grupo deve virar uma task separada.

# Regra de comparação antes/depois

Antes de alterar cada grupo de arquivos, registre internamente:

- quantidade de exemplos existentes por arquivo;
- nomes dos `describe`, `context`, `it` ou `scenario`;
- principais fluxos cobertos;
- expectativas relevantes;
- setup específico do perfil;
- diferenças específicas entre perfis.

Após a deduplicação, confirme que:

- a quantidade de exemplos foi preservada;
- os mesmos cenários continuam presentes;
- nenhuma expectativa relevante foi removida;
- nenhum cenário teve sua intenção alterada;
- cada spec continua rodando isoladamente;
- as diferenças entre perfis continuam explícitas.

No relatório final, inclua um resumo da comparação antes/depois para cada grupo de arquivos.

Exemplo esperado no relatório:

- `activities_show_spec.rb entre perfis`
  - Antes: X exemplos distribuídos entre 4 arquivos.
  - Depois: X exemplos distribuídos entre 4 arquivos.
  - Cenários preservados: sim.
  - Deduplicação aplicada: shared example/local helper/etc.
  - Observações: nenhuma expectativa removida.

# Estratégia de deduplicação

A deduplicação deve ser conservadora.

Prefira extrair apenas padrões claramente repetidos, como:

- login do perfil correto;
- criação de registros comuns;
- visita à página;
- expectativas comuns de dados básicos;
- expectativas comuns de status;
- expectativas comuns de permissões;
- mensagens ou textos comuns;
- blocos de setup idênticos ou quase idênticos.

Não esconda diferenças importantes em abstrações difíceis de ler.

Não transforme os specs em uma estrutura excessivamente genérica.

Não crie metaprogramação complexa.

Não use loops grandes para gerar cenários se isso prejudicar legibilidade ou dificultar o diagnóstico de falhas.

Evite `each` para gerar muitos exemplos, a menos que o padrão já exista no projeto e a falha continue fácil de identificar.

Se usar shared examples, eles devem ter nomes claros, por exemplo:

- `shared_examples "activity show page"`
- `shared_examples "orientation activity show page"`
- `shared_examples "supervision document show page"`
- `shared_examples "examination board create form"`

Os nomes finais devem seguir o idioma e o padrão já usados no projeto.

# Regras de implementação

Preserve o comportamento dos testes existentes.

Não remova cenários sem justificativa clara.

Não simplifique expectativas se isso reduzir cobertura.

Não altere a intenção dos testes.

Não altere setup de dados sem necessidade.

Não altere factories.

Não altere código de produção.

Não tente deduplicar agressivamente.

Não introduza abstrações difíceis de entender.

Não crie shared examples genéricos demais.

Não use nomes ambíguos.

Não altere `rails_helper.rb` ou `spec_helper.rb`.

Cada arquivo de spec afetado deve continuar podendo rodar individualmente.

Se um spec ficar menos legível após a extração, prefira manter duplicação local.

# Regra sobre nomes de arquivos

Se criar arquivos de suporte, use nomes em `snake_case`.

Os nomes devem indicar claramente o escopo do suporte.

Exemplos aceitáveis, se seguirem o padrão do projeto:

- `activity_show_examples.rb`
- `orientation_activity_show_examples.rb`
- `supervision_activity_show_examples.rb`
- `orientation_supervision_document_show_examples.rb`
- `examination_board_create_examples.rb`

Evite nomes genéricos como:

- `shared_examples.rb`
- `helpers.rb`
- `common.rb`
- `utils.rb`

Se o projeto já tiver outro padrão de nomes, siga o padrão existente.

# Testes esperados

Após a deduplicação, rode os testes diretamente afetados usando o padrão do projeto.

Comando principal esperado:

```bash
./run rspec \
  spec/features/external_members/activities \
  spec/features/professors/activities \
  spec/features/responsible/activities \
  spec/features/tcc_one_professors/activities \
  spec/features/academics/orientations \
  spec/features/professors/orientations \
  spec/features/professors/supervisions \
  spec/features/responsible/orientations \
  spec/features/external_members/supervisions \
  spec/features/tcc_one_professors/orientations \
  spec/features/responsible/examination_boards \
  spec/features/tcc_one_professors/examination_boards \
  spec/features/tcc_one_professors/calendars
```

Também rode RuboCop nos arquivos/pastas afetados:

```bash
./run rubocop \
  spec/features/external_members/activities \
  spec/features/professors/activities \
  spec/features/responsible/activities \
  spec/features/tcc_one_professors/activities \
  spec/features/academics/orientations \
  spec/features/professors/orientations \
  spec/features/professors/supervisions \
  spec/features/responsible/orientations \
  spec/features/external_members/supervisions \
  spec/features/tcc_one_professors/orientations \
  spec/features/responsible/examination_boards \
  spec/features/tcc_one_professors/examination_boards \
  spec/features/tcc_one_professors/calendars
```

Se arquivos em `spec/support/` forem criados ou alterados, inclua também esses arquivos no RuboCop:

```bash
./run rubocop \
  spec/features/external_members/activities \
  spec/features/professors/activities \
  spec/features/responsible/activities \
  spec/features/tcc_one_professors/activities \
  spec/features/academics/orientations \
  spec/features/professors/orientations \
  spec/features/professors/supervisions \
  spec/features/responsible/orientations \
  spec/features/external_members/supervisions \
  spec/features/tcc_one_professors/orientations \
  spec/features/responsible/examination_boards \
  spec/features/tcc_one_professors/examination_boards \
  spec/features/tcc_one_professors/calendars \
  spec/support
```

Se o comando completo de RSpec for muito demorado ou falhar por problema de ambiente, rode os arquivos/pastas menores afetados e explique no relatório final.

Se o RuboCop apontar apenas problemas nos arquivos alterados por esta task, corrija esses problemas.

Se o RuboCop apontar problemas antigos fora do escopo da task, não corrija nesta task. Apenas registre no relatório final.

Se algum teste falhar, investigue se a falha foi causada pela deduplicação.

Corrija apenas problemas nos arquivos de spec ou suporte alterados quando a correção for estritamente necessária para manter o mesmo comportamento após a deduplicação.

Não corrija código de produção nesta task.

# Critérios de aceite

A task será considerada concluída se:

- o grupo de `activities_show_spec.rb` entre perfis for analisado;
- duplicações claras em `activities_show_spec.rb` forem reduzidas com segurança;
- o grupo de show de atividades dentro de orientações/supervisões for analisado;
- duplicações claras nesse grupo forem reduzidas quando fizer sentido;
- o grupo de show de documentos dentro de orientações/supervisões for analisado;
- duplicações claras nesse grupo forem reduzidas quando fizer sentido;
- o grupo de create de bancas for analisado;
- duplicações claras nesse grupo forem reduzidas quando fizer sentido;
- o grupo de índices/calendários for analisado apenas se o escopo permanecer seguro;
- diferenças entre perfis continuarem explícitas;
- a quantidade de exemplos e cenários for preservada;
- nenhum código de produção for alterado;
- `spec/factories`, `rails_helper.rb` e `spec_helper.rb` não forem alterados;
- nenhum spec fora do escopo for alterado;
- cada arquivo afetado continuar rodando individualmente;
- os testes afetados forem executados ou a impossibilidade for explicada claramente;
- o RuboCop for executado nas pastas afetadas ou a impossibilidade for explicada claramente;
- problemas encontrados em expectativas, iteradores, matchers ou cenários aparentemente incorretos forem registrados como pendência em vez de corrigidos oportunisticamente.

# Relatório final esperado

No relatório final, inclua:

## Resumo

Explique quais duplicações foram reduzidas e por quê.

## Comparação antes/depois

Para cada grupo de arquivos, informe:

- quantidade de exemplos antes;
- quantidade de exemplos depois;
- cenários preservados;
- diferenças específicas mantidas;
- estratégia de deduplicação usada.

## Arquivos alterados

Liste os arquivos de spec alterados.

## Arquivos de suporte criados ou alterados

Liste arquivos de suporte criados/alterados, se houver.

Se nenhum suporte novo foi criado, informe isso.

## Duplicações reduzidas

Liste as duplicações removidas ou centralizadas.

## O que foi mantido duplicado

Liste duplicações que foram mantidas por segurança ou legibilidade.

## Pendências encontradas

Liste problemas encontrados que não foram corrigidos por estarem fora do escopo, especialmente:

- expectativas suspeitas;
- iteradores ou blocos `.each` problemáticos;
- matchers frágeis;
- cenários aparentemente incorretos;
- necessidade futura de shared examples adicionais;
- necessidade futura de helper ou suporte global.

## O que ficou para depois

Liste possíveis próximas tasks, como:

- deduplicar índices/calendários, se não forem tratados agora;
- deduplicar CRUDs do responsible;
- revisar shared examples criados nesta etapa;
- refinar nomes/organização de suporte de specs.

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
