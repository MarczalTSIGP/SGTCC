require 'active_support/concern'

module OrientationStatus
  extend ActiveSupport::Concern

  included do
    enum status: {
      "#{I18n.t('enums.orientation.status.RENEWED')}": 'RENEWED',
      "#{I18n.t('enums.orientation.status.APPROVED')}": 'APPROVED',
      "#{I18n.t('enums.orientation.status.CANCELED')}": 'CANCELED',
      "#{I18n.t('enums.orientation.status.IN_PROGRESS')}": 'IN_PROGRESS'
    }, _prefix: :status

    def equal_status?(status_enum)
      status == Orientation.statuses.key(status_enum)
    end

    def renewed?
      equal_status?('RENEWED')
    end

    def approved?
      equal_status?('APPROVED')
    end

    def canceled?
      equal_status?('CANCELED')
    end

    def in_progress?
      equal_status?('IN_PROGRESS')
    end

    def self.select_status_data
      statuses.map { |index, field| [field, index.capitalize] }.sort!
    end
  end
end
