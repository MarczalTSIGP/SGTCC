# REF-16 — Resumo de implementação

## Resumo

Removidos quatro métodos de classe de `Orientation` sem nenhum consumidor e um comentário que descrevia uma correção nunca aplicada. Nenhuma mudança de comportamento.

## Métodos removidos

| Método | Linhas | Confirmação |
|---|---:|---|
| `Orientation.last_tcc_one_calendars` | 5 | `grep` em `app/`, `spec/`, `lib/`, `config/` e `db/`: zero referências |
| `Orientation.count_orientations_in_last_tcc_one_calendar` | 4 | idem |
| `Orientation.reproved` | 3 | idem, com busca específica por `.reproved` sem `?` |
| `Orientation.reproved_tcc_one` | 3 | idem |

Além do `grep` textual, foi verificado que nenhum **despacho dinâmico** do projeto alcança esses métodos. Os pontos de `send`/`public_send` sobre `Orientation` e suas relations são:

- `Orientations::ParticipantListQuery#segmented` → `base.public_send(scope, status)`, com `scope` vindo de `SEGMENTS`, que só contém `:current_tcc_one` e `:current_tcc_two`;
- `ExaminationBoard` → `orientation.send(identifier)`, que atinge métodos de **instância** (`monograph`, `project`, `proposal`).

Nenhum deles pode chegar aos quatro removidos.

### O que foi preservado

`approved`, `approved_tcc_one`, `in_tcc_one` e o `private_class_method :by_status` **continuam**, com seus consumidores intactos: `site_controller`, `Api::V1::OrientationsController` e `Dashboard::ProfessorsRankingReport`.

Os predicados `reproved?` e `reproved_tcc_one?` de `OrientationStatus` **não** foram tocados — são usados pelos dois relatórios de dashboard. A semelhança de nome com os métodos de classe removidos era o risco principal desta task e foi conferida caso a caso.

### Evidência adicional de que estavam mortos

A cobertura subiu de 96,18% para **96,27%** após a remoção. Das 9 linhas removidas, 4 constavam como cobertas (as linhas `def`, executadas no carregamento da classe) e 5 como **não cobertas** — os corpos, que nenhum exemplo jamais executou.

## Comentário de correção temporária

```ruby
# 🚨 CORREÇÃO TEMPORÁRIA PARA MIGRAÇÃO: Troca after_create_commit por after_create
after_create_commit { Orientations::TcoTcaiService.create(self) }
```

O histórico mostra que a troca **nunca foi aplicada**:

- o comentário nasceu em `60ebf5e1` (*Major Refactor: Rails Upgrade, Hotwire Migration*, 2026-03-18), dentro do concern `OrientationTcoTcai`;
- nesse mesmo commit, a linha `after_create_commit :create_tco_and_tcai` aparece no diff apenas como **contexto**, sem alteração. O que mudou de fato foi o `after_update`, que ganhou `unless: -> { skip_documents_callbacks }`;
- em `0d76a4bd` (Task 06 / REF-06) o comentário foi transportado literalmente do concern para o model, junto com o `after_create_commit`.

Ou seja, o comentário anunciava uma intenção da migração de março que não se concretizou, e há seis meses descreve o código errado. O callback funciona como `after_create_commit` desde antes disso, com a suíte verde — inclusive os fluxos de criação de TCO e TCAI, amplamente exercitados.

**Decisão:** o comentário foi removido e o callback **não** foi tocado. Alterar `after_create_commit` para `after_create` mudaria o momento de criação dos documentos em relação à transação — área sensível, mudança funcional, fora desta task.

### Achado registrado

`skip_documents_callbacks` guarda apenas o `after_update`; o `after_create_commit` não tem guarda equivalente. E o `attr_accessor :skip_documents_callbacks` **não tem nenhum consumidor** em `app/`, `lib/`, `spec/` ou `db/` — aparentemente sobrou do script de migração de março. Registrado, não removido: diferente dos quatro métodos, mexer nele envolve o fluxo de callbacks de documento.

## Falha preexistente encontrada, não causada por esta task

Ao rodar o subconjunto de validação, `spec/features/site/activities/activities_index_spec.rb` falhou:

```
ActiveRecord::RecordInvalid: A validação falhou: Ano já está em uso para o TCC e semestre selecionado
```

Verificação feita antes de concluir qualquer coisa:

1. o banco de teste estava **vazio** no momento da falha (`Calendar.count == 0`), então não era resíduo de execução anterior;
2. o arquivo foi executado **isolado contra o `orientation.rb` original de `HEAD`**, sem nenhuma alteração desta task, e falhou igual.

Conclusão: é uma **dependência de ordem de execução preexistente**. O arquivo passa na suíte completa e falha quando roda isolado ou em subconjuntos. A configuração do DatabaseCleaner escolhe `:truncation` para specs de feature conforme `Capybara.current_driver`, e o resultado varia com o que rodou antes. **Não corrigido** — é problema de infraestrutura de teste, merece task própria.

## Efeito nas métricas

| Métrica | Após REF-15 | Após REF-16 | Δ acumulado desde a REF-14 |
|---|---:|---:|---:|
| Linhas de `orientation.rb` | 300 | **280** | 293 → 280 (−4,4%) |
| Flog total do arquivo | 236,2 | **215,3** | 259,4 → 215,3 (−17,0%) |
| `Orientation#none` | 89,3 | 89,3 | 125,3 → 89,3 (−28,8%) |
| Cobertura | 96,18% | **96,27%** | +0,09 p.p. |

A recoleta oficial é a REF-18.

## Validação

- Suíte completa: **1148 exemplos, 0 falhas, 1 pendente**.
- RuboCop: **814 arquivos, 0 offenses**.
- `grep` por cada artefato removido: nenhuma referência remanescente.
- `approved`, `approved_tcc_one` e `in_tcc_one` verificados com seus specs de API, site e ranking.

## Limites preservados

- Nenhum callback alterado.
- Nenhum predicado de status tocado.
- `by_status` mantido.
- Nenhum commit, push ou branch criado.
