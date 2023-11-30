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
                                  href: external_members_examination_board_path(
                                    examination_board_tcc_one
                                  ))

        examination_board = examination_board_tcc_one
        expect(page).to have_contents([examination_board.orientation.advisor.name_with_scholarity,
                                       examination_board.place,
                                       datetime(examination_board.date)])
      end
    end

    context 'when shows the examination boards of the tcc two calendar' do
      before do
        visit external_members_examination_boards_tcc_two_path
      end

      it 'shows the examination boards of the tcc one with options' do
        expect(page).to have_link(examination_board_tcc_two.orientation.academic_with_calendar,
                                  href: external_members_examination_board_path(
                                    examination_board_tcc_two
                                  ))

        examination_board = examination_board_tcc_two
        expect(page).to have_contents([examination_board.orientation.advisor.name_with_scholarity,
                                       examination_board.place,
                                       datetime(examination_board.date)])
      end
    end

    context 'when filter examination boards by status' do
      before do
        visit external_members_examination_boards_tcc_one_path
      end

      it 'shows examination board by current semester status' do
        status_filter = I18n.t('enums.examination_board.status.CURRENT_SEMESTER')
        selectize(status_filter, from: 'examination_boards_status')

        status = 'CURRENT_SEMESTER'
        examination_boards = external_member.examination_boards_by_tcc_one_list(nil,
                                                                                nil,
                                                                                status)
        examination_boards.each do |examination_board|
          expect(page).to have_link(examination_board.orientation.academic_with_calendar,
                                    href: external_members_examination_board_path(
                                      examination_board
                                    ))
          expect(page).to have_contents([examination_board.orientation.advisor.name,
                                         examination_board.place,
                                         datetime(examination_board.date)])
        end
      end

      it 'shows examination board by other semesters status' do
        status_filter = I18n.t('enums.examination_board.status.OTHER_SEMESTER')
        selectize(status_filter, from: 'examination_boards_status')

        status = 'OTHER_SEMESTER'
        examination_boards = external_member.examination_boards_by_tcc_one_list(nil,
                                                                                nil,
                                                                                status)

        examination_boards.each do |examination_board|
          expect(page).to have_link(examination_board.orientation.academic_with_calendar,
                                    href: external_members_examination_board_path(
                                      examination_board
                                    ))
          expect(page).to have_contents([examination_board.orientation.advisor.name,
                                         examination_board.place,
                                         datetime(examination_board.date)])
        end
      end
    end
  end
end
