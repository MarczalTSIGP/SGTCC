require 'rails_helper'

describe 'Activity::show', type: :feature do
  let(:professor) { create(:professor_tcc_one) }
  let!(:activity) { create(:activity) }

  before do
    create(:current_calendar_tcc_one)
    login_as(professor, scope: :professor)
    visit tcc_one_professors_calendar_activity_path(activity.calendar, activity)
  end

  describe '#show' do
    context 'when shows the activity' do
      it 'shows the activity' do
        tcc = I18n.t("enums.tcc.#{activity.tcc}")
        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       tcc,
                                       activity.deadline,
                                       complete_date(activity.created_at),
                                       complete_date(activity.updated_at)])
      end
    end
  end
end
