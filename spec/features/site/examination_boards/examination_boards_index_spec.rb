require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  before do
    create(:page, url: 'bancas-de-tcc')
  end

  describe '#index' do
    let!(:examination_board_tcc_one) { create(:current_examination_board_tcc_one) }
    let!(:examination_board_tcc_two) { create(:current_examination_board_tcc_two) }

    context 'when shows all the examination boards of the tcc one calendar' do
      let(:orientation) { examination_board_tcc_one.orientation }
      let(:academic) { orientation.academic }
      let!(:academic_activity) do
        create(:proposal_academic_activity, academic: academic,
                                            calendar: orientation.calendars.first)
      end

      before do
        visit site_examination_boards_path
      end

      it 'Proposta and Projeto for TCC1' do
        click_link('Proposta')
        expect(page).to have_content('Proposta')

        click_link('Projeto')
        expect(page).to have_content('Projeto')

        advisor_name = examination_board_tcc_one.orientation.advisor.name_with_scholarity
        # expect(page).to have_selector(examination_board_tcc_one.academic_activity&.title)
        expect(page).to have_contents([examination_board_tcc_one.orientation.academic.name,
                                       advisor_name,
                                       examination_board_tcc_one.place,
                                       long_date(examination_board_tcc_one.date)])

        # examination_board_tcc_one.professors.each do |professor|
        #   expect(page).to have_content(professor.name_with_scholarity)
        # end

        # examination_board_tcc_one.external_members.each do |external_member|
        #   expect(page).to have_content(external_member.name_with_scholarity)
        # end

        # expect(page).to have_selector(link(academic_activity.pdf.url))
      end
    end

    context 'when shows all the examination boards of the tcc two calendar' do
      let(:orientation) { examination_board_tcc_two.orientation }
      let(:academic) { orientation.academic }
      let!(:academic_activity) do
        create(:monograph_academic_activity, academic: academic,
                                             calendar: orientation.calendars.first)
      end

      before do
        visit site_examination_boards_path
      end

      it 'shows Monografia for TCC2' do
        click_link('Monografia')
        expect(page).to have_content('Monografia')

        advisor_name = examination_board_tcc_two.orientation.advisor.name_with_scholarity
        # expect(page).to have_selector(examination_board_tcc_two.academic_activity&.title)
        expect(page).to have_contents([examination_board_tcc_two.orientation.academic.name,
                                       advisor_name,
                                       examination_board_tcc_two.place,
                                       long_date(examination_board_tcc_two.date)])

        # examination_board_tcc_two.professors.each do |professor|
        #   expect(page).to have_content(professor.name_with_scholarity)
        # end

        # examination_board_tcc_two.external_members.each do |external_member|
        #   expect(page).to have_content(external_member.name_with_scholarity)
        # end

        # expect(page).to have_selector(link(academic_activity.pdf.url))
      end
    end
  end
end
