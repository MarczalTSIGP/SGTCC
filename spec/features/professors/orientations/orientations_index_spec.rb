require 'rails_helper'

describe 'Orientation::index', type: :feature do
  let(:professor) { create(:professor) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#index', js: true do
    context 'when shows all the orientations of tcc one calendar' do
      it 'shows basic information of tcc one supervision' do
        orientation = create(:current_orientation_tcc_one, advisor: professor)
        index_url = professors_orientations_tcc_one_path
        visit index_url

        expect(page).to have_content(orientation.short_title)
        expect(page).to have_content(orientation.advisor.name)
        expect(page).to have_link(
          orientation.academic.name,
          href: professors_orientation_path(orientation)
        )
      end

      it 'shows calendar information of tcc one supervision' do
        orientation = create(:current_orientation_tcc_one, advisor: professor)
        index_url = professors_orientations_tcc_one_path
        visit index_url

        orientation.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester_and_tcc)
        end
      end

      it 'shows active link for tcc one supervision' do
        create(:current_orientation_tcc_one, advisor: professor)
        index_url = professors_orientations_tcc_one_path
        visit index_url

        expect(page).to have_selector("a[href='#{index_url}'].active")
      end

      it 'clicks on academic name and shows additional options' do
        create(:current_orientation_tcc_one, advisor: professor)
        index_url = professors_orientations_tcc_one_path
        visit index_url

        find('.academic-name-link').click
        expect(page).to have_link(
          'Detalhes da orientação',
          href: professors_orientation_path(Orientation.last)
        )
        expect(page).to have_link(
          'Visualizar atividades',
          href: professors_orientation_calendar_activities_path(
            Orientation.last, Orientation.last.current_calendar
          )
        )
        expect(page).to have_link(
          'Visualizar documentos',
          href: professors_orientation_documents_path(Orientation.last)
        )

        if Orientation.last.meetings.any?
          expect(page).to have_link(
            'Visualizar reuniões',
            href: professors_orientation_meetings_path(Orientation.last)
          )
        else
          expect(page).not_to have_link('Visualizar reuniões')
        end

        if Orientation.last.can_be_edited?
          expect(page).to have_link(
            'Editar',
            href: edit_professors_orientation_path(Orientation.last)
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
