module Calendars
  class ListQuery
    private_class_method :new

    def self.call(tcc:, page:, term:)
      new(tcc:, page:, term:).call
    end

    def initialize(tcc:, page:, term:)
      @tcc = tcc
      @page = page
      @term = term
    end

    def call
      Calendar.where(tcc: @tcc).page(@page).search(@term)
              .order({ year: :desc }, { semester: :desc })
    end
  end
end
