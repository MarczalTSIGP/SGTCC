module CalendarHelper
  def find_or_create_calendar(year:, semester:, tcc:)
    normalized_year, normalized_semester = normalize_period(year, semester)
    start_date, end_date = date_range_for(normalized_year, normalized_semester)

    Calendar.find_by(year: normalized_year.to_s, semester: normalized_semester, tcc: tcc) ||
      create(:calendar, year: normalized_year.to_s, semester: normalized_semester, tcc: tcc,
                        start_date: start_date, end_date: end_date)
  end

  private

  def normalize_period(year, semester)
    case semester.to_i
    when 1 then [year.to_i, 'one']
    when 2 then [year.to_i, 'two']
    when 3 then [year.to_i + 1, 'one']
    else
      raise "Invalid semester #{semester}"
    end
  end

  def date_range_for(year, semester)
    return [Date.new(year, 1, 1), Date.new(year, 6, 30)] if semester == 'one'

    [Date.new(year, 7, 1), Date.new(year, 12, 31)]
  end
end

FactoryBot::SyntaxRunner.include CalendarHelper
