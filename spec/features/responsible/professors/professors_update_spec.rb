require 'rails_helper'

describe 'Professor::update', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { professor.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:professor) { create(:professor) }

    before do
      visit edit_responsible_professor_path(professor)
    end

    context 'when data is valid' do
      it 'updates the professor' do
        attributes = attributes_for(:professor_inactive)
        fill_in 'professor_name', with: attributes[:name]
        fill_in 'professor_email', with: attributes[:email]
        fill_in 'professor_lattes', with: attributes[:lattes]
        fill_in 'professor_username', with: attributes[:username]
        gender = I18n.t("enums.genders.#{attributes[:gender]}")
        click_on_label(gender, in: 'professor_gender')
        click_on_label(Professor.human_attribute_name('is_active'), in: 'professor_is_active')
        click_on_label(Professor.human_attribute_name('available_advisor'),
                       in: 'professor_available_advisor')

        submit_form('input[name="commit"]')
        expect(page).to have_current_path responsible_professor_path(professor)
        expect(page).to have_flash(:success, text: message('update.m'))
        expect(page).to have_contents([attributes[:name],
                                       attributes[:email],
                                       attributes[:username],
                                       attributes[:lattes],
                                       gender,
                                       I18n.t('helpers.boolean.true'),
                                       I18n.t('helpers.boolean.true')])
      end
    end

    context 'when the professor is not valid' do
      it 'show errors' do
        fill_in 'professor_name', with: ''
        fill_in 'professor_email', with: ''
        fill_in 'professor_lattes', with: ''
        fill_in 'professor_username', with: ''

        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.professor_name')
        expect(page).to have_message(blank_error_message, in: 'div.professor_email')
        expect(page).to have_message(blank_error_message, in: 'div.professor_username')
        expect(page).to have_message(blank_error_message, in: 'div.professor_lattes')
      end
    end
  end
end
