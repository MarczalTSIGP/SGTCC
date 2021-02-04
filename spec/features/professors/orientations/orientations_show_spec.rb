require 'rails_helper'

describe 'Orientation::show', type: :feature do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let(:calendar_tcc_one) { create(:current_calendar_tcc_one) }
  let(:calendar_tcc_two) { create(:current_calendar_tcc_two) }
  let(:orientation_tcc_one) { create(:orientation, advisor: professor, calendars: [calendar_tcc_one]) }
  let(:orientation_tcc_two) { create(:orientation, advisor: professor, calendars: [calendar_tcc_two]) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    context 'when shows the orientation' do
      it 'shows the orientation' do
        visit professors_orientation_path(orientation)

        expect_contents_of(orientation)

        breadcrumb_text = I18n.t('breadcrumbs.orientations.history')
        first("a[href='#{professors_orientations_history_path}']", text: breadcrumb_text).click
        expect(page).to have_current_path professors_orientations_history_path
      end
    end

    context 'when shows the current tcc one orientation' do
      it 'shows the current tcc one orientation' do
        visit professors_orientation_path(orientation_tcc_one)

        expect_contents_of(orientation_tcc_one)

        breadcrumb_text = I18n.t('breadcrumbs.orientations.tcc.one.calendar',
                                 calendar: calendar_tcc_one.year_with_semester)
        first("a[href='#{professors_orientations_tcc_one_path}']", text: breadcrumb_text).click
        expect(page).to have_current_path professors_orientations_tcc_one_path
      end
    end

    context 'when shows the current tcc two orientation' do
      it 'shows the current tcc two orientation' do
        visit professors_orientation_path(orientation_tcc_two)

        expect_contents_of(orientation_tcc_two)

        breadcrumb_text = I18n.t('breadcrumbs.orientations.tcc.two.calendar',
                                 calendar: calendar_tcc_two.year_with_semester)
        first("a[href='#{professors_orientations_tcc_two_path}']", text: breadcrumb_text).click
        expect(page).to have_current_path professors_orientations_tcc_two_path
      end
    end
  end

  private

  def expect_contents_of(o)
    expect(page).to have_content(o.title)
    expect(page).to have_content(o.academic.name)
    expect(page).to have_content(o.advisor.name)

    o.calendars.each do |calendar|
      expect(page).to have_content(calendar.year_with_semester_and_tcc)
    end

    expect(page).to have_content(complete_date(o.created_at))
    expect(page).to have_content(complete_date(o.updated_at))
  end
end
