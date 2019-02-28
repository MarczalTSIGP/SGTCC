namespace :db do
  desc 'Erase and fill database'

  task populate: :environment do
    require 'faker'

    [Academic].each(&:delete_all)

    100.times do
      Academic.create(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        ra: Faker::Number.number(7),
        gender: Academic.genders.values.sample,
        password: '123456',
        password_confirmation: '123456'
      )
    end
  end
end
