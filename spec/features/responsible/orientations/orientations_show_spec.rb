require 'rails_helper'

describe 'Orientation::show', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:orientation) { create(:orientation) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientation_path(orientation)
  end

  describe '#show' do
    context 'when shows the orientation' do
      it 'shows the orientation' do
        expect(page).to have_contents([orientation.title,
                                       orientation.academic.name,
                                       orientation.advisor.name,
                                       orientation.calendar.year_with_semester,
                                       complete_date(orientation.created_at),
                                       complete_date(orientation.updated_at)])
      end
    end
  end
end
