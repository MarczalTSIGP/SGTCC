class ExternalMembers::ExaminationBoardsController < ExternalMembers::BaseController
  add_breadcrumb I18n.t('breadcrumbs.examination_boards.index'),
                 :external_members_examination_boards_path

  def index
    @examination_boards = current_external_member.examination_boards
                                                 .search(params[:term])
                                                 .page(params[:page])
                                                 .order(:tcc, created_at: :desc)
                                                 .with_relationships
  end
end
