# Task

Refatorar as factories `academic_activities.rb` e `signatures.rb` para usar traits reais do domínio, atualizar os testes que usam os nomes antigos dessas factories e garantir que a suíte termine verde.

# Contexto

Estamos na Task 3 do plano de refatoração das factories do SGTCC.

As tasks anteriores já foram concluídas:

- Task 1: `calendars.rb`;
- Task 2: `base_activities.rb` + `activities.rb`.

Agora o foco é refatorar:

- `spec/factories/academic_activities.rb`;
- `spec/factories/signatures.rb`.

Essas duas factories foram agrupadas porque possuem volume menor de referências nos testes:

- `academic_activities.rb`: aproximadamente 5 referências;
- `signatures.rb`: aproximadamente 20 referências.

Ambas possuem factories antigas/aninhadas que devem ser convertidas para traits reais do domínio.

A estratégia desta task é:

1. refatorar as factories para uma estrutura baseada em traits reais;
2. manter aliases temporários apenas durante a migração, se necessário;
3. atualizar os testes e factories dependentes para usar a nova sintaxe;
4. remover aliases antigos quando não houver mais referências;
5. rodar RSpec e RuboCop;
6. terminar com a suíte verde.

# Objetivo

Refatorar `academic_activities.rb` e `signatures.rb` para reduzir duplicação e melhorar clareza, usando traits que representem variações reais já existentes no domínio.

Ao final da task:

- os testes devem usar a nova sintaxe com traits;
- factories dependentes devem usar a nova sintaxe quando necessário;
- os nomes antigos dessas factories não devem permanecer nos specs, salvo justificativa;
- aliases temporários devem ser removidos se não forem mais necessários;
- a suíte completa deve passar.

# Instrução crítica

Esta task deve alterar apenas:

- `spec/factories/academic_activities.rb`;
- `spec/factories/signatures.rb`;
- specs que referenciam factories antigas de academic activities ou signatures;
- factories diretamente dependentes dessas factories, quando a atualização for inevitável;
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
- migrations.

Não faça commit.

Não faça push.

Não abra Pull Request.

As alterações devem ficar apenas no working tree para revisão manual.

# Escopo permitido

Você pode alterar:

- `spec/factories/academic_activities.rb`;
- `spec/factories/signatures.rb`;
- specs em `spec/` que usam factories antigas de academic activities ou signatures;
- `spec/factories/orientations.rb`, somente se for necessário atualizar referência antiga a `:academic_activity_no_complementary_files`;
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

Esta task deve apenas refatorar as factories de academic activities/signatures e atualizar os testes/factories dependentes para a nova API das factories.

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

Identifique em `spec/factories/academic_activities.rb`:

- nomes de factories existentes;
- traits já existentes, se houver;
- atributos padrão;
- associações;
- callbacks;
- factories aninhadas;
- nomes antigos usados nos specs;
- diferenças reais entre as factories antigas.

As factories antigas esperadas em `academic_activities.rb` são:

- `:proposal_academic_activity`;
- `:project_academic_activity`;
- `:monograph_academic_activity`;
- `:academic_activity_no_complementary_files`.

Identifique em `spec/factories/signatures.rb`:

- nomes de factories existentes;
- traits já existentes, se houver;
- atributos padrão;
- associações;
- callbacks;
- factories aninhadas;
- nomes antigos usados nos specs;
- diferenças reais entre assinaturas de perfis diferentes;
- diferenças reais entre assinatura pendente, assinada ou outros estados;
- enums reais usados pelo model `Signature`.

Depois, crie uma nova estrutura baseada em traits reais.

# Padrão desejado para `academic_activities.rb`

A factory principal deve ser algo como:

```ruby
factory :academic_activity do
  # atributos padrão seguros
end
```

Os comportamentos específicos devem ser expressos com traits baseadas nas factories antigas reais.

Traits esperadas, se corresponderem ao código atual:

```ruby
trait :proposal
trait :project
trait :monograph
trait :without_complementary_files
```

Mapeamento esperado:

```ruby
create(:proposal_academic_activity)
# vira
create(:academic_activity, :proposal)

create(:project_academic_activity)
# vira
create(:academic_activity, :project)

create(:monograph_academic_activity)
# vira
create(:academic_activity, :monograph)

create(:academic_activity_no_complementary_files)
# vira
create(:academic_activity, :without_complementary_files)
```

Não dê ênfase a traits `:tcc_one` e `:tcc_two` nesta factory, a menos que elas existam de fato no código atual e sejam necessárias para preservar uma factory antiga real.

Não crie traits sem base no domínio real.

Não invente valores novos.

Não altere regras do model `AcademicActivity`.

# Padrão desejado para `signatures.rb`

A factory principal deve ser algo como:

```ruby
factory :signature do
  # atributos padrão seguros
end
```

As variações devem ser expressas com traits combináveis.

Use nomes de traits que correspondam aos enums e nomes reais do domínio.

Traits esperadas, se corresponderem ao código atual:

```ruby
trait :tcai
trait :tco
trait :signed
trait :academic
trait :advisor
trait :professor_supervisor
trait :external_member_supervisor
trait :responsible_institution
```

Não use trait genérica `:external_member` se o domínio real da factory usa `:external_member_supervisor`.

Mapeamento recomendado:

```ruby
:signature_tcai
# vira
:signature, :tcai

:signature_tco
# vira
:signature, :tco

:signature_signed
# vira
:signature, :signed

:academic_signature
# vira
:signature, :academic

:external_member_signature
# vira
:signature, :external_member_supervisor

:professor_supervisor_signature
# vira
:signature, :professor_supervisor

:academic_signature_signed
# vira
:signature, :academic, :signed

:external_member_signature_signed
# vira
:signature, :external_member_supervisor, :signed
```

Antes de criar qualquer trait, confirme:

- se o model possui o enum, atributo ou associação correspondente;
- se a factory antiga já representava esse comportamento;
- se existe uso real nos specs;
- se o trait substitui uma factory antiga ou reduz duplicação real.

Não crie traits sem base real.

Não crie traits apenas porque parecem úteis.

Não altere regras do model `Signature`.

# Exemplos de uso desejado nos specs

A ideia é substituir usos antigos como:

```ruby
create(:proposal_academic_activity)
create(:project_academic_activity)
create(:monograph_academic_activity)
create(:academic_activity_no_complementary_files)

create(:signature_tcai)
create(:signature_tco)
create(:signature_signed)
create(:academic_signature)
create(:external_member_signature)
create(:professor_supervisor_signature)
create(:academic_signature_signed)
create(:external_member_signature_signed)
```

por combinações com traits, por exemplo:

```ruby
create(:academic_activity, :proposal)
create(:academic_activity, :project)
create(:academic_activity, :monograph)
create(:academic_activity, :without_complementary_files)

create(:signature, :tcai)
create(:signature, :tco)
create(:signature, :signed)
create(:signature, :academic)
create(:signature, :external_member_supervisor)
create(:signature, :professor_supervisor)
create(:signature, :academic, :signed)
create(:signature, :external_member_supervisor, :signed)
```

Esses nomes devem ser confirmados contra as factories reais antes da substituição.

Preserve atributos sobrescritos.

Exemplo:

```ruby
create(:academic_signature, document: document)
```

deve virar algo como:

```ruby
create(:signature, :academic, document: document)
```

se esse mapeamento corresponder ao comportamento real.

Não remova atributos explícitos sem necessidade.

# Atualização de factory dependente

Verifique `spec/factories/orientations.rb`.

Se ela ainda referenciar:

```ruby
:academic_activity_no_complementary_files
```

atualize para a nova sintaxe equivalente:

```ruby
:academic_activity, :without_complementary_files
```

ou para a forma correta conforme o padrão real do arquivo.

Essa alteração é permitida nesta task porque é dependência direta inevitável da remoção do alias antigo.

Não altere outras partes de `orientations.rb` sem necessidade.

# Aliases temporários

Durante a migração, você pode manter aliases temporários para facilitar a transição.

Porém, ao final desta task, se todos os specs e factories dependentes tiverem sido atualizados para traits, remova os aliases antigos.

A task deve terminar preferencialmente sem factories antigas duplicando comportamento.

Se algum alias antigo precisar permanecer por compatibilidade, explique no relatório final:

- qual alias ficou;
- por que não foi removido;
- onde ainda é usado;
- qual task futura deve removê-lo.

# Cuidados importantes

`AcademicActivity` e `Signature` podem possuir regras sensíveis, como:

- tipo de atividade acadêmica;
- proposta;
- projeto;
- monografia;
- arquivos complementares;
- vínculo com calendário;
- vínculo com orientação;
- vínculo com documento;
- usuário assinante;
- perfil do usuário;
- data/hora de assinatura;
- status da assinatura;
- resolução da tabela relacionada ao usuário;
- validações de presença.

Ao refatorar as factories:

- preserve comportamento equivalente ao das factories antigas;
- evite gerar combinações inválidas;
- use sequences quando necessário;
- não deixe traits criando estados inconsistentes;
- não altere expectativas dos testes para se adaptar à factory;
- ajuste apenas o uso da factory para preservar o mesmo cenário.

# Regra de comparação antes/depois

Antes da alteração, registre internamente:

- nomes das factories antigas em `academic_activities.rb`;
- nomes das factories antigas em `signatures.rb`;
- quantidade aproximada de referências encontradas;
- arquivos principais impactados;
- comportamento de cada factory antiga.

Depois da alteração, confirme:

- cada factory antiga foi substituída por combinação equivalente de traits;
- os specs e factories dependentes continuam representando os mesmos cenários;
- não há referências antigas restantes, salvo justificativa;
- a suíte passa.

No relatório final, inclua um resumo da comparação antes/depois.

# Verificações obrigatórias

Após atualizar os specs e factories dependentes, procure referências antigas de factories de academic activities e signatures.

Use comandos equivalentes a:

```bash
grep -R "proposal_academic_activity" spec
grep -R "project_academic_activity" spec
grep -R "monograph_academic_activity" spec
grep -R "academic_activity_no_complementary_files" spec
grep -R "signature_tcai" spec
grep -R "signature_tco" spec
grep -R "signature_signed" spec
grep -R "academic_signature" spec
grep -R "external_member_signature" spec
grep -R "professor_supervisor_signature" spec
grep -R "academic_signature_signed" spec
grep -R "external_member_signature_signed" spec
```

Atenção: esses comandos podem retornar nomes legítimos em comentários ou relatórios.

Use o resultado com cuidado para identificar apenas factories antigas.

Também verifique se ainda existem factories aninhadas antigas dentro de:

```bash
spec/factories/academic_activities.rb
spec/factories/signatures.rb
```

Se alguma referência antiga permanecer, explique no relatório final.

# Testes esperados

Primeiro rode os testes diretamente relacionados, usando apenas caminhos existentes no projeto.

Antes de rodar comandos específicos, verifique se os caminhos existem.

Possíveis caminhos relacionados:

```bash
./run rspec \
  spec/models/academic_activities \
  spec/models/signatures
```

Se esses diretórios não existirem, rode os specs encontrados por busca com nomes relacionados a `academic_activity` e `signature`.

Depois rode specs de documentos e assinaturas, se existirem:

```bash
./run rspec \
  spec/features/academics/documents \
  spec/features/professors/documents \
  spec/features/external_members/documents
```

Como `spec/factories/orientations.rb` pode ser atualizado, rode também specs de orientações se houver alteração nesse arquivo:

```bash
./run rspec \
  spec/models/orientations \
  spec/features/academics/orientations \
  spec/features/professors/orientations \
  spec/features/responsible/orientations \
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
  spec/factories/academic_activities.rb \
  spec/factories/signatures.rb
```

Se `spec/factories/orientations.rb` for alterado, inclua também:

```bash
./run rubocop \
  spec/factories/academic_activities.rb \
  spec/factories/signatures.rb \
  spec/factories/orientations.rb
```

Se possível, rode RuboCop nos specs alterados também.

Não use caminhos inexistentes. Se algum caminho sugerido não existir, adapte para os caminhos reais encontrados e informe no relatório final.

# Critérios de aceite

A task será considerada concluída se:

- `spec/factories/academic_activities.rb` usar uma estrutura baseada em traits reais;
- `spec/factories/signatures.rb` usar uma estrutura baseada em traits reais;
- traits de `academic_activities` refletirem as factories antigas reais, especialmente `:proposal`, `:project`, `:monograph` e `:without_complementary_files`;
- traits de `signatures` refletirem enums/nomes reais do domínio, especialmente `:external_member_supervisor` em vez de trait genérica `:external_member`;
- não forem criados traits sem correspondência com atributos/associações/estados reais;
- os nomes antigos de factories de academic activities e signatures forem substituídos nos specs;
- `spec/factories/orientations.rb` for atualizado se ainda depender de `:academic_activity_no_complementary_files`;
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

- `academic_activities.rb`;
- `signatures.rb`.

## Factories antigas identificadas

Liste os nomes antigos encontrados.

## Nova estrutura

Liste os traits criados ou mantidos.

Não liste traits especulativos que não foram criados.

## Mapeamento de migração

Informe o mapeamento usado, por exemplo:

- `:proposal_academic_activity` → `:academic_activity, :proposal`;
- `:project_academic_activity` → `:academic_activity, :project`;
- `:monograph_academic_activity` → `:academic_activity, :monograph`;
- `:academic_activity_no_complementary_files` → `:academic_activity, :without_complementary_files`;
- `:signature_tcai` → `:signature, :tcai`;
- `:signature_tco` → `:signature, :tco`;
- `:signature_signed` → `:signature, :signed`;
- `:academic_signature` → `:signature, :academic`;
- `:external_member_signature` → `:signature, :external_member_supervisor`;
- `:professor_supervisor_signature` → `:signature, :professor_supervisor`;
- `:academic_signature_signed` → `:signature, :academic, :signed`;
- `:external_member_signature_signed` → `:signature, :external_member_supervisor, :signed`.

Use os nomes reais encontrados no projeto.

## Specs atualizados

Liste os principais arquivos ou grupos de specs alterados.

## Factories dependentes atualizadas

Informe se `spec/factories/orientations.rb` foi alterado.

Se foi alterado, explique exatamente qual referência foi migrada.

## Aliases removidos ou mantidos

Explique quais aliases foram removidos.

Se algum alias foi mantido, explique o motivo.

## Verificação de referências antigas

Informe se ainda existem referências antigas de factories de academic activities ou signatures.

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
