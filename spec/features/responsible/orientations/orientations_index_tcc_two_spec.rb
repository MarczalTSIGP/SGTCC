require 'rails_helper'

describe 'Orientation::index' do
  before do
    responsible = create(:responsible)
    login_as(responsible, scope: :professor)
  end

  describe '#index', :js do
    context 'when showing all the orientations of TCC two calendar' do
      let(:index_url) { responsible_orientations_tcc_two_path }

      before do
        create_list(:orientation, 2, :tcc_two)

        visit index_url
      end

      it 'displays basic orientation information' do
        orientations = Orientation.includes(:academic, :calendars)
                                  .order('orientations.created_at DESC')

        orientations.each_with_index do |orientation, index|
          pos = index + 1
          within("table tbody tr:nth-child(#{pos})") do
            expect(page).to have_text(orientation.short_title)
            expect(page).to have_text(orientation.advisor.name)
            expect(page).to have_text(orientation.academic.name)
            expect(page).to have_text(orientation.academic.ra)

            orientation.calendars.each do |calendar|
              expect(page).to have_text(
                calendar.year_with_semester_and_tcc
              )
            end
          end
        end
      end
    end

    context 'when an orientation has advanced from TCC one to TCC two' do
      let(:tcc_one_calendar) { create(:calendar, :tcc_one) }
      let(:tcc_two_calendar) { create(:calendar, :tcc_two) }
      let!(:advanced_orientation) do
        create(:orientation, calendars: [tcc_one_calendar, tcc_two_calendar])
      end

      before do
        visit responsible_orientations_tcc_two_path
      end

      it 'shows the advanced orientation in the TCC two listing' do
        expect(page).to have_text(advanced_orientation.academic.name)
      end
    end
  end
end
