module DocumentSignature
  extend ActiveSupport::Concern

  def confirm_and_sign(current_user, login)
    if confirm_authentication(current_user, login)
      @signature.sign
      message = I18n.t('json.messages.orientation.signatures.confirm.success')
      render json: { message: message }
    else
      message = I18n.t('json.messages.orientation.signatures.confirm.error')
      render json: { message: message, status: :internal_server_error }
    end
  end

  private

  def confirm_authentication(current_user, login)
    pwd = params[:password]

    if SGTCC::LDAP.enable? &&
       !current_user.is_a?(ExternalMember)

      return SGTCC::LDAP.authenticate(current_user, pwd)
    end

    return false if login != params[:login]

    current_user.valid_password?(pwd)
  end
end
