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
    return false if login != params[:login]

    if ENV['ldap.on'].eql?('true') &&
       (current_user.is_a?(Academic) || current_user.is_a?(Professor))

      return ldap_authenticate(current_user, params[:password])
    end

    current_user.valid_password?(params[:password])
  end

  def ldap_authenticate(current_user, pwd)
    require './lib/ldap/ldap_authentication'

    user = current_user.try(:ra) || current_user.username
    base = current_user.class.to_s.pluralize.downcase

    return false unless SGTCC::LDAP.authenticate(user, pwd, base)
    true
  end
end
