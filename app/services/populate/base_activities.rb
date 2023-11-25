class Populate::BaseActivities
  attr_reader :tccs, :base_activity_type_ids, :identifiers, :tcc_one_identifiers

  def initialize
    @tcc_one = BaseActivity.tccs.values.first
    @tcc_two = BaseActivity.tccs.values.second
    @info = BaseActivityType.find_by(identifier: :info).id
    @send_document = BaseActivityType.find_by(identifier: :send_document).id
  end

  def populate
    create_base_activities_for_tcc_one
    create_base_activities_for_tcc_two
  end

  private

  def create_base_activities_for_tcc_one
    BaseActivity.create!(
      name: 'Assinatura do Termo de Compromisso de Orientação',
      tcc: @tcc_one,
      duration_in_days: 53,
      days_to_start: 0,
      base_activity_type_id: @info,
      identifier: BaseActivity.identifiers[:proposal],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio da Proposta',
      tcc: @tcc_one,
      duration_in_days: 48,
      days_to_start: 15,
      base_activity_type_id: @send_document,
      identifier: BaseActivity.identifiers[:proposal],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Defesa da Proposta',
      tcc: @tcc_one,
      duration_in_days: 7,
      days_to_start: 69,
      base_activity_type_id: @info,
      identifier: BaseActivity.identifiers[:proposal],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio da Versão Final da Proposta',
      tcc: @tcc_one,
      duration_in_days: 42,
      days_to_start: 41,
      base_activity_type_id: @send_document,
      identifier: BaseActivity.identifiers[:proposal],
      judgment: Faker::Boolean.boolean,
      final_version: true
    )
    BaseActivity.create!(
      name: 'Envio do Projeto',
      tcc: @tcc_one,
      duration_in_days: 60,
      days_to_start: 44,
      base_activity_type_id: @send_document,
      identifier: BaseActivity.identifiers[:project],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Defesa do Projeto',
      tcc: @tcc_one,
      duration_in_days: 7,
      days_to_start: 111,
      base_activity_type_id: @info,
      identifier: BaseActivity.identifiers[:project],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio da Versão Final do Projeto',
      tcc: @tcc_one,
      duration_in_days: 15,
      days_to_start: 117,
      base_activity_type_id: @send_document,
      identifier: BaseActivity.identifiers[:project],
      judgment: Faker::Boolean.boolean,
      final_version: true
    )
  end

  def create_base_activities_for_tcc_two
    BaseActivity.create!(
      name: 'Envio da Monografia',
      tcc: @tcc_two,
      duration_in_days: 109,
      days_to_start: 0,
      base_activity_type_id: @send_document,
      identifier: BaseActivity.identifiers[:monograph],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Defesa da Monografia',
      tcc: @tcc_two,
      duration_in_days: 4,
      days_to_start: 117,
      base_activity_type_id: @info,
      identifier: BaseActivity.identifiers[:monograph],
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio da Versão Final da Monografia',
      tcc: @tcc_two,
      duration_in_days: 130,
      days_to_start: 0,
      base_activity_type_id: @send_document,
      identifier: BaseActivity.identifiers[:monograph],
      judgment: Faker::Boolean.boolean,
      final_version: true
    )
  end
end
