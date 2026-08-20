require 'rails_helper'

RSpec.describe Notification do
  describe '#set_max_attempts_from_rules' do
    let(:template) { create(:notification_template) }

    context 'when template has a rule' do
      let(:rule) { create(:notification_rule, notification_template: template, max_retries: 5) }

      it 'sets max_attempts from the rule before creation' do
        rule
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
  end
end
