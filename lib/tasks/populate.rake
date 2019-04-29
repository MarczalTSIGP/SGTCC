namespace :db do
  desc 'Erase and fill database'

  task populate: :environment do
    require 'faker'
    require 'cpf_cnpj'

<<<<<<< HEAD
    [OrientationSupervisor,
     Orientation,
     Academic,
=======
    [Academic,
>>>>>>> Add responsible/orientations feature tests
     Institution,
     ExternalMember,
     BaseActivity,
     Activity,
<<<<<<< HEAD
     Calendar].each(&:delete_all)
=======
     Calendar,
     Orientation].each(&:delete_all)
>>>>>>> Add responsible/orientations feature tests

    Professor.where.not(username: 'marczal').destroy_all

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
      professor = Professor.create(
        name: Faker::Name.name,
        email: "professor#{index}@gmail.com",
        username: "professor#{index}",
        gender: Professor.genders.values.sample,
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

    100.times do |index|
      ExternalMember.create(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: '123456',
        password_confirmation: '123456',
        is_active: Faker::Boolean.boolean,
        working_area: Faker::Markdown.headers,
        gender: Academic.genders.values.sample,
        personal_page: "http://page.com.#{index}",
        scholarity_id: Scholarity.pluck(:id).sample
      )
    end

    100.times do
      Institution.create(
        name: Faker::Company.name,
        trade_name: Faker::Company.buzzword,
        cnpj: CNPJ.generate,
        external_member_id: ExternalMember.pluck(:id).sample
      )
    end

    50.times do
      Orientation.create(
        title: Faker::Lorem.sentence(3),
        calendar_id: Calendar.pluck(:id).sample,
        advisor_id: Professor.pluck(:id).sample,
        academic_id: Academic.pluck(:id).sample,
        institution_id: Institution.pluck(:id).sample
      )
    end

    10.times do |index|
      BaseActivity.create(
        name: "Atividade base #{index}",
        tcc: BaseActivity.tccs.values.sample,
        base_activity_type_id: BaseActivityType.pluck(:id).sample
      )
    end

    50.times do |index|
      create_calendar_for_year(Calendar.current_year.to_i + index)
    end

    50.times do
      create_orientation_by_calendar(Calendar.current_by_tcc_one.id)
      create_orientation_by_calendar(Calendar.current_by_tcc_two.id)
      create_orientation_by_calendar(Calendar.pluck(:id).sample)
    end
  end

  def create_calendar_for_year(year)
    2.times do |index|
      Calendar.create(year: year, semester: index + 1, tcc: 1)
      Calendar.create(year: year, semester: index + 1, tcc: 2)
    end
  end

  def create_orientation_by_calendar(calendar_id)
    Orientation.create(
      title: Faker::Lorem.sentence(3),
      calendar_id: calendar_id,
      advisor_id: Professor.pluck(:id).sample,
      academic_id: Academic.pluck(:id).sample,
      institution_id: Institution.pluck(:id).sample
    )
  end
end
