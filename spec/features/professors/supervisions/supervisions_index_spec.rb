require 'rails_helper'

describe 'Supervision::index', type: :feature do
  let(:professor) { create(:professor) }

  before do
    login_as(professor, scope: :professor)
  end

  context 'when shows all the supervisions of tcc one calendar' do
    let(:orientation) { create(:current_orientation_tcc_one) }
    let(:index_url) { professors_supervisions_tcc_one_path }

    before do
      orientation.professor_supervisors << professor
      visit index_url
    end

    it 'shows the orientation information' do
      expect(page).to have_content(orientation.short_title)
      expect(page).to have_content(orientation.advisor.name)
      expect(page).to have_link(
        orientation.academic.name,
        href: professors_supervision_path(orientation)
      )
    end

    it 'shows the calendar information' do
      orientation.calendars.each do |calendar|
        expect(page).to have_content(calendar.year_with_semester_and_tcc)
      end
    end

    it 'displays active link' do
      expect(page).to have_selector("a[href='#{index_url}'].active")
    end

    it 'has links for details, activities, and documents' do
      orientation_link = "a[href='#{professors_supervision_path(orientation)}']"
      find(orientation_link).click

      expect(page).to have_link(
        'Detalhes da orientação',
        href: professors_supervision_path(orientation)
      )
      expect(page).to have_link(
        'Visualizar atividades',
        href: professors_supervision_calendar_activities_path(
          orientation, orientation.current_calendar
        )
      )
      expect(page).to have_link(
        'Visualizar documentos',
        href: professors_supervision_documents_path(orientation)
      )
    end
  end

  context 'when shows all the supervisions of tcc two calendar' do
    it 'shows all the supervisions of tcc two with options' do
      orientation = create(:current_orientation_tcc_two)
      orientation.professor_supervisors << professor

      index_url = professors_supervisions_tcc_two_path
      visit index_url

      expect(page).to have_content(orientation.short_title)
      expect(page).to have_content(orientation.advisor.name)
      expect(page).to have_content(orientation.academic.name)

      orientation.calendars.each do |calendar|
        expect(page).to have_content(calendar.year_with_semester_and_tcc)
      end

      expect(page).to have_selector("a[href='#{index_url}'].active")
    end
  end
end
