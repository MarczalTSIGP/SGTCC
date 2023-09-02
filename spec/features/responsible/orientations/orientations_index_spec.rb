require 'rails_helper'

describe 'Orientation::index', type: :feature do
  before do
    responsible = create(:responsible)
    login_as(responsible, scope: :professor)
  end

  describe '#index', js: true do
    context 'when showing all the orientations of TCC one calendar' do
      it 'shows all the orientations of TCC one with options' do
        create_list(:orientation_tcc_one, 2)
        orientations = Orientation.includes(:calendars, :academic).recent
        index_url = responsible_orientations_tcc_one_path
        visit index_url

        orientations.each_with_index do |orientation, index|
          pos = index + 1
          within("table tbody tr:nth-child(#{pos})") do
            expect(page).to have_link(
              orientation.academic.name,
              href: responsible_orientation_path(orientation)
            )
            expect(page).to have_content(orientation.academic.ra)
            expect(page).to have_content(orientation.short_title)
            expect(page).to have_content(orientation.advisor.name)

            orientation.calendars.each do |calendar|
              expect(page).to have_content(
                calendar.year_with_semester_and_tcc
              )
            end

            page.execute_script('arguments[0].click();', find('.academic-name-link'))
            expect(page).to have_link(
              'Detalhes da orientação',
              href: responsible_orientation_path(orientation)
            )
            expect(page).to have_link(
              'Atividades da orientação',
              href: responsible_orientation_calendar_activities_path(
                orientation, orientation.current_calendar
              )
            )

            if orientation.meetings.any?
              expect(page).to have_link(
                'Reuniões da orientação',
                href: professors_orientation_meetings_path(orientation)
              )
            else
              expect(page).not_to have_link('Reuniões da orientação')
            end

            unless orientation.documents.empty?
              expect(page).to have_link(
                'Documentos da orientação',
                href: responsible_orientation_documents_path(orientation)
              )
            end

            if orientation.can_be_edited? || orientation.can_be_destroyed?
              expect(page).to have_selector('.dropdown-divider')
            end

            if orientation.can_be_edited?
              expect(page).to have_link(
                'Editar',
                href: edit_responsible_orientation_path(orientation)
              )
            end

            if orientation.can_be_destroyed?
              expect(page).to have_link(
                'Remover',
                href: responsible_orientation_path(orientation)
              )
            end
          end
        end

        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end

    context 'when showing all the orientations of TCC two calendar' do
      it 'shows all the orientations of TCC two with options' do
        create_list(:orientation_tcc_two, 2)
        orientations = Orientation.includes(:calendars, :academic).recent
        index_url = responsible_orientations_tcc_two_path
        visit index_url

        orientations.each_with_index do |orientation, index|
          pos = index + 1
          within("table tbody tr:nth-child(#{pos})") do
            expect(page).to have_content(orientation.short_title)
            expect(page).to have_content(orientation.advisor.name)
            expect(page).to have_content(orientation.academic.name)
            expect(page).to have_content(orientation.academic.ra)

            orientation.calendars.each do |calendar|
              expect(page).to have_content(
                calendar.year_with_semester_and_tcc
              )
            end
          end
        end

        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
