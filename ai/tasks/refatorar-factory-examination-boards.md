# Task

Refatorar a factory `examination_boards.rb` para usar traits reais do domínio, atualizar os testes que usam os nomes antigos dessa factory e garantir que a suíte termine verde.

# Contexto

Estamos na Task 5 do plano de refatoração das factories do SGTCC.

As tasks anteriores já foram concluídas:

- Task 1: `calendars.rb`;
- Task 2: `base_activities.rb` + `activities.rb`;
- Task 3: `academic_activities.rb` + `signatures.rb`;
- Task 4: `professors.rb` + `document_types.rb` + `documents.rb`.

Agora o foco é refatorar:

- `spec/factories/examination_boards.rb`.

Essa factory possui complexidade média e volume relevante de referências nos testes.

Volume estimado:

- aproximadamente 92 referências nos testes;
- existem factories antigas/aninhadas que devem ser convertidas para traits;
- os specs que usam os nomes antigos devem ser atualizados nesta mesma task.

A estratégia desta task é:

1. refatorar a factory para uma estrutura baseada em traits reais;
2. manter aliases temporários apenas durante a migração, se necessário;
3. atualizar os testes para usar a nova sintaxe;
4. remover aliases antigos quando não houver mais referências;
5. rodar RSpec e RuboCop;
6. terminar com a suíte verde.

# Atenção antes de executar

Antes de iniciar esta task, verifique o working tree.

Existe indicação de alteração pendente em:

```bash
spec/rails_helper.rb
```

Esta task proíbe alterar `rails_helper.rb`.

Portanto, antes de rodar esta task, resolva, reverta ou isole essa alteração para não misturar escopos.

Use:

```bash
git status
git diff spec/rails_helper.rb
```

Se `spec/rails_helper.rb` estiver alterado antes da task, não mexa nele nesta task e registre no relatório final que havia alteração pré-existente fora de escopo.

# Objetivo

Refatorar `spec/factories/examination_boards.rb` para reduzir duplicação, melhorar clareza e tornar as variações de banca mais explícitas por meio de traits.

Ao final da task:

- os testes devem usar a nova sintaxe com traits;
- os nomes antigos de factories de bancas não devem permanecer nos specs, salvo justificativa;
- aliases temporários devem ser removidos se não forem mais necessários;
- a suíte completa deve passar.

# Instrução crítica

Esta task deve alterar apenas:

- `spec/factories/examination_boards.rb`;
- specs que referenciam factories antigas de examination boards;
- factories diretamente dependentes de examination boards, somente se a atualização for inevitável;
- arquivos de teste diretamente necessários para atualizar essas referências.

Não altere código de produção.

Não altere:

- `app/`;
- `config/`;
- `db/`;
- `lib/`;
- outras factories sem dependência direta;
- regras de negócio;
- models;
- controllers;
- services;
- views;
- migrations;
- `rails_helper.rb`;
- `spec_helper.rb`.

Não faça commit.

Não faça push.

Não abra Pull Request.

As alterações devem ficar apenas no working tree para revisão manual.

# Escopo permitido

Você pode alterar:

- `spec/factories/examination_boards.rb`;
- specs em `spec/` que usam factories antigas de examination boards;
- factories em `spec/factories/` somente se houver dependência direta inevitável;
- apenas referências necessárias para migrar o uso das factories antigas para traits.

# Escopo proibido

Não altere:

- código de produção;
- outras factories sem necessidade direta;
- `rails_helper.rb`;
- `spec_helper.rb`;
- configurações globais;
- migrations;
- schema;
- arquivos fora de `spec/`.

Se encontrar problema fora do escopo, registre no relatório final como pendência.

# Regra crítica contra correções oportunistas

Esta task deve apenas refatorar a factory de examination boards e atualizar os testes para a nova API da factory.

Não corrija expectativas.
Não corrija iteradores.
Não corrija matchers.
Não corrija cenários aparentemente incorretos.
Não altere lógica dos testes.
Não altere dados de setup para “melhorar” o teste, exceto quando for necessário para usar a nova factory equivalente.
Não remova cenários.
Não reduza cobertura.

Se encontrar um teste aparentemente incorreto, frágil ou mal escrito, registre no relatório final como pendência separada.

# Estratégia obrigatória

Antes de alterar, faça um inventário da factory atual.

Identifique em `spec/factories/examination_boards.rb`:

- nomes de factories existentes;
- traits já existentes, se houver;
- atributos padrão;
- valores de `identifier`;
- vínculo com `orientation`;
- vínculo com `calendar`, se existir;
- vínculo com `academic`;
- vínculo com `professor` ou orientador;
- avaliadores/professores associados;
- membros externos associados;
- callbacks;
- factories aninhadas;
- nomes antigos usados nos specs;
- diferenças reais entre as factories antigas.

# Factories antigas reais esperadas

As factories antigas reais encontradas em `examination_boards.rb` são:

- `:proposal_examination_board`;
- `:project_examination_board`;
- `:monograph_examination_board`;
- `:examination_board_tcc_one`;
- `:examination_board_tcc_two`;
- `:current_examination_board_tcc_one`;
- `:current_examination_board_tcc_one_project`;
- `:current_examination_board_tcc_two`.

Antes de alterar, confirme se essa lista ainda está correta no código atual.

Se houver factories adicionais, inclua no inventário e no relatório final.

# Padrão desejado da factory

A factory principal deve ser algo como:

```ruby
factory :examination_board do
  # atributos padrão seguros
end
```

As variações devem ser expressas com traits combináveis.

Traits esperadas, se corresponderem ao código atual e às factories antigas reais:

```ruby
trait :proposal
trait :project
trait :monograph
trait :tcc_one
trait :tcc_two
trait :current_tcc_one
trait :current_tcc_two
```

Use somente traits que correspondam a atributos, associações ou estados reais do model `ExaminationBoard`.

Não crie traits sem base real.

Não crie traits apenas porque parecem úteis.

Antes de criar qualquer trait, confirme:

- se o model possui o atributo, associação ou estado correspondente;
- se a factory antiga já representava esse comportamento;
- se existe uso real nos specs;
- se o trait substitui uma factory antiga ou reduz duplicação real.

# Traits de identifier

O domínio de banca está relacionado a identifiers como:

- proposta;
- projeto;
- monografia.

Se o model usa valores como:

```ruby
proposal
project
monograph
```

então os traits devem refletir esses nomes reais:

```ruby
trait :proposal
trait :project
trait :monograph
```

Não invente outros identifiers.

Não altere enums ou valores de domínio.

# Traits de TCC e current

As factories antigas diferenciam bancas de TCC I, TCC II e bancas do calendário/orientação atual.

Mapeamento esperado, se confirmado no código atual:

```ruby
:proposal_examination_board
# vira
:examination_board, :proposal

:project_examination_board
# vira
:examination_board, :project

:monograph_examination_board
# vira
:examination_board, :monograph

:examination_board_tcc_one
# vira
:examination_board, :tcc_one

:examination_board_tcc_two
# vira
:examination_board, :tcc_two

:current_examination_board_tcc_one
# vira
:examination_board, :current_tcc_one, :proposal

:current_examination_board_tcc_one_project
# vira
:examination_board, :current_tcc_one, :project

:current_examination_board_tcc_two
# vira
:examination_board, :current_tcc_two, :monograph
```

Atenção: as factories `current_*` não mexem apenas em `identifier`.

Elas provavelmente configuram `orientation`, `calendar`, `tcc`, semestre ou contexto atual.

Preserve exatamente o comportamento antigo dessas factories.

Se TCC I/TCC II forem definidos indiretamente por `orientation`, `calendar` ou `identifier`, preserve esse comportamento.

Não crie trait que apenas muda um atributo inexistente.

# Cuidado especial com avaliadores

A factory atual de `examination_board` sempre cria avaliadores no `after(:create)`.

O comportamento atual esperado é semelhante a:

```ruby
create_list(:professor, 2)
create_list(:external_member, 1)
```

Esse comportamento é importante porque vários specs podem assumir que toda banca criada pela factory já possui professores avaliadores e membro externo.

Preserve esse comportamento por padrão, a menos que todos os usos sejam migrados explicitamente para um trait equivalente.

Não transforme a criação de avaliadores em trait opcional sem muita cautela.

Não crie `:with_evaluators` como opcional se isso mudar o comportamento padrão das factories existentes.

Se criar algum trait relacionado a avaliadores, ele deve preservar compatibilidade e não remover o comportamento padrão sem uma migração explícita de todos os specs impactados.

Cuidado para não duplicar avaliadores indevidamente.

Se o teste passar avaliadores manualmente, a factory não deve sobrescrever ou duplicar esse setup de forma inesperada.

# Traits de confirmação/situação

Não crie traits como:

```ruby
trait :confirmed
trait :unconfirmed
```

a menos que exista factory antiga, atributo real ou estado real que represente exatamente esse comportamento.

A factory atual não parece possuir variação antiga de `confirmed`/`unconfirmed`.

Se o estado da banca for derivado de `situation`, data ou outro mecanismo do model, não invente traits novos nesta task.

Registre como pendência futura se perceber uma oportunidade real de trait de situação.

# Exemplos de uso desejado nos specs

A ideia é substituir usos antigos como:

```ruby
create(:proposal_examination_board)
create(:project_examination_board)
create(:monograph_examination_board)
create(:examination_board_tcc_one)
create(:examination_board_tcc_two)
create(:current_examination_board_tcc_one)
create(:current_examination_board_tcc_one_project)
create(:current_examination_board_tcc_two)
```

por combinações com traits, por exemplo:

```ruby
create(:examination_board, :proposal)
create(:examination_board, :project)
create(:examination_board, :monograph)
create(:examination_board, :tcc_one)
create(:examination_board, :tcc_two)
create(:examination_board, :current_tcc_one, :proposal)
create(:examination_board, :current_tcc_one, :project)
create(:examination_board, :current_tcc_two, :monograph)
```

Esses nomes devem ser confirmados contra as factories reais antes da substituição.

Preserve atributos sobrescritos.

Exemplo:

```ruby
create(:monograph_examination_board, date: Date.current)
```

deve virar algo como:

```ruby
create(:examination_board, :monograph, date: Date.current)
```

se esse mapeamento corresponder ao comportamento real.

Não remova atributos explícitos sem necessidade.

# Aliases temporários

Durante a migração, você pode manter aliases temporários para facilitar a transição.

Porém, ao final desta task, se todos os specs e factories dependentes tiverem sido atualizados para traits, remova os aliases antigos.

A task deve terminar preferencialmente sem factories antigas duplicando comportamento.

Se algum alias antigo precisar permanecer por compatibilidade, explique no relatório final:

- qual alias ficou;
- por que não foi removido;
- onde ainda é usado;
- qual task futura deve removê-lo.

# Atualização dos testes

Atualize todos os specs que usam nomes antigos de factories de examination boards.

Faça substituições de forma segura e mecânica.

Preserve atributos sobrescritos.

Preserve cenários.

Preserve a intenção do teste.

Não altere expectativas para se adaptar à nova factory.

Se um spec quebrar após a migração, primeiro tente preservar o comportamento anterior ajustando a factory.

Alterar spec deve ser último recurso e precisa de justificativa forte no relatório final.

# Cuidados importantes

`ExaminationBoard` pode possuir regras sensíveis, como:

- tipo de banca;
- proposta;
- projeto;
- monografia;
- TCC I;
- TCC II;
- orientação vinculada;
- calendário vinculado indiretamente;
- acadêmico;
- orientador;
- avaliadores;
- membros externos;
- apontamentos;
- ata;
- confirmação;
- situação;
- datas;
- status por data;
- callbacks.

Ao refatorar a factory:

- preserve comportamento equivalente ao das factories antigas;
- preserve criação padrão de avaliadores;
- evite gerar combinações inválidas;
- use sequences quando necessário;
- não deixe traits criando estados inconsistentes;
- não altere expectativas dos testes para se adaptar à factory;
- ajuste apenas o uso da factory para preservar o mesmo cenário;
- cuidado com callbacks que dependem de data, orientation ou identifier;
- cuidado com associações many-to-many de professores e membros externos.

# Regra de comparação antes/depois

Antes da alteração, registre internamente:

- nomes das factories antigas em `examination_boards.rb`;
- quantidade aproximada de referências encontradas;
- arquivos principais impactados;
- comportamento de cada factory antiga;
- atributos e associações configurados por cada factory antiga;
- comportamento do `after(:create)` de avaliadores.

Depois da alteração, confirme:

- cada factory antiga foi substituída por combinação equivalente de traits;
- os specs continuam representando os mesmos cenários;
- a criação padrão de avaliadores foi preservada;
- as factories `current_*` continuam criando contexto equivalente;
- não há referências antigas restantes, salvo justificativa;
- a suíte passa.

No relatório final, inclua um resumo da comparação antes/depois.

# Verificações obrigatórias

Após atualizar os specs e factories dependentes, procure referências antigas de factories de examination boards.

Use buscas específicas pelos nomes antigos reais:

```bash
grep -R "proposal_examination_board" spec
grep -R "project_examination_board" spec
grep -R "monograph_examination_board" spec
grep -R "examination_board_tcc_one" spec
grep -R "examination_board_tcc_two" spec
grep -R "current_examination_board_tcc_one" spec
grep -R "current_examination_board_tcc_one_project" spec
grep -R "current_examination_board_tcc_two" spec
```

Também verifique se ainda existem factories aninhadas antigas dentro de:

```bash
spec/factories/examination_boards.rb
```

Se alguma referência antiga permanecer, explique no relatório final.

# Testes esperados

Primeiro rode specs diretamente relacionados, usando caminhos existentes.

Possíveis caminhos relacionados:

```bash
./run rspec \
  spec/models/examination_boards \
  spec/features/academics/examination_boards \
  spec/features/professors/examination_boards \
  spec/features/responsible/examination_boards \
  spec/features/tcc_one_professors/examination_boards \
  spec/features/external_members/examination_boards
```

Se algum desses caminhos não existir, adapte para os caminhos reais encontrados e informe no relatório final.

Depois rode specs que dependem de orientações e documentos, se a factory de banca impactar esses fluxos:

```bash
./run rspec \
  spec/models/orientations \
  spec/models/documents \
  spec/features/professors/orientations \
  spec/features/responsible/orientations \
  spec/features/academics/orientations
```

Depois rode a suíte completa:

```bash
./run rspec spec
```

Também rode RuboCop nos arquivos afetados.

Comando mínimo esperado:

```bash
./run rubocop spec/factories/examination_boards.rb
```

Se specs forem alterados, rode RuboCop também nos arquivos alterados.

# Critérios de aceite

A task será considerada concluída se:

- `spec/factories/examination_boards.rb` usar uma estrutura baseada em traits reais;
- traits refletirem variações reais do domínio;
- a lista real de factories antigas tiver sido inventariada;
- os casos `current_*` forem mapeados corretamente para traits equivalentes;
- a criação padrão de avaliadores no `after(:create)` for preservada, salvo migração explícita e justificada;
- não for criado `:with_evaluators` opcional se isso mudar comportamento padrão;
- não forem criados traits `:confirmed` ou `:unconfirmed` sem base real;
- não forem criados traits sem correspondência com atributos/associações/estados reais;
- os nomes antigos de factories de examination boards forem substituídos nos specs;
- aliases antigos forem removidos quando não forem mais necessários;
- os cenários dos testes forem preservados;
- nenhum código de produção for alterado;
- nenhuma regra de negócio for alterada;
- `rails_helper.rb` e `spec_helper.rb` não forem alterados;
- nenhuma outra factory for alterada sem necessidade direta;
- a suíte completa `./run rspec spec` for executada com sucesso ou a impossibilidade for explicada claramente;
- RuboCop for executado nos arquivos afetados;
- pendências fora do escopo forem registradas no relatório final.

# Relatório final esperado

No relatório final, inclua:

## Resumo

Explique a refatoração feita em `examination_boards.rb`.

## Factories antigas identificadas

Liste os nomes antigos encontrados, incluindo:

- `:proposal_examination_board`;
- `:project_examination_board`;
- `:monograph_examination_board`;
- `:examination_board_tcc_one`;
- `:examination_board_tcc_two`;
- `:current_examination_board_tcc_one`;
- `:current_examination_board_tcc_one_project`;
- `:current_examination_board_tcc_two`.

## Nova estrutura

Liste os traits criados ou mantidos.

Não liste traits especulativos que não foram criados.

## Mapeamento de migração

Informe o mapeamento usado, por exemplo:

- `:proposal_examination_board` → `:examination_board, :proposal`;
- `:project_examination_board` → `:examination_board, :project`;
- `:monograph_examination_board` → `:examination_board, :monograph`;
- `:examination_board_tcc_one` → `:examination_board, :tcc_one`;
- `:examination_board_tcc_two` → `:examination_board, :tcc_two`;
- `:current_examination_board_tcc_one` → `:examination_board, :current_tcc_one, :proposal`;
- `:current_examination_board_tcc_one_project` → `:examination_board, :current_tcc_one, :project`;
- `:current_examination_board_tcc_two` → `:examination_board, :current_tcc_two, :monograph`.

Use os nomes reais encontrados no projeto.

## Avaliadores

Explique:

- se o `after(:create)` de avaliadores foi preservado;
- se professores e membros externos continuam sendo criados por padrão;
- se alguma lógica foi alterada;
- como foi validado que os specs que dependem de avaliadores continuam funcionando.

## Specs atualizados

Liste os principais arquivos ou grupos de specs alterados.

## Factories dependentes atualizadas

Informe se alguma outra factory precisou ser alterada por dependência direta.

Se foi alterada, explique exatamente qual referência foi migrada.

## Aliases removidos ou mantidos

Explique quais aliases foram removidos.

Se algum alias foi mantido, explique o motivo.

## Verificação de referências antigas

Informe se ainda existem referências antigas de factories de examination boards.

## Alterações fora de escopo pré-existentes

Informe se `spec/rails_helper.rb` ou outro arquivo proibido já estava alterado antes da task.

Não altere esses arquivos nesta task.

## Testes executados

Liste os comandos executados e o resultado.

Inclua obrigatoriamente o resultado de:

```bash
./run rspec spec
```

ou explique por que não foi possível executar.

## RuboCop executado

Liste os comandos executados e o resultado.

## Pendências encontradas

Liste problemas encontrados que não foram corrigidos por estarem fora do escopo.

# Observação final

Esta task não deve criar commit automaticamente.

As alterações devem ficar apenas no working tree para revisão manual com:

```bash
git status
git diff
```
