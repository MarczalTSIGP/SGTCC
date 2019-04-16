FactoryBot.define do
  factory :calendar do
    year { Faker::Number.number(4) }
    semester { Calendar.semesters.values.sample }
    tcc { Calendar.tccs.values.sample }
  end
end
