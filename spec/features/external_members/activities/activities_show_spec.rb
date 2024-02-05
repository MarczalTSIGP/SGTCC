require 'rails_helper'

describe 'Activity::show' do
  let(:external_member) { create(:external_member) }
  let(:calendar)        { create(:current_calendar_tcc_one) }
  let(:activity)        { calendar.activities.first }
  let(:orientation_one) { create(:orientation, calendar_ids: [calendar.id]) }
  let(:orientation_two) { create(:orientation, calendar_ids: [calendar.id]) }

  before do
    create(:academic_activity, academic: orientation_one.academic, activity:)

    login_as(external_member, scope: :external_member)
    visit external_members_calendar_activity_path(calendar, activity)
  end

  it 'base info' do
    tcc = I18n.t("enums.tcc.#{activity.tcc}")
    expect(page).to have_contents([activity.name,
                                   activity.base_activity_type.name,
                                   activity.deadline,
                                   tcc,
                                   complete_date(activity.created_at),
                                   complete_date(activity.updated_at)])
  end

  context 'with responses' do
    it 'show all' do
      within('table.table') do
        activity.responses.academics.each_with_index do |academic, index|
          child = index + 1
          within("tbody tr:nth-child(#{child})") do
            sent_value = I18n.t("helpers.boolean.#{academic.sent?}")

            expect(page).to have_content(academic.name)
            expect(page).to have_content(sent_value)
            expect(page).not_to have_link(sent_value)
          end
        end

        expect(page).to have_content(activity.responses.entries_info)
      end
    end
  end
end
