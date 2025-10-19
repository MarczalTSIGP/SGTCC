require 'rails_helper'

describe 'Document::sign', :js do
  let(:orientation) { create(:orientation) }
  let(:academic_signature) { orientation.signatures.where(user_type: :academic).last }
  let(:academic) { academic_signature.user }

  before do
    login_as(academic, scope: :academic)
    visit academics_document_path(Document.last)
  end

  describe '#sign' do
    context 'when signs the signature of the term of accept institution' do
      it 'signs the document of the term of accept institution' do
        click_link('Assinar documento', exact_text: true)

        expect(page).to have_content('Entre com seu RA e senha para assinar o documento.')

        within('form') do
          fill_in(:user_username, with: academic.ra)
          fill_in(:user_password, with: 'password')
          click_button('Assinar', exact_text: true)
        end

        expect(page).to have_css('.swal-modal')
        expect(find('.swal-modal')).to have_content(signature_signed_success_message)

        find('.swal-button--confirm').click

        academic_signature.reload

        date = I18n.l(academic_signature.updated_at, format: :short)
        time = I18n.l(academic_signature.updated_at, format: :time)
        role = signature_role(academic.gender, academic_signature.user_type)
        expect(page).to have_content(signature_register(academic.name, role, date, time))
      end
    end

    context 'when the password is wrong' do
      it 'shows alert message' do
        click_link('Assinar documento', exact_text: true)
        expect(page).to have_content('Entre com seu RA e senha para assinar o documento.')

        within('form') do
          fill_in(:user_username, with: academic.ra)
          fill_in(:user_password, with: 'wrongpassword')
          click_button('Assinar', exact_text: true)
        end

        expect(page).to have_css('.swal-modal')
        expect(find('.swal-modal')).to have_content(signature_login_alert_message)
      end
    end
  end
end
