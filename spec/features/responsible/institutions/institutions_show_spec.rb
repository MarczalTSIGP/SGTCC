require 'rails_helper'

describe 'Institution::show', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:institution) { create(:institution) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_institution_path(institution)
  end

  describe '#show' do
    context 'when shows the institution' do
      it 'shows the institution' do
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
