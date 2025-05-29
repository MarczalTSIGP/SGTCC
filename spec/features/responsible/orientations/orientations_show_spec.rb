require 'rails_helper'

describe 'Orientation::show' do
  let(:responsible) { create(:responsible) }
  let(:calendar_tcc_one) { create(:calendar_tcc_one) }
  let(:orientation_tcc_one) { create(:orientation, calendars: [calendar_tcc_one]) }
  let(:current_orientation_tcc_one) { create(:current_orientation_tcc_one) }
  let(:current_orientation_tcc_two) { create(:current_orientation_tcc_two) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#show', :js do
    context 'when shows the tcc one orientation' do
      it 'shows the tcc one orientation' do
        visit responsible_orientation_path(orientation_tcc_one)

        expect(page).to have_content(orientation_tcc_one.title)
        expect(page).to have_content(orientation_tcc_one.academic.name)
        expect(page).to have_content(complete_date(orientation_tcc_one.created_at))
        expect(page).to have_content(complete_date(orientation_tcc_one.updated_at))

        orientation_tcc_one.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester)
        end

        within('div.sidebar') do
          expect(page).to have_css("a[href='#{responsible_orientations_tcc_one_path}'].active")
        end

        within('nav ol.breadcrumb') do
          expect(page).to have_link(I18n.t('breadcrumbs.homepage'), href: responsible_root_path)

          calendar = orientation_tcc_one.current_calendar
          oi = I18n.t('breadcrumbs.orientations.index', calendar: calendar.year_with_semester)
          expect(page).to have_link(oi, href: responsible_orientations_tcc_one_path)

          oas = I18n.t("breadcrumbs.orientations.tcc.#{calendar.tcc}.show",
                       calendar: calendar.year_with_semester)
          expect(page).to have_content(oas)
        end
      end
    end

    context 'when shows the current tcc one orientation' do
      it 'shows the tcc current tcc one orientation' do
        visit responsible_orientation_path(current_orientation_tcc_one)

        expect(page).to have_content(current_orientation_tcc_one.title)
        expect(page).to have_content(current_orientation_tcc_one.academic.name)
        expect(page).to have_content(current_orientation_tcc_one.advisor.name)
        expect(page).to have_content(complete_date(current_orientation_tcc_one.created_at))
        expect(page).to have_content(complete_date(current_orientation_tcc_one.updated_at))

        current_orientation_tcc_one.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester)
        end

        within('div.sidebar') do
          link = "a[href='#{responsible_orientations_current_tcc_one_path}'].active"
          expect(page).to have_selector(link)
        end
      end
    end

    context 'when shows the current tcc two orientation' do
      it 'shows the tcc current tcc two orientation' do
        visit responsible_orientation_path(current_orientation_tcc_two)
        expect(page).to have_content(current_orientation_tcc_two.title)
        expect(page).to have_content(current_orientation_tcc_two.academic.name)
        expect(page).to have_content(current_orientation_tcc_two.advisor.name)
        expect(page).to have_content(complete_date(current_orientation_tcc_two.created_at))
        expect(page).to have_content(complete_date(current_orientation_tcc_two.updated_at))

        current_orientation_tcc_two.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester)
        end

        within('div.sidebar') do
          link = "a[href='#{responsible_orientations_current_tcc_two_path}'].active"
          expect(page).to have_selector(link)
        end
      end
    end
  end
end
