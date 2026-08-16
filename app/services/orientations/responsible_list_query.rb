module Orientations
  class ResponsibleListQuery
    VALID_TCCS = {
      one: :tcc_one_relation,
      two: :tcc_two_relation
    }.freeze

    def self.call(tcc:, page:, term:, status: nil)
      new(tcc:, page:, term:, status:).call
    end

    def initialize(tcc:, page:, term:, status: nil)
      @tcc = tcc.to_s.to_sym
      @page = page
      @term = term
      @status = status
    end

    def call
      relation = send(tcc_relation_method)
      relation = relation.where(status:) if status.present?

      relation
        .search(term)
        .order('orientations.created_at DESC')
        .page(page)
    end

    private

    attr_reader :tcc, :page, :term, :status

    def tcc_relation_method
      VALID_TCCS.fetch(tcc) do
        raise ArgumentError, "Invalid TCC value: #{tcc.inspect}"
      end
    end

    def tcc_one_relation
      Orientation
        .joins(:calendars)
        .group('orientations.id')
        .having(
          'COUNT(DISTINCT calendars.tcc) = ? AND MIN(calendars.tcc) = ?',
          1,
          Calendar.tccs.fetch(:one)
        )
    end

    def tcc_two_relation
      tcc_two_orientation_ids =
        Orientation.joins(:calendars)
                   .where(calendars: { tcc: :two })
                   .select(:id)

      Orientation.where(id: tcc_two_orientation_ids)
    end
  end
end
