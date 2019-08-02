class Professors::ExaminationBoardsController < Professors::BaseController
  add_breadcrumb I18n.t('breadcrumbs.examination_boards.index'),
                 :professors_examination_boards_path

  def index
    @examination_boards = current_professor.examination_boards
                                           .search(params[:term])
                                           .page(params[:page])
                                           .order(:tcc, created_at: :desc)
                                           .with_relationships
  end
end
