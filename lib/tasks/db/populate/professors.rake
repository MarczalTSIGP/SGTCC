require Rails.root.join('lib/tasks/db/populate/models/professors.rb')

namespace :populate do
  desc 'Populate professors'

  task professors: :environment do
    puts 'Populating professors...'
    Populate::Professors.new.populate
  end
end
