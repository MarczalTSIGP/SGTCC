require 'rails_helper'

describe 'ExaminationBoard::index', :js, type: :feature do
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
        create(:current_examination_board_tcc_one, date: 1.day.from_now),
        create(:current_examination_board_tcc_one, date: Time.zone.now),
        create(:current_examination_board_tcc_one, date: 1.day.ago)
      ]

      visit site_examination_boards_path

      ebs_tcc_one.each_with_index do |eb, index|
        academic_name = eb.orientation.academic.name
        advisor_name = eb.orientation.advisor.name_with_scholarity

        child = index + 1
        within("div#tabContent .examination-board-table:nth-child(#{child})") do
          expect(page).to have_content(long_date(eb.date))
          expect(page).to have_content(eb.place)
          expect(page).to have_content(academic_name)
          expect(page).to have_content(advisor_name)
        end
      end

      eb_selector = "div#tabContent .examination-board-table:nth-child(#{ebs_tcc_one.size})"
      expect(page).to have_selector("#{eb_selector}.opacity-50")
    end

    it 'displays the details of the examination board' do
      eb_tcc_one = create(:current_examination_board_tcc_one, date: Time.zone.now)
      academic = eb_tcc_one.orientation.academic
      orientation = eb_tcc_one.orientation

      paac = create(:proposal_academic_activity, academic: academic,
                                                 calendar: orientation.current_calendar)

      visit site_examination_boards_path

      within('div#tabContent .examination-board-table:nth-child(1)') do
        find("a[data-exam-id='#{eb_tcc_one.id}']").click

        expect(page).to have_content(paac.summary)

        within("div.examination-board-row.exam_#{eb_tcc_one.id}") do
          eb_tcc_one.orientation.supervisors.each do |supervisor|
            expect(page).to have_content(supervisor.name_with_scholarity)
          end

          eb_tcc_one.professors.each do |professor|
            expect(page).to have_content(professor.name_with_scholarity)
          end

          expect(page).to have_selector("a[href='#{eb_tcc_one.academic_activity.pdf.url}']")
        end
      end
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
        create(:current_examination_board_tcc_one_project, date: 1.day.from_now),
        create(:current_examination_board_tcc_one_project, date: Time.zone.now),
        create(:current_examination_board_tcc_one_project, date: 1.day.ago)
      ]

      visit site_examination_boards_path
      click_link('Projeto')

      ebs_tcc_one_project.each_with_index do |eb, index|
        academic_name = eb.orientation.academic.name
        advisor_name = eb.orientation.advisor.name_with_scholarity
        child = index + 1

        within("div#tabContent .examination-board-table:nth-child(#{child})") do
          expect(page).to have_content(long_date(eb.date))
          expect(page).to have_content(eb.place)
          expect(page).to have_content(academic_name)
          expect(page).to have_content(advisor_name)
        end
      end

      eb_selector = "div#tabContent .examination-board-table:nth-child(#{ebs_tcc_one_project.size})"
      expect(page).to have_selector("#{eb_selector}.opacity-50")
    end

    it 'displays the details of the examination board' do
      eb_tcc_one_project = create(:current_examination_board_tcc_one_project, date: Time.zone.now)
      academic = eb_tcc_one_project.orientation.academic
      orientation = eb_tcc_one_project.orientation

      paac = create(:project_academic_activity, academic: academic,
                                                calendar: orientation.current_calendar)

      visit site_examination_boards_path

      click_link('Projeto')

      within('div#tabContent .examination-board-table:nth-child(1)') do
        find("a[data-exam-id='#{eb_tcc_one_project.id}']").click

        expect(page).to have_content(paac.summary)
        within("div.examination-board-row.exam_#{eb_tcc_one_project.id}") do
          eb_tcc_one_project.orientation.supervisors.each do |supervisor|
            expect(page).to have_content(supervisor.name_with_scholarity)
          end

          eb_tcc_one_project.professors.each do |professor|
            expect(page).to have_content(professor.name_with_scholarity)
          end

          expect(page).to have_selector("a[href='#{eb_tcc_one_project.academic_activity.pdf.url}']")
        end
      end
    end
  end

  describe 'Monograph' do
    it 'clicks to the tab Monograph to display examination boards monograph' do
      visit site_examination_boards_path

      click_link('Monografia')
      expect(page).to have_css('a#monograph-tab.active', text: 'Monografia')
    end

    it 'displays the examinations boards of the current semester' do
      ebs_tcc_two = [
        create(:current_examination_board_tcc_two, date: 1.day.from_now),
        create(:current_examination_board_tcc_two, date: Time.zone.now),
        create(:current_examination_board_tcc_two, date: 1.day.ago)
      ]

      visit site_examination_boards_path

      click_link('Monografia')

      ebs_tcc_two.each_with_index do |eb, index|
        academic_name = eb.orientation.academic.name
        advisor_name = eb.orientation.advisor.name_with_scholarity

        child = index + 1
        within("div#tabContent .examination-board-table:nth-child(#{child})") do
          expect(page).to have_content(long_date(eb.date))
          expect(page).to have_content(eb.place)
          expect(page).to have_content(academic_name)
          expect(page).to have_content(advisor_name)
        end
      end

      eb_selector = "div#tabContent .examination-board-table:nth-child(#{ebs_tcc_two.size})"
      expect(page).to have_selector("#{eb_selector}.opacity-50")
    end

    it 'displays the details of the examination board' do
      eb_tcc_two = create(:current_examination_board_tcc_two, date: Time.zone.now)
      academic = eb_tcc_two.orientation.academic
      orientation = eb_tcc_two.orientation

      paac = create(:monograph_academic_activity, academic: academic,
                                                  calendar: orientation.current_calendar)

      visit site_examination_boards_path

      click_link('Monografia')

      within('div#tabContent .examination-board-table:nth-child(1)') do
        find("a[data-exam-id='#{eb_tcc_two.id}']").click

        expect(page).to have_content(paac.summary)
        within("div.examination-board-row.exam_#{eb_tcc_two.id}") do
          eb_tcc_two.orientation.supervisors.each do |supervisor|
            expect(page).to have_content(supervisor.name_with_scholarity)
          end

          eb_tcc_two.professors.each do |professor|
            expect(page).to have_content(professor.name_with_scholarity)
          end

          expect(page).to have_selector("a[href='#{eb_tcc_two.academic_activity.pdf.url}']")
        end
      end
    end
  end
end
