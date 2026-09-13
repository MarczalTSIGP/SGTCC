# REF-14 — Resumo de implementação

## Resumo

Task de medição e interpretação. As métricas to-be foram coletadas, as métricas as-is foram **recoletadas** sobre o commit de baseline no mesmo ambiente, e a comparação está em `metricas-as-is-to-be-ref-14.md`. Nenhum código de produção foi alterado por esta task.

## O que foi feito

1. **Coleta to-be** sobre `f3140bbb`: RuboCop, Reek, Brakeman, Flog, Flay, RubyCritic, SimpleCov e ERB Lint.
2. **Recoleta as-is** em um worktree de `779272b6`, com as mesmas versões de ferramenta. A recoleta reproduziu **exatamente** os cinco números publicados pela REF-00 (Flog 8226,8 / 5,8; Flay 9098; Reek 690; RubyCritic 85,91), validando o baseline e o ambiente.
3. **Contagem estrutural**: tamanho dos arquivos centrais, distribuição por diretório e pontos de montagem de consulta nos controllers.
4. **Alteração controlada**: filtro por instituição em todas as listagens de orientação, aplicada nos dois estados, medida e revertida.
5. **Interpretação** ligada aos objetivos do TCC, com limites do método declarados.

## Resultado resumido

| Métrica | as-is | to-be | Δ |
|---|---:|---:|---:|
| RuboCop offenses | 0 | 0 | 0 |
| Reek warnings | 690 | 716 | +26 |
| Brakeman alertas | 0 | 0 | 0 |
| Flog total | 8226,8 | 8263,3 | +0,4% |
| Flog média/método | 5,8 | 5,6 | −3,4% |
| Flay score | 9098 | 8627 | −5,2% |
| RubyCritic | 85,91 | 86,24 | +0,4% |
| Cobertura | não coletável | 96,18% | — |

Destaques estruturais: listagens de orientação que montam consulta no controller **6 → 0**; `Calendar` −45,6% e `ExaminationBoard` −23,3% em linhas; métodos de listagem do controller crítico −43% a −48% em complexidade; services 28 → 44.

## Pioras registradas, não escondidas

- **Reek +26.** Vem de `IrresponsibleModule` (+13) e `UtilityFunction` (+9) — classes e métodos novos criados pela extração. `DuplicateMethodCall` (−6) e `InstanceVariableAssumption` (−4) caíram. O saldo é positivo em arquitetura e negativo na métrica.
- **`Orientation` +25,4% de complexidade no corpo da classe.** A REF-06 removeu cinco concerns mas inlinou as consultas nos scopes em vez de encapsulá-las. Dívida real, próximo alvo natural.
- **A alteração controlada tocou mais arquivos no código refatorado** (9 contra 7) e mais linhas. O ganho está em onde a regra foi escrita — 7 implementações contra 3, e 6 dentro de controller contra 0 — não no volume.

## Defeito corrigido, encontrado por esta task

A REF-13D ativou `minimum_coverage 90` validando apenas a suíte completa. Ao rodar um subconjunto de specs durante o experimento, o SimpleCov reprovou o comando (`Line coverage (62.73%) is below the expected minimum`) mesmo com todos os exemplos verdes — o gate media a cobertura do recorte.

Corrigido em `spec/support/simplecov.rb`: o limiar passa a valer só quando nenhum caminho de spec é passado na linha de comando. Verificado nos dois modos — execução parcial termina com exit 0, suíte completa mantém o gate ativo e segue verde.

## Achados registrados, não corrigidos

- `Tcc_one_professors::OrientationsController#by_calendar` passa `page: params[:status]` — o status entra onde deveria entrar a página. O baseline tem o mesmo defeito em outra forma (`by_tcc_one(params[:status], params[:term])` contra assinatura `(page, term, status)`).
- Comentário `# 🚨 CORREÇÃO TEMPORÁRIA PARA MIGRAÇÃO` em `Orientation`, marcando um `after_create_commit` provisório.
- ERB Lint: 2013 offenses, 1018 delas de indentação com tab — a configuração do ERB Lint não desliga `Layout/IndentationStyle`, que o `.rubocop.yml` desliga para Ruby.

## Validação

- Suíte completa: **1137 exemplos, 0 falhas, 1 pendente**; cobertura 96,18%.
- RuboCop: **813 arquivos, 0 offenses**.
- `git worktree list`: apenas o repositório principal — o worktree do experimento foi removido.
- A alteração controlada foi revertida nos dois estados; `git status` limpo.
