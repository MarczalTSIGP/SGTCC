FactoryBot.define do
  request = { requester: { justification: 'dfd' } }

  factory :document do
    content { Faker::Lorem.paragraph }
    sequence(:code) { |n| "code#{n}" }
    document_type

    factory :document_tco do
      document_type { association :document_type_tco }
    end

    factory :document_tcai do
      document_type { association(:document_type_tcai) }
    end

    factory :document_tdo do
      document_type { association(:document_type_tdo) }
      justification { 'justification' }
      request { request }
    end

    factory :document_tep do
      document_type { association(:document_type_tep) }
      justification { 'justification' }
      request { request }
    end

    factory :document_tso do
      new_orientation = { requester: { justificatio: 'dfd' },
                          new_orientation: { advisor: { id: '', name: '' },
                                             professorSupervisors: {},
                                             externalMemberSupervisors: {} } }
      document_type { association(:document_type_tso) }
      justification { 'justification' }
      request { new_orientation }
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
