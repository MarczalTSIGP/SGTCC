require 'rails_helper'

describe 'ExaminationBoard::show academic activity' do
  include_context 'academic monograph examination board setup'

  let(:activity) do
    create(:monograph_activity,
           calendar: orientation.current_calendar)
  end
  let(:academic_activity) do
    create(:academic_activity,
           academic: orientation.academic,
           activity: activity)
  end

  before do
    academic_activity
    visit academics_examination_board_path(examination_board)
  end

  it_behaves_like 'examination board academic activity', verify_monograph: true
end
