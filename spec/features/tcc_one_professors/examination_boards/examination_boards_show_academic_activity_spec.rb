require 'rails_helper'

describe 'ExaminationBoard::show academic activity' do
  include_context 'tcc one professor project examination board setup'

  let!(:activity) do
    create(:activity, :project,
           calendar: orientation.current_calendar,
           final_version: false)
  end
  let(:academic) { orientation.academic }
  let(:academic_activity) do
    create(:academic_activity,
           academic: academic,
           activity: activity)
  end

  before do
    academic_activity
    visit tcc_one_professors_examination_board_path(examination_board)
  end

  it_behaves_like 'examination board academic activity'
end
