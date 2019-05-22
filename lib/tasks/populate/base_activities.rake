namespace :populate do
  desc 'Populate base activities'

  task base_activities: :environment do
    puts 'Populating base activities...'

    tccs = BaseActivity.tccs.values
    10.times do |index|
      BaseActivity.create(
        name: "Atividade base #{index}",
        tcc: tccs.sample,
        base_activity_type_id: BaseActivityType.pluck(:id).sample
      )
    end
  end
end
