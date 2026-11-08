module Calendars
  # Calendário do semestre anterior ou seguinte, no mesmo TCC ou na passagem do TCC I
  # para o TCC II. A aritmética de período (inclusive a virada de ano) é do
  # `AcademicPeriod` (REF-30); aqui fica só a busca.
  class PeriodNavigationQuery
    private_class_method :new

    def self.previous_semester(calendar)
      return nil if calendar.nil?

      find_calendar(AcademicPeriod.from_calendar(calendar).previous, calendar.tcc)
    end

    def self.next_semester(calendar)
      find_calendar(AcademicPeriod.from_calendar(calendar).next, calendar.tcc)
    end

    def self.next_semester_tcc_two(calendar)
      return next_semester(calendar) if calendar.tcc_two?

      find_calendar(AcademicPeriod.from_calendar(calendar).next, :two)
    end

    private_class_method def self.find_calendar(period, tcc)
      Calendar.find_by(semester: period.semester_key, year: period.year.to_s, tcc: tcc.to_sym)
    end
  end
end
