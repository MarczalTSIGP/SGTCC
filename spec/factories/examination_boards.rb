FactoryBot.define do
  tccs = ExaminationBoard.tccs.values

  factory :examination_board do
    date { Faker::Date.forward(days: 1) }
    document_available_until { Faker::Date.forward(days: 1) }
    identifier { ExaminationBoard.human_tcc_identifiers.values.sample }
    place { Faker::Address.community }
    tcc { tccs.sample }
    orientation

    trait :proposal do
      identifier { :proposal }
      tcc { tccs.first }
    end

    trait :project do
      identifier { :project }
      tcc { tccs.first }
    end

    trait :monograph do
      identifier { :monograph }
      tcc { tccs.last }
    end

    trait :tcc_one do
      tcc { tccs.first }
      identifier { [:proposal, :project].sample }
    end

    trait :tcc_two do
      tcc { tccs.last }
      identifier { :monograph }
    end

    trait :current_tcc_one do
      tcc { tccs.first }
      orientation { association(:orientation, :current, :tcc_one) }
    end

    trait :current_tcc_two do
      tcc { tccs.last }
      orientation { association(:orientation, :current, :tcc_two) }
    end

    after :create do |examination_board|
      professors = create_list(:professor, 2)
      external_members = create_list(:external_member, 1)

      professors.each do |professor|
        examination_board.professors << professor
      end

      external_members.each do |external_member|
        examination_board.external_members << external_member
      end

      examination_board.save
    end
  end
end
