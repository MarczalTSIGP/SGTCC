require 'rails_helper'

describe 'Activity::show' do
  let(:professor_tcc_one) { create(:professor_tcc_one) }
  let(:calendar)          { create(:current_calendar_tcc_one) }
  let(:activity)          { calendar.activities.first }
  let(:orientation_one)   { create(:orientation, calendar_ids: [calendar.id]) }
  let(:orientation_two)   { create(:orientation, calendar_ids: [calendar.id]) }

  before do
    create(:academic_activity, academic: orientation_one.academic, activity:)

    login_as(professor_tcc_one, scope: :professor)
    visit tcc_one_professors_calendar_activity_path(calendar, activity)
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
            expect(page).to have_content(academic.name)
            expect(page).to have_content(I18n.t("helpers.boolean.#{academic.sent?}"))
          end
        end

        expect(page).to have_content(activity.responses.entries_info)
      end
    end

    it 'has link when sent' do
      url = tcc_one_professors_orientation_calendar_activity_path(orientation_one, calendar,
                                                                  activity)
      within('table.table tbody') do
        expect(page).to have_link(I18n.t('helpers.boolean.true'), href: url)
      end
    end

    it 'has no link when no sent' do
      url = tcc_one_professors_orientation_calendar_activity_path(orientation_two, calendar,
                                                                  activity)

      within('table.table tbody') do
        expect(page).to have_no_link(I18n.t('helpers.boolean.true'), href: url)
      end
    end
  end
end
