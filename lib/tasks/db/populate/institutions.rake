namespace :populate do
  desc 'Populate institutions'

  task institutions: :environment do
    puts 'Populating institutions...'
    Populate::Institutions.new.populate
  end
end
