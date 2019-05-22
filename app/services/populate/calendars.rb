class Populate::Calendars
  attr_reader :current_year

  def initialize
    @current_year = Calendar.current_year.to_i
  end

  def populate
    create_calendars
  end

  private

  def create_calendars
    50.times do |index|
      create_calendar_for_year(@current_year + index)
    end
  end

  def create_calendar_for_year(year)
    2.times do |index|
      Calendar.create(year: year, semester: index + 1, tcc: 1)
      Calendar.create(year: year, semester: index + 1, tcc: 2)
    end
  end
end
