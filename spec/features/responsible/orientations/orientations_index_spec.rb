require 'rails_helper'

describe 'Orientation::index', type: :feature do
  before do
    responsible = create(:responsible)
    login_as(responsible, scope: :professor)
  end

  describe '#index' do
    context 'when shows all the orientations' do
      it 'shows all the orientations with options', js: true do
        orientations = create_list(:orientation, 3)

        visit responsible_orientations_path

        orientations.each do |orientation|
          expect(page).to have_contents([orientation.title,
                                         orientation.advisor.name,
                                         orientation.academic.name,
                                         short_date(orientation.created_at)])
        end
      end
    end
  end
end
