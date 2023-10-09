require Rails.root.join('lib/tasks/db/populate/models/external_members.rb')

namespace :populate do
  desc 'Populate external members'

  task external_members: :environment do
    puts 'Populating external members...'
    Populate::ExternalMembers.new.populate
  end
end
