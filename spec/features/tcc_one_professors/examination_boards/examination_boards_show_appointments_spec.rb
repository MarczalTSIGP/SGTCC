require 'rails_helper'

describe 'ExaminationBoard::show appointments' do
  include_context 'tcc one professor project examination board setup'

  let(:academic_note_name) { orientation.academic.name }

  before do
    create_examination_board_notes
    visit tcc_one_professors_examination_board_path(examination_board)
  end

  it_behaves_like 'examination board appointments'
  it_behaves_like 'examination board academic note'
end
