require 'rails_helper'

RSpec.describe ExaminationBoard do
  describe '.tcc_one' do
    let(:tccs) { [] }

    before do
      tccs << create(:current_examination_board_tcc_one).id
      tccs << create(:current_examination_board_tcc_one_project).id

      previous_orientation = create(:previous_orientation_tcc_one)
      tccs << create(:examination_board_tcc_one,
                     date: 6.months.ago,
                     orientation: previous_orientation).id
      tccs << create(:examination_board_tcc_one,
                     date: 6.months.ago,
                     identifier: :project,
                     orientation: previous_orientation).id
    end

    it 'return all the tccs one' do
      expect(described_class.tcc_one.pluck(:id)).to eq(tccs)
    end

    it 'return all the current semester tccs one' do
      tccs.pop(2)
      expect(described_class.tcc_one_current_semester.pluck(:id)).to eq(tccs)
    end
  end

  describe '.tcc_two' do
    let(:tccs) { [] }

    before do
      tccs << create(:current_examination_board_tcc_two).id
      tccs << create(:current_examination_board_tcc_two).id

      previous_orientation = create(:previous_orientation_tcc_two)
      tccs << create(:examination_board_tcc_two,
                     date: 6.months.ago,
                     orientation: previous_orientation).id
      tccs << create(:examination_board_tcc_two,
                     date: 6.months.ago,
                     identifier: :project,
                     orientation: previous_orientation).id
    end

    it 'return all the tccs two' do
      expect(described_class.tcc_two.pluck(:id)).to eq(tccs)
    end

    it 'return all the current semester tccs two' do
      tccs.pop(2)
      expect(described_class.tcc_two_current_semester.pluck(:id)).to eq(tccs)
    end
  end
end
