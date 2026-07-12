require 'rails_helper'

RSpec.describe ExaminationBoard do
  before { travel_to Date.new(2026, 5, 15) }

  describe '.tcc_one' do
    let(:tccs) { [] }

    before do
      tccs << create(:examination_board, :current_tcc_one, :proposal).id
      tccs << create(:examination_board, :current_tcc_one, :project).id

      previous_orientation = create(:orientation, :previous, :tcc_one)
      tccs << create(:examination_board, :tcc_one,
                     date: 6.months.ago,
                     orientation: previous_orientation).id
      tccs << create(:examination_board, :tcc_one,
                     date: 5.months.ago,
                     identifier: :project,
                     orientation: previous_orientation).id
    end

    it 'return all the tccs one' do
      expect(described_class.tcc_one.pluck(:id).sort).to eq(tccs.sort)
    end

    it 'return all the current semester tccs one' do
      tccs.pop(2)
      expect(described_class.tcc_one_current_semester.pluck(:id).sort).to match_array(tccs.sort)
    end
  end

  describe '.tcc_two' do
    let(:tccs) { [] }

    before do
      tccs << create(:examination_board, :current_tcc_two, :monograph).id
      tccs << create(:examination_board, :current_tcc_two, :monograph).id

      previous_orientation = create(:orientation, :previous, :tcc_two)
      tccs << create(:examination_board, :tcc_two,
                     date: 6.months.ago,
                     orientation: previous_orientation).id
      tccs << create(:examination_board, :tcc_two,
                     date: 6.months.ago,
                     identifier: :project,
                     orientation: previous_orientation).id
    end

    it 'return all the tccs two' do
      expect(described_class.tcc_two.pluck(:id).sort).to eq(tccs)
    end

    it 'return all the current semester tccs two' do
      tccs.pop(2)
      expect(described_class.tcc_two_current_semester.pluck(:id).sort).to eq(tccs)
    end
  end
end
