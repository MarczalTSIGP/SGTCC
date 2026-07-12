require 'rails_helper'

describe 'Orientation::index' do
  before do
    responsible = create(:responsible)
    login_as(responsible, scope: :professor)
  end

  describe '#index', :js do
    context 'when showing all the orientations of TCC one calendar' do
      let!(:orientations) { create_list(:orientation, 2, :tcc_one) }
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
            expect(page).to have_text(calendar.year_with_semester_and_tcc)
          end
        end
      end
    end
  end
end
