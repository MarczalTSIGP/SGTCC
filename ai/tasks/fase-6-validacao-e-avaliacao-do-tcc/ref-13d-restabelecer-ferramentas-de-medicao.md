# Task

REF-13D — Restabelecer as duas ferramentas de medição que estão inoperantes, para que a REF-14 possa coletar as métricas to-be.

# Dependência

- REF-00 (baseline) e REF-13 (validação).
- É **pré-requisito da REF-14**: sem esta task, a comparação as-is/to-be sai com a linha de cobertura vazia nos dois lados.

# Contexto

Duas ferramentas do projeto não rodam hoje, ambas por configuração e não por código de aplicação:

1. **SimpleCov** — `spec/support/simplecov.rb` está inteiramente comentado desde antes do baseline. Nenhuma cobertura é gerada e não existe `coverage/.last_run.json`. As gems `simplecov` (0.22.0) e `simplecov-console` já estão no `Gemfile`.
2. **ERB Lint** — falha ao carregar com `RuboCop::ValidationError: The 'Metrics/LineLength' cop has been moved to 'Layout/LineLength'`. O arquivo `.erb-lint.yml` ainda declara `Metrics/LineLength: Enabled: false`. Além disso, o executável foi renomeado (`erblint` → `erb_lint`) e o arquivo de config esperado passou a ser `.erb_lint.yml`. A gem `erb_lint` já está no `Gemfile`.

# Objetivo

Deixar as duas ferramentas executáveis e documentadas, sem alterar código de aplicação e sem tornar a suíte mais frágil.

# Escopo obrigatório

## SimpleCov

- Reativar a configuração de `spec/support/simplecov.rb`, preservando os filtros já escritos no bloco comentado.
- **Atenção ao gate:** o bloco comentado inclui `minimum_coverage 90` e `refuse_coverage_drop`. Reativá-los às cegas pode fazer a suíte passar a falhar por cobertura, o que seria uma mudança de comportamento do CI, não uma medição.
  - Primeiro reative **sem** o gate, rode a suíte completa e registre a cobertura real.
  - Só então decida o limiar, com base no número medido, e registre a decisão no relatório. Se a cobertura real ficar abaixo de 90%, **não** force o número para verde: registre-o como está e deixe o gate desligado ou ajustado ao valor medido, explicitando a escolha.
- Confirmar que `coverage/` está no `.gitignore` e não versionar relatório HTML.

## ERB Lint

- Corrigir a configuração: `Metrics/LineLength` → `Layout/LineLength`, mantendo `Enabled: false` e todo o resto do arquivo intacto.
- Renomear `.erb-lint.yml` para `.erb_lint.yml`, eliminando o aviso de deprecação.
- Rodar `bundle exec erb_lint --lint-all` e registrar o resultado.
- **Não corrigir** as offenses encontradas nesta task: elas são estado atual e viram insumo da REF-14 ou de uma task própria.

# Fora do escopo

- Não alterar código em `app/`, `db/` ou factories.
- Não alterar specs para subir cobertura.
- Não corrigir offenses de ERB Lint.
- Não adicionar gems novas.
- Não fazer commit, push ou criar branch.

# Critérios de aceite

- `bundle exec rspec` gera cobertura e o percentual real está registrado.
- A decisão sobre `minimum_coverage`/`refuse_coverage_drop` está explicitada e justificada pelo número medido.
- `bundle exec erb_lint --lint-all` executa até o fim, sem erro de configuração, e o total de offenses está registrado.
- A suíte completa continua com o mesmo resultado da REF-13 (1121 exemplos, 0 falhas, 1 pendente) — a não ser por um eventual gate de cobertura conscientemente ativado.
- RuboCop continua em 0 offenses.

# Validação sugerida

```bash
docker compose exec -T tests bundle exec rspec
cat coverage/.last_run.json
docker compose exec -T tests bundle exec erb_lint --lint-all
docker compose exec -T tests bundle exec rubocop --parallel
```
