FactoryBot.define do
  tccs = ExaminationBoard.tccs.values

  factory :examination_board do
    date { Faker::Date.forward(1) }
    document_available_until { Faker::Date.forward(1) }
    identifier { ExaminationBoard.human_tcc_identifiers.values.sample }
    place { Faker::Address.community }
    tcc { tccs.sample }
    orientation

    factory :examination_board_tcc_one do
      tcc { tccs.first }
    end

    factory :examination_board_tcc_two do
      tcc { tccs.last }
    end

    factory :current_examination_board_tcc_one do
      tcc { tccs.first }
      orientation { create(:current_orientation_tcc_one) }
    end

    factory :current_examination_board_tcc_two do
      tcc { tccs.last }
      orientation { create(:current_orientation_tcc_two) }
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
