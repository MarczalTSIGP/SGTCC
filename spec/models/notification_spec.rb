require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:recipient) }
  end

  describe 'enums' do
    it do
      is_expected.to define_enum_for(:status).with_values(
        pending: 'pending', scheduled: 'scheduled', sent: 'sent', failed: 'failed', cancelled: 'cancelled'
      ).backed_by_column_of_type(:text)
    end
  end

  describe 'callbacks' do
    describe '#set_max_attempts_from_rules' do
      let(:template) { create(:notification_template) }

      context 'when template has a rule' do
        let!(:rule) { create(:notification_rule, notification_template: template, max_retries: 5) }

        it 'sets max_attempts from the rule before creation' do
          notification = build(:notification, notification_type: template.key)
          expect(notification.max_attempts).to eq(3)
          notification.save!
          expect(notification.max_attempts).to eq(5)
        end
      end

      context 'when template has no rule' do
        it 'sets max_attempts to the default (3) before creation' do
          notification = build(:notification, notification_type: template.key)
          expect(notification.max_attempts).to eq(3)
          notification.save!
          expect(notification.max_attempts).to eq(3)
        end
      end

      context 'when template association method is rules' do
        let!(:rule) { create(:notification_rule, notification_template: template, max_retries: 5) }

        it 'correctly fetches rule using rules method' do
          allow_any_instance_of(NotificationTemplate).to receive(:rules).and_return(rule)
          expect_any_instance_of(NotificationTemplate).not_to receive(:notification_rule)

          notification = create(:notification, notification_type: template.key)
          expect(notification.max_attempts).to eq(5)
        end
      end
    end
  end


  describe 'scopes' do
    describe '.pending_to_send' do
      around do |example|
        travel_to Time.current do
          example.run
        end
      end

      let!(:pending_now) { create(:notification, status: 'pending', scheduled_at: nil) }
      let!(:scheduled_past) { create(:notification, status: 'scheduled', scheduled_at: Time.current) }
      let!(:scheduled_future) { create(:notification, status: 'scheduled', scheduled_at: 2.hours.from_now) }
      let!(:sent) { create(:notification, status: 'sent') }

      it 'returns only pending or scheduled notifications ready to send' do
        result = described_class.pending_to_send
        expect(result).to contain_exactly(pending_now, scheduled_past)
        expect(result).not_to include(scheduled_future, sent)
      end
    end
  end

  describe '#mark_sent!' do
    let(:notification) { create(:notification, status: 'pending', attempts: 1) }

    it 'updates status to sent and sets sent_at' do
      freeze_time do
        notification.mark_sent!
        expect(notification.status).to eq('sent')
        expect(notification.sent_at).to eq(Time.current)
      end
    end

    it 'does not increment attempts' do
       expect { notification.mark_sent! }.not_to change(notification, :attempts)
    end
  end

  describe '#mark_failed!' do
    let(:notification) { create(:notification, status: 'pending') }

    it 'updates status to failed and sets last_attempted_at' do
       freeze_time do
         notification.mark_failed!
         expect(notification.status).to eq('failed')
         expect(notification.last_attempted_at).to eq(Time.current)
       end
    end

     it 'does not increment attempts' do
        expect { notification.mark_failed! }.not_to change(notification, :attempts)
     end
  end


  describe '#payload' do
    it 'returns the data hash if present' do
      data = { 'key' => 'value' }
      notification = build(:notification, data: data)
      expect(notification.payload).to eq(data)
    end

    it 'returns empty hash if no data' do
      notification = build(:notification, data: nil)
      expect(notification.payload).to eq({})
    end
  end
end