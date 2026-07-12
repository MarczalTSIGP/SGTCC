require 'rails_helper'

describe 'Supervision::activities show' do
  let(:external_member) { create(:external_member) }
  let(:orientation) { create(:orientation, :current, :tcc_one) }
  let(:academic) { orientation.academic }
  let(:active_link) { external_members_supervisions_tcc_one_path }
  let!(:activity) do
    create(:activity, calendar: orientation.current_calendar)
  end
  let!(:academic_activity) do
    create(:academic_activity, academic: academic, activity_id: activity.id)
  end

  before do
    orientation.external_member_supervisors << external_member
    login_as(external_member, scope: :external_member)
    visit external_members_supervision_calendar_activity_path(orientation,
                                                              orientation.current_calendar,
                                                              activity)
  end

  it 'shows the activity' do
    expect(page).to have_text(activity.name)
    expect(page).to have_text(activity.base_activity_type.name)
    expect(page).to have_text(activity.deadline)
    expect(page).to have_text(I18n.t("enums.tcc.#{activity.tcc}"))
    expect(page).to have_text(complete_date(activity.created_at))
    expect(page).to have_text(complete_date(activity.updated_at))
    expect(page).to have_text(academic.name)
    expect(page).to have_text(academic_activity.title)
    expect(page).to have_text(academic_activity.summary)

    link_active = "#{link(active_link)}.active"

    expect(page).to have_selectors([link(academic_activity.pdf.url),
                                    link(academic_activity.complementary_files.url),
                                    link_active])
  end
end
