namespace :populate do
  desc 'Populate institutions'

  task institutions: :environment do
    require Rails.root.join('lib/tasks/db/populate/institutions')
    puts 'Populating institutions...'
    Db::Populate::Institutions.new.populate
  end
end
