module Notifications
  module Hooks
    module ExaminationBoard
      extend Notifications::HookHelpers

      def self.academic_eb_appointments(examination_board)
        user = examination_board.orientation.academic
        ek = event_key('examination_board', examination_board.id, 'appointments', 'user',
                       user_identifier(user))

        schedule_notification(
          notification_type: 'academic_examination_board_appointments',
          recipient: user,
          data: { date: examination_board.date.strftime('%d/%m/%Y') },
          event_key: ek
        )
      end
    end
  end
end
