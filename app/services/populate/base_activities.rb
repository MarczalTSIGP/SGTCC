class Populate::BaseActivities
  attr_reader :tccs, :base_activity_type_ids, :identifiers, :tcc_one_identifiers

  def initialize
    @tccs = BaseActivity.tccs
    @base_activity_type_ids = BaseActivityType.pluck(:id)
    @identifiers = BaseActivity.human_tcc_identifiers.values
    @tcc_one_identifiers = BaseActivity.human_tcc_one_identifiers.values
  end

  def populate
    create_base_activities
  end

  private

  def create_base_activities
    tcc_one = @tccs['one']
    tcc_two = @tccs['two']

    BaseActivity.create!(
      name: 'Assinatura do Termo de Compromisso de Orientação',
      tcc: tcc_one,
      base_activity_type_id: @base_activity_type_ids.sample,
      identifier: @tcc_one_identifiers.sample,
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio da Proposta',
      tcc: tcc_one,
      base_activity_type_id: @base_activity_type_ids.sample,
      identifier: @tcc_one_identifiers.sample,
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Defesa da Proposta',
      tcc: tcc_one,
      base_activity_type_id: @base_activity_type_ids.sample,
      identifier: @tcc_one_identifiers.sample,
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio da Versão Final da Proposta',
      tcc: tcc_one,
      base_activity_type_id: @base_activity_type_ids.sample,
      identifier: @tcc_one_identifiers.sample,
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio do Projeto',
      tcc: tcc_one,
      base_activity_type_id: @base_activity_type_ids.sample,
      identifier: @tcc_one_identifiers.sample,
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Defesa do Projeto',
      tcc: tcc_one,
      base_activity_type_id: @base_activity_type_ids.sample,
      identifier: @tcc_one_identifiers.sample,
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio da Versão Final do Projeto',
      tcc: tcc_one,
      base_activity_type_id: @base_activity_type_ids.sample,
      identifier: @tcc_one_identifiers.sample,
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio da Monografia',
      tcc: tcc_two,
      base_activity_type_id: @base_activity_type_ids.sample,
      identifier: @identifiers.last,
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Defesa da Monografia',
      tcc: tcc_two,
      base_activity_type_id: @base_activity_type_ids.sample,
      identifier: @identifiers.last,
      judgment: Faker::Boolean.boolean
    )
    BaseActivity.create!(
      name: 'Envio da Versão Final da Monografia',
      tcc: tcc_two,
      base_activity_type_id: @base_activity_type_ids.sample,
      identifier: @identifiers.last,
      judgment: Faker::Boolean.boolean
    )
  end
end
