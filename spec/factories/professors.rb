FactoryBot.define do
  factory :professor do
    sequence(:name) { |n| "Professor #{n}" }
    sequence(:username) { |n| "professor#{n}" }
    sequence(:email) { |n| "professor#{n}@gmail.com" }
    sequence(:lattes) { |n| "http://lattes.com.#{n}" }
    gender { Professor.genders.values.sample }
    is_active { Faker::Boolean.boolean }
    available_advisor { Faker::Boolean.boolean }
    working_area { Faker::Markdown.headers }
    password { 'password' }
    password_confirmation { 'password' }
    professor_type
    scholarity

    factory :professor_inactive do
      is_active { false }
      available_advisor { false }
    end

    factory :responsible do
      after :create do |professor|
        role = create(:role, name: 'Professor', identifier: 'responsible') if Role.all.empty?
        if role
          professor.roles << role
          professor.save
        end
      end
    end
  end
end
