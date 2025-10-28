require 'rails_helper'

RSpec.describe NotificationRule, type: :model do
  it { should belong_to(:notification_template) }
  it { should validate_numericality_of(:days_before).only_integer.is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:hours_before).only_integer.is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:hours_after).only_integer.is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:retry_interval_hours).only_integer.is_greater_than_or_equal_to(0) }

  describe '.for_key' do
    it 'finds the rule by the template key' do
      template = create(:notification_template, key: 'test_key')
      rule = create(:notification_rule, notification_template: template)
      expect(NotificationRule.for_key('test_key')).to eq(rule)
    end
  end
end
