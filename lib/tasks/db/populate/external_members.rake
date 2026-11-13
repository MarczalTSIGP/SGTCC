namespace :populate do
  desc 'Populate external members'

  task external_members: :environment do
    require Rails.root.join('lib/tasks/db/populate/external_members')
    puts 'Populating external members...'
    Db::Populate::ExternalMembers.new.populate
  end
end
