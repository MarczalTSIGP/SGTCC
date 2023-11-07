require 'rails_helper'

describe 'Activity::show', type: :feature do
  let(:professor) { create(:professor) }
  let(:calendar) { create(:calendar) }
  let(:activity_type_with_document) { create(:base_activity_type, identifier: :info) }
  let!(:activity) do
    create(:activity, base_activity_type: activity_type_with_document, calendar: calendar)
  end
  let(:academic_one) { create(:academic) }
  let(:orientation_one) { create(:orientation, academic: academic_one) }

  before do
    create(:orientation_calendar, orientation: orientation_one, calendar: calendar)
    create(:academic_activity, academic: academic_one, activity: activity)

    login_as(professor, scope: :professor)
    visit professors_calendar_activity_path(activity.calendar, activity)
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
        expect(page).not_to have_selector('table')
      end
    end
  end

  describe '#show activity send_document' do
    let(:responsible) { create(:responsible) }
    let(:calendar) { create(:calendar) }
    let(:activity_type_with_document) { create(:base_activity_type, identifier: :send_document) }
    let!(:activity) do
      create(:activity, base_activity_type: activity_type_with_document, calendar: calendar)
    end
    let(:academic_one) { create(:academic) }
    let(:orientation_one) { create(:orientation, academic: academic_one) }

    before do
      create(:orientation_calendar, orientation: orientation_one, calendar: calendar)
      create(:academic_activity, academic: academic_one, activity: activity)

      login_as(professor, scope: :professor)
      visit professors_calendar_activity_path(activity.calendar, activity)
    end

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

      it 'displays academic details if activity type requires it' do
        expect(page).to have_selector('table')

        within('table') do
          expect(page).to have_content(Activity.human_attribute_name('academic').upcase)
          expect(page).to have_content(Activity.human_attribute_name('sent'))

          expect(page).to have_content(academic_one.name)
          expect(page).to have_content("#{activity.response_summary.count} de \
            #{activity.response_summary.total} #{Activity.human_attribute_name('sent')}s")
        end
      end
    end
  end
end
