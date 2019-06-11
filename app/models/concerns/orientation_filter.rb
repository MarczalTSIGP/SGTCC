require 'active_support/concern'

module OrientationFilter
  extend ActiveSupport::Concern

  included do
    def self.by_tcc(data, page, term)
      data.search(term).page(page).with_relationships
    end

    def self.by_tcc_one(page, term, status = nil)
      by_tcc(tcc_one(status), page, term).recent
    end

    def self.by_tcc_two(page, term, status = nil)
      by_tcc(tcc_two(status), page, term).recent
    end

    def self.by_current_tcc_one(page, term, status = nil)
      by_tcc(current_tcc_one(status), page, term).recent
    end

    def self.by_current_tcc_two(page, term, status = nil)
      by_tcc(current_tcc_two(status), page, term).recent
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
