FactoryBot.define do
  factory :signature do
    orientation
    document
    user_id { Faker::Number.non_zero_digit }
    user_type { 'P' }
    status { false }

    factory :signature_signed do
      status { true }
    end

    factory :academic_signature do
      user_type { 'A' }
    end

    factory :external_member_signature do
      user_type { 'E' }
    end

    factory :academic_signature_signed do
      user_type { 'A' }
      status { true }
    end

    factory :external_member_signature_signed do
      user_type { 'E' }
      status { true }
    end
  end
end
