require 'active_support/concern'

module OrientationValidation
  extend ActiveSupport::Concern

  included do
    def validates_supervisor_ids
      return true unless professor_supervisor_ids.include?(advisor_id)
      message = I18n.t('activerecord.errors.models.orientation.attributes.supervisors.advisor',
                       advisor: advisor.name)
      errors.add(:professor_supervisors, message)
      false
    end
  end
end
