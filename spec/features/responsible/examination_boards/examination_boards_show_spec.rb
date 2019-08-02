require 'rails_helper'

describe 'ExaminationBoard::show', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:examination_board) { create(:examination_board) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_examination_board_path(examination_board)
  end

  describe '#show' do
    context 'when shows the examination_board' do
      it 'shows the examination board' do
        expect(page).to have_contents([examination_board.orientation.title,
                                       examination_board.place,
                                       complete_date(examination_board.date),
                                       complete_date(examination_board.created_at),
                                       complete_date(examination_board.updated_at)])

        examination_board.professors.each do |professor|
          expect(page).to have_content(professor.name)
        end

        examination_board.external_members.each do |external_member|
          expect(page).to have_content(external_member.name)
        end
      end
    end
  end
end
