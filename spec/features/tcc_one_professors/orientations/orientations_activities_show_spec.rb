require 'rails_helper'

describe 'Orientation::activities show' do
  let!(:professor) { create(:professor_tcc_one) }
  let(:orientation) { create(:orientation, :current, :tcc_two) }
  let!(:activity) { create(:activity, calendar: orientation.current_calendar) }
  let!(:academic_activity) do
    create(:academic_activity, academic: orientation.academic, activity:)
  end

  before do
    login_as(professor, scope: :professor)
    calendar = orientation.current_calendar
    visit tcc_one_professors_orientation_calendar_activity_path(orientation,
                                                                calendar, activity)
  end

  it 'shows the activity' do
    expect(page).to have_contents([activity.name,
                                   activity.base_activity_type.name,
                                   activity.deadline,
                                   I18n.t("enums.tcc.#{activity.tcc}"),
                                   complete_date(activity.created_at),
                                   complete_date(activity.updated_at),
                                   orientation.academic.name,
                                   academic_activity.title,
                                   academic_activity.summary])

    expect(page).to have_selectors([link(academic_activity.pdf.url),
                                    link(academic_activity.complementary_files.url)])
  end
end
