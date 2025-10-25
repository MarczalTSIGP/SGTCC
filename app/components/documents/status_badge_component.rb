# frozen_string_literal: true

class Documents::StatusBadgeComponent < ViewComponent::Base
  def initialize(request:)
    @request = request || {}
  end

  def badge_class
    "badge badge-#{badge_status}"
  end

  def status_label
    return 'Deferido' if accepted?
    return 'Indeferido' if refused?

    'Em análise'
  end

  private

  def badge_status
    return 'success' if accepted?
    return 'danger' if refused?

    'primary'
  end

  def judgment?
    @request['judgment'].is_a?(Hash)
  end

  def accept_value
    @request.dig('judgment', 'responsible', 'accept')
  end

  def accepted?
    judgment? && accept_value == 'true'
  end

  def refused?
    judgment? && accept_value == 'false'
  end
end
