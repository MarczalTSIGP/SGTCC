require 'rails_helper'

describe 'ExaminationBoard::show defense minutes', :js do
  include_context 'professor proposal examination board setup'

  before { visit professors_examination_board_path(examination_board) }

  it 'shows the view defense minutes button' do
    message = accept_confirm do
      find_by_id('generate_non_attendance_defense_minutes').click
    end
    expect(message).to include('Você tem certeza que deseja gerar a Ata de Defesa')

    expect(page).to have_alert(text: 'Ata de Defesa gerada com sucesso!')

    first('.swal-button--confirm').click # success message
    expect(page).to have_link(text: 'Visualizar Ata de Defesa')

    click_link('Visualizar Ata de Defesa')

    examination_board.reload
    expect(page).to have_contents([examination_board.academic_document_title,
                                   orientation.academic.name,
                                   orientation.advisor.name_with_scholarity,
                                   document_date(examination_board.date),
                                   document_date(Document.first.created_at),
                                   examination_board.situation_translated])

    orientation.supervisors.each do |supervisor|
      expect(page).to have_text(supervisor.name_with_scholarity)
    end

    examination_board.professors.each do |professor|
      expect(page).to have_text(professor.name)
    end
  end
end
