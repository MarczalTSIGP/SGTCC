require 'rails_helper'

describe 'ExaminationBoard::index', :js do
  before do
    create(:page, url: 'bancas-de-tcc')
  end

  describe 'Proposal' do
    it 'is the default tab' do
      visit site_examination_boards_path

      expect(page).to have_css('a#proposal-tab.active', text: 'Proposta')
    end

    it 'displays the examinations boards of the current semester' do
      ebs_tcc_one = [
        create(:current_examination_board_tcc_one, date: 2.hours.from_now),
        create(:current_examination_board_tcc_one, date: 1.day.from_now),
        create(:current_examination_board_tcc_one, date: 1.day.ago)
      ]

      visit site_examination_boards_path

      ebs_tcc_one.each_with_index do |eb, index|
        academic_name = eb.orientation.academic.name
        advisor_name = eb.orientation.advisor.name_with_scholarity

        child = index + 1
        within("div#tabContent .examination-board-site:nth-child(#{child})") do
          expect(page).to have_content(long_date(eb.date))
          expect(page).to have_content(eb.place)
          expect(page).to have_content(academic_name)
          expect(page).to have_content(advisor_name)
        end
      end

      eb_selector = "div#tabContent .examination-board-site:nth-child(#{ebs_tcc_one.size})"
      expect(page).to have_css("#{eb_selector}.opacity-50")
    end
  end

  describe 'Project' do
    it 'clicks to the tab Project to display examination boards projects' do
      visit site_examination_boards_path

      click_link('Projeto')
      expect(page).to have_css('a#project-tab.active', text: 'Projeto')
    end

    it 'displays the examinations boards of the current semester' do
      ebs_tcc_one_project = [
        create(:current_examination_board_tcc_one_project, date: 2.hours.from_now),
        create(:current_examination_board_tcc_one_project, date: 1.day.from_now),
        create(:current_examination_board_tcc_one_project, date: 1.day.ago)
      ]

      visit site_examination_boards_path
      click_link('Projeto')

      ebs_tcc_one_project.each_with_index do |eb, index|
        academic_name = eb.orientation.academic.name
        advisor_name = eb.orientation.advisor.name_with_scholarity
        child = index + 1

        within("div#tabContent .examination-board-site:nth-child(#{child})") do
          expect(page).to have_content(long_date(eb.date))
          expect(page).to have_content(eb.place)
          expect(page).to have_content(academic_name)
          expect(page).to have_content(advisor_name)
        end
      end

      eb_selector = "div#tabContent .examination-board-site:nth-child(#{ebs_tcc_one_project.size})"
      expect(page).to have_css("#{eb_selector}.opacity-50")
    end
  end

  describe 'Monograph' do
    it 'clicks to the tab Monograph to display examination boards monograph' do
      visit site_examination_boards_path

      click_link('Monografia')
      expect(page).to have_css('a#monograph-tab.active', text: 'Monografia')
    end
  end
end
