require 'rails_helper'

describe 'Orientation::current_tcc' do
  before do
    responsible = create(:responsible)
    login_as(responsible, scope: :professor)
  end

  describe '#index', :js do
    context 'when shows all the orientations of tcc one calendar' do
      it 'shows all the orientations of tcc one with options' do
        orientation = create(:current_orientation_tcc_one)

        visit responsible_orientations_current_tcc_one_path

        within('table tbody tr:nth-child(1)') do
          expect(page).to have_content(orientation.short_title)
          expect(page).to have_content(orientation.advisor.name)
          expect(page).to have_link(orientation.academic.name,
                                    href: responsible_orientation_path(orientation))
          expect(page).to have_content(orientation.academic.ra)

          orientation.calendars.each do |calendar|
            expect(page).to have_content(calendar.year_with_semester_and_tcc)
          end
        end
      end
    end

    context 'when shows all the orientations of tcc two calendar' do
      it 'shows all the orientations of tcc two with options' do
        orientation = create(:current_orientation_tcc_two)

        visit responsible_orientations_current_tcc_two_path

        within('table tbody tr:nth-child(1)') do
          expect(page).to have_content(orientation.short_title)
          expect(page).to have_content(orientation.advisor.name)
          expect(page).to have_content(orientation.academic.name)
          expect(page).to have_content(orientation.academic.ra)

          orientation.calendars.each do |calendar|
            expect(page).to have_content(calendar.year_with_semester_and_tcc)
          end
        end
      end
    end
  end
end
