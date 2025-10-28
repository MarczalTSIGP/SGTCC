require 'rails_helper'

RSpec.describe NotificationTemplate, type: :model do
  subject { create(:notification_template) }

  it { should have_one(:notification_rule).dependent(:destroy) }
  it { should accept_nested_attributes_for(:notification_rule) }
  it { should validate_presence_of(:key) }
  it { should validate_uniqueness_of(:key) }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:channel) }

  describe '#rules' do
    let(:template) { create(:notification_template) }
    it 'is an alias for notification_rule' do
      rule = create(:notification_rule, notification_template: template)
      expect(template.rules).to eq(rule)
    end
  end
end
