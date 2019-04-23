namespace :db do
  desc 'Erase and fill database'

  task populate: :environment do
    require 'faker'
    require 'cpf_cnpj'

    [Academic, Institution, ExternalMember, BaseActivity, Activity, Calendar].each(&:delete_all)
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

    10.times do |index|
      BaseActivity.create(
        name: "Atividade base #{index}",
        tcc: BaseActivity.tccs.values.sample,
        base_activity_type_id: BaseActivityType.pluck(:id).sample
      )
    end

    2.times do |index|
      Calendar.create(
        year: '2019',
        semester: index + 1,
        tcc: index + 1
      )
    end

    10.times do |index|
      tcc = Activity.tccs.values.sample

      Activity.create(
        name: "Atividade #{index}",
        tcc: tcc,
        base_activity_type_id: BaseActivityType.pluck(:id).sample,
        calendar_id: Calendar.where(tcc: tcc).pluck(:id).sample,
        initial_date: Faker::Date.forward(1),
        final_date: Faker::Date.forward(2)
      )
    end
  end
end
