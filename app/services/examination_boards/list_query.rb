module ExaminationBoards
  class ListQuery
    TCC_SCOPES = {
      one: {
        current: :tcc_one_current_semester,
        history: :tcc_one
      },
      two: {
        current: :tcc_two_current_semester,
        history: :tcc_two
      }
    }.freeze

    def self.call(tcc:, period:, page:, term:, ordering:)
      new(tcc:, period:, page:, term:, ordering:).call
    end

    def initialize(tcc:, period:, page:, term:, ordering:)
      @tcc = tcc.to_s.to_sym
      @period = period.to_s.to_sym
      @page = page
      @term = term
      @ordering = ordering.to_s.to_sym
    end

    def call
      ordered(search(base_relation).page(page))
    end

    private

    attr_reader :tcc, :period, :page, :term, :ordering

    def base_relation
      ExaminationBoard.public_send(scope_name)
    end

    def scope_name
      TCC_SCOPES.fetch(tcc).fetch(period)
    rescue KeyError
      raise ArgumentError, "Invalid examination board list: #{tcc.inspect}/#{period.inspect}"
    end

    def search(relation)
      relation.search(term)
    end

    def ordered(relation)
      case ordering
      when :responsible
        responsible_order(relation)
      when :tcc_one_professor
        tcc_one_professor_order(relation)
      else
        raise ArgumentError, "Invalid examination board ordering: #{ordering.inspect}"
      end
    end

    def responsible_order(relation)
      relation.order(date: :desc)
    end

    def tcc_one_professor_order(relation)
      relation.with_relationships.recent
    end
  end
end
