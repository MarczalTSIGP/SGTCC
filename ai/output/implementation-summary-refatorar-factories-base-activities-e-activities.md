# Implementation Summary

## General Summary

Foram refatoradas as factories `spec/factories/base_activities.rb` e `spec/factories/activities.rb` para substituir factories aninhadas antigas por traits reais do domínio.

A migração aplicada foi:

- `:base_activity_tcc_one` → `:base_activity, :tcc_one`
- `:base_activity_tcc_two` → `:base_activity, :tcc_two`
- `:activity_tcc_one` → `:activity, :tcc_one`
- `:activity_tcc_two` → `:activity, :tcc_two`
- `:proposal_activity` → `:activity, :proposal`
- `:project_activity` → `:activity, :project`
- `:monograph_activity` → `:activity, :monograph`

Também foi ajustada a factory de `academic_activities` porque ela referenciava as factories antigas de `Activity`.

As factories antigas foram removidas de `base_activities.rb` e `activities.rb`; não ficaram aliases temporários.

## Changed Files

### ai/tasks/refatorar-factories-base-activities-e-activities.md

- O arquivo da task foi renomeado a partir de `ai/tasks/ai-runner.js refatorar-factories-base-activities-e-activities.md`.
- Essa alteração não faz parte direta da refatoração das factories.
- Deve ser revisada porque está fora do escopo funcional descrito para a task.

### spec/factories/academic_activities.rb

- As associações internas que usavam `:proposal_activity`, `:project_activity` e `:monograph_activity` passaram a usar `association(:activity, :proposal)`, `association(:activity, :project)` e `association(:activity, :monograph)`.
- A alteração foi necessária porque as factories antigas de `Activity` foram removidas.
- Embora seja outra factory, a mudança foi diretamente necessária para eliminar referências às factories antigas.

### spec/factories/activities.rb

- A factory principal `:activity` passou a conter traits `:tcc_one`, `:tcc_two`, `:proposal`, `:project` e `:monograph`.
- Foram removidas as factories aninhadas antigas `:activity_tcc_one`, `:activity_tcc_two`, `:proposal_activity`, `:project_activity` e `:monograph_activity`.
- Foi adicionada a sequence `:activity_calendar_year` para criar calendars associados com ano único e TCC coerente com a activity.
- A associação `calendar` passou a usar `association(:calendar, year: generate(:activity_calendar_year), tcc:)`.
- A alteração foi necessária para reduzir duplicação e migrar o uso para traits reais do domínio.

### spec/factories/base_activities.rb

- A factory principal `:base_activity` passou a conter traits `:tcc_one` e `:tcc_two`.
- Foram removidas as factories aninhadas antigas `:base_activity_tcc_one` e `:base_activity_tcc_two`.
- Os valores de `tcc` e `identifier` foram preservados dentro dos traits.
- A alteração foi necessária para substituir factories duplicadas por variações explícitas da factory principal.

### spec/features/academics/activities/activities_index_spec.rb

- Referências a `:activity_tcc_one` foram migradas para `:activity, :tcc_one`.
- A alteração preserva os cenários existentes usando a nova API da factory.
- Observação: há um cenário de TCC II que já usava a factory de TCC I antes da migração; o comportamento foi preservado.

### spec/features/academics/examination_boards/examination_boards_show_academic_activity_spec.rb

- Referência a `:monograph_activity` migrada para `:activity, :monograph`.
- Necessário para remover o uso da factory antiga.

### spec/features/external_members/activities/activities_index_spec.rb

- Referências a `:activity_tcc_one` e `:activity_tcc_two` migradas para `:activity, :tcc_one` e `:activity, :tcc_two`.
- Necessário para usar traits reais de TCC.

### spec/features/external_members/activities/activities_show_spec.rb

- Referência a `:project_activity` migrada para `:activity, :project`.
- Necessário para remover o uso da factory antiga.

### spec/features/professors/activities/activities_index_spec.rb

- Referências a `:activity_tcc_one` e `:activity_tcc_two` migradas para traits.
- Necessário para alinhar os specs à nova factory `:activity`.

### spec/features/professors/activities/activities_show_spec.rb

- Referência a `:project_activity` migrada para `:activity, :project`.
- Necessário para remover o uso da factory antiga.

### spec/features/professors/dashboard/submission_activities_to_confirm_index_spec.rb

- Referência a `:proposal_activity` migrada para `:activity, :proposal`.
- O nome do `let` foi ajustado de `proposal_activity` para `activity`.
- Necessário para eliminar referência à factory antiga mantendo o setup equivalente.

### spec/features/professors/examination_boards/examination_boards_show_academic_activity_spec.rb

- Referência a `:proposal_activity` migrada para `:activity, :proposal`.
- Necessário para usar o novo trait.

### spec/features/professors/orientations/orientation_activity_judgment_spec.rb

- Referência a `:project_activity` migrada para `:activity, :project`.
- Necessário para remover a factory antiga.

### spec/features/professors/orientations/orientations_activities_index_spec.rb

- Referência a `:project_activity` migrada para `:activity, :project`.
- Necessário para usar traits.

### spec/features/professors/orientations/orientations_activities_show_spec.rb

- Referência a `:project_activity` migrada para `:activity, :project`.
- Necessário para usar traits.

### spec/features/responsible/activities/activities_index_spec.rb

- Referências a `:activity_tcc_one` migradas para `:activity, :tcc_one`.
- Necessário para remover uso da factory antiga.
- Observação: há um cenário de TCC II que já usava a factory de TCC I antes da migração; o comportamento foi preservado.

### spec/features/responsible/base_activities/base_activities_destroy_spec.rb

- Referência a `:base_activity_tcc_one` migrada para `:base_activity, :tcc_one`.
- Necessário para usar o novo trait.

### spec/features/responsible/base_activities/base_activities_index_spec.rb

- `create_list(:base_activity_tcc_one, 3)` migrado para `create_list(:base_activity, 3, :tcc_one)`.
- `create_list(:base_activity_tcc_two, 3)` migrado para `create_list(:base_activity, 3, :tcc_two)`.
- Necessário para remover factories antigas.

### spec/features/responsible/base_activities/base_activities_show_spec.rb

- Referência a `:base_activity_tcc_one` migrada para `:base_activity, :tcc_one`.
- Necessário para usar o novo trait.

### spec/features/responsible/examination_boards/examination_boards_show_academic_activity_spec.rb

- Referência a `:monograph_activity` migrada para `:activity, :monograph`.
- Necessário para remover factory antiga.

### spec/features/site/activities/activities_index_spec.rb

- Referências a `:activity_tcc_one` e `:activity_tcc_two` migradas para `:activity, :tcc_one` e `:activity, :tcc_two`.
- Variáveis locais foram renomeadas para `activity_one` e `activity_two`.
- Necessário para remover os nomes antigos sem alterar as expectativas.

### spec/features/tcc_one_professors/activities/activities_index_spec.rb

- Referência a `:activity_tcc_one` migrada para `:activity, :tcc_one`.
- Necessário para usar o novo trait.

### spec/features/tcc_one_professors/examination_boards/examination_boards_show_academic_activity_spec.rb

- Referência a `:project_activity` migrada para `:activity, :project`.
- O atributo explícito `final_version: false` foi preservado.
- Necessário para manter o mesmo cenário com a nova factory.

### spec/models/base_activities/base_activity_filters_spec.rb

- Referências a `:base_activity_tcc_one` e `:base_activity_tcc_two` migradas para traits.
- Variáveis foram renomeadas para evitar nomes antigos.
- Necessário para validar filtros usando a nova API da factory.

### spec/models/orientations/orientation_academic_activities_spec.rb

- Referências a `:proposal_activity`, `:project_activity` e `:monograph_activity` migradas para `:activity, :proposal`, `:activity, :project` e `:activity, :monograph`.
- Necessário para remover dependência das factories antigas.

## Review Notes

Revisar especialmente:

- A alteração em `spec/factories/academic_activities.rb`, por ser uma factory fora das duas inicialmente listadas, embora necessária por dependência direta.
- O rename em `ai/tasks/refatorar-factories-base-activities-e-activities.md`, por estar fora do escopo funcional da task.
- Os cenários que preservaram uso de trait `:tcc_one` mesmo dentro de exemplos descritos como TCC II, porque o comportamento anterior já usava factory de TCC I.
- Confirmar localmente que não restaram referências às factories antigas nos specs.
- Confirmar os resultados dos comandos obrigatórios de RSpec e RuboCop, pois o relatório recebido não inclui saída de execução.