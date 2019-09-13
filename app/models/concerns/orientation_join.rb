require 'active_support/concern'

module OrientationJoin
  extend ActiveSupport::Concern

  included do
    def self.join_with_status_by_tcc(tcc, status, year)
      condition = { tcc: tcc }
      condition['year'] = year if year.present?
      join_with_status(joins(:calendar).where(calendars: condition), status)
    end

    def self.join_with_status(join, status)
      return join if status.blank?
      join.where(status: status)
    end

    def self.join_current_calendar(tcc)
      joins(:calendar).where(calendars: { tcc: tcc,
                                          year: Calendar.current_year,
                                          semester: Calendar.current_semester })
    end

    def self.join_current_calendar_tcc_one
      join_current_calendar(Calendar.tccs[:one])
    end

    def self.join_current_calendar_tcc_two
      join_current_calendar(Calendar.tccs[:two])
    end
  end
end
