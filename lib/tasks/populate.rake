namespace :db do
  desc 'Erase and fill database'

  task populate: :environment do
    require 'populator'
    require 'faker'

    [Academic].each(&:delete_all)

    Academic.populate 100 do |academic|
      academic.name   = Faker::Name.name
      academic.email  = Faker::Internet.email
      academic.ra     = Faker::Number.number(7)
      academic.gender = Academic.genders.values.sample
    end
  end
end
