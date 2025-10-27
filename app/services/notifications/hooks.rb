module Notifications
  module Hooks
    def self.atendees_examination_board_assigned(board)
      recipients = (board.professors + board.external_members + [board.orientation.advisor]).uniq

      recipients.each do |user|
        ::Notifications::SchedulerService.new(
          notification_type: 'atendees_examination_board_assigned',
          recipient: user,
          data: {
            date: board.date.strftime('%d/%m/%Y'),
            place: board.place,
            time: board.date.strftime('%H:%M'),
            academic_name: board.orientation.academic.name,
            orientation_title: board.orientation.title
          },
          event_key: "examination_board:#{board.id}:created:user:#{user.class.name}:#{user.id}" 
        ).schedule!;
      end
    end

    def self.document_uploaded(submission)
      ::Notifications::SchedulerService.new(
        notification_type: 'document_uploaded',
        recipient: submission.academic,
        data: {
          academic_activity_title: submission.title,
          academic_name: submission.academic.name,
          submission_date: submission.created_at.strftime('%d/%m/%Y %H:%M')
        },
        event_key: "submission:#{submission.id}:created:user:#{submission.academic.class.name}:#{submission.academic.id}"
        ).schedule!;
    end

    def self.document_updated(submission)
      ::Notifications::SchedulerService.new(
        notification_type: 'document_updated',
        recipient: submission.academic,
        data: {
          academic_activity_title: submission.title,
          academic_name: submission.academic.name,
          submission_date: submission.updated_at.strftime('%d/%m/%Y %H:%M')
        },
        event_key: "submission:#{submission.id}:updated:user:#{submission.academic.class.name}:#{submission.academic.id}"
        ).schedule!;
    end

    def self.meeting_participation_acknowledgment(meeting)
      ::Notifications::SchedulerService.new(
        notification_type: 'meeting_participation_acknowledgment',
        recipient: meeting.orientation.academic,
        data: {
          advisor_name: meeting.orientation.advisor.name
        },
        event_key: "meeting:#{meeting.id}:orientation:#{meeting.orientation.id}:created:user:#{meeting.orientation.academic.class.name}:#{meeting.orientation.academic.id}"
      ).schedule!;
    end

    def self.activity_calendar_(activity, action)
      orientations = activity.calendar.orientations
      calendar = activity.calendar
      orientations.each do |orientation|
        user = ([orientation.academic] + [orientation.advisor]).uniq
        user.each do |recipient|
          ::Notifications::SchedulerService.new(
            notification_type: "activity_calendar_#{action}",
            recipient: recipient,
            data: {
              activity_name: activity.name,
              tcc_type: I18n.t("enums.tcc.#{activity.tcc}"),
              year: calendar.year,
              semester: I18n.t("enums.semester.#{calendar.semester}"),
              created_at: activity.created_at.strftime('%d/%m/%Y %H:%M'),
              updated_at: activity.updated_at.strftime('%d/%m/%Y %H:%M')
            },
            event_key: "activity_calendar:#{calendar.id}:#{action}:user:#{recipient.class.name}:#{recipient.id}"
          ).schedule!;
        end
      end
    end

    def self.document_created(document)
      orientation = document.orientation

      case document.document_type.identifier
      when 'tdo', 'tep', 'tso'
        notify_responsible(document, orientation)
      when 'adpp', 'adpj', 'admg'
        notify_ad_signature_pending(document, orientation)
      else
        notify_signature_pending(document, orientation)
      end
    end

    def self.academic_examination_board_appointments(examination_board)
      ::Notifications::SchedulerService.new(
        notification_type: 'academic_examination_board_appointments',
        recipient: examination_board.orientation.academic,
        data: {
          date: examination_board.date.strftime('%d/%m/%Y')
        },
        event_key: "examination_board:#{examination_board.id}:appointments:user:#{examination_board.orientation.academic.class.name}:#{examination_board.orientation.academic.id}"
      ).schedule!;
    end

    private

    def self.notify_responsible(document, orientation)
      ::Notifications::SchedulerService.new(
        notification_type: 'term_submission',
        recipient: Professor.current_responsible,
        data: {
          document_type: document.document_type.name,
          orientation: orientation.title,
          academic_name: orientation.academic.name,
          advisor_name: orientation.advisor.name
        },
        event_key: "document:#{document.id}:#{document.document_type.identifier}:created:user:#{Professor.current_responsible.class.name}:#{Professor.current_responsible.id}"
        ).schedule!
    end

    def self.notify_ad_signature_pending(document, orientation)
      examination_board = orientation.examination_boards.last

      document.signatures.each do |signature|
        ::Notifications::SchedulerService.new(
          notification_type: 'document_ad_signature_pending',
          recipient: signature.user,
          data: {
            orientation: orientation.title,
            ad_available_until: examination_board.document_available_until,

          },
          event_key: "document:#{document.id}:unsigned:#{signature.user_type}#{signature.user_id}"
        ).schedule!;
      end
    end

    def self.notify_signature_pending(document, orientation)
      document.signatures.each do |signature|
        user = signature.user
        ::Notifications::SchedulerService.new(
          notification_type: 'document_pending_signature',
          recipient: user,
          data: {
            document_id: signature.document.id,
            document_name: signature.document.document_type.name,
            orientation_id: orientation.id,
            orientation_title: orientation.title,
            user_type: signature.user_type,
            document_type: document.document_type.name
          },
          event_key: "document:#{signature.document.id}:unsigned:#{signature.user_type}#{signature.user_id}"
        ).schedule!
      end
    end

  end
end