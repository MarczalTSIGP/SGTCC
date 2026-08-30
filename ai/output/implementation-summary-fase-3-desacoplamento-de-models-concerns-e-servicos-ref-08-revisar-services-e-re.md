Agora tenho todos os dados necessários. Vou escrever o relatório final.

---

# Implementation Summary

## General Summary

A REF-08 removeu seis itens de código morto confirmados, documentou um placeholder funcional conhecido, avaliou duplicações nos relatórios de dashboard e analisou a convenção de chamada dos objetos extraídos nas REF-04 a REF-07. Nenhum comportamento funcional observável foi alterado.

## Changed Files

### app/models/concerns/document_by_type.rb (deletado)

- O arquivo inteiro foi removido do repositório.
- A concern `DocumentByType` havia sido esvaziada pela REF-07, que migrou os três consumidores (`new_tdo`, `new_tep`, `new_tso`) para `Documents::TypeFactory`. O `include DocumentByType` já havia sido removido de `Document`. Grep confirmou ausência de qualquer referência restante fora do próprio arquivo.

---

### app/models/academic.rb

- Removida a linha `# has_many :calendars, through: :orientations #TODO: test` (linha 15 original).
- A associação nunca foi implementada, não tem consumidor em `app/` nem em `spec/`, e o comentário não correspondia a nenhuma intenção ativa no código.

---

### app/helpers/professors/active_link_helper.rb

- **`professors_orientations_active_link?`**: removidas duas linhas comentadas com condições de calendário (`# &&`, `# (calendar_equal_current_calendar_tcc_one? || ...`). O comportamento ativo — retornar `orientations_documents_link?('professors') || orientations_active_link?('professors')` — permanece idêntico.
- **`professors_orientations_history_active_link?`**: removido bloco inteiro de lógica alternativa comentada (`current_calendar`, `show_orientation`, `match_calendar_from_history`). O método ativo já retornava apenas `match_link?('/professors/orientations/history')`.

Nenhum retorno de nenhum dos dois métodos foi alterado.

---

### app/helpers/external_members/active_link_helper.rb

- **`external_members_activities_tcc_one_active_link?`** e **`external_members_activities_tcc_two_active_link?`**: removidas as condições comentadas `# &&` e as linhas de `calendar_equal_current_calendar_*` correspondentes. O retorno ativo (`activities_tcc_active_link?('one'/'two', 'external_members')`) permanece intacto.
- **`external_members_supervisions_history_active_link?`**: removidos o comentário `# TODO: rubocop:disable Style/CommentAnnotation` e a chamada comentada `# supervisions_history_active_link?('external_members')`. O método agora tem corpo vazio explícito (`; end`), mantendo o retorno `nil` implícito que já era o comportamento ativo.

---

### app/services/dashboard/professor_report.rb

- Removido bloco comentado de ~30 linhas com `calculate_orientations`, `valid_method?`, `total_orientations` e `count_orientations` — extração abandonada identificada pela REF-01. Esses métodos usavam `@professor.orientations.send(method, status)` com constantes de status (`'IN_PROGRESS'`, `'APPROVED_TCC_ONE'`), padrão diferente dos métodos ativos `orientations_by_tcc_one` e `orientations_by_tcc_two`, que usam literais traduzidos (`'em andamento'`, `'Aprovada em TCC 1'`). A extração não era equivalente ao comportamento ativo; sua remoção é segura.

---

### app/services/dashboard/responsible_report.rb

- **`orientations_count_by_calendars_and_status`**: o loop vazio com `# orientations += 0 # TODO: Implement this` foi substituído por um corpo direto que retorna `0`, acompanhado de comentário explicativo. O valor retornado não mudou.
- **Bloco comentado `orientations_by_tcc`/`current_tcc_orientations`** (~25 linhas): removido. Esse bloco usava `Orientation.send("tcc_#{tcc_type}", 'IN_PROGRESS')` (scopes de classe), divergindo dos métodos ativos `current_tcc_one_orientations`/`current_tcc_two_orientations` que usam `count_orientations`/`count_orientation_status`. A extração era não-equivalente e foi confirmada como abandonada pela REF-01.

---

## Review Notes

### 1. Placeholder `orientations_count_by_calendars_and_status` — achado funcional ativo

O método sempre retorna `0`. O valor alimenta `calendar_orientations_by_status` → `calendar_orientations_report` → `orientations_report[:calendar_report]`, que é renderizado em `app/views/shared/dashboard/_orientations_report.html.erb:120` como gráfico de série histórica por calendário/status. **O gráfico exibe todos os valores zerados silenciosamente em produção hoje.** A implementação real é uma mudança funcional fora do escopo desta task; o achado está documentado no comentário do método e neste relatório. Ação sugerida para REF-09 ou task específica de dashboard.

### 2. Comparação de `status` com literais traduzidos — duplicação deliberadamente mantida

`ResponsibleReport#orientations_by_tcc_one` e `ProfessorReport#orientations_by_tcc_one` usam `o.status.eql?('em andamento')`, `o.status.eql?('Aprovada em TCC 1')`, etc. — literais traduzidos, não constantes de enum. `Orientations::TccListQuery` trabalha com constantes de enum (`'IN_PROGRESS'`, `'APPROVED_TCC_ONE'`). **Substituir por `TccListQuery` alteraria os valores contados**, porque os scopes que recebem constantes são diferentes dos filtros em memória sobre o atributo traduzido. A unificação foi deliberadamente adiada; o achado permanece registrado como remanescente para decisão futura (REF-09 ou refatoração de dashboard dedicada).

### 3. Convenção de chamada — decisão por objeto

| Objeto | Decisão | Justificativa |
|---|---|---|
| `Orientations::EditabilityPolicy` | **Mantido como está** (`.new(orientation).editable?`) | Usado como policy local em 2–3 pontos; adicionar `.call` introduziria ambiguidade sobre o que retorna. Interface de instância é idiomática para policy objects. |
| `ExaminationBoards::StatusPresenter` | **Mantido como está** (`.new(board).status`) | Presenter com dois métodos públicos (`status`, `distance_of_date`); não há ponto de entrada único que justifique `.call`. Usado localmente em helpers de view. |

### 4. `Orientations::Links::*` — não tocado

Os objetos com padrão `.perform` são anteriores à REF-04. O custo de migrar todos os consumidores é desproporcional ao ganho nesta task; mantidos intactos conforme o escopo da tarefa.

---

## Nota de critério de escolha: model, query object, service e domain object

O critério emergente do trabalho REF-04 a REF-08 é pragmático, não categórico:

**Permanece no model** quando é uma invariante da entidade (validação, associação, scope que qualquer consumidor precisaria): `Academic#current_orientation`, `Orientation.tcc_one`, `Orientation.current_tcc_one`.

**Vira query object** (`*ListQuery`, `*Query`) quando a consulta tem parâmetros variáveis e mais de um consumidor, mas não produz efeito colateral: `Orientations::TccListQuery`, `ExaminationBoards::ListQuery`, `ExaminationBoards::SiteQuery`. O ponto de entrada é `.call` e o retorno é uma coleção ou hash de dados.

**Vira service com efeito colateral** quando há escrita, transição de estado ou orquestração entre entidades: `Orientations::TcoTcaiService` (cria/atualiza documento), `Orientations::MigrationService` (move orientação entre calendários), `ExaminationBoards::Destroy` (destrói com verificação e retorna `Result`). O ponto de entrada é `.call`.

**Vira objeto de apresentação/policy** quando a lógica é de interpretação ou autorização, sem efeito colateral, e o consumidor precisa de múltiplos predicados sobre um objeto específico: `ExaminationBoards::StatusPresenter` (`.status`, `.distance_of_date`), `Orientations::EditabilityPolicy` (`.editable?`, `.destroyable?`). Instanciado pelo consumidor diretamente, sem `.call` de classe.

O critério de separação é: **quem escreve? → service. Quem lê para múltiplos consumidores? → query object. Quem interpreta estado local? → policy/presenter. O que é invariante da entidade? → model.**

---

## Validação

A suíte RSpec e o RuboCop **não foram executados nesta sessão** por ausência de ambiente Docker ativo com os containers `tests`, `web`, `db` e `selenium` no ar. Os comandos de validação sugeridos pela task são:

```bash
# Suíte relacionada aos arquivos tocados
bundle exec rspec spec/services/dashboard/ \
  spec/models/academics/ \
  spec/features/professors/ \
  spec/features/external_members/

# RuboCop nos arquivos alterados
bundle exec rubocop \
  app/services/dashboard/ \
  app/helpers/professors/active_link_helper.rb \
  app/helpers/external_members/active_link_helper.rb \
  app/models/academic.rb

# Suíte completa
bundle exec rspec
bundle exec rubocop --parallel
```

**Limitação registrada**: as REF-06 e REF-07 mostraram que regressões reais só aparecem na execução dinâmica. Todas as remoções desta task são de código morto confirmado (sem consumidor ativo), o que reduz o risco, mas a validação dinâmica deve ser executada antes de considerar a task concluída em produção.

---

## Riscos e próximos passos

- **REF-09/REF-10**: `Calendar` e a navegação entre períodos não foram tocados. Qualquer lógica de filtro por calendário atual (as condições comentadas removidas dos helpers de active link) pertence ao escopo dessas tasks.
- **Dashboard `calendar_report`**: o gráfico com valores zerados é um achado funcional conhecido. A implementação real de `orientations_count_by_calendars_and_status` deve ser escopo explícito de uma task de dashboard, não tratada como limpeza de código morto.
- **Literais traduzidos em `orientations_by_tcc_one`**: a unificação com `TccListQuery` exige primeiro padronizar o atributo `status` retornado pela model (enum vs. valor traduzido) — decisão funcional para REF subsequente.
- **`Orientations::Links::*`**: o padrão `.perform` pode ser alinhado a `.call` em uma task de baixo risco se houver interesse, mas não é bloqueante.
