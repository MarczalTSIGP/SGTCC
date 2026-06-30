module DocumentSignExamples
  def submit_document_signature(username:, password:)
    click_button(signature_button, id: 'signature_button')
    fill_in 'user_username', with: username
    fill_in 'user_password', with: password
    click_button(sign_button)
  end

  def submit_document_signature_form(username:, password:, form_selector:)
    click_button(signature_button, id: 'signature_button')
    expect(page).to have_text('Entre com seu RA e senha para assinar o documento.')

    within(form_selector) do
      fill_in(:user_username, with: username)
      fill_in(:user_password, with: password)
      click_button('Assinar', exact_text: true)
    end
  end

  def expect_signature_message(message, strategy:)
    case strategy
    when :modal
      expect(page).to have_css('.swal-modal')
      expect(find('.swal-modal')).to have_text(message)
    when :text
      expect(page).to have_message(message, in: 'div.swal-text')
    end
  end

  def expect_signature_register_for(signature:, user:)
    signature.reload
    date = I18n.l(signature.updated_at, format: :short)
    time = I18n.l(signature.updated_at, format: :time)
    role = signature_role(user.gender, signature.user_type)

    expect(page).to have_text(signature_register(user.name, role, date, time))
  end
end

RSpec.configure do |config|
  config.include DocumentSignExamples
end

RSpec.shared_examples 'a successful document signature flow' do |document_name|
  it "signs the document of #{document_name}" do
    submit_valid_document_signature

    expect_signature_message(signature_signed_success_message,
                             strategy: signature_message_strategy)
    find('.swal-button--confirm').click if confirm_signature_message
    expect_signature_register_for(signature: document_signature,
                                  user: signature_user)
  end
end

RSpec.shared_examples 'an invalid document signature flow' do
  it 'shows alert message' do
    submit_invalid_document_signature

    expect_signature_message(signature_login_alert_message,
                             strategy: signature_message_strategy)
  end
end
