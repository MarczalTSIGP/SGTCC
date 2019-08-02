class Academics::ExaminationBoardsController < Academics::BaseController
  add_breadcrumb I18n.t('breadcrumbs.examination_boards.index'),
                 :academics_examination_boards_path

  def index
    @examination_boards = current_academic.examination_boards
                                          .search(params[:term])
                                          .page(params[:page])
                                          .order(:tcc, created_at: :desc)
                                          .with_relationships
  end
end
