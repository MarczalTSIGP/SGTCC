module Notifications
  module Hooks
    module Documents
      extend Notifications::HookHelpers

      def self.document_uploaded(submission)
        ek = event_key('submission', submission.id, 'created', 'user',
                       submission.academic.class.name, submission.academic.id)

        schedule_notification(
          notification_type: 'document_uploaded',
          recipient: submission_recipient(submission),
          data: submission_data(submission),
          event_key: ek
        )
      end

      def self.document_updated(submission)
        ek = event_key('submission', submission.id, 'updated', 'user',
                       submission.academic.class.name, submission.academic.id)

        schedule_notification(
          notification_type: 'document_updated',
          recipient: submission_recipient(submission),
          data: submission_data(submission, is_update: true),
          event_key: ek
        )
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

      def self.notify_responsible(document, orientation)
        ek = event_key('document', document.id, document.document_type.identifier,
                       'created', 'user', Professor.current_responsible.class.name,
                       Professor.current_responsible.id)

        schedule_notification(
          notification_type: 'term_submission',
          recipient: Professor.current_responsible,
          data: responsible_data(document, orientation),
          event_key: ek
        )
      end

      def self.notify_ad_signature_pending(document, orientation)
        document.signatures.each do |signature|
          schedule_ad_pending(signature, document, orientation)
        end
      end

      def self.notify_signature_pending(document, orientation)
        document.signatures.each do |signature|
          user = signature.user
          ek = event_key('document', signature.document.id, 'unsigned',
                         "#{signature.user_type}#{signature.user_id}")

          schedule_notification(
            notification_type: 'document_pending_signature',
            recipient: user, event_key: ek,
            data: pending_signature_data(signature, document, orientation)
          )
        end
      end

      private_class_method def self.submission_data(submission, is_update: false)
        submission_date = submission.send(is_update ? :updated_at : :created_at)
                                    .strftime('%d/%m/%Y %H:%M')
        {
          academic_activity_title: submission.title,
          academic_name: submission.academic.name,
          submission_date: submission_date
        }
      end

      private_class_method def self.responsible_data(document, orientation)
        {
          document_type: document.document_type.name,
          orientation: orientation.title,
          academic_name: orientation.academic.name,
          advisor_name: orientation.advisor.name
        }
      end

      private_class_method def self.schedule_ad_pending(signature, document, orientation)
        examination_board = orientation.examination_boards.last

        ek = event_key('document', document.id, 'unsigned',
                       "#{signature.user_type}#{signature.user_id}")

        data = { orientation: orientation.title,
                 ad_available_until: examination_board.document_available_until }

        schedule_notification(
          notification_type: 'document_ad_signature_pending',
          recipient: signature.user, data: data, event_key: ek
        )
      end

      private_class_method def self.pending_signature_data(signature, document, orientation)
        { document_id: signature.document.id,
          created_at: signature.document.created_at.strftime('%d/%m/%Y %H:%M'),
          orientation_id: orientation.id,
          orientation_title: orientation.title,
          user_type: signature.user_type,
          document_type: document.document_type.name }
      end

      private_class_method def self.submission_recipient(submission)
        submission.academic.orientations.first.advisor
      end
    end
  end
end
