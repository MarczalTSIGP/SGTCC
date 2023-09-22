require 'rails_helper'

describe 'Orientation::index', type: :feature do
  before do
    professor = create(:professor_tcc_one)
    login_as(professor, scope: :professor)
  end

  describe '#index', js: true do
    context 'when shows all the orientations of the current tcc one calendar' do
      let(:orientation) { create(:current_orientation_tcc_one) }

      before do
        visit tcc_one_professors_calendar_orientations_path(orientation.current_calendar)
      end

      it 'shows the basic information' do
        expect(page).to have_content(orientation.short_title)
        expect(page).to have_content(orientation.advisor.name)
        expect(page).to have_content(orientation.academic.name)
        expect(page).to have_content(orientation.academic.ra)
      end

      it 'shows calendar information' do
        orientation.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester_and_tcc)
        end
      end

      it 'shows links for more details' do
        academic_link = page.find(
          "a[href='#{tcc_one_professors_calendar_orientation_path(orientation.current_calendar, orientation)}']"
        )
        academic_link.click

        expect(page).to have_link('Detalhes da orientação',
                                  href: tcc_one_professors_calendar_orientation_path(
                                    orientation.current_calendar, orientation
                                  ))
        expect(page).to have_link('Atividades da orientação',
                                  href: tcc_one_professors_calendar_orientation_activities_path(
                                    orientation.current_calendar, orientation
                                  ))
        expect(page).to have_link('Documentos da orientação',
                                  href: tcc_one_professors_calendar_orientation_documents_path(
                                    orientation.current_calendar, orientation
                                  ))
      end
    end
  end
end
