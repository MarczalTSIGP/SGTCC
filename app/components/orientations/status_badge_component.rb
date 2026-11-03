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
    return 'text-dark' if status_key == 'IN_PROGRESS'

    ''
  end

  private

  def status_key
    Orientations::StatusBadge.key_for(@status)
  end

  def status_badge_class
    Orientations::StatusBadge.class_for(status_key)
  end
end
