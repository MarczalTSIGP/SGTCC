require 'rails_helper'

describe 'ExaminationBoard::show', type: :feature do
  let(:external_member) { create(:external_member) }
  let(:orientation) { create(:orientation_tcc_one) }
  let!(:examination_board) { create(:project_examination_board, orientation: orientation) }

  before do
    create(:document_type_adpj)
    examination_board.external_members << external_member
    login_as(external_member, scope: :external_member)
  end

  context 'when shows the examination_board' do
    before do
      visit external_members_examination_board_path(examination_board)
    end

    it 'shows the examination board base info' do
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

  context 'when shows the examination_board with evaluators note and appointments' do
    before do
      examination_board.evaluators.responses.each do |response|
        params = { professor_id: response.evaluator.id } if response.evaluator.is_a?(Professor)
        params ||= { external_member_id: response.evaluator.id }
        params.merge!(note: 100, examination_board: examination_board)

        create(:examination_board_note, params)
      end
      visit external_members_examination_board_path(examination_board)
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
