# Task

REF-06 — Reorganizar as responsabilidades de `Orientation`, separando consultas, documentos, relatórios, status e fluxos hoje concentrados no model e em seus concerns, sem alterar comportamento funcional, regras acadêmicas ou a representação persistida dos enums.

# Contexto

A REF-01 (`ai/output/fase-0-baseline/inventario-ref-01.md`) já classificou os concerns de `Orientation` por responsabilidade. A REF-04 extraiu a busca de orientações do responsável para `Orientations::ResponsibleListQuery` e a REF-05 extraiu as listagens por participante para `Orientations::ParticipantListQuery`, deixando os controllers como coordenadores HTTP. `Orientation` continua concentrando, além de associações e validações intrínsecas, os seguintes concerns:

1. `OrientationStatus` — define o enum `status` e os predicados de status (`approved?`, `canceled?`, `reproved?`, `in_progress?`, `abandoned?`). Intrínseco ao model; não é alvo de extração nesta task.
2. `OrientationValidation` — valida que o orientador não apareça também como supervisor. Intrínseco ao model; não é alvo de extração.
3. `OrientationOption` — `can_be_canceled?`, `can_be_edited?`, `can_be_destroyed?`. `can_be_edited?` já consulta `DocumentType`/`documents`; é candidato a mover para um objeto de consulta/regra que não dependa de estado do controller.
4. `OrientationJoin` — métodos de classe que compõem `joins(:calendars).where(...)` para TCC e calendário atual (`join_with_status_by_tcc`, `join_with_status`, `join_current_calendar`, `join_current_calendar_tcc_one`, `join_current_calendar_tcc_two`). Consulta pura, sem `params`, HTTP ou apresentação.
5. `OrientationFilter` — `by_tcc`, `by_tcc_one`, `by_tcc_two`, `by_current_tcc_one`, `by_current_tcc_two`. Compõe paginação, seleção de colunas e busca textual a partir de `OrientationJoin`. Ainda é consumido por `Responsible::ProfessorsController#tcc_one_orientations`/`#tcc_two_orientations` (nomes de action a confirmar no código) e por `TccOneProfessors::OrientationsController#index`. Diferente do que a REF-04 descartou (o scope antigo `Orientation.tcc_one`/`tcc_two` sem o filtro de exclusividade), este `by_tcc_one`/`by_tcc_two` está ativo e não deve ser removido sem migrar esses consumidores.
6. `OrientationDocuments` — `find_document_by_document_type`, `tco`, `tcai`, `tco?`, `tcai?`, `destroy_document`. Acesso a documentos por tipo.
7. `OrientationTcoTcai` — callbacks `after_create_commit :create_tco_and_tcai` e `after_update :recreate_tco_and_tcai`, com um comentário `🚨 CORREÇÃO TEMPORÁRIA PARA MIGRAÇÃO` indicando uma troca de `after_create_commit` por `after_create` ainda pendente de revisão. Fluxo com efeito colateral (cria/recria documentos TCO/TCAI).
8. `OrientationReport` — `professors_ranking`/`professors_ranking_data`, relatório agregado por professor.

Diretamente no model, além de associações e validações, também residem:

- `migrate`/`can_be_migrated?`/scope `to_migrate` — fluxo de migração de TCC I para TCC II, usado por `Responsible::OrientationsMigrationController` e por `app/services/populate/orientations.rb`.
- Um par de métodos equivalentes já sinalizado no código com `# TODO: Refactored and Remove`: `calendar_tcc_one?`/`calendar_tcc_two?` versus `tcc_one?`/`tcc_two?`. Os dois primeiros ainda são usados em `app/models/concerns/academic_documents_info.rb` e têm spec próprio (`spec/models/orientations/orientation_calendar_spec.rb`); não é código morto, mas uma duplicação real a consolidar.
- `orientation_type`/`summary`/`approved_date` — deriva um tipo (`:approved`, `:tcc_one`, `:in_tcc_one`, `:unknown`) a partir de `status` comparado a literais de texto (`'aprovada'`, `'Aprovada em TCC 1'`, `'em andamento'`). Como `OrientationStatus` define o enum com chaves traduzidas via `I18n.t`, o valor retornado por `status` depende da tradução ativa; verifique com um teste de caracterização se essas comparações batem com o valor real antes de mover este método, e preserve o comportamento observado mesmo que pareça inconsistente — não é escopo desta task corrigir a regra, apenas realocá-la com o mesmo resultado.
- `monograph`/`final_monograph`/`project`/`final_project`/`proposal`/`final_proposal`/`find_academic_activity` — seleção de atividades acadêmicas por identificador e versão final.
- Métodos de classe usados por dashboards e relatórios administrativos: `to_json_table`, `select_status_data`, `approved`, `approved_tcc_one`, `reproved`, `reproved_tcc_one`, `in_tcc_one`, `by_status` (privado).

`ProfessorOrientationFilter` (incluído em `Professor`, não em `Orientation`) compõe `tcc_one_approved`/`tcc_two_approved`/`tcc_one_in_progress`/`tcc_two_in_progress` chamando `orientations.tcc_one(...)`/`.current_tcc_one(...)`. Ele consome os scopes de `Orientation`, mas pertence a outro model; não altere sua interface pública nesta task, apenas garanta que ele continue funcionando após qualquer mudança nos scopes que consome.

# Dependências

- REF-04 — Extrair a busca de orientações do responsável.
- REF-05 — Reestruturar os controllers mais críticos.

# Objetivo

Reduzir `Orientation` e seus concerns às responsabilidades intrínsecas de uma entidade de domínio — associações, validações e invariantes — movendo:

- consultas compostas (joins, filtros, paginação, ordenação) para query objects em `app/services/orientations/`;
- fluxos com efeito colateral (criação/recriação de TCO e TCAI, migração de TCC) para services com resultado explícito;
- relatórios agregados (`professors_ranking`) para um objeto de relatório fora do model.

O model deve manter associações, validações, enum de status, predicados de status e os métodos que expressam invariantes da entidade (por exemplo `short_title`, `supervisors`, `active?`).

# Instruções críticas

Preserve integralmente:

- os valores e o mapeamento persistido do enum `status`;
- o resultado de `tcc_one?`/`tcc_two?`/`calendar_tcc_one?`/`calendar_tcc_two?` para os consumidores atuais, mesmo ao consolidar o par duplicado;
- o comportamento de `can_be_edited?`/`can_be_destroyed?`/`can_be_canceled?` para os fluxos de edição, exclusão e cancelamento;
- a criação e recriação de TCO/TCAI, incluindo a condição `tcc_one? && can_be_edited?` antes de recriar e a criação condicional de TCAI apenas quando há `institution`;
- o fluxo de migração (`migrate`, `can_be_migrated?`, scope `to_migrate`) usado pela migração de TCC I para TCC II, incluindo os consumidores em `Populate::Orientations`;
- os resultados de `by_tcc`, `by_tcc_one`, `by_tcc_two`, `by_current_tcc_one`, `by_current_tcc_two` para `Responsible::ProfessorsController` e `TccOneProfessors::OrientationsController`;
- o relatório `professors_ranking` usado no dashboard administrativo;
- a seleção de atividades acadêmicas (`monograph`, `project`, `proposal` e suas variantes `final_*`) e o resultado de `orientation_type`/`summary`/`approved_date`.

Não mova regras de `ExaminationBoard`, `Document` ou `Signature` nesta task; isso pertence à REF-07. Não altere `Calendar` nem sua navegação entre períodos; isso pertence à REF-09/REF-10. Não altere `ProfessorOrientationFilter` além do necessário para continuar consumindo os scopes/objetos extraídos.

# Escopo obrigatório

## 1. Consultas de junção e filtro por TCC

Extrair `OrientationJoin` e `OrientationFilter` para um ou mais query objects em `app/services/orientations/`, com interface explícita (por exemplo `tcc:`, `period: :current/:history`, `status:`, `year:`, `semester:`, `page:`, `term:`). Substituir os métodos de classe por chamadas ao objeto extraído nos consumidores atuais (`Responsible::ProfessorsController`, `TccOneProfessors::OrientationsController` e qualquer outro uso confirmado). Só remover os métodos do concern após migrar todos os consumidores.

## 2. Regra de edição/exclusão

Extrair a verificação de `can_be_edited?`/`can_be_destroyed?` (hoje dependente de `DocumentType` e `documents`) para um objeto de regra que receba a orientação e não conheça `params`, controller ou sessão. Manter `can_be_canceled?` no model se permanecer uma verificação simples sobre `professor`/`active?`, ou extrair junto se isso reduzir duplicação real.

## 3. Fluxo de TCO/TCAI

Extrair `create_tco_and_tcai`/`recreate_tco_and_tcai` (hoje em `OrientationTcoTcai`) para um service com resultado explícito, mantendo os callbacks do model como pontos de disparo finos (`after_create_commit`/`after_update`) que apenas chamam o service. Investigar e documentar no relatório final se a "correção temporária" mencionada no comentário do concern ainda é necessária; não alterar o comportamento de disparo sem registrar a justificativa.

## 4. Fluxo de migração de TCC

Extrair `can_be_migrated?` e a composição de `migrate` para um service que receba a orientação e retorne um resultado explícito (migrada ou não, com o motivo). Manter o scope `to_migrate` como consulta, extraindo-o para o mesmo namespace de query objects se isso reduzir a lógica hoje embutida na subquery.

## 5. Relatório de professores

Extrair `professors_ranking`/`professors_ranking_data` para um objeto de relatório em `app/services/orientations/` ou `app/services/dashboard/`, coerente com os services de dashboard já existentes (`app/services/dashboard/professor_report.rb`, `app/services/dashboard/responsible_report.rb`).

## 6. Consolidação de duplicação confirmada

Unificar `calendar_tcc_one?`/`calendar_tcc_two?` com `tcc_one?`/`tcc_two?`, atualizando o único consumidor confirmado (`AcademicDocumentsInfo`) e o spec correspondente. Remover os comentários `# TODO: Refactored and Remove` apenas após a consolidação.

# Escopo permitido

- `app/models/orientation.rb` e os concerns listados na seção de contexto;
- novos query objects e services em `app/services/orientations/` (ou `app/services/dashboard/` para o relatório, se mais coerente);
- ajustes mínimos nos consumidores diretamente afetados pela extração (`Responsible::ProfessorsController`, `TccOneProfessors::OrientationsController`, `Responsible::OrientationsMigrationController`, `Populate::Orientations`, `AcademicDocumentsInfo`);
- specs unitários dos objetos extraídos e specs de model/feature dos fluxos diretamente afetados;
- relatório final em `ai/output/fase-3-desacoplamento-de-models-concerns-e-servicos/`.

# Escopo proibido

- Não altere migrations, schema ou dados persistidos.
- Não altere o mapeamento ou os valores do enum `status`.
- Não altere `ExaminationBoard`, `Document`, `Signature` ou seus concerns; isso pertence à REF-07.
- Não altere `Calendar` ou a navegação entre períodos; isso pertence à REF-09/REF-10.
- Não corrija comportamentos aparentemente inconsistentes (como a comparação de `orientation_type` com literais de status) sem antes caracterizá-los e sem registrar a decisão no relatório; se a caracterização confirmar um bug real e não apenas uma leitura equivocada, documente a descoberta e mantenha o comportamento atual nesta task — a correção funcional é uma mudança separada, fora do escopo de uma refatoração estrutural.
- Não altere rotas, parâmetros, textos, traduções ou respostas HTTP dos controllers consumidores.
- Não altere `ProfessorOrientationFilter` além do necessário para continuar consumindo os objetos extraídos.
- Não faça commit, push ou criação de branch.

# Roteiro de implementação

## 1. Medir e caracterizar antes da extração

- Registrar tamanho, ABC/Flog e offenses de `orientation.rb` e dos concerns listados.
- Mapear cada método de concern para seus consumidores atuais (controllers, services, views, specs).
- Adicionar testes de caracterização apenas onde houver lacuna, cobrindo pelo menos:
  - `by_tcc_one`/`by_tcc_two`/`by_current_tcc_one`/`by_current_tcc_two` com busca, paginação e status;
  - `can_be_edited?`/`can_be_destroyed?` com e sem documentos protegidos;
  - criação de TCO/TCAI ao criar uma orientação, com e sem `institution`;
  - recriação de TCO/TCAI ao atualizar uma orientação em TCC I editável, e a ausência de recriação fora dessa condição;
  - migração de uma orientação aprovada em TCC I para o próximo calendário de TCC II, e o caso em que não há calendário seguinte;
  - `professors_ranking` com múltiplos professores e orientações aprovadas;
  - `orientation_type`/`summary` para os três status considerados, registrando o valor real de `status` observado no teste.

## 2. Extrair consultas de junção e filtro

- Criar o(s) query object(s) a partir de `OrientationJoin`/`OrientationFilter`.
- Migrar os consumidores confirmados antes de remover os métodos do concern.
- Garantir ausência de `send` com entrada aberta e de filtragem em memória.

## 3. Extrair regra de edição/exclusão e fluxo de TCO/TCAI

- Extrair a regra de `can_be_edited?`/`can_be_destroyed?` preservando a consulta a `DocumentType`/`documents`.
- Extrair o service de TCO/TCAI mantendo os callbacks do model como disparo fino.
- Confirmar que `skip_documents_callbacks` continua suprimindo a recriação quando usado pelos consumidores atuais.

## 4. Extrair fluxo de migração e relatório

- Extrair `can_be_migrated?`/composição de `migrate` para o service de migração.
- Extrair `professors_ranking` para o objeto de relatório.

## 5. Consolidar duplicação e simplificar

- Unificar `calendar_tcc_one?`/`calendar_tcc_two?` com `tcc_one?`/`tcc_two?`.
- Remover concerns que ficarem vazios após as extrações e atualizar as inclusões em `orientation.rb`.
- Remover comentários temporários e TODOs resolvidos pela task.

## 6. Verificação final

- Executar specs unitários dos objetos novos.
- Executar os specs de model de `Orientation` e os specs de feature/controller dos consumidores diretamente afetados.
- Executar a suíte RSpec completa.
- Executar RuboCop nos arquivos alterados e, antes do merge, no projeto completo.
- Comparar métricas antes/depois e registrar qualquer concern mantido sem alteração com justificativa concreta.

# Critérios de aceite

- `Orientation` e seus concerns remanescentes representam responsabilidades intrínsecas da entidade (associações, validações, invariantes, predicados de status).
- Consultas compostas por TCC, período e status não permanecem como métodos de classe encadeados no model.
- O fluxo de criação/recriação de TCO/TCAI e o fluxo de migração de TCC produzem os mesmos resultados observáveis de antes, incluindo os casos de borda caracterizados.
- `professors_ranking` retorna os mesmos dados e ordenação de antes.
- Não existem mais pares equivalentes como `calendar_tcc_one?`/`tcc_one?` sem justificativa.
- Nenhuma regra de `ExaminationBoard`, `Document`, `Signature` ou `Calendar` foi movida ou alterada.
- A suíte relacionada e a suíte completa passam; o RuboCop não registra novas violações.
- Métricas de complexidade e smells de `Orientation` melhoram em relação ao baseline da REF-00/REF-01.

# Validação sugerida

```bash
bundle exec rspec spec/models/orientations/ \
  spec/models/orientation_supervisor_spec.rb \
  spec/models/professors/professor_orientations_spec.rb \
  spec/services/orientations/ \
  spec/controllers/responsible/professors_controller_spec.rb \
  spec/controllers/tcc_one_professors/orientations_controller_spec.rb \
  spec/features/responsible/orientations/ \
  spec/features/responsible/orientations_migration/

bundle exec rubocop app/models/orientation.rb \
  app/models/concerns/orientation_*.rb \
  app/models/concerns/professor_orientation_filter.rb \
  app/services/orientations/ spec/services/orientations/ \
  app/controllers/responsible/professors_controller.rb \
  app/controllers/tcc_one_professors/orientations_controller.rb \
  app/controllers/responsible/orientations_migration_controller.rb

bundle exec rspec
bundle exec rubocop --parallel
```

Se o projeto exigir Docker, use os comandos equivalentes fornecidos por `./run`.

Falhas de ambiente não devem ser registradas como sucesso. Documente comando, mensagem e comportamentos não validados dinamicamente.

# Métricas antes/depois

Registrar, no mínimo:

- linhas e ABC/Flog de `orientation.rb` e de cada concern alterado;
- quantidade de métodos de consulta movidos para query objects;
- quantidade de services novos e seus contratos;
- duplicações removidas (par `calendar_tcc_*?`/`tcc_*?` e qualquer outra confirmada);
- resultado dos specs focados e da suíte completa;
- offenses do RuboCop nos arquivos alterados e no projeto completo.

# Relatório final esperado

Criar `ai/output/fase-3-desacoplamento-de-models-concerns-e-servicos/implementation-summary-ref-06-reorganizar-orientation.md` com:

## Resumo

Responsabilidades extraídas e concerns simplificados ou removidos.

## Inventário antes da alteração

Tabela por método/concern com responsabilidade atual, consumidores e contrato preservado.

## Arquivos alterados

Lista dos arquivos e responsabilidade de cada mudança.

## Contratos dos objetos extraídos

Entradas, saída, erros e limites de cada query object/service/objeto de relatório.

## Comportamento preservado

Evidências sobre consultas por TCC/período/status, edição/exclusão protegida por documentos, criação e recriação de TCO/TCAI, migração de TCC e o relatório de professores.

## Achados sobre comportamento existente

Registrar qualquer inconsistência encontrada durante a caracterização (por exemplo a comparação de `orientation_type` com literais de status) sem corrigi-la nesta task, indicando se merece uma task funcional separada.

## Métricas antes/depois

Tabela com linhas, ABC/Flog, consultas movidas, duplicações removidas e offenses.

## Validação

Comandos e resultados de RSpec e RuboCop, separando regressões, falhas preexistentes e limitações ambientais.

## Riscos e próximos passos

Registrar decisões deliberadamente adiadas e confirmar que `ExaminationBoard`, `Document` e `Signature` pertencem à REF-07, e `Calendar` pertence à REF-09/REF-10.
