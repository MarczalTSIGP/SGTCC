namespace :populate do
  desc 'Populate professors'

  task professors: :environment do
    puts 'Populating professors...'

    genders = Professor.genders.values

    100.times do |index|
      professor = Professor.create(
        name: Faker::Name.name,
        email: "professor#{index}@gmail.com",
        username: "professor#{index}",
        gender: genders.sample,
        lattes: "http://lattes.com.#{index}",
        is_active: Faker::Boolean.boolean,
        available_advisor: Faker::Boolean.boolean,
        working_area: Faker::Markdown.headers,
        professor_type_id: ProfessorType.pluck(:id).sample,
        scholarity_id: Scholarity.pluck(:id).sample,
        password: '123456',
        password_confirmation: '123456'
      )
      offset = rand(Role.count)
      professor.roles << Role.offset(offset).first
    end
  end
end
