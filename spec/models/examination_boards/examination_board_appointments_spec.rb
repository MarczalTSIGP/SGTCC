require 'rails_helper'

RSpec.describe ExaminationBoard do
  describe '.appointments?' do
    context 'when has not appointment file and appointment text' do
      let(:examination_board) { create(:examination_board) }

      before do
        create(:examination_board_note, examination_board:,
                                        appointment_file: nil,
                                        appointment_text: nil)
      end

      it 'returns false' do
        expect(examination_board.appointments?).to be(false)
      end
    end

    context 'when has appointment file and not have appointment text' do
      let!(:examination_board) { create(:examination_board) }

      before do
        create(:examination_board_note, examination_board:)
      end

      it 'returns true' do
        expect(examination_board.appointments?).to be(true)
      end
    end

    context 'when has appointment file and appointment text' do
      let!(:examination_board) { create(:examination_board) }

      before do
        create(:examination_board_note, examination_board:,
                                        appointment_text: 'Teste')
      end

      it 'returns true' do
        expect(examination_board.appointments?).to be(true)
      end
    end

    context 'when has not appointment file but has appointment text' do
      let!(:examination_board) { create(:examination_board) }

      before do
        create(:examination_board_note, examination_board:,
                                        appointment_file: nil,
                                        appointment_text: 'Texto de teste')
      end

      it 'returns true' do
        expect(examination_board.appointments?).to be(true)
      end
    end
  end
end
