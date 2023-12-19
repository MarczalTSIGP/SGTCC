require 'rails_helper'

describe 'Submission::Activities::ToConfirm', :js, type: :feature do
  let(:orientation) { create(:current_orientation_tcc_one) }
  let(:advisor) { orientation.advisor }
  let(:calendar) { orientation.current_calendar }
  let(:academic) { orientation.academic }

  let(:proposal_activity) { create(:proposal_activity, calendar: calendar) }
  let!(:submission) do
    create(:project_academic_activity, academic: academic, activity: proposal_activity)
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
      expect(page).to have_content(submission.activity.name)
      expect(page).to have_content(calendar.year_with_semester)
    end
  end
end
