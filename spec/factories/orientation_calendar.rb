FactoryBot.define do
  factory :orientation_calendar do
    calendar_id { association :calendar }
    orientation { association :orientation }
  end
end
