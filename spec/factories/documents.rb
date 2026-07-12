FactoryBot.define do
  request_with_justification = lambda do
    { requester: { justification: 'dfd' } }
  end

  new_orientation_request = lambda do
    {
      requester: { justificatio: 'dfd' },
      new_orientation: {
        advisor: { id: '', name: '' },
        professorSupervisors: {},
        externalMemberSupervisors: {}
      }
    }
  end

  factory :document do
    content { Faker::Lorem.paragraph }
    sequence(:code) { |n| "code#{n}" }
    document_type

    trait :with_justification_request do
      justification { 'justification' }
      request { request_with_justification.call }
    end

    trait :with_new_orientation_request do
      justification { 'justification' }
      request { new_orientation_request.call }
    end

    factory :document_tco do
      document_type { association(:document_type_tco) }
    end

    factory :document_tcai do
      document_type { association(:document_type_tcai) }
    end

    factory :document_tdo, traits: [:with_justification_request] do
      document_type { association(:document_type_tdo) }
    end

    factory :document_tep, traits: [:with_justification_request] do
      document_type { association(:document_type_tep) }
    end

    factory :document_tso, traits: [:with_new_orientation_request] do
      document_type { association(:document_type_tso) }
    end

    factory :document_adpp do
      document_type { association(:document_type_adpp) }
    end

    before :create do
      create(:responsible)
      create(:coordinator)
    end
  end
end
