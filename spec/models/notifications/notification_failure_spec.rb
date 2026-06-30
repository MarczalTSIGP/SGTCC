require 'rails_helper'

RSpec.describe Notification do
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
end
