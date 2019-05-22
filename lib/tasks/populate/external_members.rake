namespace :populate do
  desc 'Populate external members'

  task external_members: :environment do
    puts 'Populating external members...'

    genders = ExternalMember.genders.values

    100.times do |index|
      ExternalMember.create(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: '123456',
        password_confirmation: '123456',
        is_active: Faker::Boolean.boolean,
        working_area: Faker::Markdown.headers,
        gender: genders.sample,
        personal_page: "http://page.com.#{index}",
        scholarity_id: Scholarity.pluck(:id).sample
      )
    end
  end
end
