require 'rails_helper'

describe 'Orientation::show', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:calendar_tcc_one) { create(:calendar_tcc_one) }
  let(:current_calendar_tcc_one) { create(:current_calendar_tcc_one) }
  let(:current_calendar_tcc_two) { create(:current_calendar_tcc_two) }
  let(:orientation_tcc_one) { create(:orientation, calendar: calendar_tcc_one) }
  let(:current_orientation_tcc_one) { create(:orientation, calendar: current_calendar_tcc_one) }
  let(:current_orientation_tcc_two) { create(:orientation, calendar: current_calendar_tcc_two) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#show', js: true do
    context 'when shows the tcc one orientation' do
      it 'shows the tcc one orientation' do
        visit responsible_orientation_path(orientation_tcc_one)
        expect(page).to have_contents([orientation_tcc_one.title,
                                       orientation_tcc_one.academic.name,
                                       orientation_tcc_one.advisor.name,
                                       orientation_tcc_one.calendar.year_with_semester,
                                       complete_date(orientation_tcc_one.created_at),
                                       complete_date(orientation_tcc_one.updated_at)])
        expect(page).to have_selector("a[href='#{responsible_orientations_tcc_one_path}'].active")
        breadcrumb_text = I18n.t('breadcrumbs.orientations.index')
        first("a[href='#{responsible_orientations_tcc_one_path}']", text: breadcrumb_text).click
        expect(page).to have_current_path responsible_orientations_tcc_one_path
      end
    end

    context 'when shows the current tcc one orientation' do
      it 'shows the tcc current tcc one orientation' do
        visit responsible_orientation_path(current_orientation_tcc_one)
        expect(page).to have_contents([current_orientation_tcc_one.title,
                                       current_orientation_tcc_one.academic.name,
                                       current_orientation_tcc_one.advisor.name,
                                       current_orientation_tcc_one.calendar.year_with_semester,
                                       complete_date(current_orientation_tcc_one.created_at),
                                       complete_date(current_orientation_tcc_one.updated_at)])
        breadcrumb_text = I18n.t('breadcrumbs.orientations.tcc.one.calendar',
                                 calendar: current_calendar_tcc_one.year_with_semester)
        back_link = responsible_orientations_current_tcc_one_path
        expect(page).to have_selector("a[href='#{back_link}'].active")
        first("a[href='#{back_link}']", text: breadcrumb_text).click
        expect(page).to have_current_path back_link
      end
    end

    context 'when shows the current tcc two orientation' do
      it 'shows the tcc current tcc two orientation' do
        visit responsible_orientation_path(current_orientation_tcc_two)
        expect(page).to have_contents([current_orientation_tcc_two.title,
                                       current_orientation_tcc_two.academic.name,
                                       current_orientation_tcc_two.advisor.name,
                                       current_orientation_tcc_two.calendar.year_with_semester,
                                       complete_date(current_orientation_tcc_two.created_at),
                                       complete_date(current_orientation_tcc_two.updated_at)])
        breadcrumb_text = I18n.t('breadcrumbs.orientations.tcc.two.calendar',
                                 calendar: current_calendar_tcc_two.year_with_semester)
        back_link = responsible_orientations_current_tcc_two_path
        expect(page).to have_selector("a[href='#{back_link}'].active")
        first("a[href='#{back_link}']", text: breadcrumb_text).click
        expect(page).to have_current_path back_link
      end
    end
  end
end
