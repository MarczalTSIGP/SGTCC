require 'active_support/concern'

module ExaminationBoardJoin
  extend ActiveSupport::Concern

  included do
    def self.join_with_status_by_tcc(tcc, status)
      join_with_status(where(tcc: tcc), status)
    end

    def self.join_with_status(join, status)
      return join if status.blank?

      if status == 'WILL_HAPPEN'
        join.where("date >= ?", Time.now)
      elsif status == 'ALREADY_HAPPENED'
        join.where("date <= ?", Time.now)
      end
    end
  end
end
