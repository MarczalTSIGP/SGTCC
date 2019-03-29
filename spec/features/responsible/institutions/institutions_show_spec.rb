require 'rails_helper'

describe 'Institution::show', type: :feature do
  describe '#show' do
    context 'when shows the institution' do
      it 'shows the institution' do
        responsible = create(:professor)
        login_as(responsible, scope: :professor)

        institution = create(:institution)
        visit responsible_institution_path(institution)

        expect(page).to have_contents([institution.name,
                                       institution.trade_name,
                                       institution.cnpj.formatted,
                                       institution.external_member.name,
                                       complete_date(institution.created_at),
                                       complete_date(institution.updated_at)])
      end
    end
  end
end
