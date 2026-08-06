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
| Fase 6 — Validação e avaliação do TCC | 2 | REF-13 — Validar regressão funcional por bloco | Executar testes e homologar os fluxos críticos ao final de cada bloco de refatoração. |
|  |  | REF-14 — Coletar métricas to-be e avaliar resultados | Repetir as medições do baseline e produzir a comparação quantitativa e qualitativa antes/depois. |
| **Total** | **15** |  |  |

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

## Marcos e estimativa restante

| Marco | Tasks | Resultado verificável | Estimativa |
|---|---|---|---:|
| M0 — Diagnóstico reproduzível | REF-00–01 | Baseline e inventário priorizado | 8 h |
| M1 — Dados padronizados | REF-02–03 | Enums usados consistentemente | 8 h |
| M2 — Camada HTTP desacoplada | REF-04–05 | Controllers críticos sem regras de consulta/negócio | 20 h |
| M3 — Domínio reorganizado | REF-06–08 | Models/concerns mais coesos e services consistentes | 20 h |
| M4 — Calendário coeso | REF-09–10 | Regras temporais e relatórios separados | 10 h |
| M5 — Apresentação organizada | REF-11–12 | Components extraídos apenas onde há reutilização | 8 h |
| M6 — Evidências finais | REF-13–14 | Regressão validada e comparação as-is/to-be | 10 h |
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
