class ExternalMembers::SignaturesController < ExternalMembers::BaseController
  before_action :set_signature, only: [:show, :confirm]
  before_action :can_view, only: :show

  add_breadcrumb I18n.t('breadcrumbs.signatures.pendings'),
                 :external_members_signatures_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.signatures.signeds'),
                 :external_members_signatures_signed_path,
                 only: :signed

  def pending
    signatures_by_status(false)
  end

  def signed
    signatures_by_status(true)
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'),
                   external_members_signature_path(@signature)
  end

  def confirm
    valid_password = ExternalMember.find_by(email: params[:login])
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

  def can_view
    return if @signature.can_view(current_external_member, 'external_member')
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to external_members_signatures_pending_path
  end

  def signatures_by_status(status)
    signatures = Signature.by_external_member_and_status(current_external_member, status)
    @signatures = Signature.paginate_array(signatures, params[:page])
  end
end
