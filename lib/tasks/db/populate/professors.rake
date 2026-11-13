namespace :populate do
  desc 'Populate professors'

  task professors: :environment do
    require Rails.root.join('lib/tasks/db/populate/professors')
    puts 'Populating professors...'
    Db::Populate::Professors.new.populate
  end
end
