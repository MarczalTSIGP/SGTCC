require 'rails_helper'

RSpec.describe ExaminationBoards::ListQuery do
  describe '.call' do
    def query(tcc:, period: :history, ordering: :responsible, page: nil, term: nil)
      described_class.call(tcc:, period:, ordering:, page:, term:)
    end

    it 'lists responsible boards by TCC ordered by date descending' do
      older = create(:examination_board, :tcc_one, date: 2.days.from_now)
      newer = create(:examination_board, :tcc_one, date: 3.days.from_now)
      create(:examination_board, :tcc_two, date: 4.days.from_now)

      expect(query(tcc: :one).pluck(:id)).to eq([newer.id, older.id])
    end

    it 'restricts current semester boards to the current TCC calendar' do
      current = create(:examination_board, :current_tcc_one)
      create(:examination_board, :tcc_one, orientation: create(:orientation, :previous, :tcc_one))

      expect(query(tcc: :one, period: :current)).to contain_exactly(current)
    end

    it 'preserves the TCC one professor listing order and search' do
      matched = create(:examination_board, :tcc_two, place: 'Sala Especial',
                                                     date: 3.days.from_now)
      create(:examination_board, :tcc_two, place: 'Outro local', date: 4.days.from_now)

      result = query(tcc: :two, ordering: :tcc_one_professor, term: 'Especial')

      expect(result).to contain_exactly(matched)
    end

    it 'raises an explicit error for unsupported combinations' do
      expect { query(tcc: :three) }.to raise_error(ArgumentError)
      expect { query(tcc: :one, period: :future) }.to raise_error(ArgumentError)
      expect { query(tcc: :one, ordering: :unknown) }.to raise_error(ArgumentError)
    end
  end
end
