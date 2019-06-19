require 'rails_helper'

describe 'Signature::sign', type: :feature, js: true do
  let!(:orientation) { create(:orientation) }
  let(:external_member) { orientation.external_member_supervisors.first }
  let!(:signature) do
    create(:external_member_signature, orientation_id: orientation.id, user_id: external_member.id)
  end

  before do
    login_as(external_member, scope: :external_member)
  end

  describe '#sign' do
    context 'when signs the signature of the term of commitment' do
      it 'signs the document of the term of commitment' do
        visit external_members_signature_path(signature)
        find('button[id="signature_button"]', text: signature_button).click
        fill_in 'login_confirmation', with: external_member.email
        fill_in 'password_confirmation', with: external_member.password
        find('button[id="login_confirmation_button"]', text: confirm_button).click
        expect(page).to have_message(signature_signed_success_message, in: 'div.swal-text')
        signature.reload
        date = I18n.l(signature.updated_at, format: :short)
        time = I18n.l(signature.updated_at, format: :time)
        expect(page).to have_content(signature_register(external_member.name, date, time))
      end
    end

    context 'when the password is wrong' do
      it 'shows alert message' do
        visit external_members_signature_path(signature)
        find('button[id="signature_button"]', text: signature_button).click
        fill_in 'login_confirmation', with: 'email'
        fill_in 'password_confirmation', with: '123'
        find('button[id="login_confirmation_button"]', text: confirm_button).click
        expect(page).to have_message(signature_login_alert_message, in: 'div.swal-text')
      end
    end
  end
end
