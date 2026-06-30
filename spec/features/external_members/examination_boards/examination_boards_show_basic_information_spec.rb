require 'rails_helper'

describe 'ExaminationBoard::show basic information' do
  include_context 'external member project examination board setup'

  before { visit external_members_examination_board_path(examination_board) }

  it_behaves_like 'examination board basic information',
                  'shows the examination board base info'
end
