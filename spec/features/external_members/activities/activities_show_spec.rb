require 'rails_helper'

describe 'Activity::show', type: :feature do
  let(:external_member) { create(:external_member) }
  let!(:calendar) { create(:current_calendar_tcc_one) }
  let!(:activity) { create(:activity_tcc_one, calendar: calendar) }
  let!(:orientation) { create(:orientation, calendars: [calendar]) }

  before do
    orientation.external_member_supervisors << external_member
    login_as(external_member, scope: :external_member)
    visit external_members_calendar_activity_path(calendar, activity)
  end

  describe '#show' do
    context 'when shows the activity' do
      it 'shows the activity' do
        tcc = I18n.t("enums.tcc.#{activity.tcc}")
        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       activity.deadline,
                                       tcc,
                                       complete_date(activity.created_at),
                                       complete_date(activity.updated_at)])
      end
    end
  end
end
