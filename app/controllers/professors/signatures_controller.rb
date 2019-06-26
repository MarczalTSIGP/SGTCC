class Professors::SignaturesController < Professors::BaseController
  include SignatureConfirm
  before_action :set_signature, only: [:show, :confirm]
  before_action :can_view, only: :show

  add_breadcrumb I18n.t('breadcrumbs.signatures.pendings'),
                 :professors_signatures_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.signatures.signeds'),
                 :professors_signatures_signed_path,
                 only: :signed

  def pending
    paginate_signatures(current_professor.signatures_pending)
  end

  def signed
    paginate_signatures(current_professor.signatures_signed)
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'), professors_signature_path(@signature)
  end

  def confirm
    confirm_and_sign(Professor, 'username')
  end

  private

  def set_signature
    @signature = Signature.find(params[:id])
  end

  def paginate_signatures(signatures)
    @signatures = Signature.paginate_array(signatures, params[:page])
  end

  def can_view
    return if @signature.professor_can_view(current_professor)
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to professors_signatures_pending_path
  end
end
