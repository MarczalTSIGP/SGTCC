FactoryBot.define do
  factory :calendar do
    year { Calendar.current_year }
    semester { Calendar.current_semester }
    tcc { Calendar.tccs.values.sample }

    factory :calendar_tcc_one do
      tcc { Activity.tccs.values.first }
    end

    factory :calendar_tcc_two do
      tcc { Activity.tccs.values.last }
    end
  end
end
