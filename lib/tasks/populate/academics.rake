namespace :populate do
  desc 'Populate academics'

  task academics: :environment do
    puts 'Populating academics...'
    genders = Academic.genders.values
    100.times do
      Academic.create(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        ra: Faker::Number.number(7),
        gender: genders.sample,
        password: '123456',
        password_confirmation: '123456'
      )
    end
  end
end
