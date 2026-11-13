module Orientations
  class TccListQuery
    # rubocop:disable Metrics/ParameterLists
    def self.call(relation:, tcc:, page:, term:, status: nil, period: nil)
      new(relation:, tcc:, page:, term:, status:, period:).call
    end

    def initialize(relation:, tcc:, page:, term:, status: nil, period: nil)
      @relation = relation
      @tcc = tcc.to_s.to_sym
      @page = page
      @term = term
      @status = status
      @period = period&.to_s&.to_sym
    end
    # rubocop:enable Metrics/ParameterLists

    def call
      apply_presentation(tcc_scoped)
    end

    private

    attr_reader :relation, :tcc, :page, :term, :status, :period

    def tcc_scoped
      case period
      when :current
        tcc == :one ? relation.current_tcc_one(status) : relation.current_tcc_two(status)
      else
        tcc == :one ? relation.tcc_one(status) : relation.tcc_two(status)
      end
    end

    def apply_presentation(base)
      base
        .includes(:professor_supervisors, :academic, :calendars, advisor: [:scholarity])
        .select('orientations.id, orientations.title, academics.name as academic_name,
            academics.ra, professors.name as advisor_name, calendars.semester,
            calendars.year, calendars.tcc, orientations.status, academics.id as academic_id,
            orientations.advisor_id')
        .search(term)
        .page(page)
        .recent
    end
  end
end
