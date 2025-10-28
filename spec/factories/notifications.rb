FactoryBot.define do
  factory :notification do
    association :recipient, factory: :professor
    notification_type { 'test.notification' }
    data { { 'example' => 'data' } }
    attempts { 0 }
    max_attempts { 3 }
    status { 'pending' }
    scheduled_at { nil }
  end
end
