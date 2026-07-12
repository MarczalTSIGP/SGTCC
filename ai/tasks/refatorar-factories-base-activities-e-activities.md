# Task

Refatorar as factories `base_activities.rb` e `activities.rb` para usar traits reais do domínio, atualizar os testes que usam os nomes antigos dessas factories e garantir que a suíte termine verde.

# Contexto

Estamos na Task 2 do plano de refatoração das factories do SGTCC.

A Task 1, relacionada a `calendars.rb`, já foi concluída.

Agora o foco é refatorar:

- `spec/factories/base_activities.rb`
- `spec/factories/activities.rb`

Essas duas factories possuem padrão parecido e devem ser refatoradas juntas, pois uma espelha a outra em vários pontos.

Volume real identificado:

- aproximadamente 45 ocorrências em 21 arquivos;
- essas factories mudam nomes ou passam a usar traits, então os specs devem ser atualizados nesta mesma task.

A estratégia desta task é:

1. refatorar as factories para uma estrutura baseada em traits;
2. manter aliases temporários apenas durante a migração, se necessário;
3. atualizar os testes para usar a nova sintaxe;
4. remover aliases antigos quando não houver mais referências;
5. rodar RSpec e RuboCop;
6. terminar com a suíte verde.

# Objetivo

Refatorar `base_activities.rb` e `activities.rb` para reduzir duplicação e melhorar clareza, usando traits reais que representem variações já existentes nas factories atuais.

Ao final da task:

- os testes devem usar a nova sintaxe com traits;
- os nomes antigos de factories de base activities e activities não devem permanecer nos specs, salvo justificativa;
- aliases temporários devem ser removidos se não forem mais necessários;
- a suíte completa deve passar.

# Instrução crítica

Esta task deve alterar apenas:

- `spec/factories/base_activities.rb`;
- `spec/factories/activities.rb`;
- specs que referenciam factories antigas de base activities ou activities;
- arquivos de teste diretamente necessários para atualizar essas referências.

Não altere código de produção.

Não altere:

- `app/`;
- `config/`;
- `db/`;
- `lib/`;
- outras factories, exceto se houver dependência direta e inevitável;
- regras de negócio;
- models;
- controllers;
- services;
- views;
- migrations.

Não faça commit.

Não faça push.

Não abra Pull Request.

As alterações devem ficar apenas no working tree para revisão manual.

# Escopo permitido

Você pode alterar:

- `spec/factories/base_activities.rb`;
- `spec/factories/activities.rb`;
- specs em `spec/` que usam factories antigas de base activities ou activities;
- apenas referências de teste necessárias para migrar o uso dessas factories para traits.

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

Esta task deve apenas refatorar as factories de base activities/activities e atualizar os testes para a nova API das factories.

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

Antes de alterar, faça um inventário das factories atuais.

Identifique em `spec/factories/base_activities.rb`:

- nomes de factories existentes;
- traits já existentes, se houver;
- atributos padrão;
- valores reais de `tcc`, `identifier`, `title`, `description` ou equivalentes;
- callbacks;
- associações;
- factories aninhadas;
- nomes antigos usados nos specs.

Identifique em `spec/factories/activities.rb`:

- nomes de factories existentes;
- traits já existentes, se houver;
- atributos padrão;
- valor de `base_activity_type`;
- vínculo com `calendar`;
- variações reais por TCC;
- variações reais por tipo de banca/documento, se existirem;
- callbacks;
- factories aninhadas;
- nomes antigos usados nos specs.

Depois, crie uma nova estrutura baseada em traits reais.

# Padrão desejado para `base_activities.rb`

A factory principal deve ser algo como:

```ruby
factory :base_activity do
  # atributos padrão seguros
end
```

Os comportamentos específicos devem ser expressos com traits baseadas nas factories antigas reais.

Traits esperadas, se corresponderem ao código atual:

```ruby
trait :tcc_one
trait :tcc_two
```

Não crie traits sem base em atributos reais do model.

Não crie traits como:

- `:with_deadline`;
- `:without_deadline`;
- `:active`;
- `:inactive`.

Esses traits não devem ser criados se `BaseActivity` não possuir campos correspondentes.

Não invente valores novos.

Não altere regras do model `BaseActivity`.

# Padrão desejado para `activities.rb`

A factory principal deve ser algo como:

```ruby
factory :activity do
  # atributos padrão seguros
end
```

Os comportamentos específicos devem ser expressos com traits baseadas nas factories antigas reais.

Traits esperadas, se corresponderem ao código atual:

```ruby
trait :tcc_one
trait :tcc_two
trait :proposal
trait :project
trait :monograph
```

Esses traits devem substituir factories antigas como:

- `activity_tcc_one`;
- `activity_tcc_two`;
- `proposal_activity`;
- `project_activity`;
- `monograph_activity`.

Não crie traits sem base em atributos reais do model.

Não crie traits como:

- `:with_base_activity`;
- `:with_orientation`;
- `:with_calendar`;
- `:answered`;
- `:pending`.

Esses traits não devem ser criados se `Activity` não possuir associações ou campos correspondentes.

Observações importantes:

- `Activity` não deve receber trait `:with_base_activity` se o model não possuir `belongs_to :base_activity`.
- `Activity` não deve receber trait `:with_orientation` se não houver associação direta com `orientation`.
- `Activity` não precisa receber trait `:with_calendar` se `calendar` já for atributo padrão da factory.
- Não crie traits de status como `:answered` ou `:pending` se o model não possuir esse conceito diretamente.

Não altere regras do model `Activity`.

# Exemplos de uso desejado nos specs

A ideia é substituir usos antigos como:

```ruby
create(:base_activity_tcc_one)
create(:base_activity_tcc_two)
create(:activity_tcc_one)
create(:activity_tcc_two)
create(:proposal_activity)
create(:project_activity)
create(:monograph_activity)
```

por combinações com traits, por exemplo:

```ruby
create(:base_activity, :tcc_one)
create(:base_activity, :tcc_two)
create(:activity, :tcc_one)
create(:activity, :tcc_two)
create(:activity, :proposal)
create(:activity, :project)
create(:activity, :monograph)
```

Esses nomes devem ser confirmados contra as factories reais antes da substituição.

Preserve atributos sobrescritos.

Exemplo:

```ruby
create(:activity_tcc_one, title: "Entrega da proposta")
```

deve virar algo como:

```ruby
create(:activity, :tcc_one, title: "Entrega da proposta")
```

Não remova atributos explícitos sem necessidade.

# Aliases temporários

Durante a migração, você pode manter aliases temporários para facilitar a transição.

Porém, ao final desta task, se todos os specs tiverem sido atualizados para traits, remova os aliases antigos.

A task deve terminar preferencialmente sem factories antigas duplicando comportamento.

Se algum alias antigo precisar permanecer por compatibilidade, explique no relatório final:

- qual alias ficou;
- por que não foi removido;
- onde ainda é usado;
- qual task futura deve removê-lo.

# Cuidados importantes

`BaseActivity` e `Activity` podem possuir regras sensíveis, como:

- TCC I;
- TCC II;
- tipo de atividade;
- identificador;
- calendário;
- status ou tipo derivado, se existir;
- associação com calendário;
- associação com documentos ou respostas, se existir no domínio real.

Ao refatorar as factories:

- preserve comportamento equivalente ao das factories antigas;
- evite gerar conflitos de validação;
- use sequences quando necessário;
- não deixe traits criando combinações inválidas;
- não altere expectativas dos testes para se adaptar à factory;
- ajuste apenas o uso da factory para preservar o mesmo cenário.

# Regra de comparação antes/depois

Antes da alteração, registre internamente:

- nomes das factories antigas em `base_activities.rb`;
- nomes das factories antigas em `activities.rb`;
- quantidade aproximada de referências encontradas;
- arquivos principais impactados;
- comportamento de cada factory antiga.

Depois da alteração, confirme:

- cada factory antiga foi substituída por combinação equivalente de traits;
- os specs continuam representando os mesmos cenários;
- não há referências antigas restantes, salvo justificativa;
- a suíte passa.

No relatório final, inclua um resumo da comparação antes/depois.

# Verificações obrigatórias

Após atualizar os specs, procure referências antigas de factories de base activities e activities.

Use comandos equivalentes a:

```bash
grep -R "base_activity_" spec
grep -R "activity_" spec
grep -R "proposal_activity" spec
grep -R "project_activity" spec
grep -R "monograph_activity" spec
```

Atenção: esses comandos podem retornar nomes legítimos de arquivos, métodos ou atributos.

Use o resultado com cuidado para identificar apenas factories antigas.

Também verifique se ainda existem factories aninhadas antigas dentro de:

```bash
spec/factories/base_activities.rb
spec/factories/activities.rb
```

Se alguma referência antiga permanecer, explique no relatório final.

# Testes esperados

Primeiro rode os testes mais diretamente relacionados.

Use apenas caminhos existentes:

```bash
./run rspec \
  spec/models/base_activities \
  spec/models/activities
```

Depois rode os specs de feature que mais dependem de atividades, se existirem no projeto:

```bash
./run rspec \
  spec/features/responsible/base_activities \
  spec/features/responsible/activities \
  spec/features/academics/orientations \
  spec/features/professors/orientations \
  spec/features/professors/supervisions \
  spec/features/responsible/orientations \
  spec/features/external_members/supervisions \
  spec/features/tcc_one_professors/orientations
```

Depois rode a suíte completa:

```bash
./run rspec spec
```

Também rode RuboCop nos arquivos afetados.

Comando mínimo esperado:

```bash
./run rubocop \
  spec/factories/base_activities.rb \
  spec/factories/activities.rb
```

Se possível, rode RuboCop nos specs alterados também.

Não use caminhos inexistentes como:

```bash
spec/models/base_activity_spec.rb
spec/models/activity_spec.rb
```

Esses arquivos não existem no estado atual do projeto.

# Critérios de aceite

A task será considerada concluída se:

- `spec/factories/base_activities.rb` usar uma estrutura baseada em traits reais;
- `spec/factories/activities.rb` usar uma estrutura baseada em traits reais;
- não forem criados traits sem correspondência com atributos/associações reais;
- os nomes antigos de factories de base activities e activities forem substituídos nos specs;
- aliases antigos forem removidos quando não forem mais necessários;
- os cenários dos testes forem preservados;
- nenhum código de produção for alterado;
- nenhuma regra de negócio for alterada;
- nenhuma outra factory for alterada sem necessidade direta;
- a suíte completa `./run rspec spec` for executada com sucesso ou a impossibilidade for explicada claramente;
- RuboCop for executado nos arquivos afetados;
- pendências fora do escopo forem registradas no relatório final.

# Relatório final esperado

No relatório final, inclua:

## Resumo

Explique a refatoração feita em:

- `base_activities.rb`;
- `activities.rb`.

## Factories antigas identificadas

Liste os nomes antigos encontrados.

## Nova estrutura

Liste os traits criados ou mantidos.

Não liste traits especulativos que não foram criados.

## Mapeamento de migração

Informe o mapeamento usado, por exemplo:

- `:base_activity_tcc_one` → `:base_activity, :tcc_one`;
- `:base_activity_tcc_two` → `:base_activity, :tcc_two`;
- `:activity_tcc_one` → `:activity, :tcc_one`;
- `:activity_tcc_two` → `:activity, :tcc_two`;
- `:proposal_activity` → `:activity, :proposal`;
- `:project_activity` → `:activity, :project`;
- `:monograph_activity` → `:activity, :monograph`.

Use os nomes reais encontrados no projeto.

## Specs atualizados

Liste os principais arquivos ou grupos de specs alterados.

## Aliases removidos ou mantidos

Explique quais aliases foram removidos.

Se algum alias foi mantido, explique o motivo.

## Verificação de referências antigas

Informe se ainda existem referências antigas de factories de base activities ou activities.

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
