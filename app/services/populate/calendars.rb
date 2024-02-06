class Populate::Calendars
  attr_reader :current_year

  def initialize
    @current_year = Calendar.current_year.to_i
    @current_semester = Calendar.current_semester
  end

  def populate
    create_calendars
  end

  private

  def create_calendars
    year = @current_year
    semester = @current_semester

    4.times do |_index|
      # this order is important to the populate
      Calendar.create!(year:, semester:, tcc: 2)
      Calendar.create!(year:, semester:, tcc: 1)

      year -= 1 if semester == 1
      semester = semester == 1 ? 2 : 1
    end
  end
end
