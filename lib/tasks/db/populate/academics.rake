namespace :populate do
  desc 'Populate academics'

  task academics: :environment do
    require Rails.root.join('lib/tasks/db/populate/academics')
    puts 'Populating academics...'
    Db::Populate::Academics.new.populate
  end
end
