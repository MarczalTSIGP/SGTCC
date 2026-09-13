# Task

REF-14 — Coletar as métricas to-be do SGTCC, compará-las com o baseline da REF-00 e interpretar o resultado das refatorações à luz dos objetivos específicos do TCC.

# Dependência

- REF-00 (baseline as-is) e REF-02 a REF-13D (todas as refatorações e a validação de regressão).
- É a última task do roadmap.

# Contexto

A REF-00 registrou o retrato as-is em `ai/output/fase-0-baseline/baseline/README.md`. A REF-13 confirmou que não há regressão funcional conhecida e a REF-13D restabeleceu SimpleCov e ERB Lint, que estavam inoperantes na coleta original.

Duas limitações do baseline precisam ser tratadas com honestidade nesta task:

1. **RSpec e SimpleCov não foram coletados no baseline** — o ambiente da REF-00 não tinha banco de teste. Não existe número as-is de cobertura para comparar; o número to-be existe isoladamente.
2. **A tabela de smells do baseline detalhou apenas 13 tipos**, somando 662 dos 690 warnings. Os 28 restantes ficaram sem discriminação, o que torna a comparação por tipo indicativa e não definitiva.

Para resolver o item 2 e tornar a comparação defensável, esta task **recoleta as métricas estáticas sobre o código do baseline**, no mesmo ambiente e com as mesmas versões de ferramenta usadas no to-be.

# Objetivo

Produzir a comparação as-is/to-be com variação absoluta e percentual, explicar melhorias, resultados neutros e pioras, e relacionar as conclusões aos objetivos do TCC.

# Instrução crítica

Esta task é de **medição e interpretação**. Não corrija código, offenses ou smells encontrados.

Números que pioraram devem ser relatados como pioraram, com explicação — não devem ser omitidos, reenquadrados nem compensados com outra métrica.

# Escopo obrigatório

## 1. Coleta to-be

Executar sobre `HEAD`, no container `tests`:

```bash
bundle exec rubocop --parallel --format json
bundle exec reek app/
bundle exec brakeman -q --ignore-config config/brakeman.ignore
bundle exec flog app/
bundle exec flay app/
bundle exec rubycritic app --no-browser -f console
bundle exec rspec     # cobertura via SimpleCov
bundle exec erb_lint --lint-all
```

## 2. Recoleta as-is sobre o código do baseline

Criar um worktree do commit de baseline (`779272b6`) e rodar **as mesmas ferramentas, nas mesmas versões**, sobre ele. Isso elimina a diferença de ambiente entre a REF-00 e esta coleta e permite comparar tipo a tipo.

Onde o número recoletado divergir do que está no documento da REF-00, **registrar as duas leituras** e explicar a divergência, em vez de substituir silenciosamente o baseline publicado.

## 3. Contagem estrutural

Recontar, as-is e to-be:

- linhas e número de métodos dos controllers que a REF-01 apontou como críticos;
- quantidade de regra de negócio deslocada dos controllers para services, queries e concerns;
- número de classes de service/query existentes.

## 4. Alteração controlada

Executar a mudança proposta pelo TCC — **adicionar um critério de busca de orientações** — duas vezes: uma sobre o worktree do baseline e outra sobre o código atual.

Para cada execução, registrar:

- arquivos tocados e linhas alteradas;
- quantos pontos precisaram ser entendidos antes de alterar;
- se a mudança exigiu tocar em controller, model, view ou apenas na camada de consulta;
- tempo aproximado.

A alteração controlada é um **experimento**: ela não deve ser incorporada ao código do projeto. Descartar o worktree e a alteração ao final, mantendo apenas o registro e o diff no relatório.

## 5. Interpretação

- Tabela as-is/to-be com variação absoluta e percentual por métrica.
- Seção explicando melhorias, resultados neutros e pioras — incluindo o aumento de smells já observado na REF-13, que precisa ser explicado e não escondido.
- Relação explícita entre os números e os objetivos específicos do TCC.
- Ressalva metodológica: métricas estáticas são evidência complementar, não prova isolada de qualidade.

# Fora do escopo

- Não alterar código de produção, specs, factories ou configuração.
- Não corrigir nada encontrado na coleta.
- Não incorporar a alteração controlada ao projeto.
- Não fazer commit, push ou criar branch (o worktree do experimento é temporário e deve ser removido).

# Critérios de aceite

- Existe tabela as-is/to-be com variação absoluta e percentual para RuboCop, Reek, Brakeman, Flog, Flay, RubyCritic e SimpleCov.
- Os números do baseline recoletados estão registrados ao lado dos publicados pela REF-00, com as divergências explicadas.
- As pioras estão explicadas, não omitidas.
- A alteração controlada tem registro comparável nos dois estados do código.
- As conclusões se ligam aos objetivos específicos do TCC e declaram os limites do método.
- Nenhum arquivo de produção, teste ou configuração foi alterado; nenhum worktree temporário ficou para trás.

# Validação sugerida

```bash
git worktree list          # deve estar vazio ao final
git status --short         # deve estar limpo ao final
```
