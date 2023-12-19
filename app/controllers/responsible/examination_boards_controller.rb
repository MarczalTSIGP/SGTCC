class Responsible::ExaminationBoardsController < Responsible::BaseController
  before_action :set_examination_board, only: [:edit, :update, :destroy]
  before_action :set_examination_board_with_relationships, only: :show
  before_action :disabled_fields, except: [:index, :show, :tcc_one, :tcc_two, :destroy]

  before_action :set_breadcrumbs_new_tcc_one, only: [:new_to_tcc_one, :create_to_tcc_one]
  before_action :set_breadcrumbs_new_tcc_two, only: [:new_to_tcc_two, :create_to_tcc_two]

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.tcc.one.index'),
                 :responsible_examination_boards_tcc_one_path,
                 only: :tcc_one

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.tcc.two.index'),
                 :responsible_examination_boards_tcc_two_path,
                 only: :tcc_two

  def index
    redirect_to action: :tcc_one
  end

  def tcc_one
    @examination_boards = ExaminationBoard.tcc_one

    if params[:current_semester].present?
      @examination_boards = @examination_boards.where('date >= ?', Calendar.start_date)
    end

    @examination_boards = @examination_boards.page(params[:page])
                                             .order(date: :desc)

    @search_url = responsible_examination_boards_tcc_one_search_path
    @new_url = responsible_examination_boards_new_tcc_one_path
    @link_name = t('breadcrumbs.examination_boards.tcc.one.new')

    render :index
  end

  def tcc_two
    @examination_boards = ExaminationBoard.tcc_two
                                          .where('date >= ?', Calendar.start_date)
                                          .page(params[:page])
                                          .order(date: :desc)

    @search_url = responsible_examination_boards_tcc_two_search_path
    @new_url = responsible_examination_boards_new_tcc_two_path
    @link_name = t('breadcrumbs.examination_boards.tcc.two.new')

    render :index
  end

  def show
    add_breadcrumb I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.index"),
                   "responsible_examination_boards_tcc_#{@examination_board.tcc}_path".to_sym

    @title = I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.show")
    add_breadcrumb @title, responsible_examination_board_path
  end

  def new_to_tcc_one
    @examination_board = ExaminationBoard.new
    @orientations = Orientation.current_tcc_one
    @activities = Activity.human_tcc_one_identifiers
  end

  def new_to_tcc_two
    @examination_board = ExaminationBoard.new(identifier: :monograph)
    @orientations = Orientation.current_tcc_two
    @activities = Activity.human_tcc_two_identifiers
  end

  def create_to_tcc_one
    @examination_board = ExaminationBoard.new(examination_board_params.merge(tcc: :one))

    if @examination_board.save
      feminine_success_create_message
      redirect_to responsible_examination_boards_tcc_one_path
    else
      @orientations = Orientation.current_tcc_one
      @activities = Activity.human_tcc_one_identifiers

      error_message
      render :new_to_tcc_one
    end
  end

  def create_to_tcc_two
    @examination_board = ExaminationBoard.new(examination_board_params.merge(tcc: :two))

    if @examination_board.save
      feminine_success_create_message
      redirect_to responsible_examination_boards_tcc_two_path
    else
      @orientations = Orientation.current_tcc_two
      @activities = Activity.human_tcc_two_identifiers

      error_message
      render :new_to_tcc_two
    end
  end

  def edit
    set_breadcrumbs_to_edit_update
    set_orientations_and_activities
  end

  def update
    set_breadcrumbs_to_edit_update

    if @examination_board.update(examination_board_params)
      feminine_success_update_message
      redirect_to responsible_examination_board_path(@examination_board)
    else
      set_orientations_and_activities
      error_message
      render :edit
    end
  end

  def destroy
    if @examination_board.defense_minutes.blank?
      @examination_board.destroy
      feminine_success_destroy_message

      redirect_to responsible_examination_boards_path
    else
      flash[:alert] = I18n.t('flash.examination_board.defense_minutes.errors.destroy')
      redirect_to responsible_examination_board_path(@examination_board)
    end
  end

  private

  def paginate(data)
    data.search(params[:term])
        .page(params[:page])
        .order(created_at: :desc)
        .with_relationships
  end

  def set_examination_board
    @examination_board = ExaminationBoard.find(params[:id])
  end

  def set_examination_board_with_relationships
    @examination_board = ExaminationBoard.with_relationships.find(params[:id])
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

  def set_orientations_and_activities
    if @examination_board.monograph?
      @orientations = Orientation.current_tcc_two
      @activities = Activity.human_tcc_two_identifiers
    else
      @orientations = Orientation.current_tcc_one
      @activities = Activity.human_tcc_one_identifiers
    end
  end

  def set_breadcrumbs_new_tcc_one
    @title_one_index = I18n.t('breadcrumbs.examination_boards.tcc.one.index')
    add_breadcrumb @title_one_index, :responsible_examination_boards_tcc_one_path
    @title = I18n.t('breadcrumbs.examination_boards.tcc.one.new')
    add_breadcrumb @title
  end

  def set_breadcrumbs_new_tcc_two
    @title_two_index = I18n.t('breadcrumbs.examination_boards.tcc.two.index')
    add_breadcrumb @title_two_index, :responsible_examination_boards_tcc_two_path
    @title = I18n.t('breadcrumbs.examination_boards.tcc.two.new')
    add_breadcrumb @title
  end

  def set_breadcrumbs_to_edit_update
    add_breadcrumb I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.index"),
                   "responsible_examination_boards_tcc_#{@examination_board.tcc}_path".to_sym

    add_breadcrumb I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.edit")
  end

  def disabled_fields
    @disabled_field = @examination_board&.defense_minutes.present?
  end
end
