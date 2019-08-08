namespace :populate do
  desc 'Populate meetings'

  task meetings: :environment do
    puts 'Populating meetings...'
    Populate::Meetings.new.populate
  end
end
