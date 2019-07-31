require 'rails_helper'

describe 'Meeting::index', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let!(:meetings) { create_list(:meeting, 3) }

  before do
    professor.orientations << Orientation.all
    login_as(professor, scope: :professor)
  end

  describe '#index' do
    context 'when shows all meetings' do
      it 'shows all meetings with options' do
        visit professors_meetings_path
        meetings.each do |meeting|
          expect(page).to have_contents([meeting.title,
                                         short_date(meeting.created_at),
                                         short_date(meeting.updated_at)])
        end
      end
    end
  end
end
