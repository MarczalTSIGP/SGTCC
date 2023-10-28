require 'active_support/concern'

module OrientationStatus
  extend ActiveSupport::Concern

  included do
    enum status: {
      "#{I18n.t('enums.orientation.status.IN_PROGRESS')}": 'IN_PROGRESS',
      "#{I18n.t('enums.orientation.status.APPROVED')}": 'APPROVED',
      "#{I18n.t('enums.orientation.status.APPROVED_TCC_ONE')}": 'APPROVED_TCC_ONE',
      "#{I18n.t('enums.orientation.status.CANCELED')}": 'CANCELED',
      "#{I18n.t('enums.orientation.status.REPROVED')}": 'REPROVED',
      "#{I18n.t('enums.orientation.status.REPROVED_TCC_ONE')}":  'REPROVED_TCC_ONE'
    }, _prefix: :status

    def equal_status?(status_enum)
      status == Orientation.statuses.key(status_enum)
    end

    def approved?
      equal_status?('APPROVED')
    end

    def abandoned?
      equal_status?('ABANDONED')
    end

    def canceled?
      equal_status?('CANCELED')
    end

    def reproved?
      equal_status?('REPROVED')
    end

    def reproved_tcc_one?
      equal_status?('REPROVED_TCC_ONE')
    end

    def in_progress?
      equal_status?('IN_PROGRESS')
    end
  end
end
