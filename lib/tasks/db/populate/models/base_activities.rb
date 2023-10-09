module Populate
  class BaseActivities
    attr_reader :tccs, :base_activity_type_ids, :identifiers, :tcc_one_identifiers

    def initialize
      @tcc_one = BaseActivity.tccs.values.first
      @tcc_two = BaseActivity.tccs.values.second

      @info = BaseActivityType.find_by(identifier: :info).id
      @send_document = BaseActivityType.find_by(identifier: :send_document).id
    end

    def populate
      create_tcc_one_base_activities
      create_tcc_two_base_activities
    end

    private

    def create_tcc_one_base_activities
      activities = [
        { name: 'Assinatura do Termo de Compromisso de Orientação',
          type: @info, judgment: false,
          identifier: BaseActivity.identifiers[:proposal] },
        { name: 'Envio da Proposta', type: @send_document, judgment: true,
          identifier: BaseActivity.identifiers[:proposal] },
        { name: 'Defesa de Proposta', type: @info, judgment: false,
          identifier: BaseActivity.identifiers[:proposal] },
        { name: 'Envio da Versão Final da Proposta', type: @send_document, judgment: true,
          identifier: BaseActivity.identifiers[:proposal], final_version: true },
        { name: 'Envio do Projeto', type: @send_document, judgment: true,
          identifier: BaseActivity.identifiers[:project] },
        { name: 'Defesa do Projeto', type: @info, judgment: false,
          identifier: BaseActivity.identifiers[:project] },
        { name: 'Envio da Versão Final do Projeto', type: @send_document, judgment: false,
          identifier: BaseActivity.identifiers[:project], final_version: true }
      ]

      activities.each do |activity|
        BaseActivity.create!(
          name: activity[:name],
          tcc: @tcc_one,
          base_activity_type_id: activity[:type],
          identifier: activity[:identifier],
          judgment: activity[:judgment],
          final_version: activity[:final_version]
        )
      end
    end

    def create_tcc_two_base_activities
      activities = [
        { name: 'Envio da Monografia', type: @send_document, judgment: true },
        { name: 'Defesa da Monografia', type: @info, judgment: false },
        { name: 'Envio da Versão Final da Monografia', type: @send_document, judgment: true,
          final_version: true }
      ]

      activities.each do |activity|
        BaseActivity.create!(
          name: activity[:name],
          tcc: @tcc_two,
          base_activity_type_id: activity[:type],
          identifier: BaseActivity.identifiers[:monograph],
          judgment: activity[:judgment],
          final_version: activity[:final_version]
        )
      end
    end
  end
end
