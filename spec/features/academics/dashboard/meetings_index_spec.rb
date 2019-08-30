require 'rails_helper'

describe 'Meeting::index', type: :feature, js: true do
  let!(:academic) { create(:academic) }
  let(:meetings) { create_list(:meeting, 3) }

  before do
    academic.orientations << Orientation.all
    login_as(academic, scope: :academic)
    visit academics_root_path
  end

  describe '#index' do
    context 'when shows all meetings' do
      it 'shows all meetings with options' do
        academic.meetings.each do |meeting|
          expect(page).to have_contents([meeting.orientation.academic_with_calendar,
                                         short_date(meeting.date),
                                         short_date(meeting.updated_at)])
        end
      end
    end
  end
end
