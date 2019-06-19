require 'rails_helper'

describe 'Signature::sign', type: :feature, js: true do
  let!(:professor) { create(:professor) }
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
        fill_in 'login_confirmation', with: advisor.username
        fill_in 'password_confirmation', with: advisor.password
        find('button[id="login_confirmation_button"]', text: confirm_button).click
        expect(page).to have_message(signature_signed_success_message, in: 'div.swal-text')
        signature.reload
        date = I18n.l(signature.updated_at, format: :short)
        time = I18n.l(signature.updated_at, format: :time)
        expect(page).to have_content(signature_register(advisor.name, date, time))
      end
    end

    context 'when the password is wrong' do
      it 'shows alert message' do
        visit professors_signature_path(signature)
        find('button[id="signature_button"]', text: signature_button).click
        fill_in 'login_confirmation', with: advisor.username
        fill_in 'password_confirmation', with: '123'
        find('button[id="login_confirmation_button"]', text: confirm_button).click
        expect(page).to have_message(signature_login_alert_message, in: 'div.swal-text')
      end
    end
  end
end