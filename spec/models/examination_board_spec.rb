require 'rails_helper'

RSpec.describe ExaminationBoard, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:place) }
    it { is_expected.to validate_presence_of(:date) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:orientation) }
    it { is_expected.to have_many(:examination_board_attendees).dependent(:delete_all) }

    it 'is expected to have many professors' do
      is_expected.to have_many(:professors).through(:examination_board_attendees)
                                           .dependent(:destroy)
    end

    it 'is expected to have many external members' do
      is_expected.to have_many(:external_members).through(:examination_board_attendees)
                                                 .dependent(:destroy)
    end
  end

  describe '#search' do
    let!(:examination_board) { create(:examination_board) }

    context 'when finds examination_board by attributes' do
      it 'returns examination_board by orientation title' do
        results_search = ExaminationBoard.search(examination_board.orientation.title)
        expect(examination_board.orientation.title).to eq(results_search.first.orientation.title)
      end

      it 'returns examination_board by place' do
        results_search = ExaminationBoard.search(examination_board.place)
        expect(examination_board.place).to eq(results_search.first.place)
      end
    end
  end
end
