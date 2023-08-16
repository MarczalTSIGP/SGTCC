require 'rails_helper'

describe 'Orientation::index', type: :feature do
  before do
    responsible = create(:responsible)
    login_as(responsible, scope: :professor)
  end

  describe '#index', js: true do
    context 'when shows all the orientations of tcc one calendar' do
      it 'shows all the orientations of tcc one with options' do
        create_list(:orientation_tcc_one, 2)
        orientations = Orientation.includes(:calendars, :academic).recent

        index_url = responsible_orientations_tcc_one_path
        visit index_url

        orientations.each_with_index do |orientation, index|
          pos = index + 1
          within("table tbody tr:nth-child(#{pos})") do
            expect(page).to have_link(orientation.academic.name,
                                      href: responsible_orientation_path(orientation))
            expect(page).to have_content(orientation.academic.ra)
            expect(page).to have_content(orientation.short_title)
            expect(page).to have_content(orientation.advisor.name)

            orientation.calendars.each do |calendar|
              expect(page).to have_content(calendar.year_with_semester_and_tcc)
            end
          end
        end

        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end

    context 'when shows all the orientations of tcc two calendar' do
      it 'shows all the orientations of tcc two with options' do
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
              expect(page).to have_content(calendar.year_with_semester_and_tcc)
            end
          end
        end
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
