module Orientations
  # Busca o documento de atividade acadêmica de uma orientação por identificador.
  # Entre as atividades dos calendários da orientação, devolve a do calendário mais
  # recente, ou `nil` quando não há nenhuma.
  class AcademicActivityFinder
    def self.call(orientation, identifier, final_version: false)
      new(orientation, identifier, final_version:).call
    end

    # Forma relacional da mesma regra: os ids das orientações que possuem atividade
    # acadêmica do identificador em um dos seus próprios calendários. Existe para que as
    # listagens públicas filtrem no banco em vez de carregar tudo e descartar em Ruby.
    def self.orientation_ids(identifier, final_version: true)
      Orientation
        .joins(:orientation_calendars, academic_activities: :activity)
        .where(activities: { identifier: identifier, final_version: final_version })
        .where('activities.calendar_id = orientation_calendars.calendar_id')
        .select(:id)
    end

    def initialize(orientation, identifier, final_version: false)
      @orientation = orientation
      @identifier = identifier
      @final_version = final_version
    end

    def call
      orientation.academic_activities
                 .joins(:activity)
                 .includes(activity: :calendar)
                 .where(activities: {
                          identifier:,
                          final_version:,
                          calendar_id: [orientation.calendars.pluck(:id)]
                        })
                 .order('calendars.year DESC, calendars.semester DESC')
                 .try(:first)
    end

    private

    attr_reader :orientation, :identifier, :final_version
  end
end
