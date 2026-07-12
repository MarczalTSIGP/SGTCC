FactoryBot.define do
  factory :signature do
    orientation
    document
    user_id { Faker::Number.non_zero_digit }
    user_type { 'AD' }
    status { false }

    trait :tcai do
      document { association(:document_tcai) }
    end

    trait :tco do
      document { association(:document_tco) }
    end

    trait :signed do
      status { true }
    end

    trait :academic do
      user_type { 'AC' }
    end

    trait :external_member_supervisor do
      user_type { 'ES' }
    end

    trait :professor_supervisor do
      user_type { 'PS' }
    end
  end
end
