# Task

Deduplicar os specs de CRUD da área `responsible`, reduzindo repetição entre fluxos de index, show, create, update, destroy, search e pagination, sem alterar comportamento dos testes e sem alterar código de produção.

# Contexto

As etapas anteriores de refatoração e deduplicação já foram concluídas para:

- divisão de specs grandes de models;
- divisão de specs grandes/misturados de features;
- deduplicação de documentos;
- deduplicação de bancas;
- deduplicação de show de orientações/supervisões;
- deduplicação de atividades e fluxos restantes;
- remoção de sleeps em specs.

O principal bloco restante de duplicação está nos CRUDs da área `responsible`.

Esses specs repetem padrões parecidos entre vários recursos administrativos, como:

- listagem;
- paginação;
- busca;
- visualização;
- criação;
- edição;
- exclusão;
- validações de formulário;
- mensagens de sucesso;
- mensagens de erro;
- permissões;
- navegação entre telas.

Diretórios principais:

- `spec/features/responsible/academics/`
- `spec/features/responsible/professors/`
- `spec/features/responsible/external_members/`
- `spec/features/responsible/institutions/`
- `spec/features/responsible/pages/`
- `spec/features/responsible/attached_documents/`
- `spec/features/responsible/base_activities/`
- `spec/features/responsible/activities/`
- `spec/features/responsible/calendars/`

# Objetivo

Reduzir duplicação nos specs de CRUD da área `responsible`, mantendo os cenários existentes, as expectativas e o comportamento testado.

A task deve melhorar:

- manutenção dos specs;
- clareza dos fluxos administrativos;
- consistência entre CRUDs;
- reaproveitamento de expectativas comuns;
- redução de setup repetido;
- facilidade para evoluir os recursos da área `responsible`.

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

- `spec/features/responsible/academics/`
- `spec/features/responsible/professors/`
- `spec/features/responsible/external_members/`
- `spec/features/responsible/institutions/`
- `spec/features/responsible/pages/`
- `spec/features/responsible/attached_documents/`
- `spec/features/responsible/base_activities/`
- `spec/features/responsible/activities/`
- `spec/features/responsible/calendars/`

Você também pode criar ou alterar arquivos de suporte somente se forem específicos para deduplicação dos CRUDs da área `responsible`.

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
- shared examples não relacionados aos CRUDs da área `responsible`;
- suporte global genérico demais.

Não altere arquivos globais de configuração de teste.

Se algum ajuste global parecer necessário, não faça nesta task. Apenas registre no relatório final.

# Ordem de prioridade

Como este grupo é maior que os anteriores, trabalhe de forma incremental.

Siga esta ordem:

1. Inspecionar os CRUDs de `academics`, `professors` e `external_members`.
2. Mapear duplicações claras entre index, show, create, update, destroy, search e pagination nesses três recursos.
3. Deduplicar apenas padrões óbvios e seguros desses três primeiros recursos.
4. Inspecionar `institutions`, `pages` e `attached_documents`.
5. Deduplicar apenas padrões óbvios e seguros desses recursos.
6. Inspecionar `base_activities`, `activities` e `calendars`.
7. Deduplicar apenas se os padrões forem claros e o escopo ainda estiver seguro.
8. Registrar o que ficar para depois.

Se a task ficar grande demais, priorize apenas:

- `spec/features/responsible/academics/`
- `spec/features/responsible/professors/`
- `spec/features/responsible/external_members/`

E registre o restante como pendência.

# Grupos de CRUD

## Grupo 1 — Pessoas

Diretórios:

- `spec/features/responsible/academics/`
- `spec/features/responsible/professors/`
- `spec/features/responsible/external_members/`

Esses specs podem repetir:

- index/listagem;
- show/detalhe;
- busca;
- paginação;
- criação com dados válidos;
- criação com dados inválidos;
- edição com dados válidos;
- edição com dados inválidos;
- exclusão;
- mensagens de sucesso;
- mensagens de erro;
- campos obrigatórios;
- login do responsible;
- navegação administrativa.

Deduplicate apenas o que for realmente comum.

Mantenha explícito:

- recurso testado;
- campos específicos de acadêmico, professor ou membro externo;
- mensagens específicas;
- diferenças de permissão;
- diferenças de validação.

## Grupo 2 — Cadastros auxiliares

Diretórios:

- `spec/features/responsible/institutions/`
- `spec/features/responsible/pages/`
- `spec/features/responsible/attached_documents/`

Esses specs podem repetir:

- index;
- show;
- create;
- update;
- destroy;
- search;
- pagination;
- mensagens;
- validações de formulário;
- campos comuns.

Deduplicate apenas padrões claros.

Mantenha explícito:

- recurso testado;
- campos específicos;
- rota usada;
- mensagens específicas;
- diferenças de comportamento.

## Grupo 3 — Atividades e calendários

Diretórios:

- `spec/features/responsible/base_activities/`
- `spec/features/responsible/activities/`
- `spec/features/responsible/calendars/`

Esses specs podem repetir:

- index;
- show;
- create;
- update;
- destroy;
- filtros;
- busca;
- paginação;
- mensagens;
- campos obrigatórios;
- status;
- TCC I/TCC II;
- semestre;
- ano.

Deduplicate apenas se o padrão for óbvio e seguro.

Mantenha explícito:

- diferenças entre atividade base e atividade concreta;
- diferenças de calendário;
- regras de TCC I/TCC II;
- campos específicos;
- mensagens específicas.

# Estratégia de deduplicação

A deduplicação deve ser conservadora.

Prefira extrair padrões claramente repetidos, como:

- login do responsible;
- visita à página de index;
- expectativa de item na listagem;
- expectativa de item não aparecer após busca;
- criação com sucesso;
- edição com sucesso;
- exclusão com sucesso;
- mensagem flash comum;
- paginação comum;
- busca comum;
- submissão de formulário inválido;
- navegação básica.

Não esconda diferenças importantes em abstrações difíceis de ler.

Não transforme os specs em uma estrutura excessivamente genérica.

Não crie metaprogramação complexa.

Não use loops grandes para gerar cenários se isso prejudicar legibilidade ou dificultar o diagnóstico de falhas.

Evite `each` para gerar muitos exemplos, a menos que o padrão já exista no projeto e a falha continue fácil de identificar.

Se usar shared examples, eles devem ter nomes claros, por exemplo:

- `shared_examples "responsible index page"`
- `shared_examples "responsible searchable index"`
- `shared_examples "responsible paginated index"`
- `shared_examples "responsible create flow"`
- `shared_examples "responsible update flow"`
- `shared_examples "responsible destroy flow"`
- `shared_examples "responsible form validation"`

Os nomes finais devem seguir o idioma e o padrão já usados no projeto.

# Regra de comparação antes/depois

Antes de alterar cada grupo de arquivos, registre internamente:

- quantidade de exemplos existentes por arquivo;
- nomes dos `describe`, `context`, `it` ou `scenario`;
- principais fluxos cobertos;
- expectativas relevantes;
- setup específico do recurso;
- diferenças específicas entre recursos.

Após a deduplicação, confirme que:

- a quantidade de exemplos foi preservada;
- os mesmos cenários continuam presentes;
- nenhuma expectativa relevante foi removida;
- nenhum cenário teve sua intenção alterada;
- cada spec continua rodando isoladamente;
- as diferenças entre recursos continuam explícitas.

No relatório final, inclua um resumo da comparação antes/depois para cada grupo de arquivos.

Exemplo esperado no relatório:

- `responsible/academics`, `responsible/professors`, `responsible/external_members`
  - Antes: X exemplos distribuídos entre Y arquivos.
  - Depois: X exemplos distribuídos entre Y arquivos.
  - Cenários preservados: sim.
  - Deduplicação aplicada: shared example/local helper/etc.
  - Observações: nenhuma expectativa removida.

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

- `responsible_crud_examples.rb`
- `responsible_index_examples.rb`
- `responsible_form_examples.rb`
- `responsible_search_examples.rb`
- `responsible_pagination_examples.rb`

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
  spec/features/responsible/academics \
  spec/features/responsible/professors \
  spec/features/responsible/external_members \
  spec/features/responsible/institutions \
  spec/features/responsible/pages \
  spec/features/responsible/attached_documents \
  spec/features/responsible/base_activities \
  spec/features/responsible/activities \
  spec/features/responsible/calendars
```

Também rode RuboCop nos arquivos/pastas afetados:

```bash
./run rubocop \
  spec/features/responsible/academics \
  spec/features/responsible/professors \
  spec/features/responsible/external_members \
  spec/features/responsible/institutions \
  spec/features/responsible/pages \
  spec/features/responsible/attached_documents \
  spec/features/responsible/base_activities \
  spec/features/responsible/activities \
  spec/features/responsible/calendars
```

Se arquivos em `spec/support/` forem criados ou alterados, inclua também esses arquivos no RuboCop:

```bash
./run rubocop \
  spec/features/responsible/academics \
  spec/features/responsible/professors \
  spec/features/responsible/external_members \
  spec/features/responsible/institutions \
  spec/features/responsible/pages \
  spec/features/responsible/attached_documents \
  spec/features/responsible/base_activities \
  spec/features/responsible/activities \
  spec/features/responsible/calendars \
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

- os principais CRUDs da área `responsible` forem analisados;
- duplicações claras em index forem reduzidas com segurança;
- duplicações claras em search forem reduzidas com segurança, se fizer sentido;
- duplicações claras em pagination forem reduzidas com segurança, se fizer sentido;
- duplicações claras em create forem reduzidas com segurança, se fizer sentido;
- duplicações claras em update forem reduzidas com segurança, se fizer sentido;
- duplicações claras em destroy forem reduzidas com segurança, se fizer sentido;
- diferenças entre recursos continuarem explícitas;
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
- necessidade futura de helper ou suporte global;
- recursos que ainda exigem deduplicação em task futura.

## O que ficou para depois

Liste possíveis próximas tasks, como:

- aprofundar deduplicação dos CRUDs que não foram tratados;
- revisar shared examples criados nesta etapa;
- refinar nomes/organização de suporte de specs;
- deduplicar outros fluxos administrativos específicos.

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
