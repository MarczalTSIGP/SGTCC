namespace :populate do
  desc 'Populate orientations'

  task orientations: :environment do
    puts 'Populating orientations...'
    Populate::Orientations.new.populate
  end
end
