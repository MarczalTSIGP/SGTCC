require 'rails_helper'

describe 'Professor::index', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:professors) { create_list(:professor, 3) }
  let(:resource_name) { Professor.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_professors_path
  end

  describe '#index' do
    context 'when shows all professors' do
      it 'shows all professors with options' do
        professors.each do |professor|
          expect(page).to have_contents([professor.name,
                                         professor.email,
                                         short_date(professor.created_at)])
          expect(page).to have_selector(link(professor.lattes))
        end
      end
    end
  end
end
