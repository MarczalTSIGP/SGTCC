require 'rails_helper'

describe 'ExaminationBoard::show', type: :feature do
  let(:external_member) { create(:external_member) }
  let(:orientation) { create(:orientation_tcc_one) }
  let!(:examination_board) { create(:project_examination_board, orientation: orientation) }
  let(:note_status) { ExaminationBoardNote.human_attribute_name('note_status') }
  let(:note_sent) { ExaminationBoardNote.human_attribute_name('note_sent') }

  before do
    create(:document_type_adpj)
    examination_board.external_members << external_member
    login_as(external_member, scope: :external_member)
    visit external_members_examination_board_path(examination_board)
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

    context 'when shows the academic activity' do
      let(:academic) { orientation.academic }
      let(:academic_activity) { examination_board.academic_activity }

      before do
        create(:project_academic_activity, academic: academic,
                                           calendar: orientation.calendars.first)
        visit external_members_examination_board_path(examination_board)
      end

      it 'shows the academic activity' do
        expect(page).to have_contents([academic.name,
                                       academic_activity.title,
                                       academic_activity.summary])

        expect(page).to have_selectors([link(academic_activity.pdf.url),
                                        link(academic_activity.complementary_files.url)])
      end
    end

    context 'when shows the examination board note from others' do
      let(:academic) { orientation.academic }

      before do
        create(:examination_board_note, examination_board: examination_board,
                                        external_member: external_member)

        examination_board.professors.each do |evaluator|
          create(:examination_board_note, examination_board: examination_board,
                                          professor: evaluator,
                                          appointment_text: 'Texto de avaliação professor')
        end

        examination_board.external_members.each do |evaluator|
          create(:examination_board_note, examination_board: examination_board,
                                          external_member: evaluator,
                                          appointment_text: 'Texto de avaliação membro externo')
        end

        visit external_members_examination_board_path(examination_board)
      end

      it 'shows the appointmnets' do
        examination_board
          .examination_board_notes_by_others(external_member.id)
          .each do |examination_board_note|
          expect(page).to have_contents([examination_board_note.appointment_text])
          expect(page).to have_selector('p > strong', text: note_status)
          expect(page).to have_selector('p > span', text: note_sent)
        end
      end
    end

    context 'when shows the examination board members not send appointments' do
      let(:academic) { orientation.academic }

      before do
        create(:examination_board_note, examination_board: examination_board,
                                        external_member: external_member)

        visit external_members_examination_board_path(examination_board)
      end

      it 'shows the appointmnets not send' do
        examination_board
          .members_that_not_send_appointments(external_member.id)
          .each do |member|
          expect(page).to have_selector('p', text: member.name_with_scholarity)
          expect(page).to have_selector('p', text: 'Apontamentos não enviados')
        end
      end
    end
  end
end
