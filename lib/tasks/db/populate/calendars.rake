namespace :populate do
  desc 'Populate calendars'

  task calendars: :environment do
    puts 'Populating calendars...'
    Populate::Calendars.new.populate
  end
end
