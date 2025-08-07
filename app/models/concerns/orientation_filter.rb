require 'active_support/concern'

module OrientationFilter
  extend ActiveSupport::Concern

  included do
    def self.by_tcc(data, page, term)
      data.includes(:professor_supervisors, :academic, :calendars,
                    advisor: [:scholarity])
          .select('orientations.id, orientations.title, academics.name as academic_name,
              academics.ra, professors.name as advisor_name, calendars.semester,
              calendars.year, calendars.tcc, orientations.status, academics.id as academic_id,
              orientations.advisor_id')
          .search(term)
          .page(page)
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
  end
end
