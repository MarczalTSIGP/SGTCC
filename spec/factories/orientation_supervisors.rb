FactoryBot.define do
  factory :orientation_supervisor do
    orientation
    supervisor { association(:professor) }
  end
end
