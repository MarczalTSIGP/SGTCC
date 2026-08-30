# Task

REF-08 — Revisar os services criados nas REF-04 a REF-07, uniformizar suas convenções, remover código morto e comentado confirmado, e documentar brevemente o critério de escolha entre model, query object, service e domain object, sem alterar comportamento funcional observável.

# Contexto

A REF-01 (`ai/output/fase-0-baseline/inventario-ref-01.md`) já listou extrações abandonadas e blocos comentados que ficaram marcados para esta task. As REF-04 a REF-07 já foram implementadas e criaram os objetos abaixo, hoje em `app/services/`:

```
app/services/orientations/responsible_list_query.rb
app/services/orientations/participant_list_query.rb
app/services/orientations/tcc_list_query.rb
app/services/orientations/editability_policy.rb
app/services/orientations/tco_tcai_service.rb
app/services/orientations/migration_service.rb
app/services/orientations/links/base_service.rb (+ 4 subclasses)
app/services/examination_boards/list_query.rb
app/services/examination_boards/form_context.rb
app/services/examination_boards/destroy.rb
app/services/examination_boards/site_query.rb
app/services/examination_boards/status_presenter.rb
app/services/documents/type_factory.rb
app/services/documents/save_signatures.rb
app/services/documents/defense_minutes.rb
app/services/dashboard/professors_ranking_report.rb
```

## Convenção de chamada — inconsistente entre os objetos já extraídos

| Objeto | Ponto de entrada | Padrão |
|---|---|---|
| `Orientations::TccListQuery`, `Orientations::MigrationService`, `Orientations::TcoTcaiService`, `ExaminationBoards::ListQuery`, `ExaminationBoards::SiteQuery`, `Documents::TypeFactory`, `Dashboard::ProfessorsRankingReport` | `.call`/método de classe | Sem instância exposta ao consumidor |
| `Orientations::EditabilityPolicy`, `ExaminationBoards::StatusPresenter` | `.new(objeto).método?` | Instanciado pelo consumidor, sem `.call` |
| `Orientations::Links::BaseService` (e as 4 subclasses em `orientations/links/`) | `.perform(orientation)`, com `private_class_method :new` | Nome de método de classe diferente de `.call` — **anterior à REF-04, não é alvo obrigatório desta task** |
| `ExaminationBoards::Destroy` | `.call`, retorna `Result = Data.define(:status)` | Único com objeto de resultado tipado |

Esta task não deve forçar um único padrão para todo `app/services/`. `Populate::*` e `Notifications::*` são anteriores ao roadmap de refatoração e não foram inventariados pela REF-01; não são alvo desta task. `Orientations::Links::*` já existia antes da REF-04 com o padrão `.perform`; avalie o custo de alinhá-lo, mas não é obrigatório se o risco de regressão for desproporcional ao ganho.

## Código morto e comentado confirmado

1. **`app/models/concerns/document_by_type.rb`** — concern órfã. A REF-07 removeu `include DocumentByType` de `Document` e migrou os três consumidores para `Documents::TypeFactory`. Confirmado sem nenhuma referência restante (`grep -rln "DocumentByType" app/ spec/` retorna apenas o próprio arquivo).
2. **`app/services/dashboard/responsible_report.rb`** — bloco comentado `orientations_by_tcc`/`current_tcc_orientations` (≈25 linhas), extração abandonada já confirmada não-equivalente ao comportamento ativo pela REF-01 (usa `Orientation.send("tcc_#{tcc_type}", ...)`, scopes diferentes dos métodos ativos `count_orientations`/`count_orientation_status`).
3. **`app/services/dashboard/professor_report.rb`** — bloco comentado `calculate_orientations`/`valid_method?`/`total_orientations`/`count_orientations` (≈30 linhas), mesmo padrão de extração abandonada.
4. **`app/helpers/professors/active_link_helper.rb`** — condições comentadas em `professors_orientations_active_link?` (`# &&` seguido de duas linhas de condição de calendário) e `professors_orientations_history_active_link?` (bloco inteiro de lógica alternativa comentada). O comportamento ativo (sem essas condições) já está em produção; remover apenas os comentários, sem reativar a lógica comentada.
5. **`app/helpers/external_members/active_link_helper.rb`** — `external_members_activities_tcc_one_active_link?`/`_tcc_two_active_link?` têm condições comentadas (mesmo padrão do item 4). `external_members_supervisions_history_active_link?` tem o corpo inteiro comentado (`# TODO: rubocop:disable Style/CommentAnnotation` + chamada comentada), retornando `nil` implicitamente. Os três métodos são consumidos por `app/views/layouts/external_members/_sidebar.html.erb`, `app/views/layouts/professors/_professor_menu.html.erb` e `app/views/layouts/external_members/_supervisor_menu.html.erb` — apenas remova os comentários mortos, sem alterar o retorno `nil` de `external_members_supervisions_history_active_link?`.
6. **`app/models/academic.rb:15`** — `# has_many :calendars, through: :orientations #TODO: test`, associação nunca implementada, sem consumidor. Remover o comentário.

## Placeholder que produz dado incorreto na UI — não é código morto, é achado funcional

`Dashboard::ResponsibleReport#orientations_count_by_calendars_and_status` (chamado por `calendar_orientations_by_status`/`calendar_orientations_report`) tem o corpo do loop inteiramente comentado (`# orientations += 0 # TODO: Implement this`) e **sempre retorna `0`**. Esse valor alimenta o gráfico `calendar_report` renderizado em `app/views/shared/dashboard/_orientations_report.html.erb:120` — ou seja, o dashboard administrativo exibe um gráfico com todos os valores zerados, silenciosamente, hoje em produção. Implementar a contagem real é uma mudança funcional (fora do escopo de uma refatoração estrutural); remover o gráfico também altera comportamento observável da UI. Trate como achado a documentar, não como TODO a resolver nesta task — ver seção de Escopo proibido.

# Dependências

- REF-06 — Reorganizar responsabilidades de `Orientation`.
- REF-07 — Reorganizar `ExaminationBoard`, `Document` e `Signature`.

# Objetivo

- Uniformizar, onde o custo for baixo e o risco de regressão for desprezível, a convenção de inicialização/chamada dos objetos criados pelas REF-04 a REF-07.
- Remover os seis itens de código morto/comentado confirmados na seção de contexto.
- Reduzir duplicação comprovada entre os relatórios de dashboard (`Dashboard::ResponsibleReport`, `Dashboard::ProfessorReport`) e os query objects já extraídos, sem alterar os valores retornados.
- Produzir uma nota curta (no relatório final, não precisa ser um arquivo README novo) documentando o critério usado neste projeto para escolher entre model, query object, service e domain object, com um exemplo real de cada categoria já extraído.

# Instruções críticas

Preserve integralmente:

- os valores retornados por `Dashboard::ResponsibleReport#report` e `Dashboard::ProfessorReport#report`, incluindo o `0` fixo de `orientations_count_by_calendars_and_status` — não implemente a contagem real nem remova o gráfico que a consome;
- o comportamento de todos os objetos listados na tabela de convenção de chamada; qualquer alinhamento de interface deve manter um caminho de compatibilidade (delegação) até confirmar que não há mais consumidores do nome antigo, ou deve migrar todos os consumidores na mesma task antes de remover a interface antiga;
- o retorno `nil` de `external_members_supervisions_history_active_link?` e o comportamento atual (sem as condições comentadas) dos outros três métodos de active link;
- as rotas, textos e HTML renderizado pelas views consumidoras dos helpers de active link e do relatório de dashboard.

Não expanda esta task para uma padronização geral de todos os services do projeto. `Populate::*`, `Notifications::*` e `Orientations::Links::*` não foram inventariados pela REF-01 como parte do problema do TCC; toque neles apenas se a remoção de código morto ou a redução de duplicação exigir, nunca por preferência estética isolada.

# Escopo obrigatório

## 1. Remover os seis itens de código morto confirmados

Excluir `app/models/concerns/document_by_type.rb`. Remover os blocos comentados de `responsible_report.rb` e `professor_report.rb`. Remover as condições e o bloco comentados dos dois `active_link_helper.rb`. Remover o comentário órfão em `academic.rb:15`.

## 2. Documentar (sem corrigir) o placeholder de contagem zerada

Adicionar um comentário curto no lugar do TODO removido em `orientations_count_by_calendars_and_status`, explicando que o método é um placeholder conhecido que sempre retorna `0` e que a implementação real é uma mudança funcional fora do escopo desta refatoração. Registrar o achado no relatório final com a evidência do consumidor na view.

## 3. Reduzir duplicação comprovada entre relatórios de dashboard e consultas existentes

Avaliar se `count_orientations`/`count_orientation_status` (`ResponsibleReport`) e o padrão equivalente em `ProfessorReport#orientations_by_tcc_one`/`#orientations_by_tcc_two` podem reutilizar `Orientations::TccListQuery` ou os scopes que ela já encapsula, **sem alterar os números retornados**. Se a caracterização mostrar que os métodos hoje comparam `status` com literais traduzidos (`'em andamento'`, `'Aprovada em TCC 1'`, `'cancelada'`, `'Reprovada em TCC 1'`, o mesmo padrão já registrado como achado na REF-06) e que substituir por `TccListQuery` mudaria esse comportamento, **não substitua** — documente a duplicação como remanescente e explique por que a unificação foi adiada.

## 4. Uniformizar convenção de chamada nos objetos de baixo risco

Para os objetos que ainda não expõem `.call`/método de classe (`Orientations::EditabilityPolicy`, `ExaminationBoards::StatusPresenter`), avalie adicionar um método de classe equivalente (`.new(...).editable?` → também disponível como método de instância já é aceitável; não é obrigatório adicionar `.call` se o objeto for majoritariamente usado como policy/presenter local). Documente a decisão tomada para cada objeto avaliado, mesmo quando a decisão for "manter como está".

## 5. Nota de critério de escolha entre model, query object, service e domain object

Escrever, no relatório final, uma nota curta (10-15 linhas) com o critério prático já emergente do trabalho das REF-06/REF-07: quando um método permanece no model (invariante/associação/validação), quando vira query object (`app/services/**/*_query.rb`, `*_query.rb`, `*ListQuery`), quando vira service com efeito colateral (`TcoTcaiService`, `MigrationService`), e quando vira objeto de apresentação (`StatusPresenter`). Use exemplos reais já existentes no código, sem inventar uma nova categoria.

# Escopo permitido

- os seis itens listados na seção de contexto (arquivo a excluir e trechos comentados a remover);
- `app/services/dashboard/responsible_report.rb` e `app/services/dashboard/professor_report.rb`, apenas para remoção de código morto e redução de duplicação sem mudança de valores retornados;
- `app/services/orientations/editability_policy.rb` e `app/services/examination_boards/status_presenter.rb`, apenas se a decisão do item 4 for adicionar um método de classe;
- specs dos arquivos alterados;
- relatório final em `ai/output/fase-3-desacoplamento-de-models-concerns-e-servicos/`.

# Escopo proibido

- Não implemente a contagem real em `orientations_count_by_calendars_and_status` nem remova o gráfico `calendar_report` da view — é mudança funcional, fora do escopo.
- Não corrija a comparação de `status` com literais traduzidos nos relatórios de dashboard; caracterize e documente, não corrija.
- Não altere `Orientation`, `ExaminationBoard`, `Document`, `Signature` ou seus concerns além do necessário para os objetos já extraídos continuarem funcionando.
- Não altere `Populate::*`, `Notifications::*` ou `Orientations::Links::*` além do estritamente necessário para remover código morto comprovado.
- Não altere `Calendar` ou a navegação entre períodos; isso pertence à REF-09/REF-10.
- Não altere rotas, textos, traduções ou HTML renderizado pelas views consumidoras.
- Não faça commit, push ou criação de branch.

# Roteiro de implementação

## 1. Confirmar ausência de consumidores antes de remover

- Reconfirmar com grep que `DocumentByType`, os blocos comentados e os comentários de `academic.rb` não têm nenhum consumidor ativo (apenas o próprio texto comentado).
- Confirmar os três consumidores de view dos helpers de active link antes de remover os comentários. Não há spec unitário dedicado a `Professors::ActiveLinkHelper`/`ExternalMembers::ActiveLinkHelper` hoje; a validação depende das specs de feature dos namespaces consumidores (`spec/features/professors/`, `spec/features/external_members/`) ou, se for mais rápido caracterizar diretamente, adicione specs de helper focados antes de remover os comentários.

## 2. Remover código morto

- Excluir a concern órfã e os blocos/condições comentados listados no escopo obrigatório item 1.
- Rodar a suíte relacionada a cada arquivo tocado após cada remoção incremental.

## 3. Documentar o placeholder de contagem zerada

- Substituir o TODO por um comentário curto e registrar o achado no relatório.

## 4. Avaliar duplicação de consulta nos relatórios de dashboard

- Caracterizar o valor atual de `count_orientations`/`count_orientation_status` e do bloco equivalente em `ProfessorReport` com teste, se ainda não houver cobertura.
- Comparar com o resultado de `Orientations::TccListQuery` para os mesmos parâmetros; só substituir se os resultados forem idênticos em todos os casos testados.

## 5. Avaliar convenção de chamada

- Decidir, objeto a objeto, entre manter e alinhar a `.call`; aplicar apenas onde o consumidor for trivial de migrar.

## 6. Verificação final

- Executar a suíte RSpec completa.
- Executar RuboCop no projeto completo.
- Escrever a nota de critério de escolha e o relatório final.

# Critérios de aceite

- `document_by_type.rb` não existe mais no repositório.
- Nenhum bloco de código comentado remanescente nos seis itens listados no contexto.
- `orientations_count_by_calendars_and_status` continua retornando `0` e o achado está documentado no relatório, não corrigido silenciosamente.
- Nenhum valor retornado por `Dashboard::ResponsibleReport#report`/`Dashboard::ProfessorReport#report` mudou.
- Toda decisão de uniformizar (ou não) a convenção de chamada de um objeto está registrada no relatório com a justificativa.
- A suíte completa passa; o RuboCop não registra novas violações no projeto.
- O relatório final contém a nota de critério de escolha entre model, query object, service e domain object.

# Validação sugerida

```bash
bundle exec rspec spec/services/dashboard/ \
  spec/services/orientations/ \
  spec/services/examination_boards/ \
  spec/services/documents/ \
  spec/models/academics/ \
  spec/features/professors/ \
  spec/features/external_members/

bundle exec rubocop app/models/concerns/document_by_type.rb \
  app/services/dashboard/ \
  app/helpers/professors/active_link_helper.rb \
  app/helpers/external_members/active_link_helper.rb \
  app/models/academic.rb \
  app/services/orientations/editability_policy.rb \
  app/services/examination_boards/status_presenter.rb

bundle exec rspec
bundle exec rubocop --parallel
```

Se o projeto exigir Docker, use `docker compose run --rm --name tests tests <comando>`, garantindo que o container se chame exatamente `tests` para que os specs de feature resolvam o host da aplicação (`TEST_APP_HOST=tests`), com `db`, `web` e `selenium` no ar (`docker compose up -d web`).

Falhas de ambiente não devem ser registradas como sucesso. Documente comando, mensagem e comportamentos não validados dinamicamente. **Execute a suíte de verdade antes de declarar a task concluída** — os relatórios das REF-06 e REF-07 marcaram "validação dinâmica não executada" e, quando a suíte foi de fato rodada, apareceram regressões reais (stub de teste quebrado na REF-06; TODOs removidos sem teste de caracterização e RuboCop com violações novas na REF-07) que não tinham sido detectadas antes.

# Relatório final esperado

Criar `ai/output/fase-3-desacoplamento-de-models-concerns-e-servicos/implementation-summary-ref-08-revisar-services-e-remover-codigo-morto.md` com:

## Resumo

Itens de código morto removidos, duplicações reduzidas (ou mantidas com justificativa) e decisões de convenção de chamada.

## Inventário antes da alteração

Tabela com cada um dos seis itens de código morto, sua localização e a confirmação de ausência de consumidores.

## Arquivos alterados

Lista dos arquivos e responsabilidade de cada mudança.

## Comportamento preservado

Evidência de que `Dashboard::ResponsibleReport#report` e `Dashboard::ProfessorReport#report` retornam os mesmos valores de antes, e de que os três helpers de active link mantêm o mesmo resultado observável.

## Achados sobre comportamento existente

O placeholder `orientations_count_by_calendars_and_status` sempre zerado e seu efeito no gráfico `calendar_report`; a comparação de `status` com literais traduzidos nos relatórios de dashboard, se ainda não corrigida; qualquer duplicação identificada e deliberadamente não removida.

## Nota de critério de escolha

O texto curto pedido no objetivo, com exemplos reais.

## Validação

Comandos e resultados de RSpec e RuboCop, execução real (não apenas comandos sugeridos), separando regressões, falhas preexistentes e limitações ambientais.

## Riscos e próximos passos

Confirmar que `Calendar` pertence à REF-09/REF-10 e que qualquer duplicação ou inconsistência deliberadamente mantida está registrada para decisão futura.
