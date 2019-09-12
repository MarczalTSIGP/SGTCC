require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  before do
    create(:page, url: 'bancas-de-defesa')
  end

  describe '#index' do
    let!(:examination_board_tcc_one) { create(:current_examination_board_tcc_one) }
    let!(:examination_board_tcc_two) { create(:current_examination_board_tcc_two) }

    context 'when shows all the examination boards of the tcc one calendar' do
      it 'shows all the examination boards of the tcc one with options' do
        visit site_examination_boards_path

        advisor_name = examination_board_tcc_one.orientation.advisor.name_with_scholarity
        expect(page).to have_contents([examination_board_tcc_one.orientation.academic.name,
                                       advisor_name,
                                       examination_board_tcc_one.place,
                                       datetime(examination_board_tcc_one.date)])

        examination_board_tcc_one.professors.each do |professor|
          expect(page).to have_content(professor.name_with_scholarity)
        end

        examination_board_tcc_one.external_members.each do |external_member|
          expect(page).to have_content(external_member.name_with_scholarity)
        end
      end
    end

    context 'when shows all the examination boards of the tcc two calendar' do
      it 'shows all the examination boards of the tcc two with options' do
        visit site_examination_boards_path

        advisor_name = examination_board_tcc_two.orientation.advisor.name_with_scholarity
        expect(page).to have_contents([examination_board_tcc_two.orientation.academic.name,
                                       advisor_name,
                                       examination_board_tcc_two.place,
                                       datetime(examination_board_tcc_two.date)])

        examination_board_tcc_two.professors.each do |professor|
          expect(page).to have_content(professor.name_with_scholarity)
        end

        examination_board_tcc_two.external_members.each do |external_member|
          expect(page).to have_content(external_member.name_with_scholarity)
        end
      end
    end
  end
end
