module Notifications
  class StopChecker

    def self.met?(notification)
      new(notification).met?
    end

    def initialize(notification)
      @notification = notification
    end

    def met?
      case @notification.notification_type
      when 'document_pending_signature'
        check_signature_status
      
      when 'document_ad_signature_pending'
        ad_date_limit_reached

      when 'meeting_participation_acknowledgment'
        check_meeting_acknowledgment_status

      else
        false
      end
    end

    private

    def check_signature_status
      parts = @notification.event_key.split(':')

      doc_id = parts[1]
      user_type = parts[3]
      user_id = parts[4]

      user_class = user_type.split('_').first.classify.safe_constantize
    
      signature = Signature.find_by(
        id: doc_id,
        user_type: user_class,
        user_id: user_id
      )

      signature.nil? || signature.status == true
    end

    def check_meeting_acknowledgment_status
      parts = @notification.event_key.split(':')

      meeting_id = parts[1]
      orientation_id = parts[3]

      Meeting.find_by(id: meeting_id, orientation_id: orientation_id)&.viewed?
    end

    def ad_date_limit_reached
      parts = @notification.event_key.split(':')

      document_id = parts[1]
      ad = Signature.find_by(id: document_id)

      return if ad.nil? || ad.status == true

      if @notification.data['ad_available_until']
        ad_available_until = Time.zone.parse(@notification.data['ad_available_until'].to_s)
        if Time.current >= ad_available_until
          @notification.update(notification_type: 'document_signature_pending')
          false
        else
          false
        end
      else
        false
      end
    end
  
  end
end