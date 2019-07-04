require 'active_support/concern'

module OrientationOption
  extend ActiveSupport::Concern

  included do
    def can_be_renewed?(professor)
      professor&.role?(:responsible) && calendar_tcc_two? && in_progress?
    end

    def can_be_canceled?(professor)
      professor&.role?(:responsible) && !canceled?
    end

    def can_be_edited?
      signatures.where(status: true).empty?
    end

    def can_be_destroyed?
      signatures.where(status: true).count < signatures.count
    end
  end
end
