class Professors::DocumentsController < Professors::BaseController
  include DocumentSignature
  before_action :set_document, only: [:show, :sign]
  before_action :set_document_for_responsible, only: :show
  before_action :set_show_sign, only: :show
  before_action :can_view, only: :show
  before_action :set_signature, only: [:show, :sign]

  add_breadcrumb I18n.t('breadcrumbs.documents.reviewing'),
                 :professors_documents_reviewing_path,
                 only: :reviewing

  add_breadcrumb I18n.t('breadcrumbs.documents.pending'),
                 :professors_documents_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.documents.signed'),
                 :professors_documents_signed_path,
                 only: :signed

  def pending
    @documents = current_professor.documents_pending(params[:page])
  end

  def signed
    @documents = current_professor.documents_signed(params[:page])
  end

  def reviewing
    @documents = current_professor.documents_reviewing(params[:page])
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.documents.show'),
                   professors_document_path(@document)
  end

  def sign
    confirm_and_sign(current_professor, current_professor.username)
  end

  private

  def set_document
    id = params[:id]
    @document = current_professor.documents.find_by(id: id)
    @document = current_professor.all_documents.find_by(id: id) if @document.blank?
  end

  def set_document_for_responsible
    for_responsible = current_professor.responsible? && @document.blank?
    @document = Document.find(params[:id]) if for_responsible
    @not_show_sign_button = true if for_responsible
  end

  def set_show_sign
    return if @document.blank? || @document&.content&.blank?

    examination_board_json = @document.content['examination_board']
    return if examination_board_json.blank?

    examination_board = ExaminationBoard.find(examination_board_json['id'])
    @not_show_sign_button = true unless examination_board.available_defense_minutes?
  end

  def set_signature
    @signature = @document.signature_by_user(current_professor.id, current_professor.user_types)
  end

  def can_view
    return if @document.present?

    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to professors_documents_pending_path
  end
end
