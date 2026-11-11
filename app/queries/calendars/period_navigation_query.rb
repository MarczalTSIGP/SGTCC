module Calendars
  # Calendário do semestre anterior ou seguinte, no mesmo TCC ou na passagem do TCC I
  # para o TCC II. A aritmética de período (inclusive a virada de ano) é do
  # `AcademicPeriod` (REF-30); aqui fica só a busca.
  #
  # `direction` aceita `:previous`, `:next` e `:next_tcc_two`.
  class PeriodNavigationQuery
    def self.call(calendar, direction:)
      new(calendar, direction:).call
    end

    def initialize(calendar, direction:)
      @calendar = calendar
      @direction = direction
    end

    def call
      case direction
      when :previous then previous_semester
      when :next then next_semester
      when :next_tcc_two then next_semester_tcc_two
      else raise ArgumentError, "Unsupported direction: #{direction.inspect}"
      end
    end

    private

    attr_reader :calendar, :direction

    def previous_semester
      return nil if calendar.nil?

      find_calendar(AcademicPeriod.from_calendar(calendar).previous, calendar.tcc)
    end

    def next_semester
      find_calendar(AcademicPeriod.from_calendar(calendar).next, calendar.tcc)
    end

    def next_semester_tcc_two
      return next_semester if calendar.tcc_two?

      find_calendar(AcademicPeriod.from_calendar(calendar).next, :two)
    end

    def find_calendar(period, tcc)
      Calendar.find_by(semester: period.semester_key, year: period.year.to_s, tcc: tcc.to_sym)
    end
  end
end
