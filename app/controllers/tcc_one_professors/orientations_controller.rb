class TccOneProfessors::OrientationsController < TccOneProfessors::BaseController
  before_action :set_calendar
  before_action :set_orientation, only: [:show, :document, :documents]
  before_action :set_title, only: :by_calendar
  before_action :set_index_breadcrumb
  before_action :set_document_orientation_breadcrumb, only: [:document, :documents]

  def by_calendar
    @orientations = @calendar.orientations.by_tcc_one(params[:status], params[:term]).recent

    render :index
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.orientations.show'),
                   tcc_one_professors_calendar_orientation_path(@calendar, @orientation)
  end

  def documents
    @documents = @orientation.documents.with_relationships.page(params[:page])
  end

  def document
    @document = @orientation.documents.find(params[:document_id])

    params_url = { calendar_id: @calendar, id: @orientation, document_id: @document }
    add_breadcrumb I18n.t('breadcrumbs.documents.show'),
                   tcc_one_professors_calendar_orientation_document_path(params_url)
  end

  private

  def set_orientation
    @orientation = @calendar.orientations.find(params[:id])
  end

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def set_title
    calendar = Calendar.current_by_tcc_one
    calendar = @calendar if @calendar.present?
    @title = I18n.t('breadcrumbs.orientations.tcc.one.calendar',
                    calendar: calendar.year_with_semester)
  end

  def set_index_breadcrumb
    add_breadcrumb I18n.t('breadcrumbs.calendars.index'),
                   tcc_one_professors_calendars_tcc_one_path
    add_breadcrumb I18n.t('breadcrumbs.orientations.index'),
                   tcc_one_professors_calendar_orientations_path(@calendar)
  end

  def set_document_orientation_breadcrumb
    add_breadcrumb I18n.t('breadcrumbs.documents.orientation'),
                   tcc_one_professors_calendar_orientation_documents_path(@calendar, @orientation)
  end
end
