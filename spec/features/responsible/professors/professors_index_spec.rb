require 'rails_helper'

describe 'Professor::index', type: :feature do
  describe '#index' do
    context 'when shows all professors' do
      it 'shows all professors with options', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        professors = create_list(:professor, 3)

        visit responsible_professors_path

        professors.each do |professor|
          expect(page).to have_contents([professor.name,
                                         professor.email,
                                         professor.lattes,
                                         short_date(professor.created_at)])
        end
      end
    end
  end
end
