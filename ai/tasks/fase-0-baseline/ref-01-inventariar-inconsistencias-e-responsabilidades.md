# Task

REF-01 — Inventariar inconsistências de dados e responsabilidades dispersas no SGTCC, a partir do baseline coletado em REF-00.

# Contexto

O baseline de qualidade (`ai/output/fase-0-baseline/baseline/README.md`, gerado pela REF-00) já mediu o estado atual do projeto:

- RuboCop: 0 offenses, Brakeman: 0 alertas — não há dívida de estilo/segurança visível.
- Reek: 690 warnings, concentrados em `IrresponsibleModule` (224, ruído — falta de comentário de classe), `InstanceVariableAssumption` (136), `DuplicateMethodCall` (77), `TooManyStatements` (41), `TooManyInstanceVariables` (31), `FeatureEnvy` (30).
- Flog (complexidade): destaque para o corpo de `ExaminationBoard` (115.0) e `Orientation` (99.9), além de `Professor`, `ExaminationBoardNote`, `Populate::BaseActivities#create_base_activities_for_tcc_one`, `Document`, `Responsible::OrientationsController#tcc_one`/`#tcc_two`, `Dashboard::ProfessorReport#orientations_by_tcc_one`, `Dashboard::ResponsibleReport#orientations_by_tcc_one`.
- Flay (duplicação): 119 blocos similares, concentrados em views (`_appointment_file_form`, `sign_form` por perfil, listagens de calendário/tep_requests) e controllers com ações repetidas entre namespaces.
- RubyCritic: nota 85.91/100, com rating F em `app/controllers/responsible/orientations_controller.rb` e `app/controllers/responsible/examination_boards_controller.rb`.
- RSpec e SimpleCov não puderam ser coletados no ambiente da REF-00 (banco de teste indisponível / config do SimpleCov comentada) — isso não bloqueia esta task, mas deve ser considerado um risco a mencionar no inventário.

Esta task é a segunda e última da Fase 0. Ela transforma esses números genéricos em um backlog concreto, ligado a arquivos e linhas reais, que vai alimentar diretamente as Fases 1 a 5 do roadmap (`ai/roadmap.md`).

# Objetivo

Produzir um inventário técnico, baseado em inspeção real do código, que:

- mapeie os usos inconsistentes dos enums `tcc` e `semester` (inteiro, string, símbolo) em toda a aplicação;
- liste consultas complexas e regras de negócio ainda presentes em controllers;
- classifique os concerns de `Orientation`, `Calendar`, `Document`, `Signature` e `ExaminationBoard` por responsabilidade;
- identifique extrações já iniciadas e abandonadas (métodos, scopes ou services comentados/desativados com TODO) que se sobrepõem a um problema do inventário;
- priorize os achados por impacto × complexidade.

# Instrução crítica

Esta task é somente de **leitura, análise e documentação**. Não corrija nada encontrado durante o inventário.

Não altere código de produção, models, controllers, services, concerns, helpers, views, rotas, migrations, factories ou specs.

A única escrita permitida é o relatório de inventário descrito abaixo.

# Escopo permitido

- Ler e inspecionar qualquer arquivo em `app/`, `config/routes.rb`, `db/schema.rb`, `spec/` e `ai/`.
- Usar `grep`/busca textual para localizar usos de `tcc`/`semester` e para localizar comentários `TODO`, código desativado (`# rubocop:disable`, métodos comentados) e scopes/serviços não referenciados.
- Consultar os resultados já coletados em `ai/output/fase-0-baseline/baseline/README.md` como ponto de partida, mas validando cada achado relevante contra o código atual (os números do Reek/Flog podem já estar levemente desatualizados).
- Criar o arquivo de relatório em `ai/output/fase-0-baseline/`.

# Escopo proibido

- Não altere nenhum arquivo em `app/`, `config/`, `db/`, `spec/`, `lib/tasks/`.
- Não remova nem corrija os TODOs, scopes ou métodos abandonados encontrados — apenas registre-os no inventário.
- Não faça commit, push ou criação de branch.

# Roteiro de investigação

## 1. Enum `tcc`

- Localizar todos os usos de `tcc` em models, controllers, services, helpers, components, views e specs.
- Separar usos que já passam pela API do enum (`Calendar.tccs`, `calendar.tcc_one?`, scopes nomeados) dos que usam literais numéricos (`1`/`2`) ou strings soltas (`"one"`/`"two"`) para o mesmo conceito.
- Prestar atenção especial a `calendars: { tcc: 2 }` e comparações equivalentes em joins/where.

## 2. Enum `semester`

- Repetir o mesmo levantamento para `semester`, incluindo lógica de período anterior/próximo período e virada de ano.
- Identificar onde `1`/`2`, `"one"`/`"two"` e símbolos coexistem para o mesmo dado.

## 3. Consultas e regras de negócio em controllers

- Focar prioritariamente em `Responsible::OrientationsController#tcc_one`/`#tcc_two` (já apontados pelo Flog com score 26.2/25.0) e `Responsible::ExaminationBoardsController` (rating F no RubyCritic).
- Listar SQL manual, encadeamento de scopes, paginação, filtros e ordenação feitos diretamente na action.
- Verificar se há lógica equivalente duplicada entre `Responsible::`, `Professors::`, `TccOneProfessors::` e outros namespaces.

## 4. Concerns e responsabilidades de `Orientation`, `Calendar`, `Document`, `Signature`, `ExaminationBoard`

- Para cada um desses models, listar os concerns incluídos e classificar cada método/concern por responsabilidade (ex.: persistência/consulta, status, documentos, relatórios, migração de TCC, apresentação).
- Usar os destaques do Flog (`ExaminationBoard#none` 115.0, `Orientation#none` 99.9, `ExaminationBoardNote#none` 37.7, `Document#none` 32.6) como sinal de onde a responsabilidade provavelmente está mais concentrada.

## 5. Extrações abandonadas

- Buscar por `TODO`, `FIXME`, métodos/scopes comentados e código desativado que se sobreponha a algum problema já mapeado.
- Para cada achado, registrar se o comportamento do código morto diverge do caminho atualmente ativo (como já é o caso conhecido de `Orientation.tcc_one`/`tcc_two` e `OrientationFilter.by_tcc_one`/`by_tcc_two`, citados no roadmap como não equivalentes ao comportamento ativo do controller — confirmar se esse achado específico ainda procede).

## 6. Duplicação de views/controllers

- Usar os blocos apontados pelo Flay (`_appointment_file_form`, `sign_form`, listagens de calendário) como ponto de partida para registrar candidatos a consolidação, sem implementá-la nesta task (isso é escopo da Fase 5 — REF-11/REF-12).

# Critérios de aceite

- Cada achado do inventário tem: arquivo (com caminho completo), responsabilidade atual, risco e destino sugerido (ex.: "extrair para query object", "mover para concern X", "consolidar com Y").
- O inventário identifica explicitamente os consumidores que dependem da representação persistida dos enums `tcc` e `semester`.
- O backlog resultante distingue dívida comprovada (com evidência no código) de abstrações apenas hipotéticas.
- Extrações abandonadas identificadas ficam associadas à task do roadmap que deve reconciliá-las (ex.: REF-04 para o caso de `Orientation.tcc_one`/`tcc_two`).
- Os achados estão priorizados por impacto × complexidade, com uma recomendação clara de por onde começar a Fase 1.

# Relatório final esperado

Criar `ai/output/fase-0-baseline/inventario-ref-01.md` com:

## Resumo

Visão geral do que foi encontrado, em poucas linhas.

## Enum `tcc`

Tabela de usos inconsistentes, por arquivo, com o padrão encontrado (literal numérico, string, símbolo, API do enum).

## Enum `semester`

Mesma estrutura da seção anterior.

## Controllers com regra de negócio/consulta

Lista priorizada de actions com SQL/regra embutida, incluindo `Responsible::OrientationsController#tcc_one`/`#tcc_two` e demais controllers críticos.

## Responsabilidades de `Orientation`, `Calendar`, `Document`, `Signature`, `ExaminationBoard`

Para cada model: lista de concerns/métodos classificados por responsabilidade.

## Extrações abandonadas

Lista de código morto/TODOs relevantes, com a task do roadmap que deve tratá-los.

## Candidatos a duplicação (views/controllers)

Lista breve dos blocos mais relevantes apontados pelo Flay, para referência futura da Fase 5.

## Backlog priorizado

Tabela final com todos os achados, ordenados por impacto × complexidade, servindo de entrada direta para as Fases 1 e 2 do roadmap.

## Riscos e limitações

Registre se algo não pôde ser confirmado (ex.: RSpec indisponível no ambiente) e o que isso significa para a confiabilidade do inventário.
