namespace :populate do
  desc 'Populate professors'

  task professors: :environment do
    puts 'Populating professors...'

    genders = Professor.genders.values
    professor_type_ids = ProfessorType.pluck(:id)
    scholarity_ids = Scholarity.pluck(:id)
    role_ids = Role.pluck(:id)

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
        professor_type_id: professor_type_ids.sample,
        scholarity_id: scholarity_ids.sample,
        password: '123456',
        password_confirmation: '123456'
      )
      professor.role_ids << role_ids.sample
    end
  end
end
