# Task

REF-18 — Recoletar as métricas to-be após a segunda rodada de coesão e atualizar a comparação da REF-14.

# Dependência

- REF-15, REF-16 e REF-17 concluídas.

# Contexto

A REF-14 produziu a comparação as-is/to-be sobre o commit `f3140bbb`. As tasks REF-15 a REF-17 alteram código de produção, então **os números publicados pela REF-14 deixam de valer** para o estado atual — em especial os dois que ela registrou como piora:

- `Orientation` com 125,3 pontos de Flog no corpo da classe (+25,4% sobre o baseline);
- Reek em 716 warnings (+26 sobre o baseline).

Esta task fecha o ciclo: mede de novo e diz, com número, se a segunda rodada reverteu a piora medida ou não.

# Objetivo

Atualizar a comparação as-is/to-be com o estado pós-REF-17, sem refazer a recoleta do baseline.

# Escopo obrigatório

- Repetir **apenas o lado to-be** da coleta da REF-14, com os mesmos comandos: RuboCop, Reek, Brakeman, Flog, Flay, RubyCritic, SimpleCov e ERB Lint.
- **Não** recriar o worktree do baseline: os números as-is já foram recoletados e validados pela REF-14, e o commit de baseline não mudou.
- Atualizar `ai/output/fase-6-validacao-e-avaliacao-do-tcc/metricas-as-is-to-be-ref-14.md` acrescentando uma coluna ou seção com a medição pós-segunda-rodada, **sem apagar** os números da primeira medição — a evolução entre as duas é evidência, não ruído.
- Responder explicitamente, com número:
  - a complexidade do corpo de `Orientation` caiu abaixo dos 125,3 medidos? Voltou ao patamar do baseline (99,9)?
  - o total do Reek caiu em relação aos 716? Qual tipo de smell explica a variação?
  - Flay, Flog médio e RubyCritic melhoraram, pioraram ou ficaram neutros?
- Revisar a seção "Pioras" e a "Conclusão" da REF-14 à luz dos números novos. Se a piora do `Orientation` foi revertida, dizer isso; se foi só atenuada, dizer isso; se não mudou, dizer isso também.

# Fora do escopo

- Não alterar código de produção, specs ou configuração.
- Não corrigir nada encontrado na coleta.
- Não recoletar o as-is.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- A comparação tem três colunas rastreáveis: as-is, to-be da REF-14 e to-be pós-segunda-rodada.
- A pergunta sobre `Orientation` e sobre o Reek está respondida com número, não com adjetivo.
- Se algum número piorou em relação à REF-14, isso está registrado como piora.
- Nenhum arquivo de produção, teste ou configuração foi alterado.

# Validação sugerida

```bash
docker compose exec -T tests bundle exec rspec
docker compose exec -T tests bundle exec rubocop --parallel
docker compose exec -T tests bundle exec reek app/ | tail -1
docker compose exec -T tests bundle exec flog app/ | head -4
docker compose exec -T tests bundle exec flay app/ | head -2
docker compose exec -T tests bundle exec rubycritic app --no-browser -f console | tail -1
```
