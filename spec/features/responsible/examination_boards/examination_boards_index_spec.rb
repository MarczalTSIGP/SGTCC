require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:examination_boards) { create_list(:examination_board, 3) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#index' do
    context 'when shows all examination boards' do
      it 'shows all examination boards with options' do
        visit responsible_examination_boards_path
        examination_boards.each do |examination_board|
          expect(page).to have_contents([examination_board.orientation.short_title,
                                         examination_board.place,
                                         short_date(examination_board.date),
                                         short_date(examination_board.created_at)])
        end
      end
    end
  end
end
