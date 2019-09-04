require 'active_support/concern'

module CurrentCalendar
  extend ActiveSupport::Concern

  included do
    def self.current_by_tcc_one
      find_by(year: current_year, semester: current_semester, tcc: tccs[:one])
    end

    def self.current_by_tcc_two
      find_by(year: current_year, semester: current_semester, tcc: tccs[:two])
    end

    def self.current_by_tcc_one?(calendar)
      calendar&.id == current_by_tcc_one&.id
    end

    def self.current_by_tcc_two?(calendar)
      calendar&.id == current_by_tcc_two&.id
    end

    def self.current_calendar?(calendar)
      current_by_tcc_one?(calendar) || current_by_tcc_two?(calendar)
    end

    def self.current_year
      I18n.l(Time.current, format: :year)
    end

    def self.current_month
      I18n.l(Time.current, format: :month)
    end

    def self.current_semester
      current_month.to_i <= 6 ? 1 : 2
    end
  end
end
