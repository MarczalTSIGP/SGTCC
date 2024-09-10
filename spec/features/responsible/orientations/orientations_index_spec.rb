require 'rails_helper'

describe 'Orientation::index' do
  before do
    responsible = create(:responsible)
    login_as(responsible, scope: :professor)
  end

  describe '#index', :js do
    context 'when showing all the orientations of TCC one calendar' do
      let!(:orientations) { create_list(:orientation_tcc_one, 2) }
      let(:index_url) { responsible_orientations_tcc_one_path }

      before do
        visit index_url
      end

      it 'displays basic orientation information' do
        orientations.each do |orientation|
          academic_link = find("a[href='#{responsible_orientation_path(orientation)}']")
          expect(academic_link).to have_text(orientation.academic.name)
        end
      end

      it 'displays calendar information' do
        orientations.each do |orientation|
          orientation.calendars.each do |calendar|
            expect(page).to have_content(calendar.year_with_semester_and_tcc)
          end
        end
      end

      it 'displays links to orientation details' do
        orientations.each do |orientation|
          visit index_url
          orientation_link = "a[href='#{responsible_orientation_path(orientation)}']"
          find(orientation_link).click

          expect(page).to have_link(
            'Detalhes da orientação',
            href: responsible_orientation_path(orientation)
          )
        end
      end

      it 'displays links to orientation activities' do
        orientations.each do |orientation|
          orientation_link = "a[href='#{responsible_orientation_path(orientation)}']"
          visit index_url
          find(orientation_link).click

          expect(page).to have_link(
            'Atividades da orientação',
            href: responsible_orientation_calendar_activities_path(
              orientation, orientation.current_calendar
            )
          )
        end
      end

      it 'displays links to orientation meetings if they exist' do
        orientations.each do |orientation|
          orientation_link = "a[href='#{responsible_orientation_path(orientation)}']"
          visit index_url
          find(orientation_link).click

          next unless orientation.meetings.any?

          expect(page).to have_link(
            'Reuniões da orientação',
            href: professors_orientation_meetings_path(orientation)
          )
        end
      end

      it 'displays links to orientation documents if they exist' do
        orientations.each do |orientation|
          orientation_link = "a[href='#{responsible_orientation_path(orientation)}']"
          visit index_url
          find(orientation_link).click

          next if orientation.documents.empty?

          expect(page).to have_link(
            'Documentos da orientação',
            href: responsible_orientation_documents_path(orientation)
          )
        end
      end

      it 'displays links to edit orientations' do
        orientations.each do |orientation|
          orientation_link = "a[href='#{responsible_orientation_path(orientation)}']"
          visit index_url
          find(orientation_link).click

          next unless orientation.can_be_edited?

          expect(page).to have_link(
            'Editar',
            href: edit_responsible_orientation_path(orientation)
          )
        end
      end

      it 'displays links to remove orientations' do
        orientations.each do |orientation|
          orientation_link = "a[href='#{responsible_orientation_path(orientation)}']"
          visit index_url
          find(orientation_link).click

          next unless orientation.can_be_destroyed?

          expect(page).to have_link(
            'Remover',
            href: responsible_orientation_path(orientation)
          )
        end
      end
    end

    context 'when showing all the orientations of TCC two calendar' do
      let(:index_url) { responsible_orientations_tcc_two_path }

      before do
        create_list(:orientation_tcc_two, 2)

        visit index_url
      end

      it 'displays basic orientation information' do
        orientations = Orientation.includes(:academic, :calendars)
                                  .order('orientations.created_at DESC')

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
      end
    end
  end
end
