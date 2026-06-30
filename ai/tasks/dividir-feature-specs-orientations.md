# Task

Dividir specs grandes da pasta `spec/features/` relacionados a orientações, atividades e documentos em arquivos menores, organizados por responsabilidade e cenário.

# Contexto

Depois da etapa inicial de organização dos specs de models, a próxima prioridade de refatoração está nos specs de features.

A análise anterior apontou que alguns arquivos em `spec/features/` misturam muitos cenários dentro do mesmo arquivo, especialmente em fluxos de orientações, supervisões, atividades e documentos.

Os arquivos prioritários são:

- `spec/features/professors/orientations/orientations_index_spec.rb`
- `spec/features/responsible/orientations/orientations_index_spec.rb`
- `spec/features/responsible/orientations/orientations_activities_spec.rb`
- `spec/features/professors/orientations/orientations_activities_spec.rb`
- `spec/features/professors/orientations/orientations_documents_spec.rb`
- `spec/features/professors/supervisions/supervisions_activities_spec.rb`
- `spec/features/professors/supervisions/supervisions_documents_spec.rb`

O objetivo desta task é dividir esses arquivos em specs menores, sem alterar o comportamento testado e sem alterar código de produção.

# Objetivo

Refatorar a organização dos testes de feature relacionados a:

- listagem de orientações;
- histórico de orientações;
- ações disponíveis na listagem;
- atividades de orientações;
- atividades de supervisões;
- documentos de orientações;
- documentos de supervisões.

A divisão deve melhorar:

- legibilidade dos specs;
- facilidade para localizar cenários;
- manutenção futura;
- isolamento por fluxo;
- clareza entre TCC I, TCC II, histórico, atividades e documentos.

Esta task NÃO tem como objetivo principal reduzir duplicação.

Se forem encontrados setups repetidos, mantenha a duplicação aceitável por enquanto, desde que os testes fiquem claros e independentes. Extração para shared examples, helpers ou support files deve ficar para uma task posterior.

# Instrução crítica

Esta task deve alterar apenas arquivos dentro de `spec/features/`.

Não altere código de produção.

Não altere:

- `app/`;
- `config/`;
- `db/`;
- `lib/`;
- `spec/models/`;
- `spec/factories/`, exceto se for absolutamente indispensável;
- `spec/support/`, exceto se for absolutamente indispensável e justificado no relatório final.

Não corrija bugs de produção.

Não mude regras de negócio.

Não mude rotas.

Não altere controllers, views, helpers, models ou services.

Não atualize dependências.

Não faça commit.

Não faça push.

Não abra Pull Request.

A prioridade é mover, reorganizar e dividir specs existentes mantendo o mesmo comportamento.

# Estratégia obrigatória

Antes de alterar os arquivos, inspecione a estrutura atual da pasta `spec/features/`.

Preserve o padrão de organização já usado no projeto.

A divisão deve ser incremental e segura.

Evite criar abstrações novas nesta task.

Não crie shared examples nesta task.

Não crie helpers nesta task.

Não altere arquivos em `spec/support/` nesta task.

O foco principal é dividir arquivos grandes por cenário, não reescrever os testes.

Sempre que possível, apenas mova blocos de `describe`, `context`, `scenario` ou `it` para arquivos menores.

Preserve os textos dos cenários sempre que eles já forem claros.

Pode melhorar nomes de `describe`, `context`, `scenario` ou `it` quando isso ajudar na leitura, mas sem alterar a intenção do teste.

# Regra sobre nomes de arquivos

Os novos arquivos devem seguir o padrão de nomes já aceito pelo RuboCop do projeto.

Use nomes em `snake_case`, terminando com `_spec.rb`.

Evite nomes longos demais, ambíguos ou fora do padrão do diretório.

Antes de criar nomes novos, observe os nomes já existentes na mesma pasta.

Exemplos aceitáveis:

- `orientations_index_tcc_one_spec.rb`
- `orientations_index_tcc_two_spec.rb`
- `orientations_history_index_spec.rb`
- `orientations_index_actions_spec.rb`
- `orientations_activities_index_spec.rb`
- `orientations_activities_show_spec.rb`
- `orientations_documents_index_spec.rb`
- `orientations_documents_show_spec.rb`
- `supervisions_activities_index_spec.rb`
- `supervisions_activities_show_spec.rb`
- `supervisions_documents_index_spec.rb`
- `supervisions_documents_show_spec.rb`

Se algum nome sugerido violar o padrão do projeto ou gerar problema no RuboCop, escolha um nome mais adequado e explique no relatório final.

# Escopo permitido

Você pode alterar, criar ou remover arquivos apenas dentro de:

- `spec/features/professors/orientations/`
- `spec/features/responsible/orientations/`
- `spec/features/professors/supervisions/`

# Escopo proibido

Não altere arquivos fora dessas pastas.

Não altere:

- specs de models;
- specs de requests;
- specs de system, caso existam;
- factories;
- support helpers;
- código de produção.

Se algum ajuste em `spec/support/` parecer útil, não faça nesta task. Apenas registre no relatório final como sugestão para uma task futura.

# Ordem de prioridade

Siga esta ordem:

1. `spec/features/professors/orientations/orientations_index_spec.rb`
2. `spec/features/responsible/orientations/orientations_index_spec.rb`
3. `spec/features/responsible/orientations/orientations_activities_spec.rb`
4. `spec/features/professors/orientations/orientations_activities_spec.rb`
5. `spec/features/professors/orientations/orientations_documents_spec.rb`
6. `spec/features/professors/supervisions/supervisions_activities_spec.rb`
7. `spec/features/professors/supervisions/supervisions_documents_spec.rb`

Se a task ficar grande demais, priorize os três primeiros arquivos e registre no relatório final o que ficou para depois.

# Divisão recomendada por arquivo

## `spec/features/professors/orientations/orientations_index_spec.rb`

Esse é o primeiro alvo da task.

Separar cenários como:

- listagem de orientações de TCC I;
- listagem de orientações de TCC II;
- histórico de orientações;
- ações disponíveis na listagem;
- links para detalhes;
- links para atividades;
- links para documentos;
- links para reuniões;
- links para edição, se existirem.

Sugestão de estrutura, se fizer sentido no projeto:

- `spec/features/professors/orientations/orientations_index_tcc_one_spec.rb`
- `spec/features/professors/orientations/orientations_index_tcc_two_spec.rb`
- `spec/features/professors/orientations/orientations_history_index_spec.rb`
- `spec/features/professors/orientations/orientations_index_actions_spec.rb`

Se algum desses arquivos ficaria pequeno demais, junte cenários relacionados de forma coerente.

## `spec/features/responsible/orientations/orientations_index_spec.rb`

Separar cenários como:

- listagem de orientações de TCC I;
- listagem de orientações de TCC II;
- histórico, se existir;
- ações da linha;
- dropdowns;
- links para detalhes;
- links para atividades;
- links para documentos;
- links para reuniões;
- links de edição, cancelamento ou ações administrativas, se existirem.

Sugestão de estrutura:

- `spec/features/responsible/orientations/orientations_index_tcc_one_spec.rb`
- `spec/features/responsible/orientations/orientations_index_tcc_two_spec.rb`
- `spec/features/responsible/orientations/orientations_history_index_spec.rb`
- `spec/features/responsible/orientations/orientations_index_actions_spec.rb`

## `spec/features/responsible/orientations/orientations_activities_spec.rb`

Separar cenários como:

- index/listagem de atividades da orientação;
- show/detalhe de uma atividade;
- ações disponíveis para o responsável;
- submissões/respostas de atividades, se existirem no arquivo;
- permissões/visibilidade, se existirem.

Sugestão de estrutura:

- `spec/features/responsible/orientations/orientations_activities_index_spec.rb`
- `spec/features/responsible/orientations/orientations_activities_show_spec.rb`
- `spec/features/responsible/orientations/orientations_activities_actions_spec.rb`

## `spec/features/professors/orientations/orientations_activities_spec.rb`

Separar cenários como:

- index/listagem de atividades;
- show/detalhe de atividade;
- ações disponíveis para professor;
- comentários, correções ou respostas, se existirem;
- permissões/visibilidade, se existirem.

Sugestão de estrutura:

- `spec/features/professors/orientations/orientations_activities_index_spec.rb`
- `spec/features/professors/orientations/orientations_activities_show_spec.rb`
- `spec/features/professors/orientations/orientations_activities_actions_spec.rb`

## `spec/features/professors/orientations/orientations_documents_spec.rb`

Separar cenários como:

- listagem de documentos da orientação;
- visualização de documento;
- links para documentos;
- documentos pendentes;
- documentos assinados;
- permissões/visibilidade, se existirem.

Sugestão de estrutura:

- `spec/features/professors/orientations/orientations_documents_index_spec.rb`
- `spec/features/professors/orientations/orientations_documents_show_spec.rb`
- `spec/features/professors/orientations/orientations_documents_permissions_spec.rb`

## `spec/features/professors/supervisions/supervisions_activities_spec.rb`

Separar cenários como:

- index/listagem de atividades da supervisão;
- show/detalhe de atividade;
- ações disponíveis na supervisão;
- permissões/visibilidade, se existirem.

Sugestão de estrutura:

- `spec/features/professors/supervisions/supervisions_activities_index_spec.rb`
- `spec/features/professors/supervisions/supervisions_activities_show_spec.rb`
- `spec/features/professors/supervisions/supervisions_activities_actions_spec.rb`

## `spec/features/professors/supervisions/supervisions_documents_spec.rb`

Separar cenários como:

- listagem de documentos da supervisão;
- visualização de documento;
- links para documentos;
- documentos pendentes;
- documentos assinados;
- permissões/visibilidade, se existirem.

Sugestão de estrutura:

- `spec/features/professors/supervisions/supervisions_documents_index_spec.rb`
- `spec/features/professors/supervisions/supervisions_documents_show_spec.rb`
- `spec/features/professors/supervisions/supervisions_documents_permissions_spec.rb`

# Regras de implementação

Preserve o comportamento dos testes existentes.

Não remova cenários sem justificativa clara.

Não simplifique expectativas se isso reduzir cobertura.

Não altere a intenção dos testes.

Não altere setup de dados sem necessidade.

Não altere factories.

Não tente deduplicar agressivamente nesta task.

Não extraia shared examples nesta task.

Não extraia helpers nesta task.

Não introduza novas abstrações.

Duplicação moderada entre arquivos separados é aceitável nesta etapa, desde que cada spec fique claro e rode isoladamente.

Evite criar arquivos com apenas um cenário, a menos que o cenário represente um fluxo claramente separado.

Se o arquivo original ficar vazio após mover todos os cenários, remova o arquivo original.

Se o arquivo original ainda tiver cenários não migrados, mantenha-o com apenas os cenários restantes.

Ao mover cenários, garanta que cada novo arquivo tenha todos os `let`, `before`, `include`, `helper` ou setup necessário para rodar isoladamente.

Cada arquivo novo deve conseguir rodar individualmente com RSpec.

# Testes esperados

Após a divisão, rode os testes diretamente afetados usando o padrão do projeto.

Comando principal esperado:

```bash
./run rspec \
  spec/features/professors/orientations \
  spec/features/responsible/orientations \
  spec/features/professors/supervisions
```

Também rode RuboCop nos arquivos/pastas afetados:

```bash
./run rubocop \
  spec/features/professors/orientations \
  spec/features/responsible/orientations \
  spec/features/professors/supervisions
```

Se o comando completo de RSpec for muito demorado ou falhar por problema de ambiente, rode os arquivos/pastas menores afetados e explique no relatório final.

Se o RuboCop apontar apenas problemas nos arquivos alterados por esta task, corrija esses problemas.

Se o RuboCop apontar problemas antigos fora do escopo da task, não corrija nesta task. Apenas registre no relatório final.

Se algum teste falhar, investigue se a falha foi causada pela reorganização dos specs.

Corrija apenas problemas nos arquivos de spec alterados.

Não corrija código de produção nesta task.

# Critérios de aceite

A task será considerada concluída se:

- os arquivos de feature prioritários forem divididos por responsabilidade;
- a organização seguir o padrão existente do projeto;
- os novos arquivos seguirem nomes aceitos pelo RuboCop do projeto;
- nenhum código de produção for alterado;
- nenhum arquivo fora do escopo permitido for alterado;
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

Explique quais arquivos antigos foram removidos e quais foram mantidos parcialmente.

## O que ficou para depois

Liste arquivos ou cenários que ainda precisam ser divididos, se houver.

## Testes executados

Liste os comandos executados e o resultado.

Inclua o resultado de:

```bash
./run rspec \
  spec/features/professors/orientations \
  spec/features/responsible/orientations \
  spec/features/professors/supervisions
```

## RuboCop executado

Liste o comando executado e o resultado.

Inclua o resultado de:

```bash
./run rubocop \
  spec/features/professors/orientations \
  spec/features/responsible/orientations \
  spec/features/professors/supervisions
```

Se algum comando não foi executado, explique o motivo.

# Observação final

Esta task não deve criar commit automaticamente.

As alterações devem ficar apenas no working tree para revisão manual com:

```bash
git status
git diff
```
