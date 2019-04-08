FactoryBot.define do
  factory :base_activity do
    sequence(:name) { |n| "activity#{n}" }
    tcc { BaseActivity.tccs.values.sample }
    base_activity_type
  end
end
