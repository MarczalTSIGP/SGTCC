require 'rails_helper'

describe 'Institution::search', :js do
  let(:responsible) { create(:responsible) }
  let(:institutions) { create_list(:institution, 10) }

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

        expect(page).to have_link(institution.trade_name,
                                  href: responsible_institution_path(institution))
        expect(page).to have_contents([institution.cnpj.formatted,
                                       institution.external_member.name,
                                       short_date(institution.created_at)])
      end
    end

    context 'when the result is not found' do
      it 'returns not found message' do
        fill_in 'term', with: 'a1#\231/ere'
        first('#search').click
        expect(page).to have_message(no_results_message, in: 'table tbody')
      end
    end
  end
end
