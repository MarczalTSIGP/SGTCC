require 'rails_helper'

describe 'Institution::create', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Institution.model_name.human }
  let!(:external_member) { create(:external_member) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_institution_path
    end

    context 'when institution is valid' do
      it 'create an institution' do
        attributes = attributes_for(:institution)
        selectize(external_member.name, from: 'institution_external_member_id')
        fill_in 'institution_name', with: attributes[:name]
        fill_in 'institution_trade_name', with: attributes[:trade_name]
        fill_in 'institution_cnpj', with: attributes[:cnpj]
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_institutions_path
        expect(page).to have_flash(:success, text: message('create.f'))
        expect(page).to have_message(attributes[:trade_name], in: 'table tbody')
      end
    end

    context 'when institution is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.institution_name')
        expect(page).to have_message(blank_error_message, in: 'div.institution_trade_name')
        expect(page).to have_message(blank_error_message, in: 'div.institution_cnpj')
        expect(page).to have_message(required_error_message, in: 'div.institution_external_member')
      end
    end
  end
end
