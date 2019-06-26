module SignatureHelper
  extend ActiveSupport::Concern

  def confirm_and_sign(class_name, login)
    if @signature.confirm_and_sign(class_name, login, params)
      message = I18n.t('json.messages.orientation.signatures.confirm.success')
      render json: { message: message }
    else
      message = I18n.t('json.messages.orientation.signatures.confirm.error')
      render json: { message: message, status: :internal_server_error }
    end
  end

  def paginate_signatures(signatures)
    @signatures = Signature.paginate_array(signatures, params[:page])
  end
end
