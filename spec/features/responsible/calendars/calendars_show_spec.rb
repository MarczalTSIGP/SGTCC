require 'rails_helper'

describe 'Calendar::show', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:calendar) { create(:calendar) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_calendar_path(calendar)
  end

  describe '#show' do
    context 'when shows the calendar' do
      it 'shows the calendar' do
        calendar.activities.each do |activity|
          tcc = I18n.t("enums.tcc.#{activity.tcc}")
          expect(page).to have_contents([activity.name,
                                         activity.base_activity_type.name,
                                         tcc,
                                         short_date(activity.initial_date),
                                         short_date(activity.final_date)])
        end
      end
    end
  end
end
