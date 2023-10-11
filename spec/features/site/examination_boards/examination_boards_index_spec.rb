require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  before do
    create(:page, url: 'bancas-de-tcc')
  end

  describe '#index' do
    let!(:examination_board_tcc_one) { create(:current_examination_board_tcc_one) }
    let!(:examination_board_tcc_one_project) { create(:current_examination_board_tcc_one_project) }
    let!(:examination_board_tcc_two) { create(:current_examination_board_tcc_two) }

    context 'when showing all the examination boards of the TCC one calendar' do
      let(:orientation) { examination_board_tcc_one.orientation }
      let(:academic) { orientation.academic }
      let!(:academic_activity) do
        create(:proposal_academic_activity, academic: academic,
                                            calendar: orientation.calendars.first)
      end

      before do
        visit site_examination_boards_path
      end

      it 'Proposta for TCC1' do
        click_link('Proposta')
        expect(page).to have_content('Proposta')

        within('div#tabContent') do
          advisor_name = examination_board_tcc_one.orientation.advisor.name_with_scholarity

          expect(page).to have_contents([long_date(examination_board_tcc_one.date),
                                         examination_board_tcc_one.place,
                                         examination_board_tcc_one.orientation.academic.name,
                                         advisor_name])
        end

        find("a[data-exam-id='#{examination_board_tcc_one.id}']").click

        expect(page).to have_content(examination_board_tcc_one.academic_activity&.title)

        within("div.examination-board-row.exam_#{examination_board_tcc_one.id}") do
          examination_board_tcc_one.orientation.supervisors.each do |supervisor|
            expect(page).to have_content(supervisor.name_with_scholarity)
          end

          examination_board_tcc_one.professors.each do |professor|
            expect(page).to have_content(professor.name_with_scholarity)
          end

          if examination_board_tcc_one.academic_activity
            expect(page).to have_selector("a[href='#{examination_board_tcc_one.academic_activity.pdf.url}']")
          end
        end
      end

      it 'Projeto for TCC1' do
        click_link('Projeto')
        expect(page).to have_content('Projeto')

        within('div#tabContent') do
          advisor_name = examination_board_tcc_one_project.orientation.advisor.name_with_scholarity

          expect(page).to have_contents([long_date(examination_board_tcc_one_project.date),
                                         examination_board_tcc_one_project.place,
                                         examination_board_tcc_one_project.orientation.academic.name,
                                         advisor_name])
        end

        find("a[data-exam-id='#{examination_board_tcc_one_project.id}']").click

        expect(page).to have_content(examination_board_tcc_one_project.academic_activity&.title)

        within("div.examination-board-row.exam_#{examination_board_tcc_one_project.id}") do
          examination_board_tcc_one_project.orientation.supervisors.each do |supervisor|
            expect(page).to have_content(supervisor.name_with_scholarity)
          end

          examination_board_tcc_one_project.professors.each do |professor|
            expect(page).to have_content(professor.name_with_scholarity)
          end

          if examination_board_tcc_one_project.academic_activity
            expect(page).to have_selector("a[href='#{examination_board_tcc_one_project.academic_activity.pdf.url}']")
          end
        end
      end
    end

    context 'when showing all the examination boards of the TCC two calendar' do
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

        within('div#tabContent') do
          advisor_name = examination_board_tcc_two.orientation.advisor.name_with_scholarity

          expect(page).to have_contents([long_date(examination_board_tcc_two.date),
                                         examination_board_tcc_two.place,
                                         examination_board_tcc_two.orientation.academic.name,
                                         advisor_name])
        end

        find("a[data-exam-id='#{examination_board_tcc_two.id}']").click

        expect(page).to have_content(examination_board_tcc_two.academic_activity&.title)

        within("div.examination-board-row.exam_#{examination_board_tcc_two.id}") do
          examination_board_tcc_two.orientation.supervisors.each do |supervisor|
            expect(page).to have_content(supervisor.name_with_scholarity)
          end

          examination_board_tcc_two.professors.each do |professor|
            expect(page).to have_content(professor.name_with_scholarity)
          end

          if examination_board_tcc_two.academic_activity
            expect(page).to have_selector("a[href='#{examination_board_tcc_two.academic_activity.pdf.url}']")
          end
        end
      end
    end
  end
end
