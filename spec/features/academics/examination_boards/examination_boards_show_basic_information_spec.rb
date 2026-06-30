require 'rails_helper'

describe 'ExaminationBoard::show basic information' do
  include_context 'academic monograph examination board setup'

  before { visit academics_examination_board_path(examination_board) }

  it_behaves_like 'examination board basic information',
                  'shows the examination board'
end
