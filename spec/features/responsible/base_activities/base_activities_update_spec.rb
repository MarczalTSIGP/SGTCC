require 'rails_helper'

describe 'Basebase_activity::update', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { BaseActivity.model_name.human }
  let!(:base_activity_types) { create_list(:base_activity_type, 3) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:base_activity) { create(:base_activity) }

    before do
      visit edit_responsible_base_activity_path(base_activity)
    end

    context 'when data is valid' do
      it 'updates the base activity' do
        attributes = attributes_for(:base_activity).merge(
          base_activity_type: base_activity_types.last
        )
        fill_in 'base_activity_name', with: attributes[:name]
        click_on_label(attributes[:tcc], in: 'base_activity_tcc')
        selectize(attributes[:base_activity_type].name, from: 'base_activity_base_activity_type_id')

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_base_activity_path(base_activity)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([attributes[:name],
                                       attributes[:tcc],
                                       attributes[:base_activity_type].name])
      end
    end

    context 'when the base activity is not valid' do
      it 'show errors' do
        fill_in 'base_activity_name', with: ''
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.base_activity_name')
      end
    end
  end
end
