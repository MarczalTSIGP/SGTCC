require 'rails_helper'

describe 'Orientation::show' do
  let(:responsible) { create(:responsible) }
  let(:calendar_tcc_one) { create(:calendar, :tcc_one) }
  let(:orientation_tcc_one) { create(:orientation, calendars: [calendar_tcc_one]) }
  let(:current_orientation_tcc_one) { create(:orientation, :current, :tcc_one) }
  let(:current_orientation_tcc_two) { create(:orientation, :current, :tcc_two) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#show', :js do
    context 'when shows the current tcc one orientation' do
      it 'shows the tcc current tcc one orientation' do
        visit responsible_orientation_path(current_orientation_tcc_one)

        expect(page).to have_text(current_orientation_tcc_one.title)
        expect(page).to have_text(current_orientation_tcc_one.academic.name)
        expect(page).to have_text(current_orientation_tcc_one.advisor.name)
        expect(page).to have_text(complete_date(current_orientation_tcc_one.created_at))
        expect(page).to have_text(complete_date(current_orientation_tcc_one.updated_at))

        current_orientation_tcc_one.calendars.each do |calendar|
          expect(page).to have_text(calendar.year_with_semester)
        end

        within('div.sidebar') do
          link = "a[href='#{responsible_orientations_current_tcc_one_path}'].active"
          expect(page).to have_selector(link)
        end
      end
    end
  end
end
