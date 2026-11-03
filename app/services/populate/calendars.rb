class Populate::Calendars
  FIRST_SEMESTER = Calendar.semesters.fetch(:one)
  SECOND_SEMESTER = Calendar.semesters.fetch(:two)

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
      Calendar.create!(year:, semester:, tcc: :two)
      Calendar.create!(year:, semester:, tcc: :one)

      year -= 1 if semester == FIRST_SEMESTER
      semester = semester == FIRST_SEMESTER ? SECOND_SEMESTER : FIRST_SEMESTER
    end
  end
end
