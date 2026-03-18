require 'rails_helper'

RSpec.describe Notifications::StopChecker, type: :service do
  include ActiveSupport::Testing::TimeHelpers

  before { freeze_time }

  describe '.met?' do
    context 'when the document is pending signature' do
      let(:notification) do
        build_stubbed(:notification,
                      event_key: 'document:1:unsigned:Professor:5',
                      notification_type: 'document_pending_signature')
      end

      it 'returns true (stop) if the signature was signed (status: true)' do
        signature = instance_double(Signature, status: true)

        allow(Signature).to receive(:find_by)
          .with(hash_including(id: '1', user_type: 'Professor', user_id: '5'))
          .and_return(signature)

        expect(described_class.met?(notification)).to be true
      end

      it 'returns true (stop) if the signature was deleted (nil)' do
        allow(Signature).to receive(:find_by).and_return(nil)

        expect(described_class.met?(notification)).to be true
      end

      it 'returns false (continue) if the signature is still pending (status: false)' do
        signature = instance_double(Signature, status: false)
        allow(Signature).to receive(:find_by).and_return(signature)

        expect(described_class.met?(notification)).to be false
      end
    end

    context 'when the meeting is waiting for acknowledgment' do
      let(:notification) do
        build_stubbed(:notification,
                      notification_type: 'meeting_participation_acknowledgment',
                      event_key: 'meeting:1:orientation:2:user:Academic:3')
      end

      it 'returns true (stop) if the meeting was viewed' do
        meeting = instance_double(Meeting, viewed?: true)
        allow(Meeting).to receive(:find_by).with(id: '1', orientation_id: '2').and_return(meeting)

        expect(described_class.met?(notification)).to be true
      end

      it 'returns false (continue) if the meeting was not viewed' do
        meeting = instance_double(Meeting, viewed?: false)
        allow(Meeting).to receive(:find_by).with(id: '1', orientation_id: '2').and_return(meeting)

        expect(described_class.met?(notification)).to be false
      end

      it 'returns false (continue) if the meeting was not found' do
        allow(Meeting).to receive(:find_by).with(id: '1', orientation_id: '2').and_return(nil)

        expect(described_class).not_to be_met(notification)
      end
    end

    context 'when document ad signature is pending' do
      let(:signature) { instance_double(Signature, status: false) }

      before do
        allow(Signature).to receive(:find_by).with(hash_including(id: '1')).and_return(signature)
      end

      it 'returns false (continue) and changes the notification type if the deadline has passed' do
        notification = create(:notification,
                              notification_type: 'document_ad_signature_pending',
                              event_key: 'document:1:unsigned:Professor:5',
                              data: { 'ad_available_until' => 1.hour.ago.to_s })

        expect(described_class.met?(notification)).to be false

        expect(notification.reload.notification_type).to eq('document_signature_pending')
      end

      it 'returns false (continue) and does not change the type if the deadline has not passed' do
        notification = create(:notification,
                              notification_type: 'document_ad_signature_pending',
                              event_key: 'document:1:unsigned:Professor:5',
                              data: { 'ad_available_until' => 1.hour.from_now.to_s })

        expect(described_class.met?(notification)).to be false

        expect(notification.reload.notification_type).to eq('document_ad_signature_pending')
      end

      it 'returns falsey (stop) if the signature has already been signed (status: true)' do
        notification = build_stubbed(:notification,
                                     notification_type: 'document_ad_signature_pending',
                                     event_key: 'document:1:unsigned:Professor:5')

        signed_signature = instance_double(Signature, status: true)
        allow(Signature).to receive(:find_by).and_return(signed_signature)

        expect(described_class).not_to be_met(notification)
      end
    end

    context 'when other notification types are present' do
      it 'returns false (continue) by default' do
        notification = build_stubbed(:notification, notification_type: 'unknown_type')
        expect(described_class.met?(notification)).to be false
      end
    end
  end
end
