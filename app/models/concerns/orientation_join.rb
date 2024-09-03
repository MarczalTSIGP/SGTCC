require 'active_support/concern'

module OrientationJoin
  extend ActiveSupport::Concern

  included do
    def self.join_with_status_by_tcc(tcc, status, year, semester)
      condition = { tcc: }
      condition['year'] = year if year.present?
      condition['semester'] = semester if semester.present?

      query = joins(:calendars).where(calendars: condition)
      join_with_status(query, status)
    end

    def self.join_with_status(join, status)
      return join if status.blank?

      join.where(status:)
    end

    def self.join_current_calendar(tcc)
      joins(:calendars).where(calendars: { tcc:,
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
