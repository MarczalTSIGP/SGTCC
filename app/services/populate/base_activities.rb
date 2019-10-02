class Populate::BaseActivities
  attr_reader :tccs, :base_activity_type_ids, :identifiers, :tcc_one_identifiers

  def initialize
    @tccs = BaseActivity.tccs.values
    @base_activity_type_ids = BaseActivityType.pluck(:id)
    @identifiers = BaseActivity.human_identifiers.values
    @tcc_one_identifiers = BaseActivity.human_tcc_one_identifiers.values
  end

  def populate
    create_base_activities
  end

  private

  def create_base_activities
    10.times do |index|
      tcc = @tccs.sample

      BaseActivity.create!(
        name: "Atividade base #{index}",
        tcc: tcc,
        base_activity_type_id: @base_activity_type_ids.sample,
        identifier: tcc == 1 ? @tcc_one_identifiers.sample : @identifiers.last,
        judgment: Faker::Boolean.boolean
      )
    end
  end
end
