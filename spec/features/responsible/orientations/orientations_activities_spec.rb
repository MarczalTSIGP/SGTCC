require 'rails_helper'

describe 'Orientation::activities', type: :feature, js: true do
  let!(:responsible) { create(:responsible) }
  let!(:orientation) { create(:orientation) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientation_calendar_activities_path(orientation, orientation.current_calendar)
  end

  describe '#index' do
    it 'shows all the activites' do
      activities = orientation.current_calendar.activities

      activities.each_with_index do |activity, index|
        child = index + 1

        lore, sent = lore_sent_attributes(activity, orientation)
        within("table tbody tr:nth-child(#{child})") do
          expect(page).to have_link(activity.name)
          expect(page).to have_content(I18n.t("enums.tcc.#{activity.tcc}"))
          expect(page).to have_content(lore)
          expect(page).to have_content(sent)
          expect(page).to have_content(activity.deadline)
        end
      end
    end

    it 'have links' do
      active_link = responsible_orientations_tcc_one_path
      expect(page).to have_selector("a[href='#{active_link}'].active")

      within('nav ol.breadcrumb') do
        expect(page).to have_link(I18n.t('breadcrumbs.homepage'), href: responsible_root_path)

        calendar = orientation.current_calendar
        os = I18n.t('breadcrumbs.orientations.index', calendar: calendar.year_with_semester)
        expect(page).to have_link(os, href: responsible_orientations_tcc_one_path)

        oas = I18n.t('breadcrumbs.orientation_activities.index',
                     calendar: calendar.year_with_semester)
        expect(page).to have_content(oas)
      end

      orientation.calendars.order(year: :desc, semester: :desc).each do |calendar|
        href = responsible_orientation_calendar_activities_path(orientation, calendar)
        expect(page).to have_link(calendar.year_with_semester, href: href)
      end
    end

    it 'academic name' do
      within('div.card-header') do
        expect(page).to have_content(orientation.academic.name)
      end
    end
  end

  context '#show' do
    let!(:activity) { orientation.current_calendar.activities.first }
    let!(:academic) { orientation.academic }
    let!(:academic_activity) do
      create(:academic_activity, academic: academic, activity: activity)
    end


    before do
      visit responsible_orientation_calendar_activity_path(orientation, orientation.current_calendar, activity)
    end

    it 'shows the activity' do
      expect(page).to have_contents([activity.name,
                                     activity.base_activity_type.name,
                                     activity.deadline,
                                     I18n.t("enums.tcc.#{activity.tcc}"),
                                     complete_date(activity.created_at),
                                     complete_date(activity.updated_at),
                                     academic.name,
                                     academic_activity.title,
                                     academic_activity.summary])
    end

    it 'have links' do
      active_link = responsible_orientations_tcc_one_path
      expect(page).to have_selector("a[href='#{active_link}'].active")

      within('nav ol.breadcrumb') do
        expect(page).to have_link(I18n.t('breadcrumbs.homepage'), href: responsible_root_path)

        calendar = orientation.current_calendar
        oi = I18n.t('breadcrumbs.orientations.index', calendar: calendar.year_with_semester)
        expect(page).to have_link(oi, href: responsible_orientations_tcc_one_path)


        oai = I18n.t('breadcrumbs.orientation_activities.index',
                     calendar: calendar.year_with_semester)
        expect(page).to have_link(oai, href: responsible_orientation_calendar_activities_path(orientation, orientation.current_calendar))

        oas = I18n.t('breadcrumbs.orientation_activities.show', calendar: orientation.current_calendar.year_with_semester)
        expect(page).to have_content(oas)
      end

      expect(page).to have_link(href: academic_activity.pdf.url)
      expect(page).to have_link(href: academic_activity.complementary_files.url)
    end


    it 'academic name' do
      within('#main-card > div.card-header') do
        expect(page).to have_content(orientation.academic.name)
      end
    end

  end

  private

  def lore_sent_attributes(activity, orientation)
    return ['-', '-'] if activity.base_activity_type.info?

    lore = sent = I18n.t('helpers.boolean.false')

    if activity.academic_activity(orientation).present?
      lore = I18n.t("helpers.boolean.#{activity.academic_activity(orientation).judgment}")
      sent = I18n.t('helpers.boolean.true')
    end

    [lore, sent]
  end
end
