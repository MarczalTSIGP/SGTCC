require 'rails_helper'

describe 'Orientation::index', type: :feature do
  let(:professor) { create(:professor) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#index', js: true do
    context 'when shows all the orientations of tcc one calendar' do
      let!(:orientation) { create(:current_orientation_tcc_one, advisor: professor) }
      let(:index_url) { professors_orientations_tcc_one_path }

      before { visit index_url }

      it 'shows basic information of tcc one supervision' do
        expect(page).to have_content(orientation.short_title)
        expect(page).to have_content(orientation.advisor.name)
        expect(page).to have_link(
          orientation.academic.name,
          href: professors_orientation_path(orientation)
        )
      end

      it 'shows calendar information of tcc one supervision' do
        orientation.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester_and_tcc)
        end
      end

      it 'shows active link for tcc one supervision' do
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end

      it 'clicks on academic name and shows "Detalhes da orientação" link' do
        orientation_link = "a[href='#{professors_orientation_path(orientation)}']"
        find(orientation_link).click

        expect(page).to have_link(
          'Detalhes da orientação',
          href: professors_orientation_path(orientation)
        )
      end

      it 'clicks on academic name and shows "Visualizar atividades" link' do
        orientation_link = "a[href='#{professors_orientation_path(orientation)}']"
        find(orientation_link).click

        expect(page).to have_link(
          'Atividades da orientação',
          href: professors_orientation_calendar_activities_path(
            orientation, orientation.current_calendar
          )
        )
      end

      it 'clicks on academic name and shows "Visualizar documentos" link' do
        orientation_link = "a[href='#{professors_orientation_path(orientation)}']"
        find(orientation_link).click

        expect(page).to have_link(
          'Documentos da orientação',
          href: professors_orientation_documents_path(orientation)
        )
      end

      it 'clicks on academic name and shows "Visualizar reuniões" link if available' do
        orientation_link = "a[href='#{professors_orientation_path(orientation)}']"
        find(orientation_link).click

        if orientation.meetings.any?
          expect(page).to have_link(
            'Reuniões da orientação',
            href: professors_orientation_meetings_path(orientation)
          )
        else
          expect(page).not_to have_link('Visualizar reuniões')
        end
      end

      it 'clicks on academic name and shows "Editar" link if allowed' do
        orientation_link = "a[href='#{professors_orientation_path(orientation)}']"
        find(orientation_link).click

        if orientation.can_be_edited?
          expect(page).to have_link(
            'Editar',
            href: edit_professors_orientation_path(orientation)
          )
        else
          expect(page).not_to have_link('Editar')
        end
      end
    end

    context 'when shows all the orientations of tcc two calendar' do
      it 'shows basic information of tcc two supervision' do
        orientation = create(:current_orientation_tcc_two, advisor: professor)
        index_url = professors_orientations_tcc_two_path
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

    context 'when shows all the orientations' do
      it 'shows basic information of history orientation' do
        orientation = create(:orientation_tcc_one, advisor: professor)
        index_url = professors_orientations_history_path
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
end
