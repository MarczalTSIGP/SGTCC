require 'rails_helper'

describe 'Supervision::show', type: :feature do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }

  before do
    professor.supervisions << orientation
    login_as(professor, scope: :professor)
    visit professors_supervision_path(orientation)
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
