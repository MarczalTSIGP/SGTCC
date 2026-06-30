require 'rails_helper'

describe 'Institution::update', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Institution.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:institution) { create(:institution) }

    before do
      visit edit_responsible_institution_path(institution)
    end

    context 'when data is valid' do
      it 'updates the institution' do
        attributes = attributes_for(:institution)
        fill_in 'institution_name', with: attributes[:name]
        fill_in 'institution_trade_name', with: attributes[:trade_name]
        fill_in 'institution_cnpj', with: attributes[:cnpj]

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_institution_path(institution)
        expect(page).to have_flash(:success, text: message('update.f'))

        expect(page).to have_text(attributes[:name])
        expect(page).to have_text(attributes[:trade_name])
        expect(page).to have_text(attributes[:cnpj])
      end
    end

    context 'when the institution is not valid' do
      it_behaves_like 'responsible update blank errors',
                      fields: %w[
                        institution_name
                        institution_trade_name
                        institution_cnpj
                      ],
                      selectors: [
                        ['div.institution_name'],
                        ['div.institution_trade_name'],
                        ['div.institution_cnpj']
                      ]
    end
  end
end
