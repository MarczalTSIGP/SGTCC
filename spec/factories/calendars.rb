FactoryBot.define do
  factory :calendar do
    sequence(:year) { |n| (2020 + n).to_s }
    semester { :one }
    tcc { :one }

    start_date do
      sem = semester.to_s
      month = (sem == 'one'|| sem == '1') ? 1 : 7
      Date.new(year.to_i, month, 1)
    end

  end_date do
    sem = semester.to_s
    month = (sem == :one || sem == '1') ? 6 : 12
    Date.new(year.to_i, month, -1)
  end

    factory :current_calendar do
      year     { Calendar.current_year }
      semester { { 1 => :one, 2 => :two }[Calendar.current_semester] }
      tcc      { :one }
    end

    factory :current_calendar_tcc_one do
      tcc      { :one }
      year     { Calendar.current_year }
      semester { { 1 => :one, 2 => :two }[Calendar.current_semester] }
    end

    factory :current_calendar_tcc_two do
      tcc      { :two }
      year     { Calendar.current_year }
      semester { { 1 => :one, 2 => :two }[Calendar.current_semester] }
    end

    factory :calendar_tcc_one do
      tcc { :one }
      sequence(:year) { |n| (2030 + n).to_s }
    end

    factory :calendar_tcc_two do
      tcc { :two }
      sequence(:year) { |n| (2040 + n).to_s }
    end

    factory :next_calendar_tcc_one do
      tcc { :one }

      transient do
        current_calendar { nil }
      end

      year do
        base = current_calendar || Calendar.find_by(tcc: :one, year: Calendar.current_year, semester: Calendar.current_semester)
        base.semester.to_i == 1 ? base.year.to_i : base.year.to_i + 1
      end

      semester do
        base = current_calendar || Calendar.find_by(tcc: :one, year: Calendar.current_year, semester: Calendar.current_semester)
        base.semester.to_i == 1 ? :two : :one
      end
    end

    factory :next_calendar_tcc_two do
      tcc { :two }

      transient do
        current_calendar { nil }
      end

      year do
        base = current_calendar || Calendar.find_by(tcc: :two, year: Calendar.current_year, semester: Calendar.current_semester)
        base.semester.to_i == 1 ? base.year.to_i : base.year.to_i + 1
      end

      semester do
        base = current_calendar || Calendar.find_by(tcc: :two, year: Calendar.current_year, semester: Calendar.current_semester)
        base.semester.to_i == 1 ? :two : :one
      end
    end

    factory :previous_calendar_tcc_one do
      tcc { :one }
      year do
        Calendar.current_semester == 1 ? Calendar.current_year - 1 : Calendar.current_year
      end
      semester do
        Calendar.current_semester.to_i == 1 ? :two : :one
      end
    end

    factory :previous_calendar_tcc_two do
      tcc { :two }
      year do
        Calendar.current_semester == 1 ? Calendar.current_year - 1 : Calendar.current_year
      end
      semester do
        Calendar.current_semester.to_i == 1 ? :two : :one
      end
    end
  end
end
