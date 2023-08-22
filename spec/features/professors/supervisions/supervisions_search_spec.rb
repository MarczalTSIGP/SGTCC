require 'rails_helper'

describe 'Supervision::search', type: :feature do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:current_orientation_tcc_one, status: 'APPROVED') }

  before do
    professor.supervisions << orientation
    login_as(professor, scope: :professor)
    visit professors_supervisions_tcc_one_path
  end

  describe '#search', js: true do
    context 'when finds the supervision' do
      it 'finds the supervision by status' do
        selectize(orientation_approved_option, from: 'orientation_status')

        expect(page).to have_content(orientation.short_title)
        expect(page).to have_content(orientation.advisor.name)
        expect(page).to have_link(orientation.academic.name,
                                  href: professors_supervision_path(orientation))
        expect(page).to have_content(orientation.academic.ra)

        orientation.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester_and_tcc)
        end
      end
    end
  end
end
