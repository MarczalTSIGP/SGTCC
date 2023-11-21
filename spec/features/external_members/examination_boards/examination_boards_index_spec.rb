require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  let(:external_member) { create(:external_member) }
  let!(:examination_board_tcc_one) { create(:examination_board_tcc_one) }
  let!(:examination_board_tcc_two) { create(:examination_board_tcc_two) }

  before do
    examination_board_tcc_one.external_members << external_member
    examination_board_tcc_two.external_members << external_member
    login_as(external_member, scope: :external_member)
    visit external_members_examination_boards_path
  end

  describe '#index' do
    context 'when shows the examination boards of the tcc one calendar' do
      before do
        visit external_members_examination_boards_tcc_one_path
      end
      it 'shows the examination boards of the tcc one with options' do
        expect(page).to have_link(examination_board_tcc_one.orientation.academic_with_calendar,
                                  href: external_members_examination_board_path(examination_board_tcc_one))
        expect(page).to have_contents([examination_board_tcc_one.orientation.advisor.name_with_scholarity,
                                       examination_board_tcc_one.place,
                                       datetime(examination_board_tcc_one.date)])
      end
    end
    context 'when shows the examination boards of the tcc two calendar' do
      before do
        visit external_members_examination_boards_tcc_two_path
      end
      it 'shows the examination boards of the tcc one with options' do
        expect(page).to have_link(examination_board_tcc_two.orientation.academic_with_calendar,
                                  href: external_members_examination_board_path(examination_board_tcc_two))
        expect(page).to have_contents([examination_board_tcc_two.orientation.advisor.name_with_scholarity,
                                       examination_board_tcc_two.place,
                                       datetime(examination_board_tcc_two.date)])
      end
    end
  end
end
