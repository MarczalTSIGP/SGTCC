namespace :populate do
  desc 'Populate base activities'

  task base_activities: :environment do
    puts 'Populating base activities...'
    Populate::BaseActivities.new.populate
  end
end
