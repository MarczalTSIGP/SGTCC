require 'rails_helper'

describe 'ExaminationBoard::show', type: :feature do
  let(:academic) { create(:academic) }
  let(:orientation) { create(:orientation_tcc_two, academic: academic) }
  let!(:examination_board) { create(:monograph_examination_board, orientation: orientation) }

  before do
    create(:document_type_admg)
    login_as(academic, scope: :academic)
    visit academics_examination_board_path(examination_board)
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
      let(:academic_activity) { examination_board.academic_activity }

      before do
        create(:monograph_academic_activity, academic: academic,
                                             calendar: orientation.calendars.first)
        visit academics_examination_board_path(examination_board)
      end

      it 'shows the academic activity' do
        expect(page).to have_contents([academic.name,
                                       academic_activity.title,
                                       academic_activity.summary])

        expect(page).to have_selectors([link(academic_activity.pdf.url),
                                        link(academic_activity.complementary_files.url)])
      end
    end

    context 'when shows the academic note' do
      let(:professor) { orientation.advisor }

      before do
        create(:examination_board_note, examination_board: examination_board,
                                        professor: professor)

        examination_board.professors.each do |evaluator|
          create(:examination_board_note, examination_board: examination_board,
                                          professor: evaluator)
        end

        examination_board.external_members.each do |evaluator|
          create(:examination_board_note, examination_board: examination_board,
                                          external_member: evaluator)
        end

        visit academics_examination_board_path(examination_board)
      end

      it 'shows the academic note' do
        expect(page).to have_contents([academic.name,
                                       examination_board.final_note,
                                       examination_board.situation_translated])
      end
    end
  end
end
