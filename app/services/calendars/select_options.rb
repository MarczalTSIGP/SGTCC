module Calendars
  class SelectOptions
    def self.for_tcc(tcc)
      Calendar.where(tcc:).order({ year: :desc }, :semester).map do |calendar|
        [calendar.id, calendar.year_with_semester]
      end
    end

    def self.for_orientation
      Calendar.order({ year: :desc }, :tcc, :semester).map do |calendar|
        [calendar.id, calendar.year_with_semester_and_tcc]
      end
    end
  end
end
