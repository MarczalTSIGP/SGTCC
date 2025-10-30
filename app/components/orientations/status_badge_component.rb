# frozen_string_literal: true

class Orientations::StatusBadgeComponent < ViewComponent::Base
  def initialize(status:, label: nil)
    @status = status
    @label = label || status
  end

  def badge_class
    "badge badge-pill #{status_badge_class} #{text_color_class}"
  end

  def status_label
    @label
  end

  def text_color_class
    return 'text-dark' if @status == 'em andamento'

    ''
  end

  private

  def status_badge_class
    status_key = Orientation.statuses[@status]
    status_mappings.fetch(status_key, 'badge-secondary')
  end

  def status_mappings
    {
      'APPROVED_TCC_ONE' => 'badge-approved-tcc-1',
      'APPROVED' => 'badge-approved',
      'IN_PROGRESS' => 'badge-in-progress',
      'CANCELED' => 'badge-canceled',
      'REPROVED_TCC_ONE' => 'badge-reproved-tcc-1',
      'REPROVED' => 'badge-reproved'
    }
  end
end
