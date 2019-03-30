require 'rails_helper'

describe 'Institution::pagination', type: :feature do
  describe '#pagination' do
    context 'when finds the last institution on second page' do
      it 'finds the last institution', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        create_list(:institution, 30)
        visit responsible_institutions_path
        institution = Institution.order(:name).last

        click_link(2)

        expect(page).to have_contents([institution.name,
                                       institution.trade_name,
                                       institution.cnpj.formatted,
                                       institution.created_at.strftime('%d/%m/%Y')])
      end
    end
  end
end
