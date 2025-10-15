module DocumentSignature
  extend ActiveSupport::Concern

  # TODO: Remove after update
  def confirm_and_sign(current_user, login)
    if confirm_authentication(current_user, login)
      @signature.sign
      flash[:success] = I18n.t('json.messages.orientation.signatures.confirm.success')
      redirect_to academics_document_path(@document)
    else
      flash.now[:error] = I18n.t('json.messages.orientation.signatures.confirm.error')
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
