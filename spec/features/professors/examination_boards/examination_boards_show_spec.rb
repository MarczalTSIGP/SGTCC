require 'rails_helper'

describe 'ExaminationBoard::show' do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let!(:examination_board) { create(:proposal_examination_board, orientation:) }

  before do
    create(:document_type_adpp)
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    before do
      visit professors_examination_board_path(examination_board)
    end

    context 'when shows the examination_board' do
      it 'shows the examination board' do
        expect(page).to have_contents([examination_board.orientation.title,
                                       examination_board.orientation.academic_with_calendar,
                                       examination_board.orientation.advisor.name_with_scholarity,
                                       examination_board.place,
                                       complete_date(examination_board.date)])
      end

      it 'show the evaluators' do
        within('table.table') do
          examination_board.evaluators.responses.each_with_index do |response, index|
            child = index + 1
            within("tbody tr:nth-child(#{child})") do
              expect(page).to have_content(response.evaluator.name_with_scholarity)
              expect(page).to have_content(I18n.t("helpers.boolean.#{response.appointments_file?}"))
              expect(page).to have_content(I18n.t("helpers.boolean.#{response.appointments_text?}"))
            end
          end
        end
      end
    end

    context 'when generates the non attendance defense minutes', :js do
      it 'shows the view defense minutes button' do
        find_by_id('generate_non_attendance_defense_minutes').click
        expect(page).to have_alert(text: 'Você tem certeza que deseja gerar a Ata de Defesa')

        first('.swal-button--confirm').click # confirmation
        expect(page).to have_alert(text: 'Ata de Defesa gerada com sucesso!')

        first('.swal-button--confirm').click # success message
        expect(page).to have_link(text: 'Visualizar Ata de Defesa')

        find_by_id('view_defense_minutes').click

        examination_board.reload
        expect(page).to have_contents([examination_board.academic_document_title,
                                       orientation.academic.name,
                                       orientation.advisor.name_with_scholarity,
                                       document_date(examination_board.date),
                                       document_date(Document.first.created_at),
                                       examination_board.situation_translated])

        orientation.supervisors do |supervisor|
          expect(page).to have_content(supervisor.name_with_scholarity)
        end

        examination_board.professors do |professor|
          expect(page).to have_content(professor.name_with_scholarity)
        end
      end
    end

    context 'when shows the academic activity' do
      let(:academic) { orientation.academic }
      let(:academic_activity) { examination_board.academic_activity }

      before do
        create(:proposal_academic_activity, academic:,
                                            calendar: orientation.calendars.first)
        visit professors_examination_board_path(examination_board)
      end

      it 'shows the academic activity' do
        expect(page).to have_contents([academic.name,
                                       academic_activity.title,
                                       academic_activity.summary])

        expect(page).to have_selectors([link(academic_activity.pdf.url),
                                        link(academic_activity.complementary_files.url)])
      end
    end
  end

  context 'when shows the examination_board with evaluators note and appointments' do
    before do
      examination_board.evaluators.responses.each do |response|
        params = { professor_id: response.evaluator.id } if response.evaluator.is_a?(Professor)
        params ||= { external_member_id: response.evaluator.id }
        params.merge!(note: 100, examination_board:)

        create(:examination_board_note, params)
      end
      visit professors_examination_board_path(examination_board)
    end

    it 'show the evaluators' do
      within('table.table') do
        examination_board.evaluators.responses.each_with_index do |response, index|
          child = index + 1
          within("tbody tr:nth-child(#{child})") do
            expect(page).to have_css("a[href='#{response.appointments_file.url}']")
            expect(page).to have_link(I18n.t("helpers.boolean.#{response.appointments_text?}"))
          end
        end
      end
    end
  end
end
