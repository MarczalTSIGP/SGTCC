require 'rails_helper'

RSpec.describe Professor do
  describe '#activities_submissions_to_confirm' do
    let(:orientation) { create(:orientation) }

    before do
      academic = orientation.academic

      create(:academic_activity, :proposal, academic:).update_judgment
      create(:academic_activity, :project, academic:)
      activity = create(:academic_activity, :project, academic:).activity
      activity.update(judgment: false)
    end

    it 'return the activities to be confirm' do
      advisor = orientation.advisor
      expect(advisor.activities_submissions_to_confirm.count).to eq(1)
    end
  end
end
