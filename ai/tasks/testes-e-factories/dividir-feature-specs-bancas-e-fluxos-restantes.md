# Task

Dividir specs de feature com muitas responsabilidades em arquivos menores e mais escopados, focando nos specs de visualização de bancas e nos fluxos restantes de atividades/documentos de orientações e supervisões.

# Contexto

As duas refatorações anteriores já foram concluídas:

- os 7 specs grandes de `spec/models/` foram divididos;
- os specs de orientações/supervisões de `professors` e `responsible` já foram divididos.

O próximo grupo prioritário contém specs de feature que ainda misturam muitas responsabilidades dentro do mesmo arquivo.

O foco desta task é dividir arquivos grandes por fluxo/cenário, mantendo o comportamento dos testes.

A deduplicação dos specs de documentos e assinaturas deve ficar para uma task posterior.

# Objetivo

Refatorar a organização dos specs de feature restantes, dividindo arquivos grandes em arquivos menores, mais específicos e mais fáceis de manter.

A task deve melhorar:

- legibilidade;
- localização de cenários;
- manutenção futura;
- separação por fluxo;
- clareza entre dados básicos, avaliadores, apontamentos, ata, atividades, documentos, index e show.

Esta task NÃO tem como objetivo reduzir duplicação entre famílias de specs.

Não crie shared examples.
Não crie helpers.
Não altere `spec/support`.
Não altere factories.

# Instrução crítica

Esta task deve alterar apenas specs dentro de `spec/features/`.

Não altere código de produção.

Não altere:

- `app/`;
- `config/`;
- `db/`;
- `lib/`;
- `spec/models/`;
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

# Escopo permitido

Você pode alterar, criar ou remover arquivos apenas nas seguintes pastas:

- `spec/features/professors/examination_boards/`
- `spec/features/academics/examination_boards/`
- `spec/features/responsible/examination_boards/`
- `spec/features/tcc_one_professors/examination_boards/`
- `spec/features/external_members/examination_boards/`
- `spec/features/academics/orientations/`
- `spec/features/tcc_one_professors/orientations/`
- `spec/features/external_members/supervisions/`

# Escopo proibido

Não altere arquivos fora das pastas listadas no escopo permitido.

Não altere:

- `spec/features/professors/documents/`;
- `spec/features/academics/documents/`;
- `spec/features/external_members/documents/`;
- `spec/models/`;
- `spec/requests/`;
- `spec/system/`, caso exista;
- `spec/factories/`;
- `spec/support/`;
- código de produção.

Se algum ajuste em `spec/support/`, factories, shared examples ou helpers parecer útil, não faça nesta task. Apenas registre no relatório final como sugestão para uma task futura.

# Ordem de prioridade

Siga esta ordem:

1. `spec/features/professors/examination_boards/examination_boards_show_spec.rb`
2. `spec/features/academics/examination_boards/examination_boards_show_spec.rb`
3. `spec/features/responsible/examination_boards/examination_boards_show_spec.rb`
4. `spec/features/tcc_one_professors/examination_boards/examination_boards_show_spec.rb`
5. `spec/features/external_members/examination_boards/examination_boards_show_spec.rb`
6. `spec/features/academics/orientations/orientations_activities_spec.rb`
7. `spec/features/academics/orientations/orientations_documents_spec.rb`
8. `spec/features/tcc_one_professors/orientations/orientations_activities_spec.rb`
9. `spec/features/tcc_one_professors/orientations/orientations_documents_spec.rb`
10. `spec/features/external_members/supervisions/supervisions_activities_spec.rb`
11. `spec/features/external_members/supervisions/supervisions_documents_spec.rb`

Se a task ficar grande demais, priorize os 5 arquivos de `examination_boards_show_spec.rb` e registre no relatório final o que ficou para depois.

# Regra de divisão

Cada spec prioritário deve ser dividido somente quando possuir responsabilidades distintas.

Quando a divisão não se justificar, mantenha o arquivo original e explique no relatório final por que ele foi mantido.

Não force a criação de arquivos pequenos sem necessidade.

Não crie arquivos com apenas um cenário, a menos que esse cenário represente um fluxo claramente separado.

# Parte 1 — Dividir os specs de visualização de bancas

Os arquivos de visualização de bancas podem misturar responsabilidades como:

- dados básicos da banca;
- informações da orientação;
- dados do acadêmico;
- dados do orientador;
- avaliadores;
- membros externos;
- atividades acadêmicas;
- apontamentos;
- ata/defense minutes;
- permissões por perfil;
- ações disponíveis na tela;
- estados diferentes da banca.

Analise cada `examination_boards_show_spec.rb` e divida apenas quando houver responsabilidades distintas.

## Arquivos prioritários

- `spec/features/professors/examination_boards/examination_boards_show_spec.rb`
- `spec/features/academics/examination_boards/examination_boards_show_spec.rb`
- `spec/features/responsible/examination_boards/examination_boards_show_spec.rb`
- `spec/features/tcc_one_professors/examination_boards/examination_boards_show_spec.rb`
- `spec/features/external_members/examination_boards/examination_boards_show_spec.rb`

## Sugestão de divisão

Use nomes em `snake_case`, terminando com `_spec.rb`, seguindo o padrão aceito pelo RuboCop do projeto.

Sugestões possíveis, se fizerem sentido para cada pasta:

- `examination_boards_show_basic_information_spec.rb`
- `examination_boards_show_evaluators_spec.rb`
- `examination_boards_show_academic_activity_spec.rb`
- `examination_boards_show_appointments_spec.rb`
- `examination_boards_show_defense_minutes_spec.rb`
- `examination_boards_show_actions_spec.rb`
- `examination_boards_show_permissions_spec.rb`

Não crie todos esses arquivos obrigatoriamente.

Crie apenas os arquivos que fizerem sentido conforme os cenários reais existentes em cada spec.

Se algum arquivo novo ficaria pequeno demais, junte cenários relacionados de forma coerente.

# Parte 2 — Dividir specs restantes de atividades e documentos

Depois dos specs de bancas, divida os arquivos restantes de orientações/supervisões que ainda misturam index, show, ações e permissões.

## Arquivos de academics/orientations

- `spec/features/academics/orientations/orientations_activities_spec.rb`
- `spec/features/academics/orientations/orientations_documents_spec.rb`

Sugestões possíveis:

- `orientations_activities_index_spec.rb`
- `orientations_activities_show_spec.rb`
- `orientations_activities_actions_spec.rb`
- `orientations_documents_index_spec.rb`
- `orientations_documents_show_spec.rb`
- `orientations_documents_permissions_spec.rb`

## Arquivos de tcc_one_professors/orientations

- `spec/features/tcc_one_professors/orientations/orientations_activities_spec.rb`
- `spec/features/tcc_one_professors/orientations/orientations_documents_spec.rb`

Sugestões possíveis:

- `orientations_activities_index_spec.rb`
- `orientations_activities_show_spec.rb`
- `orientations_activities_actions_spec.rb`
- `orientations_documents_index_spec.rb`
- `orientations_documents_show_spec.rb`
- `orientations_documents_permissions_spec.rb`

## Arquivos de external_members/supervisions

- `spec/features/external_members/supervisions/supervisions_activities_spec.rb`
- `spec/features/external_members/supervisions/supervisions_documents_spec.rb`

Sugestões possíveis:

- `supervisions_activities_index_spec.rb`
- `supervisions_activities_show_spec.rb`
- `supervisions_activities_actions_spec.rb`
- `supervisions_documents_index_spec.rb`
- `supervisions_documents_show_spec.rb`
- `supervisions_documents_permissions_spec.rb`

# Regra sobre nomes de arquivos

Os novos arquivos devem seguir o padrão de nomes já aceito pelo RuboCop do projeto.

Use nomes em `snake_case`, terminando com `_spec.rb`.

Evite nomes longos demais, ambíguos ou fora do padrão do diretório.

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
  spec/features/professors/examination_boards \
  spec/features/academics/examination_boards \
  spec/features/responsible/examination_boards \
  spec/features/tcc_one_professors/examination_boards \
  spec/features/external_members/examination_boards \
  spec/features/academics/orientations \
  spec/features/tcc_one_professors/orientations \
  spec/features/external_members/supervisions
```

Também rode RuboCop nos arquivos/pastas afetados:

```bash
./run rubocop \
  spec/features/professors/examination_boards \
  spec/features/academics/examination_boards \
  spec/features/responsible/examination_boards \
  spec/features/tcc_one_professors/examination_boards \
  spec/features/external_members/examination_boards \
  spec/features/academics/orientations \
  spec/features/tcc_one_professors/orientations \
  spec/features/external_members/supervisions
```

Se o comando completo de RSpec for muito demorado ou falhar por problema de ambiente, rode os arquivos/pastas menores afetados e explique no relatório final.

Se o RuboCop apontar apenas problemas nos arquivos alterados por esta task, corrija esses problemas.

Se o RuboCop apontar problemas antigos fora do escopo da task, não corrija nesta task. Apenas registre no relatório final.

Se algum teste falhar, investigue se a falha foi causada pela reorganização dos specs.

Corrija apenas problemas nos arquivos de spec alterados.

Não corrija código de produção nesta task.

# Critérios de aceite

A task será considerada concluída se:

- cada spec prioritário tiver sido analisado;
- cada spec prioritário tiver sido dividido somente quando houver responsabilidades distintas;
- quando a divisão não se justificar, o arquivo original for mantido e isso for explicado no relatório final;
- a organização seguir o padrão existente do projeto;
- os novos arquivos seguirem nomes aceitos pelo RuboCop do projeto;
- nenhum código de produção for alterado;
- nenhum arquivo fora do escopo permitido for alterado;
- `spec/support` e `spec/factories` não forem alterados;
- os testes continuarem cobrindo os mesmos fluxos;
- arquivos antigos vazios forem removidos;
- arquivos antigos parcialmente migrados forem mantidos apenas com cenários restantes;
- cada novo arquivo de spec puder rodar individualmente;
- o relatório final explicar claramente o que foi dividido;
- o relatório final listar o que ficou para uma próxima task, se nem tudo for concluído;
- os testes afetados forem executados ou a impossibilidade for explicada claramente;
- o RuboCop for executado nas pastas afetadas ou a impossibilidade for explicada claramente.

# Relatório final esperado

No relatório final, inclua:

## Resumo

Explique quais specs foram divididos e por quê.

## Arquivos criados

Liste os novos arquivos de spec criados.

## Arquivos removidos ou mantidos

Explique quais arquivos antigos foram removidos, quais foram mantidos parcialmente e quais não foram divididos por não justificarem separação.

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
