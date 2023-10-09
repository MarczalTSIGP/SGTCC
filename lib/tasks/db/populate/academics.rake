require Rails.root.join('lib/tasks/db/populate/models/academics.rb')

namespace :populate do
  desc 'Populate academics'

  task academics: :environment do
    puts 'Populating academics...'
    Populate::Academics.new.populate
  end
end
