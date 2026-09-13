# REF-13D — Resumo de implementação

## Resumo

As duas ferramentas voltaram a funcionar. A REF-14 já tem cobertura e ERB Lint disponíveis para a coleta to-be.

## SimpleCov

### Ordem de carregamento verificada antes de reativar

`.rspec` declara `--require spec_helper`, e `spec/spec_helper.rb` requer `support/simplecov` na **primeira linha** — antes de `rails_helper` carregar `config/environment`. A configuração podia ser reativada como estava, sem risco de medir cobertura parcial.

### Medição antes da decisão de limiar

Conforme a task, a configuração foi reativada primeiro **sem** gate, e só então o limiar foi decidido:

| Métrica | Valor |
|---|---|
| Cobertura de linhas | **96,18%** (4757 / 4946 linhas em 221 arquivos) |
| Registro | `coverage/.last_run.json` → `96.17` |
| Arquivos com 100% | 163 |

Como 96,18% está confortavelmente acima do limiar original, `minimum_coverage 90` foi reativado — ele não altera o resultado da suíte hoje e preserva a intenção original do projeto.

`refuse_coverage_drop` foi **mantido desligado**, de propósito e com justificativa no próprio arquivo: ele reprova a suíte a qualquer oscilação para baixo entre execuções, o que atrapalharia justamente a medição comparativa da REF-14.

### Piores coberturas registradas

| Arquivo | Cobertura |
|---|---:|
| `app/services/calendars/clone_base_activities.rb` | 53,57% |
| `app/components/pages/order_list_component.rb` | 60,00% |
| `app/services/notifications/hooks/activity.rb` | 62,86% |
| `app/mailers/welcome_mailer.rb` | 66,67% |
| `app/controllers/concerns/json_message.rb` | 70,00% |

Registradas como estado atual — subir cobertura estava fora do escopo.

`coverage/` já constava no `.gitignore`; nenhum relatório HTML foi versionado.

## ERB Lint

- `.erb-lint.yml` renomeado para `.erb_lint.yml` (com `git mv`), eliminando o aviso de deprecação do nome de arquivo.
- `Metrics/LineLength` trocado por `Layout/LineLength`, mantendo `Enabled: false` e o resto do arquivo intacto. Era esse cop, removido do RuboCop atual, que abortava a execução com `RuboCop::ValidationError`.
- Nenhuma referência ao nome antigo existia em `.github/`, `run`, `Guardfile`, `Rakefile`, `lib/tasks/` ou `.kamal/`.

`bundle exec erb_lint --lint-all` agora executa até o fim: **2013 offenses**, não corrigidas por estarem fora do escopo.

| Tipo | Ocorrências |
|---|---:|
| Indentação com tab em vez de espaço | 1018 |
| `Style/StringLiterals` | 377 |
| `Layout/ArgumentAlignment` | 202 |
| Múltiplas linhas em branco no fim do arquivo | 58 |
| Espaço em branco no fim da linha | 54 |
| `Layout/FirstArgumentIndentation` | 44 |
| Demais tipos | 260 |

O grosso é cosmético e concentrado em indentação: o projeto usa tab em ERB e o `.rubocop.yml` desliga `Layout/IndentationStyle` para Ruby, mas a configuração do ERB Lint não faz o equivalente. Decidir entre alinhar a configuração ou reindentar as views é assunto de task própria.

## Validação

- Suíte completa com o gate ativo: **1137 exemplos, 0 falhas, 1 pendente** — mesmo resultado da REF-13C.
- Cobertura na execução final: 96,18%.
- RuboCop: **813 arquivos, 0 offenses**.
- `bundle exec erb_lint --lint-all` executa sem erro de configuração.

## Preservado

Nenhuma alteração em `app/`, `db/`, factories ou specs. Nenhuma offense de ERB Lint corrigida. Nenhuma gem adicionada.

## Correção posterior (encontrada pela REF-14)

O gate `minimum_coverage 90` foi validado apenas contra a suíte completa. Numa execução parcial (`rspec spec/models/...`) o SimpleCov mede a cobertura **daquele recorte** e reprovava o comando mesmo com todos os exemplos verdes:

```
Line coverage (62.73%) is below the expected minimum coverage (90.00%).
SimpleCov failed with exit 2 due to a coverage related error
```

Corrigido em `spec/support/simplecov.rb`: o limiar passa a ser aplicado somente quando nenhum caminho de spec é passado na linha de comando. Verificado nos dois modos — execução parcial termina com exit 0, suíte completa mantém o gate e segue verde (1137 exemplos, 0 falhas, 96,18%).
