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
        expect(page).to have_contents([orientation.short_title,
                                       orientation.advisor.name,
                                       orientation.academic.name,
                                       orientation.academic.ra,
                                       orientation.calendar.year_with_semester_and_tcc])
      end
    end
  end
end
