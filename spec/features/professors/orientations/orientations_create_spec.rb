require 'rails_helper'

describe 'Orientation::create', type: :feature do
  let(:professor) { create(:professor) }
  let!(:academic) { create(:academic) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    create(:current_calendar_tcc_one)
    login_as(professor, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_professors_orientation_path
    end

    context 'when orientation is valid', js: true do
      it 'create an orientation' do
        attributes = attributes_for(:orientation)
        fill_in 'orientation_title', with: attributes[:title]
        find('#orientation_academic_id-selectized').click
        find('div.selectize-dropdown-content', text: academic.name).click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path professors_orientations_tcc_one_path
        success_message = I18n.t('flash.actions.create.f', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when orientation is not valid', js: true do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        message_blank_error = I18n.t('errors.messages.blank')
        expect(page).to have_message(message_blank_error, in: 'div.orientation_title')
        expect(page).to have_message(message_blank_error, in: 'div.orientation_calendar')
        expect(page).to have_message(message_blank_error, in: 'div.orientation_academic')
        expect(page).to have_message(message_blank_error, in: 'div.orientation_advisor')
      end
    end
  end
end
