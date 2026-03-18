require 'rails_helper'

describe 'Institution::destroy', :js do
  let(:responsible) { create(:responsible) }
  let!(:institution) { create(:institution) }
  let(:resource_name) { Institution.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_institutions_path
  end

  describe '#destroy' do
    context 'when institution is destroyed' do
      it 'show success message' do
        click_on_destroy_link(responsible_institution_path(institution))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).to have_no_content(institution.name)
      end
    end
  end
end
