module Populate
  class Calendars
    attr_reader :current_year

    def initialize
      @semesters_from_now = 6

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

      @semesters_from_now.times do
        create_calendar_for_semester(semester, year)

        if semester == 1
          semester = 2
          year -= 1
        else
          semester = 1
        end
      end
    end

    def create_calendar_for_semester(semester, year)
      Calendar.create!(year: year, semester: semester, tcc: 1)
      Calendar.create!(year: year, semester: semester, tcc: 2)
    end
  end
end
