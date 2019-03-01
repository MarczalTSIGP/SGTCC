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

    100.times do |index|
      Professor.create(
        name: Faker::Name.name,
        email: "professor#{index}@gmail.com",
        username: "professor#{index}",
        gender: Professor.genders.values.sample,
        lattes: "http://lattes.com.#{index}",
        is_active: Faker::Boolean.boolean,
        available_advisor: Faker::Boolean.boolean,
        professor_type_id: 2,
        professor_role_id: 1,
        professor_title_id: 1,
        password: '123456',
        password_confirmation: '123456'
      )
    end
  end
end
