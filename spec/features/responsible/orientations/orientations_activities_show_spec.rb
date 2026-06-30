require 'rails_helper'

describe 'Orientation::activities', :js do
  let!(:responsible) { create(:responsible) }
  let!(:orientation) { create(:orientation) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#show' do
    let!(:activity) { create(:activity, calendar: orientation.current_calendar) }
    let!(:academic) { orientation.academic }
    let!(:academic_activity) do
      create(:academic_activity, academic:, activity:)
    end

    before do
      visit responsible_orientation_calendar_activity_path(orientation,
                                                           orientation.current_calendar,
                                                           activity)
    end

    it 'shows the activity' do
      expect_orientation_activity_contents(academic_activity)
    end

    it 'have links' do
      active_link = responsible_orientations_tcc_one_path
      expect(page).to have_css("a[href='#{active_link}'].active")

      within('nav ol.breadcrumb') do
        expect(page).to have_link(I18n.t('breadcrumbs.homepage'), href: responsible_root_path)

        calendar = orientation.current_calendar
        oi = I18n.t('breadcrumbs.orientations.index', calendar: calendar.year_with_semester)
        expect(page).to have_link(oi, href: responsible_orientations_tcc_one_path)

        oai = I18n.t('breadcrumbs.orientation_activities.index',
                     calendar: calendar.year_with_semester)

        path = responsible_orientation_calendar_activities_path(orientation,
                                                                orientation.current_calendar)
        expect(page).to have_link(oai, href: path)

        oas = I18n.t('breadcrumbs.orientation_activities.show',
                     calendar: orientation.current_calendar.year_with_semester)
        expect(page).to have_text(oas)
      end

      expect(page).to have_link(href: academic_activity.pdf.url)
      expect(page).to have_link(href: academic_activity.complementary_files.url)
    end

    it 'academic name' do
      within('#main-card > div.card-header') do
        expect(page).to have_text(orientation.academic.name)
      end
    end
  end
end
