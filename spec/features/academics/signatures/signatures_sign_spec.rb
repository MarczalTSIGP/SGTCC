require 'rails_helper'

describe 'Signature::sign', type: :feature, js: true do
  let!(:academic) { create(:academic) }
  let!(:orientation) { create(:orientation, academic: academic) }
  let(:document_type) { create(:document_type_tco) }
  let(:document) { create(:document, document_type: document_type) }
  let!(:signature) do
    create(:academic_signature,
           document: document,
           orientation_id: orientation.id,
           user_id: academic.id)
  end

  before do
    login_as(academic, scope: :academic)
  end

  describe '#sign' do
    context 'when signs the signature of the term of commitment' do
      it 'signs the document of the term of commitment' do
        visit academics_signature_path(signature)
        find('button[id="signature_button"]', text: signature_button).click
        fill_in 'login_confirmation', with: academic.ra
        fill_in 'password_confirmation', with: academic.password
        find('button[id="login_confirmation_button"]', text: confirm_button).click
        expect(page).to have_message(signature_signed_success_message, in: 'div.swal-text')
        signature.reload
        date = I18n.l(signature.updated_at, format: :short)
        time = I18n.l(signature.updated_at, format: :time)
        expect(page).to have_content(signature_register(academic.name, date, time))
      end
    end

    context 'when the password is wrong' do
      it 'shows alert message' do
        visit academics_signature_path(signature)
        find('button[id="signature_button"]', text: signature_button).click
        fill_in 'login_confirmation', with: academic.ra
        fill_in 'password_confirmation', with: '123'
        find('button[id="login_confirmation_button"]', text: confirm_button).click
        expect(page).to have_message(signature_login_alert_message, in: 'div.swal-text')
      end
    end
  end
end
