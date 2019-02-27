require 'rails_helper'

describe 'Academics::search', type: :feature do
  describe '#search' do
    context 'when founded the academic' do
      it 'founded the academic by the name', js: true do
        professor = create(:professor)
        login_as(professor, scope: :professor)

        academics = create_list(:academic, 10)

        visit responsible_academics_path

        academic = academics.first

        fill_in 'term', with: academic.name

        expect(page).to have_content(academic.name)
        expect(page).to have_content(academic.email)
        expect(page).to have_content(academic.ra)
        expect(page).to have_content(academic.created_at.strftime('%d/%m/%Y'))
      end
    end
  end
end
