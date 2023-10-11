require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  before do
    create(:page, url: 'bancas-de-tcc')
  end

  describe 'viewing examination boards' do
    let(:examination_board_tcc_one) { create(:current_examination_board_tcc_one) }
    let(:examination_board_tcc_one_project) { create(:current_examination_board_tcc_one_project) }
    let(:examination_board_tcc_two) { create(:current_examination_board_tcc_two) }

    context 'when showing all the examination boards of the TCC one calendar' do
      let(:orientation) { examination_board_tcc_one.orientation }
      let(:academic) { orientation.academic }
      let(:academic_activity) do
        create(:proposal_academic_activity, academic: academic,
                                            calendar: orientation.calendars.first)
      end

      before do
        visit site_examination_boards_path
      end

      it 'shows Proposta for TCC1' do
        verify_examination_board(examination_board_tcc_one, 'Proposta')
      end

      it 'shows Projeto for TCC1' do
        verify_examination_board(examination_board_tcc_one_project, 'Projeto')
      end
    end

    context 'when showing all the examination boards of the TCC two calendar' do
      let(:orientation) { examination_board_tcc_two.orientation }
      let(:academic) { orientation.academic }
      let(:academic_activity) do
        create(:monograph_academic_activity, academic: academic,
                                             calendar: orientation.calendars.first)
      end

      before do
        visit site_examination_boards_path
      end

      it 'shows Monografia for TCC2' do
        verify_examination_board(examination_board_tcc_two, 'Monografia')
      end
    end
  end
end

def verify_examination_board(examination_board, type)
  click_link_and_verify_content(type, type)
  within('div#tabContent') do
    verify_examination_board_details(examination_board)
  end
  find("a[data-exam-id='#{examination_board.id}']").click
  verify_academic_activity(examination_board)
  verify_supervisors_and_professors(examination_board)
end

def click_link_and_verify_content(link_text, content)
  click_link(link_text)
  expect(page).to have_content(content)
end

def verify_examination_board_details(examination_board)
  expect(page).to have_contents([
                                  long_date(examination_board.date),
                                  examination_board.place,
                                  examination_board.orientation.academic.name,
                                  examination_board.orientation.advisor.name_with_scholarity
                                ])
end

def verify_academic_activity(examination_board)
  academic_activity = examination_board.academic_activity
  expect(page).to have_content(academic_activity&.title)
  within("div.examination-board-row.exam_#{examination_board.id}") do
    expect(page).to have_selector("a[href='#{academic_activity.pdf.url}]") if academic_activity&.pdf
  end
end

def verify_supervisors_and_professors(examination_board)
  within("div.examination-board-row.exam_#{examination_board.id}") do
    verify_supervisors(examination_board.orientation.supervisors)
    verify_professors(examination_board.professors)
  end
end

def verify_supervisors(supervisors)
  supervisors.each do |supervisor|
    expect(page).to have_content(supervisor.name_with_scholarity)
  end
end

def verify_professors(professors)
  professors.each do |professor|
    expect(page).to have_content(professor.name_with_scholarity)
  end
end
