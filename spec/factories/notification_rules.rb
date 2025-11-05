FactoryBot.define do
  factory :notification_rule do
    notification_template

    days_before { 1 }
    hours_before { 2 }
    hours_after { 0 }
    retry_interval_hours { 24 }
  end
end
