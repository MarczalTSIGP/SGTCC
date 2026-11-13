module Activities
  # Acadêmico no contexto da entrega de uma atividade: acrescenta se ele enviou o
  # documento e a orientação usada para montar o link. Todo o resto é delegado ao
  # `Academic` por `SimpleDelegator`, que também responde `respond_to?` corretamente.
  class AcademicResponseDecorator < SimpleDelegator
    attr_reader :orientation

    def initialize(academic, sent, orientation)
      super(academic)
      @sent = sent
      @orientation = orientation
    end

    def sent?
      @sent
    end
  end
end
