# REF-13 — Evidências de validação de regressão por bloco

## Resumo

**Data da coleta:** 2026-09-13
**Ruby:** 3.4.7 · **Rails:** 8.1.3
**Branch:** `@nico/fix/calendar-modal-appointments` · **HEAD:** `6b77c2e1` (task 11) + alterações da REF-12 ainda não commitadas
**Ambiente:** containers `tests`, `db` e `selenium` do `docker-compose.yml` (`docker compose exec -T tests bundle exec ...`)

Não há regressão conhecida. A suíte completa passa (**1121 exemplos, 0 falhas, 1 pendente preexistente**), os cinco blocos de refatoração (M1–M5) passam isoladamente e os seis fluxos críticos exigidos pelo roadmap estão cobertos por specs verdes. RuboCop segue em 0 offenses e Brakeman em 0 alertas de segurança. O Reek subiu de 690 para 723 warnings, variação explicada majoritariamente pelo aumento de classes extraídas (`IrresponsibleModule`, +13) — detalhada abaixo e a ser tratada definitivamente pela REF-14.

---

## Como reproduzir

```bash
docker compose up -d db selenium tests

# suíte completa
docker compose exec -T tests bundle exec rspec

# análise estática
docker compose exec -T tests bundle exec rubocop --parallel
docker compose exec -T tests bundle exec reek app/
docker compose exec -T tests bundle exec brakeman -q --ignore-config config/brakeman.ignore
```

Os comandos por bloco e por fluxo estão nas tabelas seguintes e podem ser executados isoladamente com o mesmo prefixo.

---

## 1. Suíte completa

| Métrica | Valor |
|---|---|
| Exemplos | **1121** |
| Falhas | **0** |
| Pendentes | 1 (`WelcomeMailer`, placeholder gerado pelo Rails — preexistente) |
| Duração | 4 min 34 s |
| Comando | `docker compose exec -T tests bundle exec rspec` |

---

## 2. Validação por bloco de refatoração

| Bloco | Tasks | Escopo validado | Exemplos | Falhas | Duração |
|---|---|---|---:|---:|---:|
| M1 | REF-02, REF-03 | enums `tcc`/`semester`: `spec/models/calendar`, `spec/services/populate`, `spec/services/dashboard`, listagens `orientations_index_tcc*` e `orientations_index_to_migration` | 55 | 0 | 7,9 s |
| M2 | REF-04, REF-05 | queries extraídas dos controllers: `spec/services/orientations`, `spec/services/examination_boards`, `spec/controllers`, buscas de orientações e supervisões | 79 | 0 | 22,7 s |
| M3 | REF-06, REF-07, REF-08 | models/concerns e services: `spec/models/orientations`, `spec/models/examination_boards`, `spec/models/documents`, `spec/models/signatures`, `spec/services/documents`, features de documentos | 205 | 0 | 40,6 s |
| M4 | REF-09, REF-10 | calendar: `spec/services/calendars`, `scope_calendar_spec`, features de calendários dos quatro perfis, migração de orientações | 51 | 0 | 8,4 s |
| M5 | REF-11, REF-12 | apresentação: `spec/components`, as seis listagens de documentos, assinatura nos três perfis, arquivo/nota de banca nos dois perfis | 51 | 0 | 27,4 s |

**Total por bloco:** 441 exemplos, 0 falhas. Os blocos se sobrepõem parcialmente por construção (um mesmo spec pode cobrir mais de uma task), então esse total não é a soma da suíte.

### Lacuna de evidência fechada

Os resumos de implementação anteriores registravam validação real apenas nas fases 3 (parcial), 4 e 5. As REF-02, REF-03, REF-04, REF-05 e REF-08 haviam sido entregues com verificação apenas de sintaxe (`ruby -c`) ou com registro explícito de ambiente indisponível. Esta coleta executa as specs correspondentes a esses blocos sobre o código atual e confirma que nenhuma delas falha.

---

## 3. Fluxos críticos de homologação

O roadmap pede validação manual em homologação dos fluxos abaixo. O ambiente disponível não tem instância de homologação, então cada fluxo foi associado aos feature/unit specs que o exercitam de ponta a ponta via Capybara/Selenium.

| Fluxo | Specs de evidência | Exemplos | Falhas |
|---|---|---:|---:|
| Filtros de orientações | `services/orientations/{responsible,tcc,participant}_list_query`, `models/orientations/orientation_search`, buscas de orientações (responsible, professors) e supervisões (professors, external members), índice de TCC-1 | 51 | 0 |
| Cálculo de períodos | `services/calendars/period_navigation`, `models/calendar/{scope,validations,formatters}`, `models/orientations/orientation_calendar` e `orientation_current_calendar`, `services/orientations/migration_service`, `orientations_migrate` | 56 | 0 |
| Bancas | `models/examination_boards/*`, `services/examination_boards/*`, controllers de banca (responsible e TCC-1), features de banca de responsible, TCC-1 e professores | 112 | 0 |
| Relatórios | `services/dashboard/*` e dashboards dos cinco perfis | 21 | 0 |
| Documentos | `models/documents/*`, `services/documents`, autenticação pública de documento, revisão pelo responsável, listagens e detalhe por perfil | 56 | 0 |
| Assinaturas | `models/signatures/*`, assinatura de TCO e TCAI nos perfis acadêmico, professor e membro externo, autenticação do documento assinado | 25 | 0 |

**Limitação registrada:** a homologação manual prevista pelo roadmap não foi executada. A evidência acima é automatizada e cobre os fluxos pelo navegador, mas não substitui a inspeção visual e a revisão por pares em ambiente de homologação, que permanecem pendentes.

---

## 4. Análise estática

### RuboCop 1.88.1

```
810 files inspected, no offenses detected
```

| Métrica | Baseline REF-00 | REF-13 | Variação |
|---|---:|---:|---:|
| Arquivos inspecionados | 782 | 810 | +28 |
| Offenses | 0 | **0** | 0 |

### Brakeman 8.0.5

| Métrica | Baseline REF-00 | REF-13 | Variação |
|---|---:|---:|---:|
| Security Warnings | 0 | **0** | 0 |
| Erros de scan | 0 | 0 | 0 |
| Controllers | 69 | 69 | 0 |
| Models | 36 | 36 | 0 |
| Templates | 401 | 399 | −2 |

A queda de dois templates corresponde às views duplicadas removidas pela REF-12 (`sign_form` e `_appointment_file_form` por namespace, substituídas por versões compartilhadas). As duas entradas obsoletas do `config/brakeman.ignore` já existiam no baseline.

### Reek 6.5.0

```
723 total warnings (233 arquivos)
```

| Smell | Baseline REF-00 | REF-13 | Variação |
|---|---:|---:|---:|
| IrresponsibleModule | 224 | 237 | +13 |
| InstanceVariableAssumption | 136 | 132 | −4 |
| DuplicateMethodCall | 77 | 75 | −2 |
| UtilityFunction | 65 | 73 | +8 |
| TooManyStatements | 41 | 42 | +1 |
| TooManyInstanceVariables | 31 | 35 | +4 |
| FeatureEnvy | 30 | 32 | +2 |
| UncommunicativeVariableName | 17 | 17 | 0 |
| NilCheck | 14 | 16 | +2 |
| ControlParameter | 10 | 12 | +2 |
| TooManyMethods | 9 | 10 | +1 |
| LongParameterList | 5 | 9 | +4 |
| DataClump | 3 | 3 | 0 |
| Attribute | não listado | 9 | — |
| RepeatedConditional | não listado | 5 | — |
| NestedIterators | não listado | 4 | — |
| MissingSafeMethod | não listado | 4 | — |
| BooleanParameter | não listado | 4 | — |
| ManualDispatch | não listado | 3 | — |
| UncommunicativeModuleName | não listado | 1 | — |
| **Total** | **690** | **723** | **+33** |

Leitura: `IrresponsibleModule` é ausência de comentário de classe, e cresce naturalmente quando a refatoração extrai queries e services novos — é o maior componente do aumento. `UtilityFunction` e `LongParameterList` sobem pelo mesmo motivo: métodos de consulta isolados que não usam estado de instância e recebem parâmetros explícitos. Em contrapartida, `InstanceVariableAssumption` e `DuplicateMethodCall` caem, que é o sinal esperado de controllers e views mais enxutos.

A tabela do baseline listava apenas 13 tipos de smell (662 dos 690 warnings); os tipos marcados como "não listado" provavelmente já existiam e compunham os 28 warnings não detalhados. Por isso a comparação linha a linha é indicativa, não definitiva — a comparação as-is/to-be formal é escopo da REF-14.

---

## 5. Limitações da coleta

| Item | Situação |
|---|---|
| SimpleCov | Não coletável: a configuração segue comentada em `spec/support/simplecov.rb`, igual ao baseline. Reativá-la está fora do escopo desta task. |
| ERB Lint | Não executável: `.erb-lint.yml` ainda declara `Metrics/LineLength`, cop movido para `Layout/LineLength`. Falha preexistente de configuração, não relacionada às refatorações. O executável também está renomeado (`erblint` → `erb_lint`). |
| Homologação manual | Não executada — não há ambiente de homologação disponível nesta coleta. |
| Revisão por pares | Não registrada nesta task; depende de processo externo ao repositório. |
| Flog / Flay / RubyCritic | Não coletados aqui: são métricas de comparação as-is/to-be, escopo da REF-14. |

---

## 6. Conclusão

- Nenhuma regressão conhecida na suíte nem nos fluxos críticos cobertos automaticamente.
- Todos os blocos de REF-02 a REF-12 têm agora evidência rastreável de validação, incluindo os que antes só tinham verificação de sintaxe.
- Nenhuma diferença funcional intencional foi identificada; não há mudança a aprovar como alteração funcional separada.
- Pendências para fechar a Fase 6: homologação manual com revisão por pares e a coleta comparativa de métricas da REF-14.
