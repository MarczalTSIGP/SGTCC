# app/models/concerns/current_calendar.rb (ou onde estiver definido)
require 'active_support/concern'

module CurrentCalendar
  extend ActiveSupport::Concern

  module ClassMethods
    def current_year
      Time.zone.now.year
    end

    def current_month
      Time.zone.now.month
    end

    def current_semester
      semester_from(current_range_calendar || latest_calendar) || default_semester
    end

    def current_by_tcc_one
      current_by_tcc(:one)
    end

    def current_by_tcc_two
      current_by_tcc(:two)
    end

    def current_by_tcc_one?(calendar)
      calendar&.id == current_by_tcc_one&.id
    end

    def current_by_tcc_two?(calendar)
      calendar&.id == current_by_tcc_two&.id
    end

    def current_calendar?(calendar)
      current_by_tcc_one?(calendar) || current_by_tcc_two?(calendar)
    end

    private

    def current_date
      Date.current
    end

    def current_range_calendar
      where('start_date <= ? AND end_date >= ?', current_date, current_date).first
    end

    def latest_calendar
      order(year: :desc, semester: :desc).first
    end

    def semester_from(calendar)
      return if calendar.blank?

      sem = calendar.semester.to_s.downcase
      %w[two 2].include?(sem) ? 2 : 1
    end

    def default_semester
      current_month <= 7 ? 1 : 2
    end

    def current_by_tcc(tcc_key)
      where(tcc: tccs[tcc_key])
        .where('start_date <= ? AND end_date >= ?', current_date, current_date)
        .order(year: :desc, semester: :desc)
        .first ||
        where(tcc: tccs[tcc_key]).order(end_date: :desc).first
    end
  end
end
