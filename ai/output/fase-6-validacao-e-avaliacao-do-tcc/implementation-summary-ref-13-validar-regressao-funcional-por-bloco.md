# REF-13 — Resumo de implementação

## Resumo

Task de validação e documentação: nenhum arquivo de produção, spec, factory ou configuração foi alterado. Foram executadas a suíte completa, as validações por bloco (M1–M5), os fluxos críticos exigidos pelo roadmap e a análise estática, com os resultados arquivados em `ai/output/fase-6-validacao-e-avaliacao-do-tcc/evidencias-ref-13.md`.

## Arquivos criados

- `ai/tasks/fase-6-validacao-e-avaliacao-do-tcc/ref-13-validar-regressao-funcional-por-bloco.md` — enunciado da task, seguindo a convenção das fases anteriores.
- `ai/output/fase-6-validacao-e-avaliacao-do-tcc/evidencias-ref-13.md` — evidências completas.
- Este resumo.

## Resultados

| Coleta | Resultado |
|---|---|
| Suíte completa | 1121 exemplos, 0 falhas, 1 pendente preexistente (`WelcomeMailer`) |
| Bloco M1 (REF-02, REF-03) | 55 exemplos, 0 falhas |
| Bloco M2 (REF-04, REF-05) | 79 exemplos, 0 falhas |
| Bloco M3 (REF-06, REF-07, REF-08) | 205 exemplos, 0 falhas |
| Bloco M4 (REF-09, REF-10) | 51 exemplos, 0 falhas |
| Bloco M5 (REF-11, REF-12) | 51 exemplos, 0 falhas |
| Fluxos críticos (6 grupos) | 321 exemplos, 0 falhas |
| RuboCop | 810 arquivos, 0 offenses |
| Brakeman | 0 alertas de segurança, 0 erros |
| Reek | 723 warnings (baseline REF-00: 690) |

## Lacuna de evidência fechada

As REF-02, REF-03, REF-04, REF-05 e REF-08 haviam sido entregues apenas com `ruby -c` ou com registro de ambiente indisponível. Suas specs foram executadas nesta coleta sobre o código atual e passam.

## Pontos de atenção

- **Reek +33 warnings.** O aumento concentra-se em `IrresponsibleModule` (+13), `UtilityFunction` (+8) e `LongParameterList` (+4) — efeito direto da extração de novas classes de consulta e service. `InstanceVariableAssumption` (−4) e `DuplicateMethodCall` (−2) caíram. A interpretação formal fica para a REF-14.
- **Homologação manual não executada.** Não há ambiente de homologação disponível; a cobertura registrada é automatizada (Capybara/Selenium). A inspeção visual e a revisão por pares seguem pendentes para fechar a Fase 6.
- **SimpleCov segue desativado** (config comentada em `spec/support/simplecov.rb`), como no baseline. Sem métrica de cobertura.
- **ERB Lint não roda** por incompatibilidade preexistente do `.erb-lint.yml` (`Metrics/LineLength` → `Layout/LineLength`).

## Limites preservados

- Nenhuma alteração em `app/`, `spec/`, `db/`, `config/`, `Gemfile` ou factories.
- Nenhuma offense, smell ou falha foi corrigida — apenas registrada.
- Nenhum commit, push ou branch criado.
