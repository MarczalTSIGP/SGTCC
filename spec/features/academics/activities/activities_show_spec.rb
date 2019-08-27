require 'rails_helper'

describe 'Activity::show', type: :feature do
  let(:academic) { create(:academic) }
  let!(:activity) { create(:activity) }

  before do
    login_as(academic, scope: :academic)
    visit academics_calendar_activity_path(activity.calendar, activity)
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
