require Rails.root.join('lib/tasks/db/populate/models/base_activities.rb')

namespace :populate do
  desc 'Populate base activities'

  task base_activities: :environment do
    puts 'Populating base activities...'
    Populate::BaseActivities.new.populate
  end
end
