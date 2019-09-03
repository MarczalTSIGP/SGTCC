class ExternalMembers::DashboardController < ExternalMembers::BaseController
  before_action :set_documents, only: :index
  before_action :set_examination_boards, only: :index

  def index; end

  private

  def set_documents
    @documents = current_external_member.documents_pending(params[:page]).per(5)
  end

  def set_examination_boards
    @examination_boards = current_external_member.examination_boards
                                                 .page(params[:page])
                                                 .per(5)
                                                 .order(:tcc, created_at: :desc)
                                                 .with_relationships
  end
end
