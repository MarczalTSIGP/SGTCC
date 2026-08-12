# Task

REF-00 — Registrar o baseline de qualidade do SGTCC antes de iniciar a refatoração descrita em `ai/roadmap.md`.

# Contexto

O roadmap de refatoração (`ai/roadmap.md`) define 15 tasks em 7 fases para melhorar coesão, legibilidade, modularidade e manutenibilidade do SGTCC, sem alterar comportamento funcional nem regras acadêmicas.

Antes de qualquer alteração estrutural (Fase 1 em diante), é preciso ter um retrato **as-is** mensurável do projeto. Esse retrato será usado ao final do trabalho (REF-14) para comparar antes/depois e demonstrar objetivamente o impacto das refatorações.

Esta é a primeira task do roadmap (Fase 0 — Baseline e inventário técnico) e não depende de nenhuma outra.

Ferramentas já presentes no `Gemfile`: `rspec` (via `rspec-rails`), `simplecov` + `simplecov-console`, `rubocop` (+ `rubocop-rails`, `rubocop-rspec`, `rubocop-rspec_rails`, `rubocop-capybara`, `rubocop-factory_bot`), `reek` e `brakeman`. `rubycritic`, `flay` e `flog` **não** estão no `Gemfile` hoje.

# Objetivo

Executar e arquivar, de forma reproduzível, o estado atual da suíte de testes, cobertura, estilo, code smells, complexidade e duplicação do código, para servir de linha de base às próximas tasks do roadmap.

# Instrução crítica

Esta task é somente de **medição e documentação**. Não corrija falhas de RuboCop, Reek ou testes encontrados durante a coleta — apenas registre-as.

Não altere código de produção, models, controllers, services, concerns, helpers, views, rotas, migrations ou factories.

A única exceção de escrita fora da pasta de resultados é o `Gemfile`/`Gemfile.lock`, e somente se for necessário adicionar `rubycritic`, `flay` e/ou `flog` ao grupo `:development, :test` para tornar a coleta reproduzível.

# Escopo permitido

- Executar comandos de teste e análise estática já configurados no projeto (`bundle exec rspec`, `bundle exec rubocop`, `bundle exec reek`, `bundle exec brakeman`, cobertura via SimpleCov).
- Adicionar `rubycritic`, `flay` e `flog` ao `Gemfile` (grupo `:development, :test`) caso ainda não estejam disponíveis, e rodar `bundle install`.
- Criar arquivos de resultado dentro de `ai/output/baseline/` (criar a pasta se não existir).
- Criar ou atualizar `ai/output/baseline/README.md` (ou `baseline.md`) com a tabela resumo do baseline.

# Escopo proibido

- Não altere nenhum arquivo em `app/`, `config/` (exceto adicionar gems no `Gemfile` conforme acima), `db/`, `lib/tasks/` ou `spec/`.
- Não corrija violações de RuboCop/Reek nem falhas de teste encontradas.
- Não faça commit, push ou criação de branch.
- Não versionar relatórios HTML volumosos (ex.: saída HTML do SimpleCov, RubyCritic). Versionar apenas resumos em texto/Markdown/JSON dentro de `ai/output/baseline/`; adicionar ao `.gitignore` os diretórios de relatório HTML gerados, se ainda não estiverem ignorados.

# Comandos de coleta sugeridos

Execute e registre a saída resumida (não o log completo) de cada comando abaixo. Se algum comando falhar por problema de ambiente, registre o erro no relatório em vez de tentar corrigi-lo.

```bash
bundle exec rspec 2>&1 | tail -n 40
bundle exec rubocop --format offenses 2>&1 | tail -n 40
bundle exec reek app/ 2>&1 | tail -n 60
bundle exec brakeman -q 2>&1 | tail -n 40
```

Cobertura (SimpleCov já está configurado nos specs — o percentual aparece ao final da execução do RSpec ou em `coverage/.last_run.json`, caso exista).

Se `rubycritic`, `flay` e `flog` forem adicionados:

```bash
bundle exec rubycritic app --no-browser -f console 2>&1 | tail -n 60
bundle exec flog app 2>&1 | tail -n 20
bundle exec flay app 2>&1 | tail -n 20
```

# Critérios de aceite

- Existe uma tabela de baseline em `ai/output/baseline/` com: comando executado, versão da ferramenta (ex.: `bundle exec rubocop -v`), data da coleta e resultado resumido (números, não o log inteiro).
- A tabela cobre no mínimo: número de exemplos/falhas do RSpec, percentual de cobertura do SimpleCov, total de offenses do RuboCop (por tipo/severidade se disponível), total de smells do Reek, alertas do Brakeman, e complexidade/duplicação (RubyCritic/Flog/Flay) se as ferramentas forem adicionadas.
- Falhas ou offenses preexistentes ficam claramente registradas como "estado atual", não como algo a corrigir nesta task.
- Outra pessoa consegue reproduzir a coleta usando exatamente os comandos documentados.
- Nenhum arquivo de código de produção, teste ou configuração de negócio foi alterado.

# Relatório final esperado

Crie `ai/output/baseline/README.md` com:

## Resumo

Data da coleta, versão do Ruby/Rails usada, e um parágrafo curto sobre o estado geral encontrado.

## Comandos e versões

Tabela com comando, versão da ferramenta e data.

## Resultados

Uma seção por ferramenta (RSpec, SimpleCov, RuboCop, Reek, Brakeman, e RubyCritic/Flog/Flay se adicionados), com os números coletados e, quando fizer sentido, os arquivos/classes com piores resultados (ex.: maiores smells do Reek, maior complexidade do Flog).

## Ferramentas adicionadas

Se `rubycritic`, `flay` ou `flog` tiverem sido adicionados ao `Gemfile`, explique a decisão e confirme que `bundle install` rodou sem erros.

## Limitações e falhas na coleta

Liste comandos que não puderam ser executados ou que exigiram ajuste, e por quê.

## Próximos passos

Confirme que este baseline está pronto para ser referenciado por REF-01 (inventário) e, ao final do roadmap, por REF-14 (comparação as-is/to-be).
