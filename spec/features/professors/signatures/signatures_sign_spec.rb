require 'rails_helper'

describe 'Signature::sign', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let!(:advisor) { create(:professor) }
  let!(:orientation) { create(:orientation, advisor: advisor) }
  let!(:signature) { create(:signature, orientation_id: orientation.id) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#sign' do
    context 'when signs the signature of the term of commitment' do
      it 'signs the document of the term of commitment' do
        visit professors_signature_path(signature)
        find('button[id="signature_button"]', text: signature_button).click
        fill_in 'login_confirmation', with: professor.username
        fill_in 'password_confirmation', with: professor.password
        find('button[id="login_confirmation_button"]', text: confirm_button).click

        expect(page).to have_message(signature_signed_success_message,
                                     in: 'div.swal-text')
      end
    end
  end
end
