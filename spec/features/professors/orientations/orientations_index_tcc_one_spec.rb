require 'rails_helper'

describe 'Orientation::index' do
  let(:professor) { create(:professor) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#index', :js do
    context 'when shows all the orientations of tcc one calendar' do
      let!(:orientation) { create(:orientation, :current, :tcc_one, advisor: professor) }
      let(:index_url) { professors_orientations_tcc_one_path }

      before { visit index_url }

      it 'shows basic information of tcc one supervision' do
        expect(page).to have_text(orientation.short_title)
        expect(page).to have_text(orientation.advisor.name)
        expect(page).to have_link(
          orientation.academic.name,
          href: professors_orientation_path(orientation)
        )
      end

      it 'shows calendar information of tcc one supervision' do
        orientation.calendars.each do |calendar|
          expect(page).to have_text(calendar.year_with_semester_and_tcc)
        end
      end

      it 'shows active link for tcc one supervision' do
        expect(page).to have_css("a[href='#{index_url}'].active")
      end
    end
  end
end
