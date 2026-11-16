module ExaminationBoardNotifications
  extend ActiveSupport::Concern

  included do
    before_save :capture_notification_state
    before_destroy :capture_notification_state
    after_save :schedule_board_notifications
    after_destroy :schedule_board_notifications
    after_touch :schedule_board_notifications
  end

  def capture_notification_state(_attendee = nil)
    Notifications::ExaminationBoards::Lifecycle.capture(self)
  end

  private

  def schedule_board_notifications
    Notifications::ExaminationBoards::Lifecycle.schedule(id)
  end
end
