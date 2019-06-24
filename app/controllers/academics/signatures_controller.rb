class Academics::SignaturesController < Academics::BaseController
  before_action :set_signature, only: [:show, :confirm]
  before_action :can_view, only: :show

  add_breadcrumb I18n.t('breadcrumbs.signatures.pendings'),
                 :academics_signatures_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.signatures.signeds'),
                 :academics_signatures_signed_path,
                 only: :signed

  def pending
    signatures_by_status(false)
  end

  def signed
    signatures_by_status(true)
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'), academics_signature_path(@signature)
  end

  def confirm
    if @signature.confirm(Academic, 'ra', params) && @signature.sign
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

  def can_view
    return if @signature.can_view(current_academic, 'academic')
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to academics_signatures_pending_path
  end

  def signatures_by_status(status)
    signatures = Signature.by_academic_and_status(current_academic, status)
    @signatures = Signature.paginate_array(signatures, params[:page])
  end
end
