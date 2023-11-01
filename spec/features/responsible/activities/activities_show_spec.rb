require 'rails_helper'

describe 'Activity::show', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:activity) { create(:activity) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_calendar_activity_path(activity.calendar, activity)
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
      it 'displays academic details if activity type requires it' do
        activity_type_with_document = create(:activity_type, send_document: true)
        activity_with_academics = create(:activity, calendar: calendar, base_activity_type: activity_type_with_document)
        academic = create(:academic, activity: activity_with_academics, name: 'Sample Academic')

        visit responsible_calendar_activity_path(calendar, activity_with_academics)

        within('table') do
          expect(page).to have_content("#{Activity.human_attribute_name('academic')}")
          expect(page).to have_content("#{Activity.human_attribute_name('sent')}")

          expect(page).to have_content(academic.name)
          expect(page).to have_content(t("helpers.boolean.#{academic.sent_academic_activity}"))

          expect(page).to have_content("#{Activity.human_attribute_name('total')}: #{activity_with_academics.responses.count} de #{activity_with_academics.responses.total} #{Activity.human_attribute_name('sent')}s")
        end
      end
    end
  end
end
