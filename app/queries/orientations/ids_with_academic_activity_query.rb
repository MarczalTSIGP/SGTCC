module Orientations
  # Forma relacional da regra de `AcademicActivityQuery`: os ids das orientações que possuem
  # atividade acadêmica do identificador em um dos seus próprios calendários. Existe para
  # que as listagens públicas filtrem no banco em vez de carregar tudo e descartar em Ruby.
  class IdsWithAcademicActivityQuery
    def self.call(identifier, final_version: true)
      new(identifier, final_version:).call
    end

    def initialize(identifier, final_version: true)
      @identifier = identifier
      @final_version = final_version
    end

    def call
      Orientation
        .joins(:orientation_calendars, academic_activities: :activity)
        .where(activities: { identifier: identifier, final_version: final_version })
        .where('activities.calendar_id = orientation_calendars.calendar_id')
        .select(:id)
    end

    private

    attr_reader :identifier, :final_version
  end
end
