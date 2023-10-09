namespace :db do
  desc 'Erase and fill database'

  task populate: :environment do
    require 'faker'

    # populate_tasks = %w[academics professors
    #                     external_members institutions
    #                     base_activities calendars orientations
    #                     meetings examination_boards]

    populate_tasks = %w[
      academics professors
      external_members
      base_activities calendars orientations
    ]

    Rake::Task['db:clean'].invoke
    puts 'DB seed...'
    Rake::Task['db:seed'].invoke
    populate_tasks.each do |populate_task|
      Rake::Task["populate:#{populate_task}"].invoke
    end
  end
end
