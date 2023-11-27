class TccOneProfessors::ExaminationBoardsController < TccOneProfessors::BaseController
  before_action :set_examination_board, only: [:edit, :update, :destroy]
  before_action :set_examination_board_with_relationships, only: :show
  before_action :disabled_fields, only: [:new, :create, :edit, :update]

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.tcc.one.index'),
                 :tcc_one_professors_examination_boards_tcc_one_path,
                 only: :tcc_one

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.tcc.two.index'),
                 :tcc_one_professors_examination_boards_tcc_two_path,
                 only: :tcc_two

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.tcc.one.new'),
                 :new_tcc_one_professors_examination_board_path,
                 only: [:new]

  def index
    redirect_to action: :tcc_one
  end

  def tcc_one
    @examination_boards = ExaminationBoard.by_tcc_one(params[:page],
                                                      params[:term],
                                                      params[:status])
    @search_url = tcc_one_professors_examination_boards_tcc_one_search_path
    render :index
  end

  def tcc_two
    @examination_boards = ExaminationBoard.by_tcc_two(params[:page],
                                                      params[:term],
                                                      params[:status])
    @search_url = tcc_one_professors_examination_boards_tcc_two_search_path
    render :index
  end

  def show
    @title = I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.show")
    add_breadcrumb @title, tcc_one_professors_examination_board_path
  end

  def new
    @examination_board = ExaminationBoard.new
  end

  def edit
    add_breadcrumb I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.edit"),
                   edit_tcc_one_professors_examination_board_path

    @disabled_field = @examination_board.defense_minutes.present?
  end

  def create
    @examination_board = ExaminationBoard.new(examination_board_params)

    if @examination_board.save
      feminine_success_create_message
      redirect_to tcc_one_professors_examination_boards_path
    else
      error_message
      render :new
    end
  end

  def update
    if @examination_board.update(examination_board_params)
      feminine_success_update_message
      redirect_to tcc_one_professors_examination_board_path(@examination_board)
    else
      @disabled_field = @examination_board.defense_minutes.present?
      error_message
      render :edit
    end
  end

  def destroy
    @examination_board.destroy
    feminine_success_destroy_message

    redirect_to tcc_one_professors_examination_boards_path
  end

  private

  def paginate(data)
    data.with_relationships
        .search(params[:term])
        .page(params[:page])
        .recent
  end

  def set_examination_board
    @examination_board = ExaminationBoard.find(params[:id])
  end

  def set_examination_board_with_relationships
    @examination_board = ExaminationBoard.includes(external_members: [:scholarity],
                                                   professors: [:scholarity])
                                         .find(params[:id])
  end

  def examination_board_params
    if @examination_board&.defense_minutes.blank?
      params.require(:examination_board)
            .permit(:place, :date, :orientation_id, :tcc, :identifier,
                    :document_available_until, professor_ids: [], external_member_ids: [])
    else
      params.require(:examination_board).permit(:document_available_until)
    end
  end

  def disabled_fields
    @disabled_field = @examination_board&.defense_minutes.present?
  end
end
