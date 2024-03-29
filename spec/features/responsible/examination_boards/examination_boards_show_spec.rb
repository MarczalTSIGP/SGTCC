require 'rails_helper'

describe 'ExaminationBoard::show' do
  let(:responsible) { create(:responsible) }
  let(:orientation) { create(:orientation_tcc_two) }
  let!(:examination_board) { create(:monograph_examination_board, orientation:) }

  before do
    create(:document_type_admg)
    examination_board.professors << create(:professor)
    examination_board.external_members << create(:external_member)
    login_as(responsible, scope: :professor)
  end

  describe '#show' do
    before do
      visit responsible_examination_board_path(examination_board)
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

    context 'when shows the academic activity' do
      let(:academic) { orientation.academic }
      let(:academic_activity) { examination_board.academic_activity }

      before do
        create(:monograph_academic_activity, academic:,
                                             calendar: orientation.calendars.first)
        visit responsible_examination_board_path(examination_board)
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
      visit responsible_examination_board_path(examination_board)
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
