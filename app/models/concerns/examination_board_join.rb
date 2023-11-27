require 'active_support/concern'

module ExaminationBoardJoin
  extend ActiveSupport::Concern

  included do
    def self.join_with_status_by_tcc(tcc, status)
      join_with_status(where(tcc: tcc), status)
    end

    def self.join_with_status(join, status)
      return join if status.blank?

      current_semester_start, current_semester_end = current_semester_dates
      case status
      when 'CURRENT_SEMESTER'
        join.where(date: current_semester_start..current_semester_end)
      when 'OTHER_SEMESTER'
        join.where.not(date: current_semester_start..current_semester_end)
      end
    end

    def self.current_semester_dates
      today = Time.zone.today
      start_month = today.month < 7 ? 1 : 7
      end_month = start_month == 1 ? 6 : 12
      [Date.new(today.year, start_month, 1), Date.new(today.year, end_month, 31)]
    end
  end
end
