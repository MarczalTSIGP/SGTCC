require 'rails_helper'

describe 'Orientation::create', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:academic) { create(:academic) }
  let!(:professor) { create(:professor) }
  let!(:calendar) { create(:calendar) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_orientation_path
    end

    context 'when orientation is valid', js: true do
      it 'create an orientation' do
        attributes = attributes_for(:orientation)
        fill_in 'orientation_title', with: attributes[:title]
        find('#orientation_calendar_id-selectized').click
        find('div.selectize-dropdown-content', text: calendar.year_with_semester_and_tcc).click
        find('#orientation_academic_id-selectized').click
        find('div.selectize-dropdown-content', text: academic.name).click
        find('#orientation_advisor_id-selectized').click
        find('div.selectize-dropdown-content', text: professor.name).click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_orientations_path
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
