require 'rails_helper'

describe 'ExaminationBoard::show academic activity' do
  include_context 'responsible monograph examination board setup'

  let(:activity) do
    create(:monograph_activity,
           calendar: orientation.current_calendar)
  end
  let(:academic) { orientation.academic }
  let(:academic_activity) do
    create(:academic_activity,
           academic: academic,
           activity: activity)
  end

  before do
    academic_activity
    visit responsible_examination_board_path(examination_board)
  end

  it_behaves_like 'examination board academic activity'
end
