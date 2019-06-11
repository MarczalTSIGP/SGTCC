require 'rails_helper'

describe 'Supervision::search', type: :feature do
  let(:external_member) { create(:external_member) }
  let(:orientation) { create(:current_orientation_tcc_one, status: 'CANCELED') }

  before do
    external_member.supervisions << orientation
    login_as(external_member, scope: :external_member)
    visit external_members_supervisions_tcc_one_path
  end

  describe '#search', js: true do
    context 'when finds the supervision' do
      it 'finds the supervision by status' do
        selectize(orientation_canceled_option, from: 'orientation_status')
        expect(page).to have_contents([orientation.short_title,
                                       orientation.advisor.name,
                                       orientation.academic.name,
                                       orientation.academic.ra,
                                       orientation.calendar.year_with_semester_and_tcc])
      end
    end
  end
end
