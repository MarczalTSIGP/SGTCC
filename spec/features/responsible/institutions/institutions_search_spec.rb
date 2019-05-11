require 'rails_helper'

describe 'Institution::search', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:institutions) { create_list(:institution, 25) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_institutions_path
  end

  describe '#search' do
    context 'when finds the institution' do
      it 'finds the institution by the trade name' do
        institution = institutions.first

        fill_in 'term', with: institution.trade_name
        first('#search').click

        expect(page).to have_contents([institution.external_member.name,
                                       institution.trade_name,
                                       institution.cnpj.formatted,
                                       short_date(institution.created_at)])
      end
    end

    context 'when the result is not found' do
      it 'returns not found message' do
        fill_in 'term', with: 'a1#\231/ere'
        first('#search').click
        expect(page).to have_message(I18n.t('helpers.no_results'), in: 'table tbody')
      end
    end
  end
end
