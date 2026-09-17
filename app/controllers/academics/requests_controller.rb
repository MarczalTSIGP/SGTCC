# Esqueleto comum dos pedidos do acadêmico (TEP e TSO).
#
# Os dois recursos compartilham o CRUD, a listagem e a regra de "não pode mais
# mudar depois de assinado", e divergem no formulário, no `show` e — só no TSO —
# na troca de orientação, que exige recriar o documento. As subclasses informam
# a diferença pelos ganchos abaixo; a divergência de domínio fica nelas.
#
# A classe não é `abstract!` de propósito: é ela que coloca `academics/requests`
# entre os prefixos de busca de view das subclasses, e é assim que `index`,
# `_request`, `new` e `edit` passam a ter uma fonte única.
class Academics::RequestsController < Academics::BaseController
  before_action :set_document, only: [:edit, :update, :destroy]
  before_action :can_change, only: [:edit, :update, :destroy]

  helper_method :request_title, :requests_path, :new_request_path,
                :edit_request_path, :request_path

  def index
    @requests = requests_scope.with_relationships.page(params[:page])
  end

  def new
    @document = Document.new
  end

  def edit; end

  def create
    @document = build_document

    if @document.save
      feminine_success_create_message
      redirect_to academics_document_path(@document)
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if update_document
      feminine_success_update_message
      redirect_to academics_document_path(@document)
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @document.destroy
    feminine_success_destroy_message

    redirect_to requests_path
  end

  private

  # Ganchos obrigatórios da subclasse:
  #   requests_scope  -> relation dos documentos do acadêmico para este pedido
  #   build_document  -> documento novo a partir de request_params
  #   request_params  -> parâmetros permitidos do formulário
  #
  # Gancho opcional: update_document, abaixo.

  def update_document
    @document.update_requester_justification(request_params)
  end

  # Identificação do recurso: "tep" ou "tso".

  def request_type
    controller_name.delete_suffix('_requests')
  end

  def request_title(key)
    I18n.t("breadcrumbs.documents.requests.#{request_type}.#{key}")
  end

  def requests_path
    public_send("academics_#{request_type}_requests_path")
  end

  def new_request_path
    public_send("new_academics_#{request_type}_request_path")
  end

  def edit_request_path(document)
    public_send("edit_academics_#{request_type}_request_path", document)
  end

  def request_path(document)
    public_send("academics_#{request_type}_request_path", document)
  end

  # Comum aos dois.

  def set_document
    @document = current_academic.documents.find_by(id: params[:id])
  end

  def model_human
    I18n.t('flash.request.index')
  end

  def can_change
    return unless @document.academic_signed?(current_academic)

    flash[:alert] = I18n.t('flash.documents.academics.requests.not_allowed')
    redirect_to requests_path
  end
end
