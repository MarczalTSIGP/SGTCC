# frozen_string_literal: true

# Fonte única do mapeamento entre o status persistido da orientação e a classe CSS do badge.
# Consumido por Orientations::StatusBadgeComponent e Orientations::TableComponent, que
# renderizam marcações diferentes a partir do mesmo mapeamento.
module Orientations::StatusBadge
  DEFAULT_CLASS = 'badge-secondary'

  MAPPINGS = {
    'APPROVED_TCC_ONE' => 'badge-approved-tcc-1',
    'APPROVED' => 'badge-approved',
    'IN_PROGRESS' => 'badge-in-progress',
    'CANCELED' => 'badge-canceled',
    'REPROVED_TCC_ONE' => 'badge-reproved-tcc-1',
    'REPROVED' => 'badge-reproved'
  }.freeze

  module_function

  # Traduz o rótulo exibido de status para o valor persistido do enum.
  def key_for(status)
    Orientation.statuses[status]
  end

  def class_for(status_key)
    MAPPINGS.fetch(status_key, DEFAULT_CLASS)
  end
end
