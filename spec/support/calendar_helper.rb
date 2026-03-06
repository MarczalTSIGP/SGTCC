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
    normalized_year = year.to_i
    normalized_semester = semester.to_s.downcase

    return [normalized_year, 'one'] if %w[one 1].include?(normalized_semester)
    return [normalized_year, 'two'] if %w[two 2].include?(normalized_semester)
    return [normalized_year + 1, 'one'] if normalized_semester == '3'
    return [normalized_year - 1, 'two'] if normalized_semester == '0'

    raise "Invalid semester #{semester}"
  end

  def date_range_for(year, semester)
    return [Date.new(year, 1, 1), Date.new(year, 6, 30)] if semester == 'one'

    [Date.new(year, 7, 1), Date.new(year, 12, 31)]
  end
end

FactoryBot::SyntaxRunner.include CalendarHelper
