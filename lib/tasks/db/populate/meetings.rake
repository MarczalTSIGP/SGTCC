namespace :populate do
  desc 'Populate meetings'

  task meetings: :environment do
    require Rails.root.join('lib/tasks/db/populate/meetings')
    puts 'Populating meetings...'
    Db::Populate::Meetings.new.populate
  end
end
