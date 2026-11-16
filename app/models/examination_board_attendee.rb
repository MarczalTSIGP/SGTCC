class ExaminationBoardAttendee < ApplicationRecord
  before_save :capture_board_notifications
  before_destroy :capture_board_notifications
  after_destroy :schedule_board_notifications
  after_save :schedule_board_notifications

  belongs_to :examination_board
  belongs_to :professor, optional: true
  belongs_to :external_member, optional: true

  private

  def capture_board_notifications
    Notifications::ExaminationBoards::Lifecycle.capture(examination_board)
  end

  def schedule_board_notifications
    Notifications::ExaminationBoards::Lifecycle.schedule(examination_board_id)
  end
end
