# Implementation Summary

## General Summary

A REF-01 produziu um inventário técnico de inconsistências e responsabilidades dispersas no SGTCC, com base na inspeção real do código a partir do baseline coletado em REF-00. O trabalho foi exclusivamente de leitura, análise e documentação — nenhum arquivo de produção foi alterado. O resultado é um backlog priorizado com 16 achados ligados a arquivos e linhas reais, cobrindo enums inconsistentes, regras de negócio em controllers, concerns com responsabilidades misturadas, 13 extrações abandonadas e 3 candidatos a consolidação de views. O inventário serve de entrada direta para as Fases 1 a 5 do roadmap.

---

## Changed Files

### `ai/output/fase-0-baseline/inventario-ref-01.md`

- Arquivo criado do zero como único produto desta task.
- Contém todas as seções exigidas pela task: Resumo, Enum `tcc`, Enum `semester`, Controllers com regra de negócio, Responsabilidades dos 5 models centrais, Extrações abandonadas, Candidatos a duplicação e Backlog priorizado.
- **Enum `tcc`:** 19 ocorrências mapeadas em 12 arquivos distintos, separadas em padrão correto (`Calendar.tccs[:one]`, símbolo `:one`) e padrões a eliminar (inteiro `1`/`2` em SQL/where, string `'one'`/`'two'` em comparações). Consumidores críticos do valor inteiro persistido identificados explicitamente.
- **Enum `semester`:** 7 ocorrências mapeadas em 4 arquivos. Identificado problema especial em `Calendar#set_dates` (conversão via `to_i` frágil) e em `Dashboard::ResponsibleReport` que recalcula o semestre manualmente ignorando `Calendar.current_semester`.
- **Controllers:** 6 blocos de lógica embutida documentados, com destaque para `Responsible::OrientationsController#tcc_one/tcc_two` (SQL HAVING manual com inteiro bruto, rubocop disable, TODO explícito) e os dois services de dashboard (`ResponsibleReport`, `ProfessorReport`) com carga em memória e comparações de status dependentes de locale.
- **Responsabilidades dos models:** `Orientation` tem 12 concerns, `ExaminationBoard` tem 6 (incluindo `ActionView::Helpers::DateHelper` diretamente no model). Cada concern classificado por responsabilidade com indicação de candidatos a extração.
- **Extrações abandonadas:** 13 locais documentados com indicação de divergência comportamental em relação ao caminho ativo, e associação à task do roadmap responsável por cada reconciliação. Confirmado o achado citado no roadmap sobre `Orientation.tcc_one` vs query HAVING do controller — a divergência procede.
- **Backlog:** 16 itens ordenados por impacto × complexidade, com recomendação de início pela REF-02 (enum `tcc`) → REF-03 (enum `semester`) → REF-04 (extração da query do responsável).

### `ai/tasks/fase-0-baseline/ref-01-inventariar-inconsistencias-e-responsabilidades.md`

- Arquivo da task criado para registrar o escopo, contexto e critérios de aceite da REF-01.
- Serve de referência para o roadmap e para rastreabilidade do trabalho realizado nesta fase.

---

## Review Notes

- **Confirmar comportamento de `orientations_count_by_calendars_and_status`:** o método existe, é chamado e sempre retorna 0. Se o dashboard exibe esse dado, ele está incorreto em produção agora — vale verificar manualmente na UI antes de planejar a REF-08.
- **Risco de locale em comparações de status:** `o.status.eql?('em andamento')` nos services de dashboard é o maior risco técnico identificado. Se o locale não for `pt-BR` no momento da chamada, os filtros de status retornam resultados incorretos silenciosamente. Deve ser tratado como prioridade junto com REF-06/REF-08.
- **`AcademicDocumentsInfo` usa método deprecated:** `calendar_tcc_one?` está marcado com `TODO: Refactored and Remove` mas ainda é consumido por esse concern. Nenhuma refatoração deve remover o método deprecated antes de migrar `AcademicDocumentsInfo` para `tcc_one?` (REF-06).
- **RSpec indisponível no ambiente:** a divergência de comportamento entre `Orientation.tcc_one` e a query HAVING do controller foi confirmada por inspeção estática, mas não por execução de testes. A REF-04 deve começar com testes de caracterização antes de qualquer extração.
