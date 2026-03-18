FactoryBot.define do
  factory :notification_template do
    sequence(:key) { |n| "template_key_#{n}" }
    title { 'Default Title' }
    subject { 'Default Subject' }
    body { 'Default Body %<variable>s' }
    channel { 'email' }
    active { true }
  end
end
