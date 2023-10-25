class Populate::BaseActivities
  attr_reader :tccs, :base_activity_type_ids, :identifiers, :tcc_one_identifiers

  def initialize
    @tcc_one = BaseActivity.tccs.values.first
    @tcc_two = BaseActivity.tccs.values.second
    @info = BaseActivityType.find_by(identifier: :info).id
    @send_document = BaseActivityType.find_by(identifier: :send_document).id
  end

  def populate
    create_base_activities
  end

  private

  def create_base_activities
    BaseActivity.create!(
      name: 'Assinatura do Termo de Compromisso de Orientação',
      tcc: @tcc_one,
      interval: 53,
      increment_date: 0,
      base_activity_type_id: @info,
      identifier: BaseActivity.identifiers[:proposal],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio da Proposta',
      tcc: @tcc_one,
      interval: 48,
      increment_date: 15,
      base_activity_type_id: @send_document,
      identifier: BaseActivity.identifiers[:proposal],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Defesa da Proposta',
      tcc: @tcc_one,
      interval: 7,
      increment_date: 69,
      base_activity_type_id: @info,
      identifier: BaseActivity.identifiers[:proposal],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio da Versão Final da Proposta',
      tcc: @tcc_one,
      interval: 42,
      increment_date: 41,
      base_activity_type_id: @send_document,
      identifier: BaseActivity.identifiers[:proposal],
      judgment: Faker::Boolean.boolean,
      final_version: true
    )
    BaseActivity.create!(
      name: 'Envio do Projeto',
      tcc: @tcc_one,
      interval: 60,
      increment_date: 44,
      base_activity_type_id: @send_document,
      identifier: BaseActivity.identifiers[:project],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Defesa do Projeto',
      tcc: @tcc_one,
      interval: 7,
      increment_date: 111,
      base_activity_type_id: @info,
      identifier: BaseActivity.identifiers[:project],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio da Versão Final do Projeto',
      tcc: @tcc_one,
      interval: 15,
      increment_date: 117,
      base_activity_type_id: @send_document,
      identifier: BaseActivity.identifiers[:project],
      judgment: Faker::Boolean.boolean,
      final_version: true
    )
    BaseActivity.create!(
      name: 'Envio da Monografia',
      tcc: @tcc_two,
      interval: 109,
      increment_date: 0,
      base_activity_type_id: @send_document,
      identifier: BaseActivity.identifiers[:monograph],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Defesa da Monografia',
      tcc: @tcc_two,
      interval: 4,
      increment_date: 117,
      base_activity_type_id: @info,
      identifier: BaseActivity.identifiers[:monograph],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio da Versão Final da Monografia',
      tcc: @tcc_two,
      interval: 130,
      increment_date: 0,
      base_activity_type_id: @send_document,
      identifier: BaseActivity.identifiers[:monograph],
      judgment: Faker::Boolean.boolean,
      final_version: true
    )
  end
end
