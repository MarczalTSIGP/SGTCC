# REF-14 — Métricas as-is/to-be e avaliação dos resultados

**Data da coleta:** 2026-09-13
**Ruby:** 3.4.7 · **Rails:** 8.1.3
**as-is:** commit `779272b6` (baseline da REF-00) · **to-be:** commit `f3140bbb`
**Ambiente:** container `tests` do `docker-compose.yml`, mesmas versões de ferramenta nas duas coletas

## Nota metodológica

A coleta da REF-00 rodou fora do Docker e não conseguiu executar RSpec nem SimpleCov. Para tornar a comparação defensável, as métricas estáticas do as-is foram **recoletadas** nesta task, sobre um worktree do commit de baseline, no mesmo container e com as mesmas versões usadas no to-be.

A recoleta **reproduziu exatamente** os números publicados pela REF-00:

| Métrica | REF-00 publicado | Recoletado na REF-14 | Confere |
|---|---:|---:|:--:|
| Flog total | 8226,8 | 8226,8 | sim |
| Flog/método | 5,8 | 5,8 | sim |
| Flay score | 9098 | 9098 | sim |
| Reek warnings | 690 | 690 | sim |
| RubyCritic score | 85,91 | 85,91 | sim |

Isso valida tanto o documento de baseline quanto o ambiente desta coleta. RuboCop e Brakeman não foram recoletados sobre o worktree: o baseline publicado já registrava 0 offenses e 0 alertas, e o to-be também, então não há delta a apurar.

---

## 1. Tabela as-is/to-be

| Métrica | as-is | to-be (REF-14) | to-be (REF-18) | Δ total | Δ % total |
|---|---:|---:|---:|---:|---:|
| RuboCop — offenses | 0 | 0 | 0 | 0 | — |
| RuboCop — arquivos inspecionados | 782 | 813 | 816 | +34 | +4,3% |
| Reek — warnings | 690 | 716 | 714 | +24 | +3,5% |
| Brakeman — alertas de segurança | 0 | 0 | 0 | 0 | — |
| Brakeman — templates | 401 | 395 * | 395 | −6 | −1,5% |
| Flog — total | 8226,8 | 8263,3 | **8225,3** | −1,5 | −0,02% |
| Flog — média por método | 5,8 | 5,6 | 5,6 | −0,2 | −3,4% |
| Flay — score de duplicação | 9098 | 8627 | **8431** | −667 | −7,3% |
| Flay — blocos similares | 119 | 119 | **116** | −3 | −2,5% |
| RubyCritic — nota global | 85,91 | 86,24 | **86,46** | +0,55 | +0,6% |
| SimpleCov — cobertura | não coletável | 96,18% | 96,28% | — | — |
| ERB Lint — offenses | não executável | 2013 | 2013 | — | — |

\* **Correção de um número da primeira medição.** A coluna to-be da REF-14 publicou 399 templates. Esse valor tinha sido coletado durante a REF-13, **antes** de a REF-13A remover quatro views órfãs, e foi reaproveitado por engano na tabela da REF-14. O valor correto para o commit que a REF-14 mediu (`f3140bbb`) é **395**, o mesmo de agora — confirmado por contagem de arquivos `.erb`, idêntica entre `HEAD` e o estado atual. A conclusão qualitativa não muda; o número, sim.

A coluna "to-be (REF-18)" mede `f3140bbb` acrescido das REF-15, REF-16 e REF-17.

---

## 2. Complexidade dos pontos críticos apontados pela REF-01

Flog por método, as-is → to-be:

| Método | as-is | to-be | Δ % |
|---|---:|---:|---:|
| `Responsible::OrientationsController#tcc_one` | 26,2 | 14,3 | **−45,4%** |
| `Responsible::OrientationsController#tcc_two` | 25,0 | 14,3 | **−42,8%** |
| `Responsible::OrientationsController#current_tcc_one` | 15,5 | 8,0 | **−48,4%** |
| `Responsible::OrientationsController#current_tcc_two` | 15,5 | 8,0 | **−48,4%** |
| `Dashboard::ResponsibleReport#orientations_by_tcc_one` | 22,4 | 17,2 | −23,2% |
| `Dashboard::ProfessorReport#orientations_by_tcc_one` | 24,2 | 19,0 | −21,5% |
| `ExaminationBoard` (corpo da classe) | 115,0 | 97,7 | −15,0% |
| `Orientation` (corpo da classe) | 99,9 | 125,3 → **89,3** na REF-18 | **+25,4% → −10,6%** |

Os quatro métodos de listagem do controller mais crítico do inventário caíram entre 43% e 48%. `ExaminationBoard` saiu do topo da lista de complexidade, onde estava no baseline.

---

## 3. Estrutura

### Tamanho dos arquivos centrais

| Arquivo | as-is | to-be | Δ % |
|---|---:|---:|---:|
| `app/models/calendar.rb` | 147 | 80 | **−45,6%** |
| `app/models/examination_board.rb` | 232 | 178 | **−23,3%** |
| `app/controllers/responsible/examination_boards_controller.rb` | 235 | 224 | −4,7% |
| `app/controllers/responsible/orientations_controller.rb` | 172 | 168 | −2,3% |
| `app/models/document.rb` | 143 | 142 | −0,7% |
| `app/models/orientation.rb` | 295 | 293 | −0,7% |
| `app/controllers/professors/orientations_controller.rb` | 126 | 127 | +0,8% |
| `app/controllers/tcc_one_professors/examination_boards_controller.rb` | 141 | 146 | +3,5% |

Linha de código é uma métrica fraca aqui: os controllers quase não encolheram em linhas, mas caíram quase pela metade em complexidade. O que saiu foi a construção da consulta; o que entrou foi a chamada ao objeto que a encapsula.

### Distribuição de responsabilidade

| Diretório | as-is | to-be | Δ |
|---|---:|---:|---:|
| `app/services` | 28 | 44 | **+16** |
| `app/models/concerns` | 28 | 22 | −6 |
| `app/components` | 15 | 17 | +2 |
| `app/controllers` | 78 | 78 | 0 |

### Lógica de consulta nos controllers

Arquivos de controller que montam busca paginada diretamente (`.search(params[:term])`):

| | as-is | to-be |
|---|---:|---:|
| Arquivos | 15 | 9 |
| Desses, listagens de orientação/supervisão | 6 | **0** |

Os nove restantes no to-be são CRUDs simples (instituições, páginas, imagens, professores, acadêmicos, membros externos, documentos anexos, bancas de dois perfis) — nenhum deles é listagem de orientação, que era o alvo do roadmap.

---

## 4. Alteração controlada

**Mudança aplicada:** adicionar um critério de busca — filtro por instituição — a todas as listagens de orientações e supervisões, nos dois estados do código. A alteração foi aplicada, medida e **revertida**; não faz parte do projeto.

| Indicador | as-is | to-be | Comentário |
|---|---:|---:|---|
| Arquivos tocados | 7 | 9 | **a favor do as-is** |
| Hunks | 13 | 15 | **a favor do as-is** |
| Linhas +/− | +33 / −15 | +44 / −19 | **a favor do as-is** |
| Implementações distintas do filtro | **7** | **3** | a favor do to-be |
| Implementações dentro de controller | **6** | **0** | a favor do to-be |
| Linhas citando `params[:institution_id]` | 15 | 9 | a favor do to-be |
| Forma de repasse | posicional | keyword | a favor do to-be |

### Interpretação honesta

Pela contagem bruta de arquivos e linhas, **a alteração no código refatorado é maior**. Isso não é ruído de medição: as consultas moram em arquivos próprios, então o que antes era uma linha dentro do controller virou uma edição no service mais o repasse do parâmetro no controller.

O que muda a favor da refatoração é **onde** a lógica precisou ser escrita:

- No as-is, a mesma regra de filtro foi escrita **sete vezes**, em seis idiomas diferentes — `@orientations = @orientations.where(...)` em quatro ações, um hash `condition[...]` em um helper, um `data = data.where(...)` em outro, e um parâmetro novo atravessando quatro assinaturas posicionais de `OrientationFilter`. Seis dessas sete implementações leem `params` dentro do controller.
- No to-be, a regra foi escrita **três vezes**, uma por query object, cada uma como método nomeado (`institution_filtered`). Os seis controllers só repassam `institution_id: params[:institution_id]`, uma edição mecânica e idêntica em todos.

O risco que isso remove é de divergência: no as-is, esquecer uma das sete implementações produz uma tela que ignora o filtro, silenciosamente. No to-be, esquecer o repasse em um controller produz o mesmo sintoma, mas a regra em si continua única.

### Sobre tempo de execução

O roadmap pedia registrar o tempo da alteração. As duas execuções foram feitas por um agente, não por uma pessoa, e os tempos medidos (~1 min as-is, ~1,5 min to-be) **não** são comparáveis ao esforço humano nem devem ser usados como evidência — o gargalo real é entender onde mexer, não digitar. Os indicadores estruturais da tabela acima substituem esse número.

### Defeito preexistente encontrado durante o experimento

`Tcc_one_professors::OrientationsController#by_calendar` passa `page: params[:status]` para a query — o status entra onde deveria entrar a página. O mesmo defeito existe no baseline, em outra forma: `by_tcc_one(params[:status], params[:term])` contra a assinatura `(page, term, status)`. É exatamente a classe de erro que parâmetro posicional favorece e que keyword argument impede. **Registrado, não corrigido** — está fora do escopo desta task.

---

## 5. Melhorias, neutros e pioras

### Melhorias

- **Duplicação**: Flay −5,2% na REF-14 e **−7,3% na REF-18**, quando o número de blocos similares finalmente caiu (119 → 116) — a deduplicação dos scopes e dos acessores de atividade acadêmica eliminou focos inteiros, não só massa.
- **Complexidade por método**: Flog médio −3,4%, e −43% a −48% nos quatro métodos de listagem do controller mais crítico do inventário.
- **Models centrais**: `Calendar` −45,6% e `ExaminationBoard` −23,3% em linhas; `ExaminationBoard` também caiu 15% em complexidade e deixou de ser o arquivo mais complexo do projeto.
- **Lógica de consulta fora do HTTP**: nenhuma listagem de orientação monta consulta no controller, contra seis no baseline.
- **Cobertura mensurável**: 96,18%, métrica que simplesmente não existia antes.

### Neutros

- RuboCop (0 → 0) e Brakeman (0 → 0): o projeto já estava em conformidade e continua.
- ~~Flay em número de blocos (119 → 119)~~ — deixou de ser neutro na REF-18: **116 blocos**, três focos a menos.
- Flog total (8226,8 → 8263,3 → **8225,3**): depois da segunda rodada, a complexidade total voltou a ficar marginalmente **abaixo** do baseline. Continua sendo um resultado neutro: o que mudou de verdade é a distribuição, não o volume.
- Flog total (+0,4%): a complexidade não foi eliminada, foi redistribuída em mais métodos menores. É isso que o total estável somado à média em queda significa.
- Contagem de controllers (78 → 78): nenhuma camada HTTP nova foi criada.

### Pioras

- **Reek +26 warnings (+3,8%).** A decomposição por tipo, agora disponível para os dois estados, mostra de onde vem:

| Smell | as-is | to-be | Δ |
|---|---:|---:|---:|
| IrresponsibleModule | 224 | 237 | **+13** |
| UtilityFunction | 65 | 74 | **+9** |
| TooManyInstanceVariables | 31 | 35 | +4 |
| LongParameterList | 5 | 9 | +4 |
| FeatureEnvy | 30 | 32 | +2 |
| NilCheck | 14 | 16 | +2 |
| ControlParameter | 10 | 12 | +2 |
| TooManyMethods | 9 | 10 | +1 |
| RepeatedConditional | 4 | 5 | +1 |
| BooleanParameter | 3 | 4 | +1 |
| UncommunicativeVariableName | 17 | 15 | −2 |
| TooManyStatements | 41 | 40 | −1 |
| InstanceVariableAssumption | 136 | 132 | −4 |
| DuplicateMethodCall | 77 | 71 | **−6** |
| Demais tipos (sem variação) | 24 | 24 | 0 |
| **Total** | **690** | **716** | **+26** |

  `IrresponsibleModule` é ausência de comentário de classe: 16 services novos produzem 16 classes novas, e o smell cresce por construção. `UtilityFunction` e `LongParameterList` sobem pelo mesmo motivo — métodos de consulta isolados que não dependem de estado de instância e recebem parâmetros explícitos. Ou seja, **+26 é o preço contábil de extrair objetos**, não sinal de degradação. O contraponto está nos dois smells que caem, `DuplicateMethodCall` (−6) e `InstanceVariableAssumption` (−4), que são justamente os que medem controller e view inchados.

  Ainda assim, **o número piorou** e a métrica não distingue as duas coisas sozinha. Registrado como está.

  **Atualização da REF-18:** após a segunda rodada o total caiu de 716 para **714**, ainda +24 sobre o baseline. A variação de −2 se decompõe integralmente:

  | Smell | REF-14 | REF-18 | Δ | Origem |
  |---|---:|---:|---:|---|
  | NilCheck | 16 | 14 | −2 | remoção de `reproved`/`reproved_tcc_one` (REF-16) |
  | UncommunicativeVariableName | 15 | 13 | −2 | mesmos dois métodos, que usavam a variável `o` |
  | RepeatedConditional | 5 | 4 | −1 | deduplicação dos scopes (REF-15) |
  | LongParameterList | 9 | 10 | **+1** | `Orientation.by_tcc_period`, com 4 parâmetros (REF-15) |
  | BooleanParameter | 4 | 6 | **+2** | `AcademicActivityFinder`, com `final_version:` (REF-17) |

  Os três warnings novos foram **introduzidos pela própria segunda rodada** e estão registrados como tal. São o preço de parametrizar a consulta em vez de duplicá-la: o `final_version:` é um booleano legítimo na API do finder, e os quatro parâmetros de `by_tcc_period` substituem quatro scopes duplicados.

- ~~**`Orientation` ficou 25,4% mais complexo no corpo da classe** (99,9 → 125,3)~~ — **revertido pela REF-15** (ver atualização ao final desta seção). O diagnóstico original, mantido abaixo por ser o que orientou a correção: `Orientation` ficou 25,4% mais complexo no corpo da classe (99,9 → 125,3), apesar de ser um dos alvos da REF-06. A causa é rastreável: o baseline incluía cinco concerns (`OrientationFilter`, `OrientationJoin`, `OrientationOption`, `OrientationTcoTcai`, `OrientationReport`) e os scopes apenas delegavam a métodos deles (`join_with_status_by_tcc('one', ...)`). A refatoração removeu os concerns e **inlinou as condições** nos scopes, que passaram a montar `joins`/`where` explicitamente. O total do arquivo mal mudou (254,5 → 259,4) e cinco concerns sumiram, mas a consulta ficou concentrada no corpo da classe, com `tcc_one`/`tcc_two` e `current_tcc_one`/`current_tcc_two` quase idênticos entre si. **É uma troca, não um ganho**: menos indireção, mais duplicação local. `Orientation` continua sendo o candidato mais forte a uma próxima rodada.

- ~~**`app/models/orientation.rb` praticamente não encolheu** (295 → 293 linhas)~~ — **corrigido pela segunda rodada**: 268 linhas, −8,5% sobre a REF-14 e −9,2% sobre o baseline.

### Atualização da REF-18 — o que a segunda rodada fez com as duas pioras

| Indicador | baseline | REF-14 | REF-18 | Situação |
|---|---:|---:|---:|---|
| `Orientation#none` (corpo da classe) | 99,9 | 125,3 | **89,3** | **revertido e abaixo do baseline** (−10,6%) |
| Flog total de `orientation.rb` | — | 259,4 | **197,6** | −23,8% |
| Linhas de `orientation.rb` | 295 | 293 | **268** | −8,5% |
| Reek total | 690 | 716 | **714** | atenuado, ainda +24 |

`Orientation` deixou de ser o arquivo mais complexo do projeto por corpo de classe — hoje está atrás de `ExaminationBoard` (97,7). A piora medida pela REF-14 **foi revertida**; a do Reek **foi apenas atenuada**, e com três warnings novos introduzidos pela própria correção.

---

## 6. Relação com os objetivos do TCC

| Objetivo | Evidência | Resultado |
|---|---|---|
| Reduzir acoplamento entre camadas, tirando regra de consulta da camada HTTP | Nenhuma listagem de orientação monta consulta no controller (6 → 0); 16 services novos; métodos de listagem 43–48% menos complexos | **atingido** |
| Reduzir duplicação | Flay −5,2%; três templates de assinatura e dois formulários de banca consolidados; seis listagens de documento sob um component | **atingido parcialmente** — a massa caiu, o número de focos (119 blocos) não |
| Aumentar coesão dos models centrais | `Calendar` −45,6%, `ExaminationBoard` −23,3% | **atingido para `Calendar` e `ExaminationBoard`, não para `Orientation`** |
| Preservar comportamento | REF-13: 1121 exemplos e 0 falhas, cinco blocos e seis fluxos críticos validados; hoje 1137 exemplos, 0 falhas | **atingido** |
| Facilitar evolução | Alteração controlada: 7 → 3 implementações da regra, 6 → 0 dentro de controller, posicional → keyword | **atingido em estrutura**, não em volume de edição |

---

## 7. Limites desta avaliação

- **Métricas estáticas são evidência complementar.** Reek subiu enquanto a arquitetura melhorou; Flog total ficou estável enquanto a complexidade por método caiu. Nenhum desses números, isolado, sustenta uma conclusão.
- **Não há cobertura as-is.** Os 96,18% de hoje não têm par de comparação — o SimpleCov estava desativado desde antes do baseline.
- **A alteração controlada teve uma única amostra por estado**, executada por um agente com conhecimento prévio das duas bases. Ela ilustra a estrutura, não mede produtividade.
- **O churn do RubyCritic é contaminado**: as refatorações do próprio roadmap elevaram o churn dos arquivos tocados, o que penaliza a nota to-be por um motivo que não é qualidade de código.
- **Não houve homologação manual nem revisão por pares** (pendência registrada desde a REF-13).

---

## 8. Conclusão

*Revisada pela REF-18, após a segunda rodada de coesão.*

O roadmap atingiu o que se propôs no eixo principal: a regra de consulta saiu da camada HTTP, os models mais críticos ficaram menores e a duplicação de apresentação caiu, tudo sem regressão funcional conhecida — hoje 1153 exemplos verdes e 96,28% de cobertura.

Das duas pioras que a primeira medição registrou, **uma foi revertida e a outra apenas atenuada**:

- a complexidade do corpo de `Orientation` voltou de 125,3 para 89,3, **abaixo dos 99,9 do baseline**, e o arquivo encolheu de 295 para 268 linhas. A dívida que a REF-14 apontou como "o próximo alvo com clareza" foi efetivamente paga;
- o Reek caiu de 716 para 714, ainda **+24 sobre o baseline**. A segunda rodada removeu 5 warnings e **introduziu 3 novos**, vindos das próprias abstrações criadas (um `LongParameterList` e dois `BooleanParameter`). O saldo continua negativo nessa métrica.

Isso reforça a leitura metodológica do trabalho: métricas estáticas penalizam a extração de objetos por construção, e por isso não servem como juiz isolado de qualidade arquitetural. Flog total terminou praticamente idêntico ao baseline (8225,3 contra 8226,8) enquanto a média por método caiu 3,4% — o volume de complexidade não mudou, a distribuição sim.

O ganho mais defensável continua não estando em nenhuma métrica isolada, e sim na alteração controlada: a mesma regra de negócio que antes precisava ser escrita sete vezes, seis delas dentro de controllers, hoje é escrita três vezes, nenhuma delas na camada HTTP.
