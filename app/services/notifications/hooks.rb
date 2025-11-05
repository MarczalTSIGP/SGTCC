module Notifications
  module Hooks
    extend Notifications::HookHelpers

    def self.meeting_participation_acknowledgment(meeting)
      orientation = meeting.orientation
      ek = event_key('meeting', meeting.id, 'orientation', orientation.id, 'created', 'user',
                     orientation.academic.class.name, orientation.academic.id)
      schedule_notification(
        notification_type: 'meeting_participation_acknowledgment',
        recipient: meeting.orientation.academic,
        data: { advisor_name: meeting.orientation.advisor.name },
        event_key: ek
      )
    end
  end
end
