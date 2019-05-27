require 'rails_helper'

describe 'Orientation::show', type: :feature do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:calendar_tcc_one) { create(:current_calendar_tcc_one) }
  let(:calendar_tcc_two) { create(:current_calendar_tcc_two) }
  let(:orientation_tcc_one) { create(:orientation, advisor: professor, calendar: calendar_tcc_one) }
  let(:orientation_tcc_two) { create(:orientation, advisor: professor, calendar: calendar_tcc_two) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    context 'when shows the orientation' do
      it 'shows the orientation' do
        visit professors_orientation_path(orientation)
        expect(page).to have_contents([orientation.title,
                                       orientation.academic.name,
                                       orientation.advisor.name,
                                       orientation.calendar.year_with_semester,
                                       complete_date(orientation.created_at),
                                       complete_date(orientation.updated_at)])
        breadcrumb_text = I18n.t('breadcrumbs.orientations.history')
        first("a[href='#{professors_orientations_history_path}']", text: breadcrumb_text).click
        expect(page).to have_current_path professors_orientations_history_path
      end
    end

    context 'when shows the current tcc one orientation' do
      it 'shows the current tcc one orientation' do
        visit professors_orientation_path(orientation_tcc_one)
        expect(page).to have_contents([orientation_tcc_one.title,
                                       orientation_tcc_one.academic.name,
                                       orientation_tcc_one.advisor.name,
                                       orientation_tcc_one.calendar.year_with_semester,
                                       complete_date(orientation_tcc_one.created_at),
                                       complete_date(orientation_tcc_one.updated_at)])
        breadcrumb_text = I18n.t('breadcrumbs.orientations.tcc.one.calendar',
                                 calendar: calendar_tcc_one.year_with_semester)
        first("a[href='#{professors_orientations_tcc_one_path}']", text: breadcrumb_text).click
        expect(page).to have_current_path professors_orientations_tcc_one_path
      end
    end

    context 'when shows the current tcc two orientation' do
      it 'shows the current tcc two orientation' do
        visit professors_orientation_path(orientation_tcc_two)
        expect(page).to have_contents([orientation_tcc_two.title,
                                       orientation_tcc_two.academic.name,
                                       orientation_tcc_two.advisor.name,
                                       orientation_tcc_two.calendar.year_with_semester,
                                       complete_date(orientation_tcc_two.created_at),
                                       complete_date(orientation_tcc_two.updated_at)])
        breadcrumb_text = I18n.t('breadcrumbs.orientations.tcc.two.calendar',
                                 calendar: calendar_tcc_one.year_with_semester)
        first("a[href='#{professors_orientations_tcc_two_path}']", text: breadcrumb_text).click
        expect(page).to have_current_path professors_orientations_tcc_two_path
      end
    end
  end
end
