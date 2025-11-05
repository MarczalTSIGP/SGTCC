module Notifications
  module Hooks
    module ExaminationBoard
      extend Notifications::HookHelpers

      def self.atendees_examination_board_assigned(board)
        recipients = recipients_for_board(board, include_academic: false)
        data = examination_board_data(board)

        recipients.each do |user|
          schedule_notification(
            recipient: user,
            data: data,
            notification_type: 'atendee_examination_board_assigned',
            event_key: event_key('examination_board', board.id, 'assigned', user_identifier(user))
          )
        end
      end

      def self.confirmed_examination_board(board)
        recipients = recipients_for_board(board, include_academic: true)
        data = examination_board_data(board)

        schedule_examination_board_confirmed(recipients, data, board)
      end

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

      private_class_method def self.examination_board_data(board)
        {
          date: board.date.strftime('%d/%m/%Y'), place: board.place,
          time: board.date.strftime('%H:%M'),
          academic_name: board.orientation.academic.name,
          orientation_title: board.orientation.title
        }
      end

      private_class_method def self.recipients_for_board(board, include_academic: false)
        arr = []
        arr << board.orientation.academic if include_academic
        arr += board.professors
        arr += board.external_members
        arr << board.orientation.advisor
        arr.compact.uniq
      end

      private_class_method def self.schedule_examination_board_confirmed(recipients, data, board)
        recipients.each do |user|
          ek = event_key('examination_board', board.id, 'confirmed', user_identifier(user))

          notification_type = if user.instance_of?(::Academic)
                                'academic_confirmed_examination_board'
                              else
                                'atendee_confirmed_examination_board'
                              end

          schedule_notification(recipient: user, notification_type: notification_type,
                                data: data, event_key: ek)
        end
      end
    end
  end
end
