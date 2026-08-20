require 'rails_helper'

describe 'ExaminationBoard::show appointments' do
  include_context 'professor proposal examination board setup'

  before do
    create_examination_board_notes
    visit professors_examination_board_path(examination_board)
  end

  it_behaves_like 'examination board appointments'
end
