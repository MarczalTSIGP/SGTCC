namespace :populate do
  desc 'Populate orientations'

  task orientations: :environment do
    require Rails.root.join('lib/tasks/db/populate/orientations')
    puts 'Populating orientations...'
    Db::Populate::Orientations.new.populate
  end
end
