# Task

REF-03 — Padronizar o uso do enum `semester` na camada de aplicação, preservando a navegação acadêmica, os limites de ano e os valores persistidos.

# Contexto

A REF-01 (`ai/output/fase-0-baseline/inventario-ref-01.md`) confirmou que o semestre acadêmico é representado como inteiro (`1`/`2`), string (`'one'`/`'two'`), símbolo (`:one`/`:two`) e chamada à API do enum em diferentes pontos da aplicação.

O enum é definido em `app/models/concerns/semester.rb` como:

```ruby
enum :semester, { one: 1, two: 2 }, prefix: :semester
```

Os valores inteiros `1` e `2` já estão persistidos e não podem ser alterados. A task deve padronizar consultas, atribuições e comparações sem criar migration ou converter dados históricos.

Os principais pontos identificados no inventário são:

- `Calendar#set_dates`, que converte o valor do enum com `semester.to_i`;
- métodos de navegação em `Calendar`, que alternam entre inteiros e strings;
- `Calendars::CloneBaseActivities`, que compara `semester == 'one'`;
- `Populate::Calendars`, que alterna os períodos com inteiros;
- `Dashboard::ResponsibleReport`, que recalcula o semestre a partir do mês;
- `CurrentCalendar`, que expõe `current_semester` como inteiro e aceita representações diferentes ao normalizar o calendário atual.

A extração das regras de navegação para um objeto próprio pertence à REF-09, e a separação de consultas e relatórios de `Calendar` pertence à REF-10. Nesta task, preserve as interfaces existentes e limite-se a uniformizar a representação do enum.

# Dependências

- REF-01 — Inventariar inconsistências e responsabilidades.

# Objetivo

Adotar uma convenção consistente para `semester`:

- usar `semester_one?` e `semester_two?` nas comparações de instâncias que incluem o concern `Semester`;
- usar `:one` e `:two` em atribuições e consultas Active Record nas quais o atributo enum é conhecido;
- usar `Calendar.semesters.fetch(:one)` e `Calendar.semesters.fetch(:two)` quando uma interface existente exigir o valor inteiro persistido;
- preservar `Calendar.current_semester` como inteiro `1`/`2`, pois esse é um contrato público consumido em consultas, factories, services e specs;
- manter a chave textual retornada pelo enum apenas em tradução e apresentação.

# Instrução crítica

Não altere o mapeamento `{ one: 1, two: 2 }`, o tipo da coluna, migrations ou dados existentes.

Não mude as regras acadêmicas de navegação:

- depois do primeiro semestre vem o segundo semestre do mesmo ano;
- depois do segundo semestre vem o primeiro semestre do ano seguinte;
- antes do segundo semestre vem o primeiro semestre do mesmo ano;
- antes do primeiro semestre vem o segundo semestre do ano anterior;
- a transição para TCC II mantém a regra atual de semestre e ano.

Não transforme esta task na REF-09 ou REF-10: não extraia objetos, não mova os métodos de `Calendar` e não redesenhe relatórios ou consultas.

# Escopo permitido

- `app/models/concerns/semester.rb` e `app/models/concerns/current_calendar.rb`;
- `app/models/calendar.rb` e consumidores diretos do enum `semester`;
- services que consultam, calculam ou atribuem semestre, incluindo `Calendars::CloneBaseActivities`, `Populate::Calendars` e `Dashboard::ResponsibleReport`;
- helpers e components com comparações de semestre;
- factories, support helpers e specs diretamente necessários para caracterizar o comportamento;
- relatório final em `ai/output/fase-1-dados-de-dominio/`.

# Escopo proibido

- Não altere o enum `tcc`; ele pertence à REF-02.
- Não crie ou altere migrations e não execute atualizações em massa.
- Não extraia navegação, consultas ou relatórios para novos objetos.
- Não altere rotas, textos, traduções, ordenação, paginação ou respostas HTTP.
- Não modifique datas acadêmicas ou introduza uma nova definição de início/fim de semestre.
- Não altere o contrato de `Calendar.current_semester` sem atualizar todos os consumidores e demonstrar necessidade; o resultado esperado permanece inteiro `1`/`2`.
- Não faça commit, push ou criação de branch.

# Roteiro de implementação

## 1. Caracterizar o contrato persistido

- Adicionar ou ajustar um spec que confirme `Calendar.semesters` igual a `{ 'one' => 1, 'two' => 2 }`.
- Confirmar que calendários atribuídos com `semester: :one` e `semester: :two` gravam respectivamente `1` e `2`, usando leitura sem conversão de tipo.
- Confirmar que registros existentes com `1`/`2` são lidos como `'one'`/`'two'` pela API do enum.
- Preservar os valores retornados por `Calendar.current_semester`: `1` para o primeiro período e `2` para o segundo.

## 2. Uniformizar comparações e consultas

- Em `Calendar`, substituir comparações diretas com `'one'`/`'two'` pelos predicados `semester_one?`/`semester_two?`.
- Substituir `find_by`/`where` com `semester: 1`, `2`, `'one'` ou `'two'` por `:one`/`:two` quando a consulta conhece o enum.
- Em `Calendars::CloneBaseActivities`, usar o predicado do enum para escolher o mês inicial, preservando março para o primeiro semestre e agosto para o segundo.
- Revisar os demais consumidores ativos em `app/` e `lib/tasks/`, distinguindo comparações de enum de usos legítimos do número do semestre em apresentação ou interfaces públicas.

## 3. Corrigir a derivação de datas sem mudar a regra

- Remover de `Calendar#set_dates` a dependência de `semester.to_i` para identificar o primeiro semestre.
- Usar o predicado do enum ou a API explícita para manter os intervalos atuais:
  - primeiro semestre: 1º de janeiro a 30 de junho;
  - segundo semestre: 1º de julho a 31 de dezembro.
- Cobrir calendários criados com símbolos e registros recarregados do banco.
- Não alterar datas fornecidas explicitamente pelo usuário.

## 4. Padronizar transições de período

- Manter os métodos `previous_semester`, `next_semester`, `next_semester_tcc_two`, `search_by_first_semester_next_year` e `search_by_second_semester_previous_year` em `Calendar` nesta task.
- Internamente, usar símbolos/predicados do enum em vez de misturar strings e inteiros.
- Adicionar exemplos para os quatro limites essenciais: primeiro → segundo no mesmo ano, segundo → primeiro no ano seguinte, segundo → primeiro no mesmo ano ao retroceder e primeiro → segundo no ano anterior ao retroceder.
- Cobrir a transição para TCC II nos dois semestres, preservando o ano calculado atualmente.
- Preservar `nil` quando não existir calendário correspondente.

## 5. Preservar e centralizar o cálculo do semestre atual

- Manter `Calendar.current_semester` como fonte do semestre acadêmico atual e como retorno inteiro compatível com os consumidores existentes.
- Em `Dashboard::ResponsibleReport`, substituir o cálculo duplicado baseado em `Date.current.month` pela chamada a `Calendar.current_year` e `Calendar.current_semester`, sem alterar a consulta ou os totais retornados.
- Em `Populate::Calendars`, usar constantes derivadas de `Calendar.semesters.fetch(...)` ou uma transição explícita entre chaves válidas, mantendo a mesma sequência de anos e semestres.
- Revisar `CurrentCalendar#semester_from` para remover tolerância desnecessária a representações inválidas, somente se os testes demonstrarem que nenhum contrato ativo depende dela. Na dúvida, preserve a compatibilidade e registre a ocorrência no relatório.

## 6. Verificação final

- Buscar em `app/` e `lib/tasks/` comparações e consultas de `semester` com `1`, `2`, `'one'` e `'two'`.
- Classificar ocorrências mantidas como legítimas, por exemplo: retorno público de `current_semester`, meses de início/fim, ordenação SQL, tradução e valores dos testes do contrato persistido.
- Registrar cada exceção no relatório final.

# Critérios de aceite

- `Calendar.semesters` continua mapeando `one` para `1` e `two` para `2`.
- Nenhuma migration ou transformação de dados foi criada.
- A camada de aplicação usa predicados do enum para comparações de instância e símbolos para consultas/atribuições Active Record.
- Valores inteiros permanecem apenas onde fazem parte de um contrato explícito, como `Calendar.current_semester`, ou onde validam o formato persistido.
- `Calendar#set_dates` produz exatamente os mesmos intervalos para os dois semestres e respeita datas informadas previamente.
- Navegação anterior e seguinte preserva resultados dentro do ano e nas duas viradas de ano.
- `next_semester_tcc_two` mantém o comportamento para calendários originados em ambos os semestres.
- `Dashboard::ResponsibleReport` usa a fonte central de ano/semestre sem alterar os totais.
- `Populate::Calendars` mantém a quantidade, a ordem cronológica reversa e os valores persistidos dos calendários criados.
- Calendários antigos continuam legíveis sem conversão implícita ou migração destrutiva.
- Ordenações por `year` e `semester`, traduções e interfaces de formulário permanecem inalteradas.
- A suíte RSpec relacionada passa e o RuboCop não registra novas violações no escopo alterado.
- Nenhum objeto de navegação, query object ou relatório novo foi criado nesta task.

# Validação sugerida

Execute os specs focados e depois a suíte completa:

```bash
bundle exec rspec spec/models/calendar/ \
  spec/features/responsible/calendars/ \
  spec/models/examination_boards/ \
  spec/services/

bundle exec rspec
bundle exec rubocop app/ spec/
```

Adapte a seleção de `spec/services/` aos arquivos existentes. Se o projeto exigir Docker, use os comandos equivalentes fornecidos por `./run`.

Se RSpec ou SimpleCov não puderem ser executados por indisponibilidade do banco ou do ambiente, registre o comando, o erro e os comportamentos que ficaram validados apenas por inspeção. Ausência de execução não equivale a sucesso.

# Métricas antes/depois

Registrar no escopo alterado:

- quantidade de comparações diretas de `semester` com `1`/`2` ou `'one'`/`'two'`;
- quantidade de consultas/atribuições Active Record que não usam a convenção definida;
- quantidade de cálculos duplicados do semestre atual;
- exemplos e falhas dos specs focados;
- offenses do RuboCop nos arquivos alterados.

O esperado é zerar as comparações e consultas inconsistentes, eliminar o cálculo duplicado no dashboard e preservar apenas os inteiros que constituem contratos explícitos.

# Relatório final esperado

Criar `ai/output/fase-1-dados-de-dominio/implementation-summary-ref-03-padronizar-enum-semester.md` com:

## Resumo

Descrição da convenção adotada e confirmação de que o mapeamento persistido foi mantido.

## Arquivos alterados

Lista dos arquivos e da inconsistência removida em cada um.

## Comportamento preservado

Evidências sobre leitura/escrita de `1`/`2`, datas padrão, semestre atual, navegação anterior/seguinte, viradas de ano, transição para TCC II, população e ordenação.

## Métricas antes/depois

Tabela das representações inconsistentes e dos cálculos duplicados antes e depois.

## Validação

Comandos e resultados de RSpec e RuboCop, separando limitações do ambiente de regressões.

## Riscos e próximos passos

Listar exceções mantidas e confirmar que a extração da navegação pertence à REF-09 e a separação de consultas/relatórios à REF-10.
