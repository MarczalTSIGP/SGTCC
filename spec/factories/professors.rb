FactoryBot.define do
  professor_roles = {
    responsible: { name: 'Professor', identifier: 'responsible' },
    coordinator: { name: 'Coordinator', identifier: 'coordinator' },
    tcc_one: { name: 'Professor tcc one', identifier: 'tcc_one' }
  }.freeze

  assign_professor_role = lambda do |professor, role_key|
    role_attributes = professor_roles.fetch(role_key)
    role = Role.find_by(identifier: role_attributes[:identifier]) ||
           FactoryBot.create(:role, role_attributes)

    professor.roles << role unless professor.roles.exists?(role.id)
  end

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
        assign_professor_role.call(professor, :responsible)
      end
    end

    factory :coordinator do
      after :create do |professor|
        assign_professor_role.call(professor, :coordinator)
      end
    end

    factory :professor_tcc_one do
      after :create do |professor|
        assign_professor_role.call(professor, :tcc_one)
      end
    end
  end
end
