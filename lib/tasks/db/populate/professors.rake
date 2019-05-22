namespace :populate do
  desc 'Populate professors'

  task professors: :environment do
    puts 'Populating professors...'
    Populate::Professors.new.populate
  end
end
