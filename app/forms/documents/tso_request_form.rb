module Documents
  # Entrada do pedido de troca de orientação (TSO) e a pergunta que o controller precisa
  # responder: a orientação pedida mudou em relação à que está gravada no documento?
  # Se mudou, o documento é recriado, porque o `request` descreve a orientação inteira.
  class TsoRequestForm < ApplicationForm
    attribute :justification
    attribute :advisor_id
    attribute :professor_supervisor_ids, default: -> { [] }
    attribute :external_member_supervisor_ids, default: -> { [] }

    # Os selects múltiplos enviam um "" escondido antes dos ids; ele é descartado aqui,
    # sem alterar os params recebidos.
    def professor_supervisor_ids
      selected_ids(super)
    end

    def external_member_supervisor_ids
      selected_ids(super)
    end

    def orientation_changed?(document)
      requested = document.request['new_orientation']

      advisor_id.to_i != requested['advisor']['id'] ||
        professor_supervisor_ids != requested['professorSupervisors'].pluck('id') ||
        external_member_supervisor_ids != requested['externalMemberSupervisors'].pluck('id')
    end

    private

    def selected_ids(values)
      Array(values).compact_blank.map(&:to_i)
    end
  end
end
