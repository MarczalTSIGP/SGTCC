require 'active_support/concern'

module ExaminationBoardStatus
  extend ActiveSupport::Concern

  included do
    enum status: {
      "#{I18n.t('enums.examination_board.status.CURRENT_SEMESTER')}": 'CURRENT_SEMESTER',
      "#{I18n.t('enums.examination_board.status.OTHER_SEMESTER')}": 'OTHER_SEMESTER'
    }, _prefix: :status

    def equal_status?(status_enum)
      status == ExaminationBoard.statuses.key(status_enum)
    end
  end
end
