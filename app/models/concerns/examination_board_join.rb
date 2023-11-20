require 'active_support/concern'

module ExaminationBoardJoin
  extend ActiveSupport::Concern

  included do
    def self.join_with_status_by_tcc(tcc, status)
      join_with_status(where(tcc: tcc), status)
    end

    def self.join_with_status(join, status)
      return join if status.blank?

      current_semester_start = Date.new(Date.today.year, Date.today.month < 7 ? 1 : 7, 1)
      current_semester_end = Date.new(Date.today.year, Date.today.month < 7 ? 6 : 12, 31)

      if status == 'CURRENT_SEMESTER'
        join.where(date: current_semester_start..current_semester_end)
      elsif status == 'OTHER_SEMESTER'
        join.where.not(date: current_semester_start..current_semester_end)
      end
    end
  end
end