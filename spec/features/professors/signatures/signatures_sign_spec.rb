require 'rails_helper'

describe 'Signature::sign', type: :feature, js: true do
  let!(:advisor) { create(:professor) }
  let!(:orientation) { create(:orientation, advisor: advisor) }
  let(:document_type) { create(:document_type_tco) }
  let(:document) { create(:document, document_type: document_type) }
  let!(:signature) do
    create(:signature, orientation_id: orientation.id, user_id: advisor.id, document: document)
  end

  before do
    login_as(advisor, scope: :professor)
  end

  describe '#sign' do
    context 'when signs the signature of the term of commitment' do
      it 'signs the document of the term of commitment' do
        visit professors_signature_path(signature)
        find('button[id="signature_button"]', text: signature_button).click
        fill_in 'login_confirmation', with: advisor.username
        fill_in 'password_confirmation', with: advisor.password
        find('button[id="login_confirmation_button"]', text: sign_button).click
        expect(page).to have_message(signature_signed_success_message, in: 'div.swal-text')
        signature.reload
        date = I18n.l(signature.updated_at, format: :short)
        time = I18n.l(signature.updated_at, format: :time)
        role = signature_role(advisor.gender, signature.user_type)
        expect(page).to have_content(signature_register(advisor.name, role, date, time))
      end
    end

    context 'when the password is wrong' do
      it 'shows alert message' do
        visit professors_signature_path(signature)
        find('button[id="signature_button"]', text: signature_button).click
        fill_in 'login_confirmation', with: advisor.username
        fill_in 'password_confirmation', with: '123'
        find('button[id="login_confirmation_button"]', text: sign_button).click
        expect(page).to have_message(signature_login_alert_message, in: 'div.swal-text')
      end
    end
  end
end
