require 'rails_helper'

describe 'ExaminationBoard::show appointments' do
  include_context 'external member project examination board setup'

  before do
    create_examination_board_notes
    visit external_members_examination_board_path(examination_board)
  end

  it_behaves_like 'examination board appointments'
end
