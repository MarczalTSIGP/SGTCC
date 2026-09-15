# Roadmap de refatoração do SGTCC

## Objetivo e escopo

Este roadmap traduz a proposta do TCC **“Refatoração do Sistema SGTCC para Melhoria da Qualidade do Código com Base em Boas Práticas de Engenharia de Software”** em tarefas incrementais para a base atual do sistema.

O objetivo é melhorar coesão, legibilidade, modularidade e manutenibilidade **sem alterar o comportamento funcional nem as regras acadêmicas existentes**. A intervenção permanece restrita à estrutura interna da camada de aplicação.

## Premissas

- A reestruturação dos testes automatizados e das factories já foi implementada e não integra o trabalho pendente.
- A suíte existente será a rede de segurança de todas as próximas alterações.
- Quando um trecho ainda não estiver suficientemente protegido, serão adicionados apenas testes de caracterização ou regressão necessários à refatoração daquele trecho.
- Cada task deve resultar em uma alteração pequena, revisável e passível de reversão.
- Services e classes de domínio só devem ser criados quando houver uma responsabilidade clara a encapsular; não são um objetivo isolado.
- Nenhuma alteração de enum pode modificar os valores persistidos atualmente no banco.

## Definition of Done global

Uma task só é considerada concluída quando:

- preserva as rotas, respostas HTTP, regras de autorização e resultados observáveis;
- passa na suíte RSpec relacionada e, antes do merge, na suíte completa;
- não introduz novas violações de RuboCop no escopo alterado;
- remove os comentários temporários e código morto que tenham sido resolvidos pela task;
- registra no PR a motivação, o comportamento preservado e as evidências de validação;
- contém comparação antes/depois das métricas aplicáveis ao bloco de refatoração.

## Visão geral das fases e tasks

O roadmap possui **15 tasks**, distribuídas em **7 fases**. A tabela abaixo apresenta a quantidade e um resumo breve de cada task em sua respectiva etapa.

| Fase | Quantidade | Task | Resumo breve |
|---|---:|---|---|
| Fase 0 — Baseline e inventário técnico | 2 | REF-00 — Registrar baseline de qualidade | Medir o estado atual da suíte, cobertura, estilo, smells, complexidade e duplicação usando comandos reproduzíveis. |
|  |  | REF-01 — Inventariar inconsistências e responsabilidades | Mapear representações inconsistentes, controllers com regras de negócio e responsabilidades dispersas em models e concerns. |
| Fase 1 — Padronização dos dados de domínio | 2 | REF-02 — Padronizar o enum `tcc` | Substituir valores mágicos de TCC I/TCC II pela API do enum, preservando os valores já armazenados. |
|  |  | REF-03 — Padronizar o enum `semester` | Uniformizar a representação dos semestres e validar transições de período e viradas de ano. |
| Fase 2 — Controllers finos e consultas encapsuladas | 2 | REF-04 — Extrair a busca de orientações do responsável | Retirar SQL, filtros e paginação das actions `tcc_one` e `tcc_two`, encapsulando a consulta. |
|  |  | REF-05 — Reestruturar os controllers mais críticos | Remover regras de negócio e duplicações dos maiores controllers, mantendo-os como coordenadores HTTP. |
| Fase 3 — Desacoplamento de models, concerns e serviços | 3 | REF-06 — Reorganizar responsabilidades de `Orientation` | Separar consultas, documentos, relatórios, status e fluxos hoje concentrados no model e em seus concerns. |
|  |  | REF-07 — Reorganizar `ExaminationBoard`, `Document` e `Signature` | Desacoplar regras de bancas, documentos e assinaturas sem comprometer histórico ou autenticidade. |
|  |  | REF-08 — Revisar services existentes e remover código morto | Padronizar contratos dos services e eliminar TODOs resolvidos, código comentado e abstrações sem uso. |
| Fase 4 — Reestruturação de `Calendar` | 2 | REF-09 — Extrair navegação entre períodos acadêmicos | Centralizar as regras de semestre anterior, próximo semestre e transição de TCC I para TCC II. |
|  |  | REF-10 — Separar consultas e relatórios de `Calendar` | Retirar do model buscas paginadas, estruturas para selects e geração de relatórios. |
| Fase 5 — Components e apresentação | 2 | REF-11 — Inventariar partials e regras de apresentação repetidas | Identificar repetições visuais que realmente justificam a criação de components reutilizáveis. |
|  |  | REF-12 — Extrair components priorizados | Converter os candidatos selecionados em components com interface explícita e testes próprios. |
| Fase 6 — Validação e avaliação do TCC | 6 | REF-13 — Validar regressão funcional por bloco | Executar testes e homologar os fluxos críticos ao final de cada bloco de refatoração. |
|  |  | REF-13A — Remover código morto de apresentação e roteamento | Eliminar partials, rota e predicado sem consumidor, identificados pela REF-11 e pela REF-13. |
|  |  | REF-13B — Desacoplar comparações de status do locale | Fechar o risco nº 1 do inventário da REF-01, substituindo literais traduzidos pela API de status. |
|  |  | REF-13C — Consolidar mapeamento de badge de status | Unificar o mapeamento status → classe CSS duplicado entre dois components. |
|  |  | REF-13D — Restabelecer ferramentas de medição | Reativar SimpleCov e corrigir a configuração do ERB Lint, pré-requisito da REF-14. |
|  |  | REF-14 — Coletar métricas to-be e avaliar resultados | Repetir as medições do baseline e produzir a comparação quantitativa e qualitativa antes/depois. |
| Fase 7 — Segunda rodada de coesão | 4 | REF-15 — Deduplicar os scopes de período de `Orientation` | Reverter a duplicação que a REF-14 mediu como a única piora estrutural do roadmap. |
|  |  | REF-16 — Remover código morto de `Orientation` | Eliminar quatro métodos de classe sem consumidor e um comentário que não descreve o código. |
|  |  | REF-17 — Extrair os acessores de atividades acadêmicas | Unificar as três variantes idênticas de busca de documento de atividade. |
|  |  | REF-18 — Recoletar métricas após a segunda rodada | Medir de novo o lado to-be e dizer, com número, se a piora do `Orientation` foi revertida. |
| Fase 8 — Dívidas registradas | 4 | REF-19 — Corrigir o N+1 das listagens públicas de orientação | Filtrar no banco em vez de carregar tudo e descartar em Ruby, em caminho público sem autenticação. |
|  |  | REF-20 — Consolidar a duplicação real entre TEP e TSO | Unificar listagem e esqueleto de CRUD, preservando as diferenças de domínio do pedido de troca. |
|  |  | REF-21 — Eliminar a dependência de ordem nos specs | Fazer os specs afetados passarem isolados e na suíte, sem mascarar com ordem fixa. |
|  |  | REF-22 — Resolver as offenses do ERB Lint | Alinhar a configuração à convenção do projeto e corrigir o que tem efeito real. |
| Fase 9 — Subsistemas não cobertos | 2 | REF-23 — Organizar o subsistema de notificações | Área sensível que atravessou todo o roadmap sem nunca ter sido alvo de nenhuma fase. |
|  |  | REF-24 — Reduzir `ExaminationBoard` com a receita da REF-15 | Deduplicar os scopes de período do novo corpo de classe mais complexo do projeto. |
| **Total** | **29** |  |  |

## Ordem de execução

### Fase 0 — Baseline e inventário técnico

Objetivo: produzir o estado **as-is** antes das alterações estruturais e transformar os problemas genéricos do TCC em alvos mensuráveis.

#### REF-00 — Registrar baseline de qualidade

**Prioridade:** alta  
**Estimativa:** 4 h  
**Dependências:** nenhuma

Tarefas:

- Executar e arquivar os resultados da suíte RSpec, SimpleCov, RuboCop e Reek.
- Adicionar RubyCritic/Flay/Flog ao fluxo de métricas, caso ainda não estejam disponíveis de forma reproduzível no projeto.
- Registrar número de falhas, cobertura, code smells, duplicações e maiores escores de complexidade.
- Definir um local versionado para os resultados resumidos, sem versionar relatórios HTML volumosos.

Critérios de aceite:

- Existe uma tabela de baseline com comando, versão da ferramenta, data e resultado.
- Outra pessoa consegue reproduzir a coleta usando comandos documentados.
- Falhas preexistentes ficam separadas das regressões introduzidas pela refatoração.

#### REF-01 — Inventariar inconsistências e responsabilidades

**Prioridade:** alta  
**Estimativa:** 4 h  
**Dependências:** REF-00

Tarefas:

- Mapear usos de `tcc` e `semester` como inteiro, string e símbolo em models, controllers, services, helpers, components e views.
- Listar consultas complexas e regras de negócio ainda presentes em controllers.
- Classificar os concerns de `Orientation`, `Calendar`, `Document`, `Signature` e `ExaminationBoard` por responsabilidade.
- Levantar extrações já iniciadas e abandonadas no código (métodos, scopes ou services comentados/desativados com TODO) que se sobrepõem a um problema do inventário, registrando se o comportamento diverge do caminho atualmente ativo.
- Priorizar os achados pelo binômio impacto × complexidade proposto no TCC.

Critérios de aceite:

- Cada achado tem arquivo, responsabilidade atual, risco e destino sugerido.
- O inventário identifica consumidores que dependem da representação persistida dos enums.
- O backlog resultante distingue dívida comprovada de abstrações apenas hipotéticas.
- Extrações abandonadas identificadas ficam associadas à task que deve reconciliá-las (ex.: REF-04).

### Fase 1 — Padronização dos dados de domínio

Objetivo: concluir o uso consistente dos enums existentes, eliminando valores mágicos sem alterar a representação no banco.

#### REF-02 — Padronizar o enum `tcc`

**Prioridade:** alta  
**Estimativa:** 4 h  
**Dependências:** REF-01

Tarefas:

- Adotar a API do enum (`Calendar.tccs`, chaves simbólicas ou scopes nomeados) nas consultas.
- Substituir comparações numéricas como `calendars: { tcc: 2 }` por uma representação explícita e consistente.
- Revisar os consumidores em dashboards, filtros, helpers, components, services de população e controllers.
- Manter o mapeamento persistido `one: 1` e `two: 2`.

Critérios de aceite:

- Não há literais numéricos `1/2` usados para expressar TCC I/TCC II fora da definição do enum ou de migrações históricas justificadas.
- Consultas para TCC I e TCC II retornam os mesmos registros de antes.
- Dados existentes são lidos sem migração destrutiva ou conversão implícita.

#### REF-03 — Padronizar o enum `semester`

**Prioridade:** alta  
**Estimativa:** 4 h  
**Dependências:** REF-01

Tarefas:

- Uniformizar comparações e consultas de semestre usando a API do enum.
- Revisar cálculos de período anterior, próximo período, primeiro/segundo semestre e ordenação.
- Remover alternância desnecessária entre `1/2`, `"one"/"two"` e símbolos.

Critérios de aceite:

- O mesmo padrão é usado em toda a camada de aplicação.
- Navegação entre semestres preserva os resultados nos limites de ano.
- Criação e leitura de calendários antigos continuam compatíveis.

### Fase 2 — Controllers finos e consultas encapsuladas

Objetivo: retirar consultas e regras de seleção da camada HTTP, começando pelo exemplo central apresentado no TCC.

#### REF-04 — Extrair a busca de orientações do responsável

**Prioridade:** alta  
**Estimativa:** 8 h  
**Dependências:** REF-02

Alvo inicial: `Responsible::OrientationsController#tcc_one` e `#tcc_two`.

Ponto de atenção confirmado no código: já existe uma extração anterior abandonada para esse mesmo problema (`scope :tcc_one`/`:tcc_two` em `Orientation` e `OrientationFilter.by_tcc_one`/`by_tcc_two`), hoje comentada no controller com `# TODO: Refactor this method`. Ela **não é equivalente** à query manual em uso: o scope traz qualquer orientação com calendário `tcc: one`, enquanto a query atual do controller restringe `tcc_one` às orientações que **ainda não avançaram** para TCC II (`HAVING COUNT(DISTINCT tcc)=1 AND MIN(tcc)=1`). Essa extração antiga deve ser **descartada**: a task constrói a consulta nova a partir do comportamento hoje ativo no controller, e remove o scope/método abandonado como código morto.

Tarefas:

- Caracterizar paginação, busca textual, filtro por status, ordenação e distinção entre TCC I e TCC II a partir do comportamento hoje ativo no controller.
- Extrair a composição da consulta para um query object ou service novo, com interface única e parâmetros explícitos, reproduzindo a semântica caracterizada (incluindo a exclusividade de TCC I).
- Remover `Orientation.tcc_one`/`tcc_two`, `OrientationFilter.by_tcc_one`/`by_tcc_two` e a chamada comentada no controller que aponta para eles, após confirmar que não há outro consumidor ativo desses métodos.
- Manter no controller somente breadcrumb, chamada da consulta, URL de busca e renderização.
- Remover os blocos de desativação do RuboCop e comentários de solução temporária resolvidos.

Critérios de aceite:

- As duas actions não constroem SQL nem encadeiam regras de filtragem.
- O objeto extraído pode ser testado isoladamente e não conhece `params`, rotas ou renderização.
- Registros que possuem apenas TCC I e registros que alcançaram TCC II permanecem corretamente separados, com teste de caracterização cobrindo explicitamente uma orientação que migrou de TCC I para TCC II.
- Paginação, termo, status e ordem permanecem idênticos.
- O scope/método abandonado (`tcc_one`/`tcc_two`/`by_tcc_one`/`by_tcc_two`) não existe mais no código ao final da task.

#### REF-05 — Reestruturar os controllers mais críticos

**Prioridade:** alta  
**Estimativa:** 12 h  
**Dependências:** REF-04

Ordem inicial sugerida:

1. `Responsible::ExaminationBoardsController`;
2. `Responsible::OrientationsController`;
3. `TccOneProfessors::ExaminationBoardsController`;
4. `Professors::OrientationsController`;
5. controllers de supervisions e documents com lógica semelhante.

Tarefas:

- Identificar fluxos repetidos, consultas, montagem de estruturas de apresentação e regras transacionais.
- Extrair apenas responsabilidades com nome e contrato claros.
- Reaproveitar scopes/query objects existentes quando expressarem conceitos de domínio.
- Eliminar duplicação entre namespaces sem criar uma superclasse genérica difícil de compreender.

Critérios de aceite:

- Actions coordenam entrada, autorização, chamada de aplicação e resposta HTTP.
- Regras extraídas não dependem de estado do controller.
- Cada extração reduz complexidade ou duplicação medida no alvo.
- Não há mudança nas rotas nem nos contratos das views.

### Fase 3 — Desacoplamento de models, concerns e serviços

Objetivo: aumentar a coesão das classes centrais e dar nomes explícitos às regras de domínio hoje dispersas.

#### REF-06 — Reorganizar responsabilidades de `Orientation`

**Prioridade:** alta  
**Estimativa:** 8 h  
**Dependências:** REF-04, REF-05

Tarefas:

- Classificar os concerns incluídos em persistência/consulta, status, documentos, relatórios, migração e apresentação.
- Consolidar duplicações como verificações de TCC e remover métodos marcados para futura remoção após atualizar consumidores.
- Mover consultas compostas para query objects e fluxos com efeitos colaterais para services.
- Manter no model associações, validações, invariantes e comportamento intrínseco da entidade.

Critérios de aceite:

- Cada concern remanescente representa uma responsabilidade compartilhada e coesa.
- Não existem pares equivalentes como `calendar_tcc_one?` e `tcc_one?` sem justificativa.
- Services de fluxo possuem resultado/erro explícito e fronteira transacional quando necessária.
- Métricas de complexidade e smells de `Orientation` melhoram em relação ao baseline.

#### REF-07 — Reorganizar `ExaminationBoard`, `Document` e `Signature`

**Prioridade:** média-alta  
**Estimativa:** 8 h  
**Dependências:** REF-05, REF-06

Tarefas:

- Separar seleção/consulta, regras de domínio, geração de estruturas de documento e apresentação.
- Identificar lógica duplicada de status, avaliadores, documentos e assinaturas.
- Extrair operações multi-entidade para services e regras puras para objetos de domínio quando isso reduzir dependências.
- Preservar rastreabilidade, autenticidade documental e histórico.

Critérios de aceite:

- Regras críticas não ficam duplicadas entre model, concern e controller.
- Operações que alteram várias entidades têm uma fronteira transacional clara.
- Geração, consulta e assinatura de documentos mantêm o comportamento anterior.

#### REF-08 — Revisar services existentes e remover código morto

**Prioridade:** média  
**Estimativa:** 4 h  
**Dependências:** REF-06, REF-07

Tarefas:

- Uniformizar convenções de inicialização, chamada, retorno e tratamento de falhas.
- Revisar duplicação entre relatórios de dashboard e demais consultas.
- Remover blocos comentados, TODOs concluídos e implementações substituídas.
- Documentar brevemente a decisão entre model, query object, service e domain object.

Critérios de aceite:

- Services novos e existentes seguem uma convenção previsível.
- Não permanece código comentado como mecanismo de histórico.
- Nenhuma camada de abstração existe sem consumidor ou responsabilidade definida.

### Fase 4 — Reestruturação de `Calendar`

Objetivo: reduzir a concentração de regras temporais e de consulta em uma classe central do domínio.

#### REF-09 — Extrair navegação entre períodos acadêmicos

**Prioridade:** alta  
**Estimativa:** 6 h  
**Dependências:** REF-03

Tarefas:

- Isolar as regras de período anterior, próximo período e transição de TCC I para TCC II.
- Tornar explícitos os casos de ausência de calendário e virada de ano.
- Separar cálculo temporal de acesso ao banco quando isso simplificar o contrato.

Critérios de aceite:

- A regra de navegação possui uma única implementação.
- Os casos 1º→2º semestre, 2º→1º do ano seguinte e TCC I→TCC II estão cobertos.
- Métodos públicos anteriores são preservados temporariamente como delegadores quando houver consumidores ainda não migrados.

#### REF-10 — Separar consultas e relatórios de `Calendar`

**Prioridade:** média  
**Estimativa:** 4 h  
**Dependências:** REF-09

Tarefas:

- Extrair buscas paginadas, dados para selects e relatório por status para objetos específicos.
- Evitar parâmetros acumuladores mutáveis como `years: []` e `total: []`.
- Manter no model validações, associações, invariantes e formatações diretamente ligadas ao calendário.

Critérios de aceite:

- `Calendar` deixa de coordenar relatórios e estruturas destinadas à interface.
- Chamadas repetidas ao relatório não compartilham estado.
- Resultados, ordem e rótulos permanecem compatíveis.

### Fase 5 — Components e apresentação

Objetivo: encapsular repetição visual e retirar regras de apresentação de controllers/models.

#### REF-11 — Inventariar partials e regras de apresentação repetidas

**Prioridade:** média  
**Estimativa:** 2 h  
**Dependências:** REF-05

Tarefas:

- Localizar partials repetidos entre namespaces e views com condicionais de domínio.
- Priorizar elementos reutilizados, com variantes claras e lógica própria.
- Não converter partials simples e locais sem benefício mensurável.

Critérios de aceite:

- O inventário registra ocorrências, variantes, dependências e benefício esperado.
- Há uma lista curta e ordenada de candidatos reais a component.

#### REF-12 — Extrair components priorizados

**Prioridade:** média  
**Estimativa:** 6 h  
**Dependências:** REF-11

Tarefas:

- Extrair um componente por vez, com interface explícita e sem acesso implícito a variáveis do controller.
- Centralizar mapeamentos de apresentação duplicados, como badges de status, quando aplicável.
- Preservar HTML, acessibilidade e comportamento visual.

Critérios de aceite:

- O component tem API pequena, testes próprios e ao menos um uso real.
- A duplicação substituída é removida.
- O HTML relevante e os fluxos de interface permanecem equivalentes.

### Fase 6 — Validação e avaliação do TCC

Objetivo: demonstrar que o comportamento foi preservado e medir o impacto das intervenções.

#### REF-13 — Validar regressão funcional por bloco

**Prioridade:** alta e contínua  
**Estimativa:** 6 h  
**Dependências:** executada ao final de cada fase

Tarefas:

- Executar suíte completa e análise estática após cada bloco.
- Validar manualmente em homologação: filtros de orientações, cálculo de períodos, bancas, relatórios, documentos e assinaturas.
- Registrar evidências da revisão por pares.

Critérios de aceite:

- Não há regressões conhecidas na suíte nem nos fluxos críticos de homologação.
- Diferenças intencionais, se surgirem, são retiradas do escopo ou aprovadas como mudança funcional separada.
- Cada fase possui evidências rastreáveis de validação.

#### REF-13A a REF-13D — Pendências abertas pela validação

**Prioridade:** alta
**Estimativa:** 6 h no total
**Dependências:** REF-13; devem ser concluídas **antes da REF-14**

A execução da REF-13 confirmou que a suíte está verde, mas deixou quatro pendências que, se resolvidas depois da medição to-be, invalidariam a comparação e obrigariam a remedir. Cada uma tem task própria em `ai/tasks/fase-6-validacao-e-avaliacao-do-tcc/`:

- **REF-13A** — três partials de tabela sem consumidor (herdadas da REF-11) e o fluxo de desistência nunca implementado: rota sem ação no controller e predicado `abandoned?` que sempre retorna `false`.
- **REF-13B** — o risco nº 1 do inventário da REF-01, atribuído à REF-06 e não resolvido: quatro pontos comparam `orientation.status` contra literais em português, acoplando regra de negócio ao locale.
- **REF-13C** — mapeamento status → classe CSS duplicado entre `Orientations::StatusBadgeComponent` e `Orientations::TableComponent`, fora do alcance do inventário da REF-11 por estar em components e não em partials.
- **REF-13D** — SimpleCov desativado desde antes do baseline e ERB Lint inoperante por configuração obsoleta.

Achados registrados e **deixados fora** deste bloco, por serem mudança funcional ou reestruturação maior: a duplicação do recurso inteiro `tep_requests`/`tso_requests` e a decisão sobre implementar ou descartar o fluxo de desistência de orientação.

#### REF-14 — Coletar métricas to-be e avaliar resultados

**Prioridade:** alta  
**Estimativa:** 4 h  
**Dependências:** REF-02 a REF-13

Tarefas:

- Repetir exatamente os comandos do baseline.
- Comparar Reek, Flog, Flay, SimpleCov e RuboCop antes/depois.
- Recontar dependências diretas e lógica de negócio removida dos controllers.
- Executar a alteração controlada proposta no TCC, por exemplo adicionar um critério de busca, registrando tempo e pontos modificados.
- Interpretar métricas como evidência complementar, não como fim isolado.

Critérios de aceite:

- Existe uma tabela as-is/to-be com variação absoluta e percentual.
- A análise explica melhorias, resultados neutros e eventuais pioras.
- As conclusões se relacionam diretamente aos objetivos específicos do TCC.

### Fase 7 — Segunda rodada de coesão

Objetivo: atacar o único alvo do roadmap que a medição da REF-14 mostrou ter piorado, e fechar o ciclo com nova medição.

**Prioridade:** média
**Estimativa:** 8 h no total
**Dependências:** REF-14

A REF-14 mediu que `Orientation` ficou 25,4% mais complexo no corpo da classe (99,9 → 125,3 pontos de Flog), apesar de ter sido alvo explícito da REF-06, e que o modelo não encolheu (295 → 293 linhas). A causa está identificada: a REF-06 removeu cinco concerns mas inlinou o conteúdo deles nos scopes, trocando indireção por duplicação local.

- **REF-15** — os quatro scopes de período diferem apenas no valor de `tcc`; a montagem da consulta e o tratamento de status estão repetidos quatro vezes.
- **REF-16** — `last_tcc_one_calendars`, `count_orientations_in_last_tcc_one_calendar`, `reproved` e `reproved_tcc_one` não têm nenhum consumidor; o comentário `🚨 CORREÇÃO TEMPORÁRIA` anuncia uma troca de callback que não está aplicada.
- **REF-17** — `monograph`/`project`/`proposal` e suas variantes `final_*` são três cópias da mesma busca, diferindo só no identificador.
- **REF-18** — recoleta apenas o lado to-be e responde, com número, se a piora foi revertida.

Achado registrado e **deixado fora** deste bloco: `Orientation.approved` e `Orientation.approved_tcc_one` carregam todos os registros e filtram em Ruby (`reject { |o| o.final_monograph.nil? }`), com uma consulta por registro. Corrigir isso muda consulta usada pelo site público e pela API, e merece task própria com medição de desempenho.

### Fase 8 — Dívidas registradas

Objetivo: fechar os achados que as fases anteriores identificaram e deixaram explicitamente fora de escopo, por serem mudança funcional, reestruturação maior ou infraestrutura de teste.

**Prioridade:** REF-19 alta; REF-21 média; REF-20 e REF-22 baixas
**Estimativa:** 14 h no total
**Dependências:** REF-17 (para a REF-19), REF-11/REF-12 (para a REF-20), REF-16/REF-17 (para a REF-21), REF-13D (para a REF-22)

- **REF-19** — `Orientation.approved` e `approved_tcc_one` carregam todos os registros do status e filtram em Ruby com `reject`, disparando uma consulta de atividade acadêmica por registro. Serve site público sem autenticação, API e ranking de professores, e cresce a cada semestre. É a dívida de maior impacto do conjunto.
- **REF-20** — TEP e TSO compartilham listagem, linha, `new`, `edit` e esqueleto de CRUD, mas **não** são o mesmo recurso: o formulário e o `show` do TSO carregam orientador, coorientadores e a lógica de troca de orientação, com quatro métodos exclusivos no controller. A task corrige o inventário da REF-11 nesse ponto e consolida só o que é duplicação de fato.
- **REF-21** — há specs que passam na suíte completa e falham isolados. A causa provável está mapeada: `Calendar.current_semester` consulta a própria tabela, então a resposta muda depois que o primeiro calendário é criado.
- **REF-22** — metade das 2013 offenses do ERB Lint vem do linter `space_indentation`, que contraria uma convenção que o projeto já adotou ao desligar `Layout/IndentationStyle` no RuboCop. A task alinha a configuração em vez de reindentar as views, e corrige separadamente as 21 ocorrências de `Rails/LinkToBlank`, as únicas com efeito além de estilo.

### Fase 9 — Subsistemas não cobertos

Objetivo: alcançar o que as sete primeiras fases não olharam e o alvo que a própria segunda rodada promoveu ao topo.

**Prioridade:** média
**Estimativa:** 10 h no total
**Dependências:** REF-15 e REF-18 para a REF-24; a REF-23 é independente

- **REF-23** — notificações nunca entraram em nenhuma fase do roadmap, apesar de serem área explicitamente sensível (processo assíncrono, disparo de e-mail). Concentram 44 smells em quatro arquivos, o maior bolo fora do código de seed. Dois problemas concretos: `SchedulerService#load_and_check_template?` é um predicado que atribui `@template`, lido depois por `schedule!`; e `calculate_base_time` engole qualquer `StandardError` e cai para `Time.current` **sem registro**, o que produz notificação no horário errado sem rastro. O subsistema tem specs em quase tudo — a lacuna é `services/notifications/hooks/`, sem spec dedicado e com `hooks/activity.rb` em 62,86%.
- **REF-24** — com a REF-15, `Orientation#none` caiu para 89,3 e `ExaminationBoard` assumiu o topo com **97,7**. A causa é a mesma: `tcc_one_current_semester` e `tcc_two_current_semester` são 14 linhas cada, idênticas exceto por `:one`/`:two`. A receita da REF-15 se aplica quase literalmente, inclusive a armadilha dos métodos de apoio precisarem ser públicos dentro de um `scope`.

Registrado e **fora** deste bloco: `Responsible::ExaminationBoardsController`, com 16 warnings, é o pior controller do projeto mesmo depois da REF-05.

## Marcos e estimativa restante

| Marco | Tasks | Resultado verificável | Estimativa |
|---|---|---|---:|
| M0 — Diagnóstico reproduzível | REF-00–01 | Baseline e inventário priorizado | 8 h |
| M1 — Dados padronizados | REF-02–03 | Enums usados consistentemente | 8 h |
| M2 — Camada HTTP desacoplada | REF-04–05 | Controllers críticos sem regras de consulta/negócio | 20 h |
| M3 — Domínio reorganizado | REF-06–08 | Models/concerns mais coesos e services consistentes | 20 h |
| M4 — Calendário coeso | REF-09–10 | Regras temporais e relatórios separados | 10 h |
| M5 — Apresentação organizada | REF-11–12 | Components extraídos apenas onde há reutilização | 8 h |
| M6 — Evidências finais | REF-13, REF-13A–13D, REF-14 | Regressão validada, pendências fechadas e comparação as-is/to-be | 10 h |
| **Total restante estimado** |  |  | **84 h** |

As estimativas devem ser recalibradas após o inventário da REF-01. REF-13 é contínua: suas horas estão consolidadas no marco final, mas a validação deve ocorrer ao término de cada fase, e não apenas no fim do projeto.

## Estratégia de branches/PRs

- Uma task por branch e, preferencialmente, um PR por responsabilidade extraída.
- Não misturar padronização ampla de dados com extração arquitetural no mesmo PR.
- Para classes centrais, preferir a sequência: caracterização → extração/delegação → migração de consumidores → remoção do caminho antigo.
- Commits devem separar mudanças mecânicas de mudanças estruturais, facilitando revisão e comparação.

## Itens fora do escopo

- Novas funcionalidades ou mudanças nas regras acadêmicas.
- Redesign visual do sistema.
- Alteração da representação persistida dos enums sem necessidade comprovada e plano de migração próprio.
- Reescrita completa da aplicação ou adoção de uma arquitetura paralela.
- Busca por cobertura de 100% ou eliminação de todos os avisos apenas para melhorar números.
- Nova refatoração geral de testes e factories; somente testes de caracterização/regressão diretamente necessários às tasks restantes.
