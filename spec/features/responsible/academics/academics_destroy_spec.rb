require 'rails_helper'

describe 'Academic::destroy', :js do
  let(:responsible) { create(:responsible) }
  let!(:academic) { create(:academic) }
  let(:resource_name) { Academic.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_academics_path
  end

  describe '#destroy' do
    context 'when academic is destroyed' do
      it 'show success message' do
        click_on_destroy_link(responsible_academic_path(academic))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.m'))
        expect(page).not_to have_content(academic.name)
      end
    end
  end
end
