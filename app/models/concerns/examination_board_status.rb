require 'active_support/concern'

module ExaminationBoardStatus
  extend ActiveSupport::Concern

  included do
    enum status: {
      "#{I18n.t('enums.examination_board.status.WILL_HAPPEN')}": 'WILL_HAPPEN',
      "#{I18n.t('enums.examination_board.status.ALREADY_HAPPENED')}": 'ALREADY_HAPPENED',
    }, _prefix: :status

    def equal_status?(status_enum)
      status == ExaminationBoard.statuses.key(status_enum)
    end
  end
end
