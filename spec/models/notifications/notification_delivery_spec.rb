require 'rails_helper'

RSpec.describe Notification do
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
