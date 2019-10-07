require 'rails_helper'

describe 'ExaminationBoard::show', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let!(:examination_board) { create(:proposal_examination_board, orientation: orientation) }

  before do
    create(:document_type_adpp)
    login_as(professor, scope: :professor)
    visit professors_examination_board_path(examination_board)
  end

  describe '#show' do
    context 'when shows the examination_board' do
      it 'shows the examination board' do
        expect(page).to have_contents([examination_board.orientation.title,
                                       examination_board.orientation.academic_with_calendar,
                                       examination_board.orientation.advisor.name_with_scholarity,
                                       examination_board.place,
                                       complete_date(examination_board.date),
                                       complete_date(examination_board.created_at),
                                       complete_date(examination_board.updated_at)])

        examination_board.professors.each do |professor|
          expect(page).to have_content(professor.name_with_scholarity)
        end

        examination_board.external_members.each do |external_member|
          expect(page).to have_content(external_member.name_with_scholarity)
        end
      end
    end

    context 'when generates the defense minutes' do
      it 'shows the view defense minutes button' do
        find('#generate_defense_minutes').click
        find('#view_defense_minutes').click
        document = Document.first
        expect(page).to have_contents([orientation.title,
                                       orientation.academic.name,
                                       orientation.advisor.name_with_scholarity,
                                       document_date(examination_board.date),
                                       document_date(document.created_at)])

        orientation.supervisors do |supervisor|
          expect(page).to have_content(supervisor.name_with_scholarity)
        end

        examination_board.professors do |professor|
          expect(page).to have_content(professor.name_with_scholarity)
        end
      end
    end
  end
end
