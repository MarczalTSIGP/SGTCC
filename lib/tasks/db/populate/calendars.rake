namespace :populate do
  desc 'Populate calendars'

  task calendars: :environment do
    require Rails.root.join('lib/tasks/db/populate/calendars')
    puts 'Populating calendars...'
    Db::Populate::Calendars.new.populate
  end
end
