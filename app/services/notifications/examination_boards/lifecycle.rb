module Notifications
  module ExaminationBoards
    class Lifecycle
      def self.capture(board)
        return if board.new_record? || board.previously_new_record?

        ExaminationBoardNotificationState.find_or_create_by!(
          examination_board_id: board.id
        ) do |state|
          persisted = ExaminationBoard.find(board.id)
          state.snapshot = Snapshot.call(persisted)
        end
      end

      def self.schedule(board_id)
        ActiveRecord.after_all_transactions_commit { new(board_id).call }
      end

      def initialize(board_id)
        @board_id = board_id
      end

      def call
        state = ExaminationBoardNotificationState.find_or_create_by!(
          examination_board_id: @board_id
        )
        state.with_lock do
          board = ExaminationBoard.find_by(id: @board_id)
          current = Snapshot.call(board) if board
          return if current == state.snapshot

          reconcile(state, current)
        end
      end

      private

      def reconcile(state, current)
        state.revision += 1
        targets = Targets.new(state, current).call
        state.update!(snapshot: current, targets: targets)
        ActiveRecord.after_all_transactions_commit { enqueue_targets(state) }
      end

      def enqueue_targets(state)
        state.targets.each do |identifier, target|
          next unless target['revision'] == state.revision

          enqueue_target(identifier, target, state.revision)
        end
        invalidate_pending
      end

      def enqueue_target(identifier, target, revision)
        user_type, user_id = identifier.split(':')
        recipient = user_type.constantize.find_by(id: user_id)
        return unless recipient

        Notifications::CreateJob.perform_later(
          notification_type: target['type'], recipient: recipient, data: target['data'],
          event_key: "board_event:#{@board_id}:#{revision}:#{identifier}",
          scheduled_at: Time.current
        )
      end

      def invalidate_pending
        Notification.where('event_key LIKE ?', "board_event:#{@board_id}:%")
                    .where(status: %w[pending scheduled]).find_each do |notification|
          next if Validity.call(notification.notification_type, notification.event_key)

          notification.update!(status: 'cancelled')
        end
      end
    end
  end
end
