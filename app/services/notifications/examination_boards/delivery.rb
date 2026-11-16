module Notifications
  module ExaminationBoards
    class Delivery
      def self.record(notification)
        key = notification.event_key.to_s
        return unless key.start_with?('board_event:')

        _, board_id, revision, user_type, user_id = key.split(':')
        state = ExaminationBoardNotificationState.find_by(examination_board_id: board_id)
        return unless state

        mark_delivered(state, "#{user_type}:#{user_id}", revision)
      end

      def self.mark_delivered(state, identifier, revision)
        state.with_lock do
          targets = state.targets.deep_dup
          target = targets[identifier]
          next unless target && target['revision'].to_s == revision

          target['delivered'] = true
          state.update!(targets: targets)
        end
      end
    end
  end
end
