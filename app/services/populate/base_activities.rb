class Populate::BaseActivities
  attr_reader :tccs, :base_activity_type_ids

  def initialize
    @tccs = BaseActivity.tccs.values
    @base_activity_type_ids = BaseActivityType.pluck(:id)
  end

  def populate
    create_base_activities
  end

  private

  def create_base_activities
    10.times do |index|
      BaseActivity.create(
        name: "Atividade base #{index}",
        tcc: @tccs.sample,
        base_activity_type_id: @base_activity_type_ids.sample
      )
    end
  end
end
