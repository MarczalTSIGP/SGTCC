require 'rails_helper'

describe 'ExaminationBoard::show academic activity' do
  include_context 'professor proposal examination board setup'

  let(:activity) do
    create(:proposal_activity,
           calendar: orientation.current_calendar)
  end
  let(:academic) { orientation.academic }
  let(:academic_activity) do
    create(:academic_activity,
           academic: orientation.academic,
           activity: activity)
  end

  before do
    academic_activity
    visit professors_examination_board_path(examination_board)
  end

  it_behaves_like 'examination board academic activity'
end
