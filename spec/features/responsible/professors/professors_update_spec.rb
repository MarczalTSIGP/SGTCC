require 'rails_helper'

describe 'Professor::update', :js do
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

        submit_form('input[name="commit"]')
        expect(page).to have_current_path responsible_professor_path(professor)
        expect(page).to have_flash(:success, text: message('update.m'))
        expect(page).to have_contents([attributes[:name],
                                       attributes[:email],
                                       attributes[:username],
                                       attributes[:lattes],
                                       gender])
      end
    end

    context 'when the professor is not valid' do
      it_behaves_like 'responsible update blank errors',
                      fields: %w[
                        professor_name
                        professor_email
                        professor_lattes
                        professor_username
                      ],
                      selectors: [
                        ['div.professor_name'],
                        ['div.professor_email'],
                        ['div.professor_username'],
                        ['div.professor_lattes']
                      ]
    end
  end
end
