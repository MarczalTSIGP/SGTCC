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
        if Role.find_by(identifier: :responsible).blank?
          role = create(:role, name: 'Professor', identifier: 'responsible')
          professor.roles << role
          professor.save
        end
      end
    end

    factory :coordinator do
      after :create do |professor|
        if Role.find_by(identifier: :coordinator).blank?
          role = create(:role, name: 'Coordinator', identifier: 'coordinator')
          professor.roles << role
          professor.save
        end
      end
    end

    factory :professor_tcc_one do
      after :create do |professor|
        if Role.find_by(identifier: :tcc_one).blank?
          role = create(:role, name: 'Professor tcc one', identifier: 'tcc_one')
          professor.roles << role
          professor.save
        end
      end
    end
  end
end
