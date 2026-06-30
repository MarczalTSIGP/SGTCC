require 'rails_helper'

RSpec.describe Notification do
  describe 'scopes' do
    describe '.pending_to_send' do
      before { freeze_time }

      let!(:pending_now) { create(:notification, status: 'pending', scheduled_at: nil) }
      let!(:scheduled_past) do
        create(:notification, status: 'scheduled', scheduled_at: Time.current)
      end
      let!(:scheduled_future) do
        create(:notification, status: 'scheduled', scheduled_at: 2.hours.from_now)
      end
      let!(:sent) { create(:notification, status: 'sent') }

      it 'returns only pending or scheduled notifications ready to send' do
        result = described_class.pending_to_send
        expect(result).to contain_exactly(pending_now, scheduled_past)
        expect(result).not_to include(scheduled_future, sent)
      end
    end
  end
end
