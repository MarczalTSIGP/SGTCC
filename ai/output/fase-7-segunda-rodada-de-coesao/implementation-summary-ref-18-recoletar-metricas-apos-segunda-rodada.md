# REF-18 — Resumo de implementação

## Resumo

Recoletado apenas o lado to-be das métricas, sobre `f3140bbb` acrescido das REF-15, REF-16 e REF-17. O baseline **não** foi recoletado: o commit de referência não mudou e a REF-14 já validou aqueles números. A comparação em `metricas-as-is-to-be-ref-14.md` ganhou uma terceira coluna, sem apagar a primeira medição.

## Respostas às perguntas da task

### A complexidade do corpo de `Orientation` caiu abaixo dos 125,3? Voltou ao patamar do baseline?

**Sim para as duas.** `Orientation#none` está em **89,3** — abaixo dos 125,3 da REF-14 (−28,8%) e também abaixo dos **99,9 do baseline** (−10,6%).

`Orientation` deixou de ser o corpo de classe mais complexo do projeto: hoje aparece em segundo, atrás de `ExaminationBoard` (97,7). Na REF-14 era o primeiro.

| Indicador de `orientation.rb` | baseline | REF-14 | REF-18 |
|---|---:|---:|---:|
| Corpo da classe (`#none`) | 99,9 | 125,3 | **89,3** |
| Flog total do arquivo | — | 259,4 | **197,6** |
| Linhas | 295 | 293 | **268** |

### O total do Reek caiu? Qual smell explica a variação?

Caiu de 716 para **714** — ainda **+24 sobre o baseline de 690**. A variação de −2 se decompõe integralmente, sem resto:

| Smell | REF-14 | REF-18 | Δ | Origem |
|---|---:|---:|---:|---|
| NilCheck | 16 | 14 | −2 | remoção de `reproved`/`reproved_tcc_one` (REF-16) |
| UncommunicativeVariableName | 15 | 13 | −2 | os mesmos dois métodos, que usavam a variável `o` |
| RepeatedConditional | 5 | 4 | −1 | deduplicação dos scopes (REF-15) |
| LongParameterList | 9 | 10 | **+1** | `Orientation.by_tcc_period`, 4 parâmetros (REF-15) |
| BooleanParameter | 4 | 6 | **+2** | `AcademicActivityFinder`, `final_version:` (REF-17) |
| **Total** | **716** | **714** | **−2** | |

**Três dos warnings foram introduzidos pela própria segunda rodada.** Isso está registrado como está: são o custo de parametrizar a consulta em vez de duplicá-la. Nenhum outro tipo de smell variou.

### Flay, Flog médio e RubyCritic: melhoraram, pioraram ou ficaram neutros?

| Métrica | baseline | REF-14 | REF-18 | Situação |
|---|---:|---:|---:|---|
| Flay — score | 9098 | 8627 | **8431** | melhorou (−7,3% sobre o baseline) |
| Flay — blocos similares | 119 | 119 | **116** | **deixou de ser neutro** — três focos a menos |
| Flog — total | 8226,8 | 8263,3 | **8225,3** | voltou a ficar marginalmente abaixo do baseline |
| Flog — média por método | 5,8 | 5,6 | 5,6 | estável, mantém −3,4% |
| RubyCritic | 85,91 | 86,24 | **86,46** | melhora marginal, continua dentro do ruído |
| RuboCop | 0 offenses | 0 | 0 | neutro |
| Brakeman | 0 alertas | 0 | 0 | neutro |
| Cobertura | não coletável | 96,18% | **96,28%** | sem par de comparação |
| ERB Lint | não executável | 2013 | 2013 | inalterado |

O dado mais relevante aqui é o **número de blocos do Flay**: na REF-14 a massa duplicada caiu mas a quantidade de focos não se moveu (119 → 119), o que eu havia registrado como resultado neutro. A segunda rodada eliminou três focos inteiros.

## Correção de um número da REF-14

A tabela da REF-14 publicou **399 templates** do Brakeman na coluna to-be. Esse valor tinha sido coletado durante a **REF-13**, antes de a REF-13A remover quatro views órfãs, e foi reaproveitado por engano.

O valor correto para o commit que a REF-14 mediu é **395** — o mesmo de agora. Confirmado por contagem de arquivos `.erb` em `app/views`, **idêntica entre `HEAD` e o estado atual** (386 arquivos), já que nenhuma das tasks da segunda rodada tocou em views.

A conclusão qualitativa não muda (a queda de templates vem das views duplicadas removidas pelas REF-12 e REF-13A), mas o número estava errado e foi corrigido na tabela, com a nota explicando a origem do erro.

## Revisão das seções da REF-14

- **Pioras**: a de `Orientation` está marcada como **revertida**, com o diagnóstico original preservado por ter sido o que orientou a correção. A do Reek está marcada como **apenas atenuada**, com os três warnings novos atribuídos às tasks que os criaram.
- **Neutros**: o item "Flay em número de blocos" deixou de ser neutro; foi acrescentado o Flog total, que voltou a ficar abaixo do baseline.
- **Conclusão**: reescrita para dizer, com número, que uma piora foi revertida e a outra não, e para reforçar a leitura metodológica — métricas estáticas penalizam extração de objetos por construção.

## Estado medido

- `HEAD` = `f3140bbb` (task 13a-13d) mais as REF-15, REF-16 e REF-17 ainda **não commitadas** no working tree.
- Suíte: **1153 exemplos, 0 falhas, 1 pendente**.
- RuboCop: **816 arquivos, 0 offenses**.

## Limites preservados

- Nenhum código de produção, spec ou configuração alterado por esta task.
- Nada corrigido a partir da coleta.
- Baseline não recoletado.
- Nenhum commit, push ou branch criado.
