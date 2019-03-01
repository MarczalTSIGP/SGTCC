require 'rails_helper'

describe 'Professor::index', type: :feature do
  describe '#index' do
    context 'when shows all professors' do
      it 'shows all professors with options', js: true do
        responsible = create(:professor)
        login_as(responsible, scope: :professor)

        professors = create_list(:professor, 3)

        visit responsible_professors_path

        professors.each do |a|
          expect(page).to have_content(a.name)
          expect(page).to have_content(a.email)
          expect(page).to have_content(a.username)
          expect(page).to have_content(a.created_at.strftime('%d/%m/%Y'))
        end
      end
    end
  end
end
