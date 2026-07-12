require 'rails_helper'

describe 'Submission::Activities::ToConfirm', :js do
  let(:orientation) { create(:orientation, :current, :tcc_one) }
  let(:advisor) { orientation.advisor }
  let(:calendar) { orientation.current_calendar }
  let(:academic) { orientation.academic }

  let(:activity) { create(:activity, :proposal, calendar:) }
  let!(:submission) do
    create(:academic_activity, :project, academic:, activity:)
  end

  before do
    login_as(advisor, scope: :professor)
    visit professors_root_path
  end

  it 'shows all the activities submissions with pending confirmation' do
    within 'div#activities-submissions-to-confirm' do
      expect(page).to have_link(academic.name,
                                href: professors_orientation_calendar_activity_path(
                                  academic, calendar, submission.activity
                                ))
      expect(page).to have_text(submission.activity.name)
      expect(page).to have_text(calendar.year_with_semester)
    end
  end
end
