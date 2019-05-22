namespace :populate do
  desc 'Populate orientations'

  task orientations: :environment do
    puts 'Populating orientations...'

    50.times do
      create_orientation_by_calendar(Calendar.current_by_tcc_one.id)
      create_orientation_by_calendar(Calendar.current_by_tcc_two.id)
      create_orientation_by_calendar(Calendar.pluck(:id).sample)
    end
  end

  def create_orientation_by_calendar(calendar_id)
    Orientation.create(
      title: Faker::Lorem.sentence(3),
      calendar_id: calendar_id,
      advisor_id: Professor.pluck(:id).sample,
      academic_id: Academic.pluck(:id).sample,
      institution_id: Institution.pluck(:id).sample
    )
  end
end
