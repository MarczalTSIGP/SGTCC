require 'rails_helper'

RSpec.describe ExaminationBoard do
  describe '#search' do
    let!(:examination_board) { create(:examination_board) }

    context 'when finds examination_board by attributes' do
      it 'returns examination_board by orientation title' do
        results_search = described_class.search(examination_board.orientation.title)
        expect(examination_board.orientation.title).to eq(results_search.first.orientation.title)
      end

      it 'returns examination_board by place' do
        results_search = described_class.search(examination_board.place)
        expect(examination_board.place).to eq(results_search.first.place)
      end
    end
  end
end
