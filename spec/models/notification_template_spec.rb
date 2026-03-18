require 'rails_helper'

RSpec.describe NotificationTemplate do
  subject { create(:notification_template) }

  it { is_expected.to have_one(:notification_rule).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:notification_rule) }
  it { is_expected.to validate_presence_of(:key) }
  it { is_expected.to validate_uniqueness_of(:key) }
  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:channel) }

  describe '#rules' do
    let(:template) { create(:notification_template) }

    it 'is an alias for notification_rule' do
      rule = create(:notification_rule, notification_template: template)
      expect(template.rules).to eq(rule)
    end
  end
end
