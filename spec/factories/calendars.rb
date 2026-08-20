FactoryBot.define do
  factory :calendar do
    sequence(:year) { |n| (2020 + n).to_s }
    semester { :one }
    tcc { :one }

    start_date do
      sem = semester.to_s
      month = %w[one 1].include?(sem) ? 1 : 7
      Date.new(year.to_i, month, 1)
    end

    end_date do
      sem = semester.to_s
      month = [:one, '1'].include?(sem) ? 6 : 12
      Date.new(year.to_i, month, -1)
    end

    trait :tcc_one do
      tcc { :one }
    end

    trait :tcc_two do
      tcc { :two }
    end

    trait :current do
      year { Calendar.current_year }
      semester { Calendar.current_semester == 1 ? :one : :two }
    end

    trait :previous do
      year { Calendar.current_semester == 1 ? Calendar.current_year - 1 : Calendar.current_year }
      semester { Calendar.current_semester == 1 ? :two : :one }
    end

    trait :next do
      year { Calendar.current_semester == 1 ? Calendar.current_year : Calendar.current_year + 1 }
      semester { Calendar.current_semester == 1 ? :two : :one }
    end
  end
end
