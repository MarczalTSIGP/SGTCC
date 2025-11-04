class Responsible::OrientationsController < Responsible::BaseController
  include Breadcrumb
  include OrientationCancel
  include OrientationEdit
  include OrientationDestroy

  before_action :set_orientation, only: [:show, :edit, :update, :destroy, :document, :documents]
  before_action :set_calendar, only: [:show, :edit, :document, :documents]
  before_action :set_document_orientation_breadcrumb, only: [:document, :documents]
  before_action :responsible_can_edit, only: :edit
  before_action :responsible_can_destroy, only: :destroy

  # rubocop:disable Metrics/AbcSize
  # TEMPORARY SOLUCTION: This method must be refactored in the future
  # TODO: Refactor this method
  def tcc_one
    add_breadcrumb I18n.t('breadcrumbs.orientations.index'), responsible_orientations_tcc_one_path

    # @orientations = Orientation.by_tcc_one(params[:page], params[:term], params[:status])
    @orientations = Orientation.joins(:calendars)
                               .group('orientations.id')
                               .having('COUNT(DISTINCT calendars.tcc) = 1
                                        AND MIN(calendars.tcc) = 1')
                               .order('orientations.created_at DESC')

    @orientations = @orientations.where(status: params[:status]) if params[:status].present?
    @orientations = @orientations.search(params[:term]).page(params[:page])

    @search_url = responsible_orientations_search_tcc_one_path

    render :index
  end

  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  # TEMPORARY SOLUCTION: This method must be refactored in the future
  # TODO: Refactor this method
  def tcc_two
    add_breadcrumb I18n.t('breadcrumbs.orientations.index'), responsible_orientations_tcc_two_path

    # @orientations = Orientation.by_tcc_two(params[:page], params[:term], params[:status])
    @orientations = Orientation.includes(:calendars).where(calendars: { tcc: 2 })
                               .order('orientations.created_at DESC')

    @orientations = @orientations.where(status: params[:status]) if params[:status].present?
    @orientations = @orientations.search(params[:term]).page(params[:page])

    @search_url = responsible_orientations_search_tcc_two_path
    render :index
  end

  # rubocop:enable Metrics/AbcSize

  def current_tcc_one
    @title = orientation_calendar_title(Calendar.current_by_tcc_one)
    add_breadcrumb @title, responsible_orientations_current_tcc_one_path
    @orientations = Orientation.by_current_tcc_one(params[:page], params[:term], params[:status])
    @search_url = responsible_orientations_search_current_tcc_one_path
    render :current_index
  end

  def current_tcc_two
    @title = orientation_calendar_title(Calendar.current_by_tcc_two)
    add_breadcrumb @title, responsible_orientations_current_tcc_two_path
    @orientations = Orientation.by_current_tcc_two(params[:page], params[:term], params[:status])
    @search_url = responsible_orientations_search_current_tcc_two_path
    render :current_index
  end

  def show
    add_responsible_index_breadcrumb
    add_breadcrumb show_orientation_calendar_title, responsible_orientation_path
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.orientations.index'), responsible_orientations_tcc_one_path
    add_breadcrumb I18n.t('breadcrumbs.orientations.new'), new_responsible_orientation_path
    @orientation = Orientation.new
  end

  def edit
    add_responsible_index_breadcrumb
    @title = edit_orientation_calendar_title
    add_breadcrumb @title, edit_responsible_orientation_path
  end

  def create
    @orientation = Orientation.new(orientation_params)

    if @orientation.save
      feminine_success_create_message
      redirect_to responsible_orientations_tcc_one_path
    else
      error_message
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @orientation.update(orientation_params)
      feminine_success_update_message
      redirect_to responsible_orientation_path(@orientation)
    else
      error_message
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @orientation.destroy
    feminine_success_destroy_message

    redirect_to responsible_orientations_tcc_one_path
  end

  def document
    @document = @orientation.documents.find(params[:document_id])
    @signatures = build_signatures_list(@document)

    add_breadcrumb I18n.t('breadcrumbs.documents.show'),
                   responsible_orientation_document_path(@orientation, @document)

    @not_show_sign_button = true
  end

  def build_signatures_list(document)
    document.signatures.where(status: true).map do |signature|
      format_signature_data(signature)
    end
  end

  def format_signature_data(signature)
    {
      name: signature.user.name,
      role: signature_role_translation(signature.user_type),
      date: I18n.l(signature.updated_at.to_date, format: :document),
      time: signature.updated_at.strftime('%H:%M')
    }
  end

  def signature_role_translation(user_type)
    I18n.t("activerecord.attributes.signature.user_types.#{user_type}")
  end

  def documents
    @documents = @orientation.documents.with_relationships.page(params[:page])
  end

  private

  def set_orientation
    @orientation = Orientation.find(params[:id])
  end

  def set_calendar
    @calendar = @orientation.current_calendar
  end

  def orientation_params
    params
      .expect(orientation: [:title, :academic_id, :advisor_id, :institution_id,
                            { calendar_ids: [], professor_supervisor_ids: [],
                              external_member_supervisor_ids: [] }])
  end

  def set_document_orientation_breadcrumb
    add_breadcrumb I18n.t('breadcrumbs.orientations.index'), responsible_tcc_index_path
    add_breadcrumb I18n.t('breadcrumbs.documents.orientation'),
                   responsible_orientation_documents_path(@orientation)
  end
end
