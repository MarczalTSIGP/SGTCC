require 'rails_helper'

describe 'ExaminationBoard::show appointments' do
  include_context 'academic monograph examination board setup'

  let(:academic_note_name) { academic.name }

  before do
    create_examination_board_notes
    visit academics_examination_board_path(examination_board)
  end

  it_behaves_like 'examination board appointments'
  it_behaves_like 'examination board academic note'
end
