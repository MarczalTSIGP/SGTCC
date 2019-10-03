FactoryBot.define do
  tccs = Calendar.tccs.values
  current_year = Calendar.current_year
  current_semester = Calendar.current_semester
  tcc_one = tccs.first
  tcc_two = tccs.last

  factory :calendar do
    sequence(:year) { |n| Faker::Number.number(4) || "20#{n}" }
    sequence(:semester) { tccs.first || tccs.last }
    tcc { tccs.sample }

    before :create do
      create_list(:base_activity, 4)
    end

    before :destroy do
      activities.destroy_all
    end

    factory :current_calendar do
      year { current_year }
      semester { current_semester }
    end

    factory :current_calendar_tcc_one do
      year { current_year }
      semester { current_semester }
      tcc { tcc_one }
    end

    factory :current_calendar_tcc_two do
      year { current_year }
      semester { current_semester }
      tcc { tcc_two }
    end

    factory :calendar_tcc_one do
      tcc { tcc_one }
    end

    factory :calendar_tcc_two do
      tcc { tcc_two }
    end
  end
end
