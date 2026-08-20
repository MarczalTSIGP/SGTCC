require 'rails_helper'

RSpec.describe Notification do
  describe 'associations' do
    it { is_expected.to belong_to(:recipient) }
  end

  describe 'enums' do
    subject(:notification) { described_class.new }

    it 'defines status enum correctly' do
      expect(notification).to define_enum_for(:status).with_values(
        pending: 'pending',
        scheduled: 'scheduled',
        sent: 'sent',
        failed: 'failed',
        cancelled: 'cancelled'
      ).backed_by_column_of_type(:string)
    end
  end
end
