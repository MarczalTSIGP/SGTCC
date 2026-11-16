module Notifications
  module ExaminationBoards
    class Targets
      def initialize(state, current)
        @state = state
        @current = current
        @previous = state.snapshot
        @recipients = current&.fetch('recipients') || @previous.fetch('recipients')
        @previous_recipients = @previous&.fetch('recipients') || {}
      end

      def call
        targets = @current ? @state.targets.dup : {}
        @recipients.each_key do |identifier|
          targets[identifier] = target(notification_type(identifier), identifier)
        end
        return targets unless @current

        @previous_recipients.except(*@recipients.keys).each_key do |identifier|
          targets[identifier] = target('examination_board_removed', identifier)
        end
        targets
      end

      private

      def target(type, identifier)
        { 'type' => type, 'revision' => @state.revision, 'data' => payload(identifier) }
      end

      def notification_type(identifier)
        return 'examination_board_cancelled' unless @current
        return 'examination_board_scheduled' unless @previous

        return 'examination_board_assigned' unless @previous_recipients.key?(identifier)

        pending = pending_target(identifier)
        return pending['type'] if pending

        'examination_board_updated'
      end

      def pending_target(identifier)
        target = @state.targets[identifier]
        target unless target.nil? || target['delivered']
      end

      def baseline_members(identifier)
        pending_target(identifier)&.dig('data', 'baseline_members') || @previous_recipients
      end

      def payload(identifier)
        baseline = baseline_members(identifier)
        snapshot = @current || @previous
        date = Time.zone.parse(snapshot.fetch('date'))
        snapshot.except('recipients').merge(
          'date' => date.strftime('%d/%m/%Y'), 'time' => date.strftime('%H:%M'),
          'baseline_members' => baseline,
          'added_members' => @recipients.except(*baseline.keys).values.join(', '),
          'removed_members' => baseline.except(*@recipients.keys).values.join(', ')
        )
      end
    end
  end
end
