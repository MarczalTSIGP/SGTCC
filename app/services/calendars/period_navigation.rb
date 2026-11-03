module Calendars
  class PeriodNavigation
    private_class_method :new

    def self.previous_semester(calendar)
      return nil if calendar.nil?
      return search_by_semester(calendar, :one) if calendar.semester_two?

      search_by_second_semester_previous_year(calendar)
    end

    def self.next_semester(calendar)
      return search_by_semester(calendar, :two) if calendar.semester_one?

      search_by_first_semester_next_year(calendar)
    end

    def self.next_semester_tcc_two(calendar)
      return next_semester(calendar) if calendar.tcc_two?

      if calendar.semester_one?
        Calendar.find_by(semester: :two, year: calendar.year, tcc: :two)
      else
        Calendar.find_by(semester: :one, year: calendar.year.to_i + 1, tcc: :two)
      end
    end

    private_class_method def self.search_by_semester(calendar, semester)
      Calendar.find_by(semester:, year: calendar.year, tcc: calendar.tcc.to_sym)
    end

    private_class_method def self.search_by_first_semester_next_year(calendar)
      Calendar.find_by(semester: :one, year: calendar.year.to_i + 1, tcc: calendar.tcc.to_sym)
    end

    private_class_method def self.search_by_second_semester_previous_year(calendar)
      Calendar.find_by(semester: :two, year: calendar.year.to_i - 1, tcc: calendar.tcc.to_sym)
    end
  end
end
