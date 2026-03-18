module DocumentSignature
  extend ActiveSupport::Concern

  def confirm_and_sign(current_user, login, redirect_url)
    if confirm_authentication(current_user, login)
      @signature.sign
      flash[:sweet_success] = I18n.t('json.messages.orientation.signatures.confirm.success')
      redirect_to redirect_url
    else
      flash.now[:sweet_error] = I18n.t('json.messages.orientation.signatures.confirm.error')
      render partial: 'shared/sweet_alert'
    end
  end

  private

  def confirm_authentication(current_user, login)
    username = params[:user][:username]
    pwd = params[:user][:password]

    return false if login != username

    if SGTCC::LDAP.enable? &&
       !current_user.is_a?(ExternalMember)

      return SGTCC::LDAP.authenticate(current_user, pwd)
    end

    current_user.valid_password?(pwd)
  end
end
