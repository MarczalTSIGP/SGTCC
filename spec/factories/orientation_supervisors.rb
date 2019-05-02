FactoryBot.define do
  factory :orientation_supervisor do
    orientation
    supervisor { create(:professor) }
  end
end
