namespace :populate do
  desc 'Populate base activities'

  task base_activities: :environment do
    require Rails.root.join('lib/tasks/db/populate/base_activities')
    puts 'Populating base activities...'
    Db::Populate::BaseActivities.new.populate
  end
end
