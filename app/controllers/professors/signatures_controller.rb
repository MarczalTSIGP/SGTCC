class Professors::SignaturesController < Professors::BaseController
  before_action :set_signature, only: [:show, :confirm]
  before_action :can_view, only: :show

  add_breadcrumb I18n.t('breadcrumbs.signatures.pendings'),
                 :professors_signatures_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.signatures.signeds'),
                 :professors_signatures_signed_path,
                 only: :signed

  def pending
    signatures_by_status(false)
  end

  def signed
    signatures_by_status(true)
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'), professors_signature_path(@signature)
  end

  def confirm
    valid_password = Professor.find_by(username: params[:login])
                             &.valid_password?(params[:password])

    if valid_password && @signature.sign
      message = I18n.t('json.messages.orientation.signatures.confirm.success')
      render json: { message: message }
    else
      message = I18n.t('json.messages.orientation.signatures.confirm.error')
      render json: { message: message, status: :internal_server_error }
    end
  end

  private

  def set_signature
    @signature = Signature.find(params[:id])
  end

  def signatures_by_status(status)
    signatures = Signature.by_professor_and_status(current_professor, status)
    @signatures = Signature.paginate_array(signatures, params[:page])
  end

  def can_view
    return if @signature.can_view(current_professor, 'professor')
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to professors_signatures_pending_path
  end
end
