# Task

Revisar e corrigir problemas pontuais de estabilidade, duplicação e legibilidade nos specs, priorizando setup duplicado em `examination_boards`, teste com `if/else` morto em calendário, índice hardcoded em spec de controller e pequenas limpezas seguras.

# Contexto

A etapa pesada de divisão e deduplicação dos specs já foi concluída.

Agora restam melhorias pontuais de estabilidade, clareza e manutenção.

Foram identificados os seguintes problemas:

## Prioridade Alta

1. Setup duplicado em massa em specs de `examination_boards`

Há vários arquivos de `examination_boards` repetindo setup parecido com:

- `create(:document_type_admg)`;
- adição de professor à banca;
- adição de membro externo à banca;
- `login_as(...)`;
- `visit ...examination_board_path(examination_board)`.

Esse setup aparece em múltiplos arquivos e deve ser extraído para `shared_context` quando for seguro.

2. `if/else` dentro de `it` em `spec/features/responsible/calendars/calendars_show_spec.rb`

Existe um teste com `if/else` dentro do exemplo. O `else` aparentemente nunca é executado porque o factory não cria atividades.

O teste deve ser separado em contextos explícitos, com setup claro para:

- calendário com atividades;
- calendário sem atividades.

3. Índice hardcoded `resp[1]` em controller spec

Em `spec/controllers/api/v1/orientations/orientations_controller_tcc_one_spec.rb`, o teste acessa uma posição fixa da resposta JSON com `resp[1]`.

Isso é frágil porque a ordem pode depender de datas geradas pelo Faker.

Trocar por busca explícita pelo registro esperado, por exemplo:

```ruby
response_orientation = resp.detect { |orientation_response| orientation_response['id'] == orientation.id.to_s }
```

## Prioridade Média

4. Shared example definido mas não usado

Existe um shared example chamado algo como `"orientation activity show page"` em `spec/support/`, mas alguns specs `orientations_activities_show_spec.rb` ainda parecem repetir o código manualmente.

Verificar se esse shared example está carregado, faz sentido e pode ser aplicado com segurança.

5. `let(:document_type)` declarado e não usado

Em specs de `documents_show_spec.rb`, incluindo o irmão de `term_of_accept_institution`, existe `let(:document_type)` não utilizado.

Remover apenas se for comprovadamente código morto e não alterar comportamento.

## Prioridade Baixa

6. Typo `activites` → `activities`

Corrigir typo em `orientations_activities_index_spec.rb`, se existir.

7. Strings hardcoded em vez de i18n em `calendars_show_spec.rb`

Apenas revisar e corrigir se for simples, seguro e já houver padrão claro no arquivo.

8. Inconsistência entre `let` e `let!` nos specs de documents

Padronizar somente se for seguro e não alterar ordem de criação nem comportamento.

9. `visit` dentro do `it` em `calendars_index_spec.rb`

Mover para `before` apenas se isso não prejudicar clareza nem alterar comportamento.

# Objetivo

Resolver os problemas pontuais listados acima, melhorando:

- estabilidade dos specs;
- legibilidade;
- redução de duplicação;
- robustez contra ordem variável;
- remoção de código morto;
- reaproveitamento de shared examples já existentes;
- clareza dos contextos de teste.

Esta task deve ser conservadora.

Não faça refatorações amplas fora dos pontos listados.

# Instrução crítica

Esta task deve alterar apenas arquivos de teste.

Não altere código de produção.

Não altere:

- `app/`;
- `config/`;
- `db/`;
- `lib/`;
- `spec/factories/`;
- specs fora do escopo permitido, exceto se forem arquivos de suporte diretamente relacionados;
- configurações globais de RSpec ou Capybara.

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

Você pode alterar arquivos dentro dos seguintes caminhos:

- `spec/features/**/examination_boards/**/*_spec.rb`
- `spec/features/responsible/calendars/calendars_show_spec.rb`
- `spec/features/responsible/calendars/calendars_index_spec.rb`
- `spec/controllers/api/v1/orientations/orientations_controller_tcc_one_spec.rb`
- `spec/features/**/orientations_activities_show_spec.rb`
- `spec/features/**/orientations_activities_index_spec.rb`
- `spec/features/**/documents_show_spec.rb`
- arquivos de suporte em `spec/support/`, somente quando forem diretamente relacionados aos shared contexts/shared examples usados nesta task.

# Escopo proibido

Não altere:

- código de produção;
- factories;
- `rails_helper.rb`;
- `spec_helper.rb`;
- specs que não tenham relação com os problemas listados;
- configurações globais;
- arquivos de suporte genéricos demais.

Se algum ajuste exigir alteração em factory, código de produção, helper global amplo ou configuração de RSpec, não faça nesta task. Registre como pendência.

# Ordem de prioridade

Siga esta ordem:

1. Resolver setup duplicado em specs de `examination_boards`.
2. Corrigir o `if/else` morto em `responsible/calendars/calendars_show_spec.rb`.
3. Corrigir `resp[1]` em `orientations_controller_tcc_one_spec.rb`.
4. Verificar e aplicar shared example `"orientation activity show page"`, se for seguro.
5. Remover `let(:document_type)` não usado, se comprovado.
6. Corrigir typo `activites`.
7. Avaliar strings hardcoded de i18n em `calendars_show_spec.rb`.
8. Avaliar padronização `let` vs `let!` em documents.
9. Avaliar `visit` dentro do `it` em `calendars_index_spec.rb`.

Se a task ficar grande demais, faça apenas os itens 1, 2 e 3, e registre os demais como pendência.

# Parte 1 — Setup duplicado em examination_boards

Inspecione os specs de `examination_boards` e localize blocos repetidos de setup.

O padrão apontado é semelhante a:

```ruby
before do
  create(:document_type_admg)
  examination_board.professors << create(:professor)
  examination_board.external_members << create(:external_member)
  login_as(academic, scope: :academic)
  visit academics_examination_board_path(examination_board)
end
```

Extraia esse setup para um `shared_context` somente quando:

- o bloco for realmente repetido;
- as variáveis usadas forem compatíveis entre os arquivos;
- o contexto continuar legível;
- as diferenças de perfil/rota continuarem explícitas;
- cada spec continuar rodando isoladamente.

Sugestão, se fizer sentido:

```ruby
RSpec.shared_context 'monograph examination board setup' do
  before do
    create(:document_type_admg)
    examination_board.professors << create(:professor)
    examination_board.external_members << create(:external_member)
    login_as(academic, scope: :academic)
    visit academics_examination_board_path(examination_board)
  end
end
```

Atenção: não aplique esse contexto cegamente para perfis diferentes.

Se houver setups parecidos para `professors`, `responsible`, `tcc_one_professors` ou `external_members`, crie nomes específicos e claros, ou mantenha duplicado se a abstração prejudicar legibilidade.

Exemplos aceitáveis de nomes:

- `academic monograph examination board setup`;
- `professor monograph examination board setup`;
- `responsible examination board setup`;
- `external member examination board setup`.

Evite shared contexts genéricos demais.

# Parte 2 — Corrigir if/else morto em calendars_show_spec

No arquivo:

- `spec/features/responsible/calendars/calendars_show_spec.rb`

Localize o teste com `if/else` dentro do `it`.

Não mantenha lógica condicional dentro do exemplo.

Separe em contextos explícitos, por exemplo:

```ruby
context 'when the calendar has activities' do
  before do
    # setup explícito criando atividade
  end

  it 'shows the activities' do
    # expectativa para calendário com atividades
  end
end

context 'when the calendar has no activities' do
  it 'shows empty state' do
    # expectativa para calendário sem atividades
  end
end
```

Ajuste os nomes conforme o padrão do projeto.

Não invente comportamento novo.

Use apenas expectativas que já existiam no teste original, reorganizadas de forma clara.

Se o teste original tiver uma branch que nunca foi coberta de verdade, registre no relatório final.

# Parte 3 — Corrigir índice hardcoded resp[1]

No arquivo:

- `spec/controllers/api/v1/orientations/orientations_controller_tcc_one_spec.rb`

Substitua acesso frágil por índice fixo, como:

```ruby
resp[1]
```

por busca explícita pelo registro esperado, como:

```ruby
response_orientation = resp.detect { |orientation_response| orientation_response['id'] == orientation.id.to_s }
```

ou equivalente compatível com o padrão do arquivo.

Depois valide as expectativas usando o objeto encontrado.

Adicione uma expectativa clara para garantir que o item foi encontrado, por exemplo:

```ruby
expect(response_orientation).to be_present
```

Não altere o contrato da API.

Não altere controller.

Não altere factory.

# Parte 4 — Shared example definido mas não usado

Verifique se existe shared example chamado algo como:

- `"orientation activity show page"`

em `spec/support/`.

Verifique os specs:

- `spec/features/**/orientations_activities_show_spec.rb`

Se os specs repetirem o mesmo fluxo manualmente e o shared example já cobrir exatamente esse comportamento, use o shared example.

Só aplique se:

- o shared example já estiver carregado;
- a substituição preservar os mesmos cenários;
- as diferenças de perfil continuarem explícitas;
- não for necessário alterar `rails_helper.rb` ou `spec_helper.rb`.

Se o shared example existir, mas não for seguro aplicar, registre no relatório final.

# Parte 5 — Remover let(:document_type) não usado

Verifique os specs `documents_show_spec.rb`, principalmente:

- specs de `term_of_commitment`;
- specs de `term_of_accept_institution`.

Se houver `let(:document_type)` declarado e realmente não usado, remova.

Não remova se:

- o `let` tiver efeito colateral necessário;
- ele for usado indiretamente de forma não óbvia;
- a remoção alterar criação de dados necessária para o teste.

Se houver dúvida, mantenha e registre no relatório final.

# Parte 6 — Correções pequenas de baixa prioridade

Corrija apenas se for seguro e local:

- typo `activites` para `activities` em `orientations_activities_index_spec.rb`;
- strings hardcoded em `calendars_show_spec.rb`, somente se existir chave i18n clara e já usada no mesmo arquivo;
- inconsistência entre `let` e `let!` nos specs de documents, somente se não alterar ordem de criação;
- `visit` dentro do `it` em `calendars_index_spec.rb`, somente se mover para `before` não alterar comportamento.

Não force essas mudanças.

Se houver risco de alteração de comportamento, registre como pendência.

# Regra de comparação antes/depois

Antes de alterar cada arquivo, registre internamente:

- quantidade de exemplos;
- nomes dos principais `describe`, `context`, `it` ou `scenario`;
- setup relevante;
- expectativas principais.

Depois da alteração, confirme que:

- a quantidade de exemplos foi preservada, exceto quando um `if/else` for separado corretamente em dois contextos explícitos;
- nenhum cenário foi removido sem justificativa;
- nenhuma expectativa relevante foi removida;
- cada arquivo alterado continua rodando isoladamente.

No relatório final, inclua comparação resumida antes/depois para cada grupo alterado.

# Estratégia de implementação

A implementação deve ser conservadora.

Prefira:

- shared contexts pequenos;
- nomes claros;
- escopo restrito;
- mudanças locais;
- preservação de expectativas;
- uso de padrões já existentes no projeto.

Evite:

- metaprogramação;
- loops grandes;
- shared examples genéricos demais;
- helpers globais amplos;
- alteração de factories;
- alteração de setup que mude comportamento;
- correções oportunistas fora dos problemas listados.

# Testes esperados

Rode os testes diretamente afetados usando o padrão do projeto.

Comando principal esperado:

```bash
./run rspec \
  spec/features/academics/examination_boards \
  spec/features/professors/examination_boards \
  spec/features/responsible/examination_boards \
  spec/features/tcc_one_professors/examination_boards \
  spec/features/external_members/examination_boards \
  spec/features/responsible/calendars/calendars_show_spec.rb \
  spec/features/responsible/calendars/calendars_index_spec.rb \
  spec/controllers/api/v1/orientations/orientations_controller_tcc_one_spec.rb \
  spec/features/academics/orientations/orientations_activities_show_spec.rb \
  spec/features/professors/orientations/orientations_activities_show_spec.rb \
  spec/features/responsible/orientations/orientations_activities_show_spec.rb \
  spec/features/professors/supervisions/supervisions_activities_show_spec.rb
```

Também rode RuboCop nos arquivos afetados:

```bash
./run rubocop \
  spec/features/academics/examination_boards \
  spec/features/professors/examination_boards \
  spec/features/responsible/examination_boards \
  spec/features/tcc_one_professors/examination_boards \
  spec/features/external_members/examination_boards \
  spec/features/responsible/calendars/calendars_show_spec.rb \
  spec/features/responsible/calendars/calendars_index_spec.rb \
  spec/controllers/api/v1/orientations/orientations_controller_tcc_one_spec.rb \
  spec/features/academics/orientations/orientations_activities_show_spec.rb \
  spec/features/professors/orientations/orientations_activities_show_spec.rb \
  spec/features/responsible/orientations/orientations_activities_show_spec.rb \
  spec/features/professors/supervisions/supervisions_activities_show_spec.rb
```

Se arquivos em `spec/support/` forem criados ou alterados, inclua também esses arquivos no RuboCop:

```bash
./run rubocop spec/support
```

Se o comando completo for muito demorado ou falhar por problema de ambiente, rode os arquivos menores afetados e explique no relatório final.

# Critérios de aceite

A task será considerada concluída se:

- setup duplicado de `examination_boards` for extraído quando seguro;
- diferenças entre perfis de banca continuarem explícitas;
- o `if/else` dentro de `calendars_show_spec.rb` for separado em contextos explícitos, se confirmado;
- o acesso `resp[1]` for substituído por busca explícita pelo registro esperado;
- shared example de `"orientation activity show page"` for usado se já existir e for seguro;
- `let(:document_type)` não usado for removido quando comprovadamente morto;
- correções pequenas forem aplicadas apenas quando seguras;
- nenhum código de produção for alterado;
- nenhuma factory for alterada;
- `rails_helper.rb` e `spec_helper.rb` não forem alterados;
- nenhum spec fora do escopo for alterado;
- os testes afetados forem executados ou a impossibilidade for explicada;
- RuboCop for executado ou a impossibilidade for explicada;
- pendências fora do escopo forem registradas, não corrigidas oportunisticamente.

# Relatório final esperado

No relatório final, inclua:

## Resumo

Explique quais problemas foram resolvidos.

## Arquivos alterados

Liste todos os arquivos alterados.

## Setup de examination_boards

Explique:

- qual duplicação foi extraída;
- qual shared context foi criado/usado;
- quais arquivos passaram a usar o shared context;
- quais duplicações foram mantidas por segurança.

## Calendars show

Explique como o `if/else` foi separado.

## Controller orientations tcc one

Explique como o `resp[1]` foi substituído.

## Shared examples

Explique se o shared example `"orientation activity show page"` foi usado ou por que foi mantido como pendência.

## Código morto removido

Liste `let`, typos ou pequenas limpezas removidas/corrigidas.

## Pendências encontradas

Liste problemas que ficaram para depois, incluindo:

- shared examples não usados;
- código morto duvidoso;
- strings hardcoded;
- inconsistência entre `let` e `let!`;
- qualquer correção que exigiria mudança fora do escopo.

## Testes executados

Liste os comandos executados e o resultado.

## RuboCop executado

Liste os comandos executados e o resultado.

# Observação final

Esta task não deve criar commit automaticamente.

As alterações devem ficar apenas no working tree para revisão manual com:

```bash
git status
git diff
```
