require 'rails_helper'

RSpec.describe NotificationRule do
  subject(:rule) { described_class.new }

  it { is_expected.to belong_to(:notification_template) }

  it 'validates days_before as a non-negative integer' do
    expect(rule).to validate_numericality_of(:days_before)
      .only_integer
      .is_greater_than_or_equal_to(0)
  end

  it 'validates hours_before as a non-negative integer' do
    expect(rule).to validate_numericality_of(:hours_before)
      .only_integer
      .is_greater_than_or_equal_to(0)
  end

  it 'validates hours_after as a non-negative integer' do
    expect(rule).to validate_numericality_of(:hours_after)
      .only_integer
      .is_greater_than_or_equal_to(0)
  end

  it 'validates retry_interval_hours as a non-negative integer' do
    expect(rule).to validate_numericality_of(:retry_interval_hours)
      .only_integer
      .is_greater_than_or_equal_to(0)
  end

  describe '.for_key' do
    it 'finds the rule by the template key' do
      template = create(:notification_template, key: 'test_key')
      rule = create(:notification_rule, notification_template: template)
      expect(described_class.for_key('test_key')).to eq(rule)
    end
  end
end
