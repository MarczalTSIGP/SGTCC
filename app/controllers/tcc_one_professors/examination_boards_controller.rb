class TccOneProfessors::ExaminationBoardsController < TccOneProfessors::BaseController
  before_action :set_examination_board, only: [:edit, :update, :destroy]
  before_action :set_examination_board_with_relationships, only: :show
  before_action :disabled_fields, only: [:new, :create, :edit, :update]
  before_action :can_update_or_destroy?, only: [:edit, :update, :destroy]

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
    @examination_boards = list_examination_boards(:one)
    @search_url = tcc_one_professors_examination_boards_tcc_one_search_path
    render :index
  end

  def tcc_two
    @examination_boards = list_examination_boards(:two)
    @search_url = tcc_one_professors_examination_boards_tcc_two_search_path
    render :index
  end

  def show
    @title = I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.show")
    add_breadcrumb @title, tcc_one_professors_examination_board_path
  end

  def new
    load_form_context(ExaminationBoards::FormContext.for_new(tcc: :one))
  end

  def edit
    add_breadcrumb I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.edit"),
                   edit_tcc_one_professors_examination_board_path

    set_orientations_and_activities
  end

  def create
    @examination_board = ExaminationBoard.new(examination_board_params.merge(tcc: :one))

    if @examination_board.save
      feminine_success_create_message
      redirect_to tcc_one_professors_examination_boards_path
    else
      set_orientations_and_activities

      error_message
      render :new, orientations: @orientations, activities: @activities,
                   status: :unprocessable_content
    end
  end

  def update
    if @examination_board.update(examination_board_params.merge(tcc: :one))
      feminine_success_update_message
      redirect_to tcc_one_professors_examination_board_path(@examination_board)
    else
      set_orientations_and_activities

      error_message
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    result = ExaminationBoards::Destroy.call(@examination_board)

    if result.destroyed?
      feminine_success_destroy_message

      redirect_to tcc_one_professors_examination_boards_path
    elsif result.blocked_by_defense_minutes?
      flash[:alert] = I18n.t('flash.examination_board.defense_minutes.errors.destroy')
      redirect_to tcc_one_professors_examination_board_path(@examination_board)
    else
      alert_destroy_bond_message
      redirect_to tcc_one_professors_examination_board_path(@examination_board)
    end
  end

  private

  def list_examination_boards(tcc)
    ExaminationBoards::ListQuery.call(tcc:, period: :history, page: params[:page],
                                      term: params[:term], ordering: :tcc_one_professor)
  end

  def set_examination_board
    @examination_board = ExaminationBoard.find(params.expect(:id))
  end

  def set_examination_board_with_relationships
    @examination_board = ExaminationBoard.includes(external_members: [:scholarity],
                                                   professors: [:scholarity])
                                         .find(params.expect(:id))
  end

  def examination_board_params
    if @examination_board&.defense_minutes.blank?
      params
        .expect(examination_board: [:place,
                                    :date,
                                    :orientation_id,
                                    :tcc,
                                    :identifier,
                                    :document_available_until,
                                    { professor_ids: [], external_member_ids: [] }])
    else
      params.expect(examination_board: [:document_available_until])
    end
  end

  def disabled_fields
    @disabled_field = @examination_board&.defense_minutes.present?
  end

  def set_orientations_and_activities
    load_form_context(ExaminationBoards::FormContext.for_board(@examination_board))
  end

  def load_form_context(context)
    @examination_board = context.examination_board
    @orientations = context.orientations
    @activities = context.activities
  end

  def can_update_or_destroy?
    return false unless @examination_board.monograph?

    flash[:error] = I18n.t('flash.not_authorized')
    redirect_back_or_to(tcc_one_professors_examination_boards_tcc_one_path)
  end
end
