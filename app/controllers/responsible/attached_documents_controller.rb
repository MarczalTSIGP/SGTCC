class Responsible::AttachedDocumentsController < Responsible::BaseController
  before_action :set_attached_document, only: [:edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.attached_documents.index'),
                 :responsible_attached_documents_path

  add_breadcrumb I18n.t('breadcrumbs.attached_documents.show'),
                 :responsible_attached_document_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.attached_documents.new'),
                 :new_responsible_attached_document_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.attached_documents.edit'),
                 :edit_responsible_attached_document_path,
                 only: [:edit]

  def index
    @attached_documents = AttachedDocument.page(params[:page])
                                          .search(params[:term])
                                          .order(created_at: :desc)
  end

  def new
    @attached_document = AttachedDocument.new
  end

  def edit; end

  def create
    @attached_document = AttachedDocument.new(attached_document_params)

    if @attached_document.save
      success_create_message
      redirect_to responsible_attached_documents_path
    else
      error_message
      render :new
    end
  end

  def update
    if @attached_document.update(attached_document_params)
      success_update_message
      redirect_to responsible_attached_documents_path
    else
      error_message
      render :edit
    end
  end

  def destroy
    @attached_document.destroy
    success_destroy_message

    redirect_to responsible_attached_documents_path
  end

  private

  def set_attached_document
    @attached_document = AttachedDocument.find(params[:id])
  end

  def attached_document_params
    params.require(:attached_document).permit(:name, :file, :file_cache)
  end
end
