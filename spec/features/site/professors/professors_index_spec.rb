require 'rails_helper'

describe 'Professor::index', type: :feature, js: true do
  let!(:professors) { create_list(:professor, 25) }

  before do
    create(:page, url: 'professores')
    visit site_professors_path
  end

  describe '#index' do
    context 'when shows all professors' do
      it 'shows all professors with options' do
        professors.each do |professor|
          expect(page).to have_contents([professor.name,
                                         professor.email,
                                         professor.professor_type.name])
          expect(page).to have_selector(link(professor.lattes))
        end
      end
    end
  end
end
