require 'rails_helper'

describe 'Institution::index', type: :feature do
  describe '#index' do
    context 'when shows all institutions' do
      it 'shows all institutions with options', js: true do
        responsible = create(:professor)
        login_as(responsible, scope: :professor)

        institutions = create_list(:institution, 3)

        visit responsible_institutions_path

        institutions.each do |institution|
          expect(page).to have_contents([institution.name,
                                         institution.trade_name,
                                         institution.cnpj.formatted,
                                         short_date(institution.created_at)])
        end
      end
    end
  end
end
