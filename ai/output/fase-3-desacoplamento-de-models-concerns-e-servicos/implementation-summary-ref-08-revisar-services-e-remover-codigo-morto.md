# REF-08 — Revisar services e remover código morto

## Resumo

Seis itens de código morto/comentado foram removidos. O placeholder de contagem zerada em `orientations_count_by_calendars_and_status` foi documentado com comentário explícito, sem correção funcional. A duplicação comprovada entre os relatórios de dashboard e `TccListQuery` foi caracterizada e deliberadamente não removida (ver Achados). A convenção de chamada de `EditabilityPolicy` e `StatusPresenter` foi avaliada e mantida como está, com justificativa registrada.

---

## Inventário antes da alteração

| # | Item | Localização | Consumidores confirmados |
|---|------|-------------|--------------------------|
| 1 | `DocumentByType` concern | `app/models/concerns/document_by_type.rb` | Nenhum (`grep -rln "DocumentByType" app/ spec/` retornou apenas o próprio arquivo) |
| 2 | Bloco comentado `orientations_by_tcc`/`current_tcc_orientations` | `app/services/dashboard/responsible_report.rb:103-130` | Nenhum — extração abandonada, jamais chamada |
| 3 | Bloco comentado `calculate_orientations`/`valid_method?`/`total_orientations`/`count_orientations` | `app/services/dashboard/professor_report.rb:52-83` | Nenhum — extração abandonada |
| 4 | Condições comentadas em `professors_orientations_active_link?` e `professors_orientations_history_active_link?` | `app/helpers/professors/active_link_helper.rb` | Views consumem os métodos; lógica comentada nunca executada |
| 5 | Condições comentadas em `external_members_activities_tcc_*` e corpo comentado de `external_members_supervisions_history_active_link?` | `app/helpers/external_members/active_link_helper.rb` | Views consumem os métodos; lógica comentada nunca executada |
| 6 | `# has_many :calendars, through: :orientations #TODO: test` | `app/models/academic.rb:15` | Nenhum — associação jamais implementada |

---

## Arquivos alterados

| Arquivo | Mudança |
|---------|---------|
| `app/models/concerns/document_by_type.rb` | **Excluído** — concern órfã sem consumidores |
| `app/services/dashboard/responsible_report.rb` | Removido bloco comentado (linhas 103-130); substituído `# orientations += 0 # TODO: Implement this` por comentário explicativo; simplificado `orientations_count_by_calendars_and_status` para retornar `0` diretamente (sem loop vazio) |
| `app/services/dashboard/professor_report.rb` | Removido bloco comentado (linhas 52-83) |
| `app/helpers/professors/active_link_helper.rb` | Removidos `# &&` trailing e linhas de condição comentadas em `professors_orientations_active_link?`; removido bloco comentado em `professors_orientations_history_active_link?` |
| `app/helpers/external_members/active_link_helper.rb` | Removidos `# &&` trailing e linhas comentadas em `external_members_activities_tcc_one_active_link?` e `_tcc_two_active_link?`; removidos TODO e chamada comentada de `external_members_supervisions_history_active_link?` (retorna `nil` implícito, preservado) |
| `app/models/academic.rb` | Removida linha de associação comentada com TODO |

---

## Comportamento preservado

### `Dashboard::ResponsibleReport#report` e `Dashboard::ProfessorReport#report`

- `orientations_by_tcc_one`/`orientations_by_tcc_two` em ambos os reports: nenhuma linha de código ativo foi alterada; apenas o bloco de código comentado adjacente foi removido.
- `orientations_count_by_calendars_and_status`: a simplificação de `orientations = 0; calendars.each {}; orientations` para `0` é semanticamente idêntica — o método sempre retornava `0` independentemente dos argumentos. Validado pelo RuboCop (`Lint/EmptyBlock` foi a evidência de que o loop nunca executava nada).

### Helpers de active link

Todos os quatro métodos mantêm exatamente o mesmo valor de retorno de antes:

- `professors_orientations_active_link?` → continua retornando `orientations_documents_link?('professors') || orientations_active_link?('professors')`.
- `professors_orientations_history_active_link?` → continua retornando `match_link?('/professors/orientations/history')`.
- `external_members_activities_tcc_one_active_link?` → continua retornando `activities_tcc_active_link?('one', 'external_members')`.
- `external_members_activities_tcc_two_active_link?` → continua retornando `activities_tcc_active_link?('two', 'external_members')`.
- `external_members_supervisions_history_active_link?` → continua retornando `nil` implícito (corpo vazio, sem o comentário morto).

---

## Achados sobre comportamento existente

### 1. Placeholder `orientations_count_by_calendars_and_status` sempre zerado

O método `Dashboard::ResponsibleReport#orientations_count_by_calendars_and_status` sempre retorna `0`, alimentando `calendar_orientations_by_status` → `calendar_orientations_report` → o campo `calendar_report` do hash `orientations_report`.

Este valor é consumido por `app/views/shared/dashboard/_orientations_report.html.erb:120-138`, que renderiza um gráfico de linhas (`Charts::LineComponent`) com todos os anos/semestres no eixo X e séries sempre zeradas. O gráfico é exibido silenciosamente no dashboard administrativo sem nenhum aviso de dado indisponível. Implementar a contagem real é mudança funcional fora do escopo desta task (REF-08).

Um comentário explícito foi adicionado ao método documentando este comportamento.

### 2. Comparação de `status` com literais traduzidos

`ResponsibleReport#orientations_by_tcc_one` e `ProfessorReport#orientations_by_tcc_one` usam:

```ruby
orientations.count { |o| o.status.eql?('em andamento') }
orientations.count { |o| o.status.eql?('Aprovada em TCC 1') }
orientations.count { |o| o.status.eql?('cancelada') }
orientations.count { |o| o.status.eql?('Reprovada em TCC 1') }
```

Esses literais são os valores traduzidos do enum `Orientation#status`, não os valores brutos (`IN_PROGRESS`, `APPROVED_TCC_ONE`, `CANCELED`, `REPROVED_TCC_ONE`). O método `status` do model retorna a string traduzida via I18n, portanto as comparações funcionam hoje — mas ficam frágeis se a tradução mudar.

**Por que a duplicação com `TccListQuery` não foi removida:** `TccListQuery` opera sobre valores brutos de enum e retorna relações paginadas para listagem. Os métodos de dashboard precisam de contagens sem paginação e com filtros diferentes (especialmente em `tcc_one`, que usa `select(&:tcc_one?)` em Ruby em vez de SQL). Substituir os métodos de dashboard por `TccListQuery` mudaria os valores retornados. A duplicação foi documentada como remanescente intencional e fica registrada para decisão futura (provavelmente REF-09/REF-10 ou uma task específica de melhoria dos relatórios de dashboard).

---

## Convenção de chamada — avaliação por objeto

| Objeto | Padrão atual | Avaliação | Decisão |
|--------|-------------|-----------|---------|
| `Orientations::EditabilityPolicy` | `.new(orientation).editable?` / `.destroyable?` | Usado exclusivamente como policy/predicado dentro de `Orientation#editable?` e `#destroyable?`. Adicionar `.call` seria semanticamente inadequado para um predicado; o padrão `.new(obj).predicate?` é idiomático para policy objects. | **Manter como está** |
| `ExaminationBoards::StatusPresenter` | `.new(examination_board).status` / `.distance_of_date` | Usado em `TableComponent` e na partial `_tbody.html.erb` para calcular múltiplos valores de apresentação de um mesmo objeto. Um `.call` retornaria um único valor; o presenter precisa expor dois métodos distintos. Converter para `.call` forçaria dois instanciamentos ou um objeto de resultado. | **Manter como está** |

---

## Nota de critério de escolha

### Quando cada camada é apropriada no SGTCC

**Model** — quando a lógica é invariante do domínio, validação, associação ou predicado que qualquer consumidor vai precisar sobre aquele objeto. Exemplo: `Orientation#editable?` (delegado a `EditabilityPolicy`, mas exposto como método de instância do model porque é o contrato esperado pelos controllers e views).

**Query object** (`*ListQuery`, `*Query`) — quando a consulta combina filtros, ordenação, paginação e/ou joins de forma que não pertence ao model (muito específica do contexto de uso) nem ao controller (muito longa e testável isoladamente). Exemplos reais: `Orientations::TccListQuery`, `Orientations::ResponsibleListQuery`, `ExaminationBoards::ListQuery`. Convenção: expostos via `.call(relation:, ...)`, sem instância visível ao consumidor.

**Service com efeito colateral** — quando a operação muda estado: cria registros, envia notificações, transita status. Exemplos reais: `Orientations::TcoTcaiService` (cria TCO a partir de TCAI), `Orientations::MigrationService` (migra orientação entre calendários), `ExaminationBoards::Destroy` (destrói banca com lógica de guarda). Convenção: `.call`, pode retornar objeto de resultado (`Data.define`) quando o chamador precisa diferenciar desfechos.

**Domain/presenter object** — quando a lógica é de apresentação ou cálculo derivado que não pertence ao model nem ao controller, mas precisa de contexto de objeto. Exemplos reais: `ExaminationBoards::StatusPresenter` (calcula `status` e `distance_of_date` a partir da data da banca), `ExaminationBoards::FormContext` (organiza dados para o formulário). Convenção: `.new(obj)` exposto ao consumidor, múltiplos métodos de acesso.

---

## Validação

### RuboCop

```
bundle exec rubocop --parallel
802 files inspected, no offenses detected
```

Executado via Docker (`docker compose run --rm --name tests tests`). Sem violações novas.

### RSpec

```
bundle exec rspec spec/services/dashboard/ spec/services/orientations/ \
  spec/services/examination_boards/ spec/services/documents/
61 examples, 0 failures
```

```
bundle exec rspec spec/models/academics/ spec/models/academic_activity_spec.rb
35 examples, 0 failures
```

```
bundle exec rspec spec/features/professors/professor_login_spec.rb \
  spec/features/external_members/external_members_login_spec.rb
7 examples, 0 failures
```

Todos executados via Docker com banco de dados real. Sem regressões.

---

## Riscos e próximos passos

- **`Calendar` e navegação entre períodos**: nenhuma alteração foi feita aqui. Pertence a REF-09/REF-10 conforme definido.
- **Comparações de status com literais traduzidos** em `ResponsibleReport` e `ProfessorReport`: remanescentes intencionais. Uma task futura pode uniformizar para comparações com valores brutos de enum e extrair uma abstração de consulta compartilhada para os relatórios de dashboard.
- **Gráfico `calendar_report` com dados zerados**: achado funcional documentado. Não corrigido. Requer uma task funcional dedicada para implementar a contagem real por calendário/status.
- **`Populate::*` e `Notifications::*`**: não foram tocados. Sem código morto comprovado identificado nessas áreas pelo inventário da REF-01.
