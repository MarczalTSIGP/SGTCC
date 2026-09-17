# Refatoração do SGTCC — resumo das implementações e comparação antes/depois

**Data:** 2026-09-17 · **Ruby** 3.4.7 · **Rails** 8.1.3
**as-is:** commit `779272b6` (baseline da REF-00, coletado em 2026-08-11)
**to-be final:** commit `5e9033bb` (task 24)
**Ambiente:** container `tests` do `docker-compose.yml`, mesmas versões de ferramenta nas duas coletas

O roadmap previa 29 tasks em 10 fases. Todas foram executadas. Este documento
resume o que cada fase entregou e compara o estado inicial com o final, usando
as quatro coletas de métrica feitas ao longo do trabalho: o baseline (REF-00),
a primeira medição to-be (REF-14), a recoleta após a segunda rodada (REF-18) e
esta, feita depois das fases 8 e 9.

---

## 1. O que foi implementado

### Fase 0 — Baseline e inventário (REF-00, REF-01)

Ferramentas de medição adicionadas ao projeto (RubyCritic, Flog, Flay) e o
estado inicial arquivado de forma reproduzível. O inventário classificou os
achados por impacto × complexidade e, principalmente, separou **dívida
comprovada de abstração hipotética** — foi ele que dirigiu todas as fases
seguintes, inclusive para dizer o que **não** deveria ser mexido.

### Fases 1 e 2 — Dados de domínio e controllers (REF-02 a REF-05)

Os enums `tcc` e `semester` passaram a ser usados pela API do enum, sem literais
`1`/`2` espalhados, preservando os valores persistidos. A busca de orientações do
responsável saiu das actions e virou query object com parâmetros nomeados; os
controllers mais críticos deixaram de montar consulta.

Nesse caminho foi descartada uma extração abandonada (`Orientation.tcc_one`,
`OrientationFilter.by_tcc_one`) que **não era equivalente** ao código ativo — o
scope trazia qualquer orientação de TCC I, a query do controller trazia só as que
ainda não avançaram para TCC II.

### Fase 3 — Models, concerns e serviços (REF-06 a REF-08)

Responsabilidades de `Orientation`, `ExaminationBoard`, `Document` e `Signature`
redistribuídas; contratos dos services padronizados; TODOs resolvidos e código
comentado removidos.

### Fase 4 — `Calendar` (REF-09, REF-10)

Navegação entre períodos acadêmicos centralizada e consultas/relatórios retirados
do model. `Calendar` caiu de 147 para 80 linhas, a maior redução de arquivo do
roadmap.

### Fase 5 — Apresentação (REF-11, REF-12)

Inventário de partials repetidos e extração só dos candidatos que se pagavam. A
REF-11 é a task que mais **evitou** trabalho: registrou repetições que não
justificavam component.

### Fase 6 — Validação e avaliação (REF-13 a REF-14, com 13A–13D)

Homologação por bloco, remoção de código morto de apresentação e roteamento,
desacoplamento das comparações de status em relação ao locale (risco nº 1 do
inventário), unificação do mapeamento de badge e **reativação do SimpleCov e do
ERB Lint**, que estavam desligados por configuração. A REF-14 produziu a primeira
comparação as-is/to-be.

### Fase 7 — Segunda rodada de coesão (REF-15 a REF-18)

Provocada pela própria medição: a REF-14 mostrou que `Orientation` tinha
**piorado** (99,9 → 125,3 de Flog). A REF-15 deduplicou os scopes de período, a
REF-16 removeu código morto e a REF-17 unificou os acessores de atividade
acadêmica. A REF-18 remediu e confirmou a reversão (89,3).

### Fase 8 — Dívidas registradas (REF-19 a REF-22)

- **REF-19** — N+1 em listagem pública sem autenticação: de `1 + 2N` consultas
  para 1, constante. Com 50 orientações aprovadas, de 101 consultas para 1.
- **REF-20** — TEP e TSO passam a compartilhar o esqueleto de CRUD e a listagem,
  mantendo formulário e `show` separados, que é diferença de domínio.
- **REF-21** — a dependência de ordem nos specs era um `before(:suite)` que criava
  calendários **depois** da truncação do DatabaseCleaner.
- **REF-22** — ERB Lint de 2006 para 758 offenses, com `Rails/LinkToBlank`
  corrigido em 21 pontos.

### Fase 9 — Subsistemas não cobertos (REF-23, REF-24)

- **REF-23** — notificações, a única área que atravessou o roadmap inteiro sem
  nunca ser alvo. Cobertura do hook de atividade de 62,86% para 100%.
- **REF-24** — `ExaminationBoard` deduplicado com a receita da REF-15: corpo da
  classe de 97,7 para 60,6.

---

## 2. Comparação antes/depois

| Métrica | as-is | REF-14 | REF-18 | **final** | Δ total |
|---|---:|---:|---:|---:|---:|
| RuboCop — offenses | 0 | 0 | 0 | **0** | 0 |
| RuboCop — arquivos inspecionados | 782 | 813 | 816 | **819** | +37 |
| Brakeman — alertas de segurança | 0 | 0 | 0 | **0** | 0 |
| Brakeman — templates | 401 | 395 | 395 | **391** | −10 |
| Reek — warnings | 690 | 716 | 714 | **712** | **+22** |
| Flog — total | 8226,8 | 8263,3 | 8225,3 | **8208,3** | −18,5 |
| Flog — média por método | 5,8 | 5,6 | 5,6 | **5,5** | **−5,2%** |
| Flay — score de duplicação | 9098 | 8627 | 8431 | **8235** | **−9,5%** |
| Flay — blocos similares | 119 | 119 | 116 | **114** | −5 |
| RubyCritic — nota global | 85,91 | 86,24 | 86,46 | **86,74** | +0,83 |
| SimpleCov — cobertura | não coletável | 96,18% | 96,28% | **96,65%** | — |
| ERB Lint — offenses | não executável | 2013 | 2013 | **758** | **−62,3%** |
| RSpec — exemplos | não executável | — | 1153 | **1183** | — |
| RSpec — falhas | não executável | 0 | 0 | **0** | — |

Duas das linhas mais importantes não têm coluna "antes": **cobertura e ERB Lint
não eram mensuráveis no baseline**. A configuração do SimpleCov estava comentada
e o ERB Lint não rodava por configuração obsoleta. A REF-13D religou as duas —
passar a ter o número é, em si, parte do resultado.

### Complexidade dos pontos críticos

| Alvo | as-is | final | Δ |
|---|---:|---:|---:|
| `ExaminationBoard` — corpo da classe | 115,0 | **60,6** | **−47,3%** |
| `Orientation` — corpo da classe | 99,9 | **91,3** | −8,6% |
| `Responsible::OrientationsController#tcc_one` | 26,2 | 14,3 | −45,4% |
| `Responsible::OrientationsController#tcc_two` | 25,0 | 14,3 | −42,8% |
| `Responsible::OrientationsController#current_tcc_one` | 15,5 | 8,0 | −48,4% |
| `Dashboard::ProfessorReport#orientations_by_tcc_one` | 24,2 | 19,0 | −21,5% |

`ExaminationBoard` era o corpo de classe mais complexo do projeto no baseline e
caiu quase pela metade. `Orientation` fez uma curva: piorou na primeira rodada
(125,3), foi revertido pela REF-15 (89,3) e subiu 2 pontos na REF-19, que
acrescentou a forma relacional da regra de atividade final — chegando a 91,3,
ainda abaixo do baseline.

### Tamanho dos arquivos centrais

| Arquivo | as-is | final | Δ |
|---|---:|---:|---:|
| `app/models/calendar.rb` | 147 | **80** | −45,6% |
| `app/models/examination_board.rb` | 232 | **177** | −23,7% |
| `app/models/orientation.rb` | 295 | **277** | −6,1% |
| `app/models/document.rb` | 143 | 142 | −0,7% |
| `responsible/examination_boards_controller.rb` | 235 | 224 | −4,7% |
| `responsible/orientations_controller.rb` | 172 | 168 | −2,3% |

### Distribuição de responsabilidade

| Diretório | as-is | final | Δ |
|---|---:|---:|---:|
| `app/services` | 28 | **45** | +17 |
| `app/models/concerns` | 28 | **22** | −6 |
| `app/components` | 15 | 17 | +2 |
| `app/controllers` | 78 | 79 | +1 |

Nenhuma camada HTTP nova foi criada. O que cresceu foi a camada onde consulta e
regra passaram a morar.

---

## 3. Leitura honesta dos números

### O que melhorou

- **Duplicação** é o resultado mais sólido: Flay −9,5% em massa e cinco focos a
  menos. Não é só volume — blocos inteiros deixaram de existir.
- **Complexidade por método** caiu 5,2% na média e entre 21% e 48% nos métodos
  que o inventário tinha apontado como críticos.
- **Nenhuma listagem de orientação monta consulta no controller**, contra seis no
  baseline.
- **ERB Lint −62,3%**, com as 21 ocorrências de `Rails/LinkToBlank` — as únicas
  com efeito além de estilo — corrigidas.
- **Cobertura de 96,65%**, métrica que não existia antes.

### O que é neutro

- **Flog total praticamente igual** (8226,8 → 8208,3, −0,2%). A complexidade não
  foi eliminada, foi redistribuída em mais métodos menores. Total estável somado
  a média em queda é exatamente isso.
- **RuboCop e Brakeman em zero** nos dois estados: o projeto já estava em
  conformidade e continua.
- **RubyCritic +0,83 ponto**, dentro do ruído.

### O que piorou

**Reek: +22 warnings (+3,2%).** A decomposição mostra que a piora é contábil:

| Smell | as-is | final | Δ |
|---|---:|---:|---:|
| IrresponsibleModule | 224 | 237 | **+13** |
| UtilityFunction | 65 | 76 | **+11** |
| TooManyInstanceVariables | 31 | 35 | +4 |
| LongParameterList | 5 | 10 | +5 |
| BooleanParameter | 3 | 7 | +4 |
| TooManyMethods | 9 | 11 | +2 |
| ControlParameter | 10 | 12 | +2 |
| FeatureEnvy | 30 | 31 | +1 |
| UncommunicativeVariableName | 17 | 12 | −5 |
| InstanceVariableAssumption | 136 | 131 | −5 |
| TooManyStatements | 41 | 39 | −2 |
| **DuplicateMethodCall** | 77 | **69** | **−8** |
| **Total** | **690** | **712** | **+22** |

`IrresponsibleModule` é ausência de comentário de classe: 17 services novos
produzem 17 classes novas e o smell cresce por construção. `UtilityFunction`,
`LongParameterList` e `BooleanParameter` sobem pelo mesmo motivo — métodos de
consulta isolados, que não dependem de estado de instância e recebem parâmetros
explícitos.

O contraponto está nos que caem: `DuplicateMethodCall` (−8) e
`InstanceVariableAssumption` (−5) são justamente os que medem controller e view
inchados.

**A conclusão metodológica é essa:** métricas estáticas de smell penalizam
extração de objeto por construção. Elas medem quantidade de unidades, e extrair
cria unidades. Isso não isenta o número — ele piorou e está registrado —, mas
explica por que a mesma refatoração melhora Flay e Flog médio e piora Reek.

---

## 4. Verificação de comportamento

O roadmap exigia preservar comportamento. Além da suíte (1183 exemplos, 0 falhas
em todas as tasks), três tasks usaram comprovação direta:

- **REF-15 e REF-24** — captura do `to_sql` dos scopes antes e depois, em três
  cenários e com encadeamento; diff vazio nas duas.
- **REF-20** — comparação byte a byte do HTML das seis páginas afetadas: quatro
  idênticas, duas diferindo apenas em linhas em branco no fim do arquivo.
- **REF-19, REF-23 e REF-24** — validação por mutação dos specs novos, para
  confirmar que a cobertura acrescentada de fato pega o erro que diz pegar.

---

## 5. O que fica em aberto

Achados registrados ao longo do trabalho que **não** viraram task e que o roadmap
não cobre:

| Achado | Origem |
|---|---|
| `Responsible::ExaminationBoardsController`, 16 warnings do Reek, pior controller do projeto | REF-24 |
| 10 offenses de `ErbSafety` (`raw`/`html_safe`), que pedem análise de segurança | REF-22 |
| A suíte não passa com `--order random` (2 falhas preexistentes) | REF-21 |
| `show.html.erb` de TEP e TSO é código morto (rotas declaram `except: :show`) | REF-20 |
| O `update` do TSO anuncia sucesso sem verificar o retorno do `save` | REF-20 |
| `Style/StringLiterals` (373) e `Style/SingleArgumentDig` (27) no ERB Lint | REF-22 |
| Fallback inalcançável e `.distinct` inerte em `ExaminationBoard` | REF-24 |
| `Orientation.approved` devolve Array enquanto `in_tcc_one` devolve relation | REF-19 |
| `Notifications::SchedulerService` estoura com `NoMethodError` se `Time.zone.parse` devolver `nil` | REF-23 |

Nenhum deles é regressão introduzida pela refatoração: são defeitos preexistentes
ou decisões conscientes de escopo, cada um registrado no relatório da task que o
encontrou.
