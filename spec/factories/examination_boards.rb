FactoryBot.define do
  tccs = ExaminationBoard.tccs.values

  factory :examination_board do
    date { Faker::Date.forward(days: 1) }
    document_available_until { Faker::Date.forward(days: 1) }
    identifier { ExaminationBoard.human_tcc_identifiers.values.sample }
    place { Faker::Address.community }
    tcc { tccs.sample }
    orientation

    factory :proposal_examination_board do
      identifier { :proposal }
    end

    factory :project_examination_board do
      identifier { :project }
    end

    factory :monograph_examination_board do
      identifier { :monograph }
    end

    factory :examination_board_tcc_one do
      tcc { tccs.first }
    end

    factory :examination_board_tcc_two do
      tcc { tccs.last }
    end

    factory :current_examination_board_tcc_one do
      tcc { tccs.first }
      orientation { create(:current_orientation_tcc_one) }
      identifier { :proposal }
    end

    factory :current_examination_board_tcc_two do
      tcc { tccs.last }
      orientation { create(:current_orientation_tcc_two) }
      identifier { :monograph }
    end

    after :create do |examination_board|
      professors = create_list(:professor, 3)
      external_members = create_list(:external_member, 3)

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
