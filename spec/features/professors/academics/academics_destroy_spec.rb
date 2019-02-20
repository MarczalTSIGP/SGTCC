require 'rails_helper'

describe 'Academics::destroy', type: :feature do
  let(:professor) { create(:professor) }
  let(:resource_name) { Academic.model_name.human }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#destroy' do
    context 'with valid destroy', js: true do
      it 'academic' do
        create(:academic)
        visit responsible_academics_path

        sleep 3.seconds
        within first('.destroy').click

        sleep 1.second

        find('.swal-button--confirm').click

        expect(page).to have_selector('div.swal-text',
                                      text: I18n.t('flash.actions.destroy.m',
                                                   resource_name: resource_name))
      end
    end
  end
end
