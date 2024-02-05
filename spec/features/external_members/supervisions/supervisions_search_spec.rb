require 'rails_helper'

describe 'Supervision::search' do
  let(:external_member) { create(:external_member) }
  let(:canceled_orientation) { create(:current_orientation_tcc_one, status: 'CANCELED') }
  let(:current_orientation) do
    create(:orientation,
           calendars: [canceled_orientation.current_calendar])
  end

  before do
    external_member.supervisions << canceled_orientation
    external_member.supervisions << current_orientation
    login_as(external_member, scope: :external_member)
  end

  describe '#search', :js do
    context 'when finds the supervision' do
      it 'finds the supervision by status' do
        visit external_members_supervisions_tcc_one_path

        selectize(orientation_canceled_option, from: 'orientation_status')

        expect(page).to have_content(canceled_orientation.short_title)
        expect(page).to have_content(canceled_orientation.advisor.name)
        expect(page).to have_content(canceled_orientation.academic.name)
        expect(page).to have_content(canceled_orientation.academic.ra)

        canceled_orientation.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester_and_tcc)
        end

        expect(page).not_to have_content(current_orientation.short_title)
      end
    end
  end
end
