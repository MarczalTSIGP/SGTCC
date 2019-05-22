namespace :populate do
  desc 'Populate external members'

  task external_members: :environment do
    puts 'Populating external members...'
    Populate::ExternalMembers.new.populate
  end
end
