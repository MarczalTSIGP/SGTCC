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


        orientation.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester)
          expect(page).to have_content(I18n.t("enums.tcc.#{calendar.tcc}"))
          expect(page).to have_content(orientation.title)
          expect(page).to have_content(orientation.advisor.name)
        end

        orientation.supervisors.each do |supervisor|
          expect(page).to have_content(supervisor.name)
        end

        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
