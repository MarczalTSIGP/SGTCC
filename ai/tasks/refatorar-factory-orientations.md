# Task

Refatorar a factory `orientations.rb` para usar traits reais do domínio, atualizar todos os testes que usam os nomes antigos dessa factory e garantir que a suíte termine verde.

# Contexto

Estamos na Task 6 do plano de refatoração das factories do SGTCC.

As tasks anteriores já foram concluídas:

- Task 1: `calendars.rb`;
- Task 2: `base_activities.rb` + `activities.rb`;
- Task 3: `academic_activities.rb` + `signatures.rb`;
- Task 4: `professors.rb` + `document_types.rb` + `documents.rb`;
- Task 5: `examination_boards.rb`.

Agora o foco é refatorar:

- `spec/factories/orientations.rb`.

Essa é a factory mais complexa do plano, porque `Orientation` costuma depender de:

- calendário;
- acadêmico;
- professor/orientador;
- instituição;
- status;
- TCC I;
- TCC II;
- migração de TCC I para TCC II;
- atividades acadêmicas;
- documentos;
- bancas;
- supervisores;
- dados históricos.

Volume estimado:

- aproximadamente 215 referências nos testes;
- existem factories antigas/aninhadas que devem ser convertidas para traits;
- os specs que usam nomes antigos devem ser atualizados nesta mesma task.

A estratégia desta task é:

1. refatorar `spec/factories/orientations.rb` para uma estrutura baseada em traits reais;
2. manter aliases temporários durante a migração;
3. validar equivalência com specs diretamente relacionados;
4. migrar os specs por grupos;
5. remover aliases antigos somente depois que não houver mais referências;
6. rodar RSpec e RuboCop;
7. terminar com a suíte verde.

# Atenção antes de executar

Antes de iniciar esta task, verifique o working tree.

Use:

```bash id="sz7rpo"
git status
```

Se houver arquivos alterados fora do escopo desta task, especialmente:

```bash id="xky7j3"
spec/rails_helper.rb
spec/spec_helper.rb
app/
config/
db/
lib/
```

não altere esses arquivos nesta task.

Registre no relatório final se havia alteração pré-existente fora de escopo.

# Objetivo

Refatorar `spec/factories/orientations.rb` para reduzir duplicação, melhorar clareza e tornar explícitas as variações de orientação por meio de traits.

Ao final da task:

- os testes devem usar a nova sintaxe com traits;
- os nomes antigos de factories de orientações não devem permanecer nos specs, salvo justificativa;
- aliases temporários devem ser removidos se não forem mais necessários;
- os cenários dos testes devem continuar equivalentes;
- a suíte completa deve passar.

# Instrução crítica

Esta task deve alterar apenas:

- `spec/factories/orientations.rb`;
- specs que referenciam factories antigas de orientations;
- factories diretamente dependentes de orientations, somente se a atualização for inevitável;
- arquivos de teste diretamente necessários para atualizar essas referências.

Não altere código de produção.

Não altere:

- `app/`;
- `config/`;
- `db/`;
- `lib/`;
- `rails_helper.rb`;
- `spec_helper.rb`;
- models;
- controllers;
- services;
- views;
- migrations;
- regras de negócio.

Não faça commit.

Não faça push.

Não abra Pull Request.

As alterações devem ficar apenas no working tree para revisão manual.

# Escopo permitido

Você pode alterar:

- `spec/factories/orientations.rb`;
- specs em `spec/` que usam factories antigas de orientations;
- outras factories em `spec/factories/` somente se houver dependência direta inevitável;
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

Esta task deve apenas refatorar a factory de orientations e atualizar os testes para a nova API da factory.

Não corrija expectativas.
Não corrija iteradores.
Não corrija matchers.
Não corrija cenários aparentemente incorretos.
Não altere lógica dos testes.
Não altere dados de setup para “melhorar” o teste, exceto quando for necessário para usar a nova factory equivalente.
Não remova cenários.
Não reduza cobertura.

Se um spec quebrar após a migração, primeiro tente preservar o comportamento anterior ajustando a factory.

Alterar spec deve ser último recurso e precisa de justificativa forte no relatório final.

# Factories antigas reais esperadas

As factories antigas reais encontradas em `spec/factories/orientations.rb` são:

- `:orientation_tcc_one`;
- `:orientation_tcc_two`;
- `:current_orientation_tcc_one`;
- `:current_orientation_tcc_two`;
- `:previous_orientation_tcc_one`;
- `:previous_orientation_tcc_two`;
- `:orientation_tcc_one_approved`;
- `:orientation_tcc_two_approved`;
- `:orientation_tcc_one_approved_current_calendar`;
- `:orientation_tcc_one_approved_next_calendar`;
- `:orientation_tcc_two_approved_no_complementary_files`;
- `:orientation_approved`;
- `:orientation_canceled`;
- `:orientation_reproved`.

Antes de alterar, confirme se essa lista ainda está correta no código atual.

Se houver factories adicionais, inclua no inventário e no relatório final.

# Estratégia obrigatória em fases

Não execute esta task como um big bang.

Siga as fases abaixo.

## Fase 1 — Refatorar a factory com aliases temporários

Refatore `spec/factories/orientations.rb` criando a factory base e traits reais.

Nesta fase, mantenha aliases temporários para os nomes antigos, apontando para as novas combinações de traits.

Objetivo da Fase 1:

- provar que a nova estrutura reproduz o comportamento antigo;
- evitar quebrar todos os specs de uma vez;
- permitir migração segura por grupos.

## Fase 2 — Validar equivalência com specs diretamente relacionados

Antes de migrar todos os specs, rode specs diretamente relacionados a orientations.

Use caminhos existentes.

Exemplo:

```bash id="90vqhs"
./run rspec spec/models/orientations
```

e outros caminhos reais encontrados.

Se algo quebrar, primeiro corrija a factory para preservar o comportamento antigo.

## Fase 3 — Migrar specs por grupos

Migre os usos antigos para a nova sintaxe com traits por grupos de specs.

Sugestão de ordem:

1. `spec/models/orientations`;
2. `spec/features/academics/orientations`;
3. `spec/features/professors/orientations`;
4. `spec/features/professors/supervisions`;
5. `spec/features/responsible/orientations`;
6. `spec/features/responsible/supervisions`;
7. `spec/features/tcc_one_professors/orientations`;
8. `spec/features/external_members/supervisions`;
9. demais specs encontrados por busca.

Após cada grupo relevante, rode os specs daquele grupo.

## Fase 4 — Remover aliases antigos

Depois que todos os specs e factories dependentes estiverem migrados para traits, remova os aliases antigos.

Antes de remover, confirme por busca que os nomes antigos não existem mais em `spec/`.

## Fase 5 — Rodar suíte completa

Rode a suíte completa:

```bash id="gxcvhs"
./run rspec spec
```

Depois rode RuboCop nos arquivos afetados.

# Inventário obrigatório

Antes de alterar, faça um inventário completo da factory atual.

Identifique em `spec/factories/orientations.rb`:

- nomes de factories existentes;
- traits já existentes, se houver;
- atributos padrão;
- status padrão;
- status alternativos;
- vínculo com `academic`;
- vínculo com `advisor` ou `professor`;
- vínculo com `institution`;
- vínculo com `calendar`;
- vínculo com `orientation_calendar`, se existir;
- vínculo com `academic_activity`, se existir;
- vínculo com documentos, se existir;
- vínculo com bancas, se existir;
- callbacks;
- supervisores criados no callback;
- factories aninhadas;
- nomes antigos usados nos specs;
- diferenças reais entre as factories antigas;
- dependências com factories já refatoradas nas tasks anteriores.

Depois, crie uma nova estrutura baseada em traits reais.

# Padrão desejado da factory

A factory principal deve ser algo como:

```ruby id="mexsnd"
factory :orientation do
  # atributos padrão seguros
end
```

As variações devem ser expressas com traits combináveis.

# Separação entre traits simples e traits que criam dados

Separe mentalmente os traits em dois grupos.

## Traits de estado/calendário

Traits que configuram estado, calendário ou tipo de TCC.

Exemplos esperados, se corresponderem ao código real:

```ruby id="zrvuwb"
trait :tcc_one
trait :tcc_two
trait :current
trait :previous
trait :next
trait :approved_tcc_one
trait :approved
trait :canceled
trait :reproved_tcc_one
trait :reproved
```

## Traits com criação de dados

Traits que criam ou associam registros relacionados.

Exemplos esperados, se corresponderem ao código real:

```ruby id="9ops39"
trait :with_final_project
trait :with_final_monograph
trait :with_approved_project_board
trait :with_approved_monograph_board
trait :without_complementary_files
```

Não crie trait mágico demais que configure status, calendário, documentos e banca de forma escondida sem necessidade.

Prefira combinações explícitas de traits, desde que preservem o comportamento antigo.

# Status e enums reais

`Orientation` possui regras sensíveis relacionadas a status.

Os status reais conhecidos são:

- `APPROVED_TCC_ONE`;
- `APPROVED`;
- `IN_PROGRESS`;
- `CANCELED`;
- `REPROVED_TCC_ONE`;
- `REPROVED`.

Não invente status.

Não crie trait `:approved_tcc_two`.

Para TCC II aprovado, preserve o status real:

```ruby id="yoj6f2"
APPROVED
```

O trait adequado para TCC II aprovado deve ser algo como:

```ruby id="8vn2bs"
trait :approved
```

e não:

```ruby id="mhxmqq"
trait :approved_tcc_two
```

Traits de status devem apenas configurar a factory para o mesmo estado que uma factory antiga já configurava.

Não altere enums.

Não altere regras de migração.

# TCC I e TCC II

As factories antigas diferenciam orientações de TCC I e TCC II.

Essa diferença pode estar em:

- calendário;
- semestre;
- status;
- academic activity;
- orientation calendar;
- documentos;
- tipo de resumo;
- associação indireta;
- banca;
- dados auxiliares.

Ao criar traits como:

```ruby id="d0pykj"
trait :tcc_one
trait :tcc_two
```

preserve o comportamento antigo completo.

Não crie trait que apenas altera um atributo e perde associações importantes.

# Current, previous e next calendar

Como `calendars.rb` já foi refatorado na Task 1, esta task deve usar a nova API da factory de calendars.

Se a factory antiga de orientation criava calendário atual, anterior ou próximo, migre para combinações com traits reais de `calendar`.

Exemplo conceitual:

```ruby id="vci1mi"
create(:calendar, :current, :tcc_one)
create(:calendar, :current, :tcc_two)
```

Use os traits reais criados na Task 1.

Não recrie aliases antigos de calendário.

Não volte a usar factories antigas removidas em tasks anteriores.

# Academic activities

Como `academic_activities.rb` já foi refatorado na Task 3, esta task deve usar a nova API da factory de academic activities.

Se `orientations.rb` ainda usa factories antigas como:

```ruby id="1j7d6b"
:academic_activity_no_complementary_files
:proposal_academic_activity
:project_academic_activity
:monograph_academic_activity
```

migre para os traits reais criados na Task 3.

Exemplo conceitual:

```ruby id="0jf64r"
create(:academic_activity, :without_complementary_files)
create(:academic_activity, :proposal)
create(:academic_activity, :project)
create(:academic_activity, :monograph)
```

Use os nomes reais disponíveis no projeto.

Não recrie aliases antigos de academic activities.

# Examination boards

Como `examination_boards.rb` já foi refatorado na Task 5, esta task deve usar a nova API da factory de examination boards.

Se `orientations.rb` ou specs de orientations ainda usam factories antigas de bancas, não recrie aliases antigos.

Use a nova sintaxe com traits.

Exemplo conceitual:

```ruby id="w0mhoy"
create(:examination_board, :proposal)
create(:examination_board, :project)
create(:examination_board, :monograph)
```

Use os nomes reais disponíveis no projeto.

# Callbacks e supervisores

A factory base de `orientation` possui `after(:create)` que adiciona:

- `professor_supervisors`;
- `external_member_supervisors`.

Preserve esse comportamento por padrão.

Esse callback pode ser comportamento esperado por vários specs.

Se algum trait aprovado herdar esse callback e adicionar outros supervisores, confirme se isso reproduz exatamente o comportamento antigo.

Cuidado: callbacks de FactoryBot são herdados.

Não remova criação de supervisores apenas por parecer acoplada.

Se houver duplicação de supervisores após a refatoração, compare com o comportamento antigo antes de alterar.

Se o comportamento antigo já criava múltiplos supervisores em determinada factory, preserve.

Se algum spec passar supervisores explicitamente, a factory não deve sobrescrever ou duplicar sem necessidade.

# Overrides devem vencer

Preserve overrides passados pelos specs.

Muitos specs podem fazer chamadas como:

```ruby id="znejdx"
create(:orientation_tcc_one_approved, calendars: [current_calendar])
create(:current_orientation_tcc_one, advisor: professor)
create(:current_orientation_tcc_one, academic: academic)
create(:orientation_tcc_one, institution: institution)
create(:orientation_tcc_two, status: Orientation::APPROVED)
```

A nova combinação de traits deve preservar esses overrides.

Se o spec passar explicitamente:

- `calendars`;
- `calendar`;
- `academic`;
- `advisor`;
- `professor`;
- `institution`;
- `status`;

a factory/trait não deve sobrescrever esse valor sem necessidade.

Ao criar callbacks ou traits, respeite atributos já informados pelo teste.

# Mapeamento esperado inicial

Use este mapeamento como guia inicial, confirmando contra o código real antes de aplicar.

```ruby id="62v22u"
:orientation_tcc_one
# vira
:orientation, :tcc_one

:orientation_tcc_two
# vira
:orientation, :tcc_two

:current_orientation_tcc_one
# vira
:orientation, :current, :tcc_one

:current_orientation_tcc_two
# vira
:orientation, :current, :tcc_two

:previous_orientation_tcc_one
# vira
:orientation, :previous, :tcc_one

:previous_orientation_tcc_two
# vira
:orientation, :previous, :tcc_two

:orientation_tcc_one_approved
# vira
:orientation, :tcc_one, :approved_tcc_one, :with_final_project

:orientation_tcc_two_approved
# vira
:orientation, :tcc_two, :approved, :with_final_monograph

:orientation_tcc_one_approved_current_calendar
# vira
:orientation, :tcc_one, :current, :approved_tcc_one, :with_final_project

:orientation_tcc_one_approved_next_calendar
# vira
:orientation, :tcc_one, :next, :approved_tcc_one, :with_final_project

:orientation_tcc_two_approved_no_complementary_files
# vira
:orientation, :tcc_two, :approved, :with_final_monograph, :without_complementary_files

:orientation_approved
# vira
:orientation, :approved

:orientation_canceled
# vira
:orientation, :canceled

:orientation_reproved
# vira
:orientation, :reproved
```

Os nomes exatos dos traits podem mudar se o código real exigir.

O importante é preservar comportamento equivalente.

Não invente `:approved_tcc_two`.

Para TCC II aprovado, use `:approved`, preservando o status real `APPROVED`.

# Aliases temporários

Durante a Fase 1 e a Fase 3, mantenha aliases temporários para facilitar a transição.

Porém, ao final desta task, se todos os specs e factories dependentes tiverem sido atualizados para traits, remova os aliases antigos.

A task deve terminar preferencialmente sem factories antigas duplicando comportamento.

Se algum alias antigo precisar permanecer por compatibilidade, explique no relatório final:

- qual alias ficou;
- por que não foi removido;
- onde ainda é usado;
- qual task futura deve removê-lo.

# Atualização dos testes

Atualize todos os specs que usam nomes antigos de factories de orientations.

Faça substituições de forma segura e mecânica.

Preserve atributos sobrescritos.

Preserve cenários.

Preserve a intenção do teste.

Não altere expectativas para se adaptar à nova factory.

Se um spec quebrar após a migração, primeiro tente preservar o comportamento anterior ajustando a factory.

Alterar spec deve ser último recurso e precisa de justificativa forte no relatório final.

# Cuidados importantes

`Orientation` pode possuir regras sensíveis, como:

- status;
- TCC I;
- TCC II;
- calendário atual;
- calendário anterior;
- calendário seguinte;
- migração de TCC I para TCC II;
- acadêmico;
- professor orientador;
- coorientador, se existir;
- instituição;
- resumo por status;
- academic activity;
- documentos;
- bancas;
- orientação em calendários;
- supervisores;
- validações de unicidade;
- callbacks;
- escopos de semestre atual;
- dados históricos importados.

Ao refatorar a factory:

- preserve comportamento equivalente ao das factories antigas;
- preserve a criação de calendários quando era feita antes;
- preserve status e transições esperadas;
- preserve associações com acadêmico e orientador;
- preserve instituição quando existir;
- preserve supervisores criados por callback;
- preserve associações com academic activities quando existirem;
- preserve comportamento usado por specs de migração;
- evite gerar combinações inválidas;
- use sequences quando necessário;
- não deixe traits criando estados inconsistentes;
- não altere expectativas dos testes para se adaptar à factory;
- cuidado com callbacks que dependem de calendar, status ou academic activity;
- cuidado com specs que testam migração de orientação;
- cuidado com overrides explícitos vindos dos specs.

# Regra de comparação antes/depois

Antes da alteração, registre internamente:

- nomes das factories antigas em `orientations.rb`;
- quantidade aproximada de referências encontradas;
- arquivos principais impactados;
- comportamento de cada factory antiga;
- atributos e associações configurados por cada factory antiga;
- status configurado por cada factory antiga;
- calendários criados ou associados por cada factory;
- supervisores criados por cada factory;
- dependências com calendars, academic activities e examination boards.

Depois da alteração, confirme:

- cada factory antiga foi substituída por combinação equivalente de traits;
- os specs continuam representando os mesmos cenários;
- as factories dependentes usam a nova API das factories já refatoradas;
- callbacks herdados foram preservados;
- overrides continuam funcionando;
- não há referências antigas restantes, salvo justificativa;
- a suíte passa.

No relatório final, inclua um resumo da comparação antes/depois.

# Verificações obrigatórias

Após atualizar os specs e factories dependentes, procure referências antigas de factories de orientations.

Use buscas específicas pelos nomes antigos reais:

```bash id="3k9e6b"
grep -R "orientation_tcc_one" spec
grep -R "orientation_tcc_two" spec
grep -R "current_orientation_tcc_one" spec
grep -R "current_orientation_tcc_two" spec
grep -R "previous_orientation_tcc_one" spec
grep -R "previous_orientation_tcc_two" spec
grep -R "orientation_tcc_one_approved" spec
grep -R "orientation_tcc_two_approved" spec
grep -R "orientation_tcc_one_approved_current_calendar" spec
grep -R "orientation_tcc_one_approved_next_calendar" spec
grep -R "orientation_tcc_two_approved_no_complementary_files" spec
grep -R "orientation_approved" spec
grep -R "orientation_canceled" spec
grep -R "orientation_reproved" spec
```

Também verifique se ainda existem factories aninhadas antigas dentro de:

```bash id="9fr1rh"
spec/factories/orientations.rb
```

Verifique também se `orientations.rb` não voltou a usar aliases antigos já removidos nas tasks anteriores:

```bash id="n9y13m"
grep -R "academic_activity_no_complementary_files" spec/factories/orientations.rb
grep -R "proposal_academic_activity" spec/factories/orientations.rb
grep -R "project_academic_activity" spec/factories/orientations.rb
grep -R "monograph_academic_activity" spec/factories/orientations.rb
grep -R "current_examination_board" spec/factories/orientations.rb
```

Se alguma referência antiga permanecer, explique no relatório final.

# Testes esperados

Primeiro rode specs diretamente relacionados, usando caminhos existentes.

Possíveis caminhos relacionados:

```bash id="z38g54"
./run rspec \
  spec/models/orientations \
  spec/features/academics/orientations \
  spec/features/professors/orientations \
  spec/features/professors/supervisions \
  spec/features/responsible/orientations \
  spec/features/responsible/supervisions \
  spec/features/tcc_one_professors/orientations \
  spec/features/external_members/supervisions
```

Se algum desses caminhos não existir, adapte para os caminhos reais encontrados e informe no relatório final.

Depois rode specs que podem depender fortemente de orientations:

```bash id="9wppj7"
./run rspec \
  spec/models/calendars \
  spec/models/examination_boards \
  spec/models/documents \
  spec/features/responsible/documents \
  spec/features/academics/documents \
  spec/features/professors/documents \
  spec/features/external_members/documents
```

Depois rode a suíte completa:

```bash id="791mtd"
./run rspec spec
```

Também rode RuboCop nos arquivos afetados.

Comando mínimo esperado:

```bash id="cd4xly"
./run rubocop spec/factories/orientations.rb
```

Se specs forem alterados, rode RuboCop também nos arquivos alterados.

# Critérios de aceite

A task será considerada concluída se:

- `spec/factories/orientations.rb` usar uma estrutura baseada em traits reais;
- traits refletirem variações reais do domínio;
- não forem criados traits sem correspondência com atributos/associações/status reais;
- não for criado trait `:approved_tcc_two`;
- TCC II aprovado continuar usando status real `APPROVED`;
- as factories antigas de orientations forem inventariadas;
- o mapeamento real das factories antigas for documentado;
- os aliases temporários forem usados somente durante a migração;
- os nomes antigos de factories de orientations forem substituídos nos specs;
- aliases antigos forem removidos quando não forem mais necessários;
- a factory usar a nova API das factories refatoradas nas tasks anteriores;
- callbacks de supervisores forem preservados;
- overrides explícitos de specs continuarem vencendo;
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

Explique a refatoração feita em `orientations.rb`.

## Factories antigas identificadas

Liste os nomes antigos encontrados, incluindo:

- `:orientation_tcc_one`;
- `:orientation_tcc_two`;
- `:current_orientation_tcc_one`;
- `:current_orientation_tcc_two`;
- `:previous_orientation_tcc_one`;
- `:previous_orientation_tcc_two`;
- `:orientation_tcc_one_approved`;
- `:orientation_tcc_two_approved`;
- `:orientation_tcc_one_approved_current_calendar`;
- `:orientation_tcc_one_approved_next_calendar`;
- `:orientation_tcc_two_approved_no_complementary_files`;
- `:orientation_approved`;
- `:orientation_canceled`;
- `:orientation_reproved`.

## Nova estrutura

Liste os traits criados ou mantidos.

Separe, se possível:

- traits de estado/calendário;
- traits que criam dados relacionados.

Não liste traits especulativos que não foram criados.

## Mapeamento de migração

Informe o mapeamento usado.

Exemplo:

- `:orientation_tcc_one` → `:orientation, :tcc_one`;
- `:orientation_tcc_two` → `:orientation, :tcc_two`;
- `:current_orientation_tcc_one` → `:orientation, :current, :tcc_one`;
- `:current_orientation_tcc_two` → `:orientation, :current, :tcc_two`;
- `:previous_orientation_tcc_one` → `:orientation, :previous, :tcc_one`;
- `:previous_orientation_tcc_two` → `:orientation, :previous, :tcc_two`;
- `:orientation_tcc_one_approved` → `:orientation, :tcc_one, :approved_tcc_one, :with_final_project`;
- `:orientation_tcc_two_approved` → `:orientation, :tcc_two, :approved, :with_final_monograph`;
- `:orientation_tcc_two_approved_no_complementary_files` → `:orientation, :tcc_two, :approved, :with_final_monograph, :without_complementary_files`;
- `:orientation_approved` → `:orientation, :approved`;
- `:orientation_canceled` → `:orientation, :canceled`;
- `:orientation_reproved` → `:orientation, :reproved`.

Use os nomes reais encontrados no projeto.

## Dependências com factories anteriores

Explique como a factory passou a usar a nova API de:

- `calendars.rb`;
- `academic_activities.rb`;
- `examination_boards.rb`, se aplicável.

## Status e TCC

Explique como os traits de status/TCC foram preservados.

Deixe explícito que TCC II aprovado usa `APPROVED`, não `APPROVED_TCC_TWO`.

## Callbacks e supervisores

Explique:

- se o callback base de supervisores foi preservado;
- se professor supervisor e membro externo supervisor continuam sendo criados;
- se algum trait adiciona supervisores extras;
- como foi validado que o comportamento antigo foi preservado.

## Overrides preservados

Explique como foram preservados overrides explícitos de:

- `calendars`;
- `calendar`;
- `academic`;
- `advisor`;
- `professor`;
- `institution`;
- `status`.

## Fases executadas

Liste como a execução foi dividida:

- Fase 1: refatoração com aliases;
- Fase 2: validação direta;
- Fase 3: migração por grupos;
- Fase 4: remoção de aliases;
- Fase 5: suíte completa.

## Specs atualizados

Liste os principais arquivos ou grupos de specs alterados.

## Factories dependentes atualizadas

Informe se alguma outra factory precisou ser alterada por dependência direta.

Se foi alterada, explique exatamente qual referência foi migrada.

## Aliases removidos ou mantidos

Explique quais aliases foram removidos.

Se algum alias foi mantido, explique o motivo.

## Verificação de referências antigas

Informe se ainda existem referências antigas de factories de orientations.

## Alterações fora de escopo pré-existentes

Informe se algum arquivo proibido já estava alterado antes da task.

Não altere esses arquivos nesta task.

## Testes executados

Liste os comandos executados e o resultado.

Inclua obrigatoriamente o resultado de:

```bash id="vp5gra"
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

```bash id="f0wisq"
git status
git diff
```
