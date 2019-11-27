FactoryBot.define do
  factory :activity do
    sequence(:name) { |n| "activity#{n}" }
    tcc { BaseActivity.tccs.values.sample }
    identifier { Activity.human_tcc_identifiers.values.sample }
    initial_date { Faker::Date.backward(1) }
    final_date { Faker::Date.forward(2) }
    base_activity_type
    calendar
    judgment { true }

    factory :activity_tcc_one do
      tcc { Activity.tccs.values.first }
    end

    factory :activity_tcc_two do
      tcc { Activity.tccs.values.last }
    end

    factory :proposal_activity do
      tcc { Activity.tccs.values.first }
      identifier { :proposal }
    end

    factory :project_activity do
      tcc { Activity.tccs.values.first }
      identifier { :project }
    end

    factory :monograph_activity do
      tcc { Activity.tccs.values.last }
      identifier { :monograph }
    end
  end
end
