require 'rails_helper'

describe 'Calendar::index', type: :feature do
  let!(:orientation) { create(:orientation) }

  before do
    login_as(orientation.academic, scope: :academic)
  end

  describe '#index' do
    context 'when shows all calendars' do
      it 'shows all tcc 1 calendars with options' do
        index_url = academics_calendars_path
        visit index_url
        calendar = orientation.calendar

        expect(page).to have_contents([calendar.year_with_semester,
                                       I18n.t("enums.tcc.#{calendar.tcc}"),
                                       orientation.title,
                                       orientation.advisor.name,
                                       short_date(calendar.created_at)])

        orientation.supervisors.each do |supervisor|
          expect(page).to have_content(supervisor.name)
        end

        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
