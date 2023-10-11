require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  before do
    create(:page, url: 'bancas-de-tcc')
  end

  describe '#index' do
    let!(:examination_board_tcc_one) { create(:current_examination_board_tcc_one) }
    let!(:examination_board_tcc_one_project) { create(:current_examination_board_tcc_one_project) }
    let!(:examination_board_tcc_two) { create(:current_examination_board_tcc_two) }

    def visit_examination_boards_path
      visit site_examination_boards_path
    end

    it 'Proposta' do
      visit_examination_boards_path
      click_link('Proposta')
      expect(page).to have_content('Proposta')
    end

    it 'Projeto' do
      visit_examination_boards_path
      click_link('Projeto')
      expect(page).to have_content('Projeto')
    end

    it 'Monografia' do
      visit_examination_boards_path
      click_link('Monografia')
      expect(page).to have_content('Monografia')
    end

    def verify_board_info(examination_board)
      academic_name = examination_board.orientation.academic.name
      advisor_name = examination_board.orientation.advisor.name_with_scholarity

      within('div#tabContent') do
        expect(page).to have_content([long_date(examination_board.date),
                                      examination_board.place,
                                      academic_name,
                                      advisor_name].join(' '))
      end
    end

    def navigate_to_board(examination_board)
      find("a[data-exam-id='#{examination_board.id}']").click
      expect(page).to have_content(examination_board.academic_activity&.title)
    end

    def verify_supervisors(supervisors)
      supervisors.each do |supervisor|
        expect(page).to have_content(supervisor.name_with_scholarity)
      end
    end

    def verify_professors(professors)
      professors.each do |professor|
        expect(page).to have_content(professor.name_with_scholarity)
      end
    end

    def verify_academic_activity(academic_activity)
      return unless academic_activity

      expect(page).to have_selector("a[href='#{academic_activity.pdf.url}']")
    end

    context 'when showing all the examination boards of the TCC one calendar' do
      before { visit_examination_boards_path }

      it 'Proposta for TCC1' do
        navigate_to_board(examination_board_tcc_one)
        verify_board_info(examination_board_tcc_one)
        verify_supervisors(examination_board_tcc_one.orientation.supervisors)
        verify_professors(examination_board_tcc_one.professors)
        verify_academic_activity(examination_board_tcc_one.academic_activity)
      end

      it 'Projeto for TCC1' do
        navigate_to_board(examination_board_tcc_one_project)
        verify_board_info(examination_board_tcc_one_project)
        verify_supervisors(examination_board_tcc_one_project.orientation.supervisors)
        verify_professors(examination_board_tcc_one_project.professors)
        verify_academic_activity(examination_board_tcc_one_project.academic_activity)
      end
    end

    context 'when showing all the examination boards of the TCC two calendar' do
      before { visit_examination_boards_path }

      it 'Monografia for TCC2' do
        navigate_to_board(examination_board_tcc_two)
        verify_board_info(examination_board_tcc_two)
        verify_supervisors(examination_board_tcc_two.orientation.supervisors)
        verify_professors(examination_board_tcc_two.professors)
        verify_academic_activity(examination_board_tcc_two.academic_activity)
      end
    end
  end
end
