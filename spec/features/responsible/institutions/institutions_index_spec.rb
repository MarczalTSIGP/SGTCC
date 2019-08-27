require 'rails_helper'

describe 'Institution::index', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:institutions) { create_list(:institution, 3) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_institutions_path
  end

  describe '#index' do
    context 'when shows all institutions' do
      it 'shows all institutions with options' do
        institutions.each do |institution|
          expect(page).to have_contents([institution.external_member.name,
                                         institution.trade_name,
                                         institution.cnpj.formatted,
                                         short_date(institution.created_at)])
        end
      end
    end
  end
end
