require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  before do
    create(:page, url: 'bancas-de-tcc')
  end

  describe '#index' do
    let!(:examination_board_tcc_one) { create(:current_examination_board_tcc_one) }
    let!(:examination_board_tcc_two) { create(:current_examination_board_tcc_two) }

    before do
      visit site_examination_boards_path
    end

    it 'displays the "Proposta" tab by default' do
      expect(page).to have_selector('.nav-link.active', text: 'Proposta')
    end

    it 'allows switching between tabs' do
      click_on 'Proposta'
      expect(page).to have_selector('.nav-link.active', text: 'Proposta')
      
      click_on 'Projeto'
      expect(page).to have_selector('.nav-link.active', text: 'Projeto')

      click_on 'Monografia'
      expect(page).to have_selector('.nav-link.active', text: 'Monografia')
    end

    it 'displays examination board details' do
      # Verifica se as informações da banca estão sendo exibidas corretamente
      expect(page).to have_content(complete_date(examination_board_tcc_one.date))
      expect(page).to have_content(examination_board_tcc_one.place)
      expect(page).to have_content(ExaminationBoard.human_attribute_name('title'))
      expect(examination_board_tcc_one.academic_activity).not_to be_nil # Verifique se a atividade acadêmica não é nula
      expect(page).to have_content(examination_board_tcc_one.academic_activity.title) # Use title diretamente
      expect(page).to have_content(ExaminationBoard.human_attribute_name('academic'))
      expect(page).to have_content(examination_board_tcc_one.orientation.academic.name)
      expect(page).to have_content(ExaminationBoard.human_attribute_name('orientation'))
      expect(page).to have_content(examination_board_tcc_one.orientation.advisor.name_with_scholarity)
      expect(page).to have_content(ExaminationBoard.human_attribute_name('orientation_supervisors'))
      
      examination_board_tcc_one.orientation.supervisors.each do |supervisor|
        expect(page).to have_content(supervisor.name_with_scholarity)
      end

      # Verifica se o título é um link
      within('.showDetails') do
        expect(page).to have_link(examination_board_tcc_one.academic_activity.title, href: "javascript:void(0);")
      end

      # Clique no link de título para abrir as opções
      click_link examination_board_tcc_one.academic_activity.title

      # Verifique se as opções são exibidas
      expect(page).to have_content(ExaminationBoard.human_attribute_name('evaluators'))
      expect(page).to have_content(ExaminationBoard.human_attribute_name('summary'))
      expect(page).to have_content(ExaminationBoard.human_attribute_name('documents'))
    end
  end
end
