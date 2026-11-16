module Notifications
  module ExaminationBoards
    class Validity
      LEGACY_TYPES = %w[atendees_examination_board_assigned atendee_confirmed_examination_board
                        academic_confirmed_examination_board].freeze

      def self.call(type, key)
        return false if LEGACY_TYPES.include?(type)
        return true unless type.start_with?('examination_board_') && key.start_with?('board_event:')

        current_target?(type, key)
      end

      def self.current_target?(type, key)
        _, board_id, revision, user_type, user_id = key.split(':')
        state = ExaminationBoardNotificationState.find_by(examination_board_id: board_id)
        target = state&.targets&.fetch("#{user_type}:#{user_id}", nil)
        target && target['revision'].to_s == revision && target['type'] == type
      end
    end
  end
end
