require 'rails_helper'

describe 'Document::sign', :js do
  let(:orientation) { create(:orientation) }
  let(:professor_signature) { orientation.signatures.find_by(user_type: :advisor) }
  let(:professor) { professor_signature.user }

  before do
    login_as(professor, scope: :professor)
    visit professors_document_path(Document.first)
  end

  describe '#sign' do
    context 'when signs the signature of the term of accept institution' do
      it 'signs the document of the term of accept institution' do
        click_button(signature_button, id: 'signature_button')
        fill_in 'login_confirmation', with: professor.username
        fill_in 'password_confirmation', with: 'password'
        click_button(sign_button, id: 'login_confirmation_button')

        expect(page).to have_message(signature_signed_success_message, in: 'div.swal-text')
        professor_signature.reload
        date = I18n.l(professor_signature.updated_at, format: :short)
        time = I18n.l(professor_signature.updated_at, format: :time)
        role = signature_role(professor.gender, professor_signature.user_type)

        expect(page).to have_content(signature_register(professor.name, role, date, time))
      end
    end

    context 'when the password is wrong' do
      it 'shows alert message' do
        click_button(signature_button, id: 'signature_button')
        fill_in 'login_confirmation', with: professor.username
        fill_in 'password_confirmation', with: '123'
        click_button(sign_button, id: 'login_confirmation_button')

        expect(page).to have_message(signature_login_alert_message, in: 'div.swal-text')
      end
    end
  end
end
