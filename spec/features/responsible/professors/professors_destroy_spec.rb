require 'rails_helper'

describe 'Professor::destroy', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Professor.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#destroy' do
    context 'when professor is destroyed', js: true do
      it 'show success message' do
        professor = create(:professor)
        visit responsible_professors_path

        url = responsible_professor_path(professor)
        destroy_link = "a[href='#{url}'][data-method='delete']"
        find(destroy_link).click

        alert = page.driver.browser.switch_to.alert
        alert.accept
        sleep 2.seconds

        success_message = I18n.t('flash.actions.destroy.m',
                                 resource_name: resource_name)

        expect(page).to have_flash(:success, text: success_message)

        expect(page).not_to have_content(professor.name)
      end
    end
  end
end
